--!strict
-- Vessie Roblox Framework - DataManager
-- Persistência via DataStore com cache de sessão, chave estável por UserId e autosave

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local DataManager = {}

DataManager._stores = {}
DataManager._cache = {}
DataManager._prefix = "Vessie_"
DataManager._connections = {}
DataManager._started = false

function DataManager.GetStore(name: string)
	local cached = DataManager._stores[name]
	if cached then return cached end
	local store = DataStoreService:GetDataStore(DataManager._prefix .. name)
	DataManager._stores[name] = store
	return store
end

local function playerStore()
	return DataManager.GetStore("PlayerData_" .. tostring(game.PlaceId))
end

local function keyFor(player: Player, key: string?): string
	return key or tostring(player.UserId)
end

function DataManager.Init()
	if DataManager._started or not RunService:IsServer() then return end
	DataManager._started = true

	table.insert(DataManager._connections, Players.PlayerRemoving:Connect(function(player)
		DataManager.Flush(player)
		DataManager._cache[player] = nil
	end))

	game:BindToClose(function()
		for player in pairs(DataManager._cache) do
			DataManager.Flush(player)
		end
	end)
end

function DataManager.Load(player: Player, key: string?, default: any?): any
	if key == nil then
		local cached = DataManager._cache[player]
		if cached then return cached end
	end
	local store = playerStore()
	local ok, result = pcall(function()
		return store:GetAsync(keyFor(player, key))
	end)
	if ok and type(result) == "table" then
		if key == nil then DataManager._cache[player] = result end
		return result
	end
	local fallback = default or {}
	if key == nil then DataManager._cache[player] = fallback end
	return fallback
end

function DataManager.Save(player: Player, data: {[string]: any}, key: string?): (boolean, any)
	if type(data) ~= "table" then return false, "data deve ser uma tabela" end
	if key == nil then
		local cached = DataManager._cache[player] or {}
		for field, value in pairs(data) do cached[field] = value end
		DataManager._cache[player] = cached
	end
	local store = playerStore()
	local ok, err = pcall(function()
		store:UpdateAsync(keyFor(player, key), function(existing)
			local merged = existing or {}
			for field, value in pairs(data) do merged[field] = value end
			return merged
		end)
	end)
	return ok, err
end

function DataManager.Update(player: Player, transform: (any) -> any, key: string?): (boolean, any)
	local store = playerStore()
	local ok, err = pcall(function()
		store:UpdateAsync(keyFor(player, key), function(existing)
			return transform(existing or {})
		end)
	end)
	if ok and key == nil then DataManager._cache[player] = nil end
	return ok, err
end

function DataManager.Remove(player: Player, key: string?): boolean
	local store = playerStore()
	local ok = pcall(function()
		store:RemoveAsync(keyFor(player, key))
	end)
	if ok and key == nil then DataManager._cache[player] = nil end
	return ok
end

function DataManager.Flush(player: Player): boolean
	local cached = DataManager._cache[player]
	if not cached then return true end
	local ok = DataManager.Save(player, cached)
	return ok
end

function DataManager.GetVersion(player: Player, key: string?): any
	local data = DataManager.Load(player, key)
	return data.version
end

function DataManager.SetVersion(player: Player, version: any, key: string?): (boolean, any)
	return DataManager.Save(player, { version = version }, key)
end

function DataManager.ClearCache(player: Player)
	DataManager._cache[player] = nil
end

return DataManager
