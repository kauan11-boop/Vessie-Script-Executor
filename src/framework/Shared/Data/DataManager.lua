--!strict
-- Vessie - DataManager
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local DataManager = {}
DataManager._stores = {}
DataManager._prefix = "Vessie_"

function DataManager.Init() end

function DataManager.GetStore(name)
	return DataStoreService:GetDataStore(DataManager._prefix .. name)
end

function DataManager.Save(player, data, key)
	local k = key or tostring(player.UserId)
	local s = DataManager.GetStore(player.Name .. "_" .. game.PlaceId)
	local ok, err = pcall(function()
		s:UpdateAsync(k, function(existing)
			local merged = existing or {}
			for k2, v in pairs(data) do merged[k2] = v end
			return merged
		end)
	end)
	return ok, err
end

function DataManager.Load(player, key, default)
	local k = key or tostring(player.UserId)
	local s = DataManager.GetStore(player.Name .. "_" .. game.PlaceId)
	local ok, result = pcall(function() return s:GetAsync(k) end)
	if ok and result and type(result) == "table" then return result end
	return default or {}
end

function DataManager.Remove(player, key)
	local k = key or tostring(player.UserId)
	local s = DataManager.GetStore(player.Name .. "_" .. game.PlaceId)
	local ok, err = pcall(function() s:RemoveAsync(k) end)
	return ok
end

function DataManager.GetVersion(player, key)
	local d = DataManager.Load(player, key)
	return d.version or nil
end

function DataManager.SetVersion(player, version, key)
	return DataManager.Save(player, {version = version}, key)
end

return DataManager