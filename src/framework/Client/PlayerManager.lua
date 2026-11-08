--!strict
-- Vessie Roblox Framework - PlayerManager
-- Gerencia jogadores, entrada/saída, personagens e respawns

local Players = game:GetService("Players")

local PlayerManager = {}

PlayerManager._playerData = {}
PlayerManager._connections = {}
PlayerManager._started = false

PlayerManager.Events = {
	PlayerAdded = nil,
	PlayerRemoving = nil,
	CharacterAdded = nil,
	CharacterRemoving = nil,
	PlayerRespawned = nil,
}

local function fire(eventName: string, ...)
	local bindable = PlayerManager.Events[eventName]
	if bindable then
		bindable:Fire(...)
	end
end

function PlayerManager.Init()
	if PlayerManager._started then return end
	PlayerManager._started = true

	for _, eventName in ipairs({ "PlayerAdded", "PlayerRemoving", "CharacterAdded", "CharacterRemoving", "PlayerRespawned" }) do
		PlayerManager.Events[eventName] = Instance.new("BindableEvent")
	end

	table.insert(PlayerManager._connections, Players.PlayerAdded:Connect(function(player)
		PlayerManager.OnPlayerAdded(player)
	end))
	table.insert(PlayerManager._connections, Players.PlayerRemoving:Connect(function(player)
		PlayerManager.OnPlayerRemoving(player)
	end))

	for _, player in ipairs(Players:GetPlayers()) do
		task.spawn(PlayerManager.OnPlayerAdded, player)
	end
end

function PlayerManager.OnPlayerAdded(player: Player)
	if PlayerManager._playerData[player] then return end

	local data = {
		Character = nil,
		LastPosition = Vector3.new(0, 0, 0),
		JoinTime = os.clock(),
		Connections = {},
	}
	PlayerManager._playerData[player] = data

	table.insert(data.Connections, player.CharacterAdded:Connect(function(character)
		local isRespawn = data.Character ~= nil
		data.Character = character
		fire("CharacterAdded", player, character)
		if isRespawn then
			fire("PlayerRespawned", player, character)
		end

		local humanoid = character:WaitForChild("Humanoid", 5)
		if humanoid and humanoid:IsA("Humanoid") then
			local root = humanoid.RootPart
			if root then
				data.LastPosition = root.Position
			end
		end
	end))

	table.insert(data.Connections, player.CharacterRemoving:Connect(function(character)
		if data.Character == character then
			local root = character:FindFirstChild("HumanoidRootPart")
			if root and root:IsA("BasePart") then
				data.LastPosition = root.Position
			end
			data.Character = nil
		end
		fire("CharacterRemoving", player, character)
	end))

	if player.Character then
		data.Character = player.Character
		fire("CharacterAdded", player, player.Character)
	end

	fire("PlayerAdded", player)
end

function PlayerManager.OnPlayerRemoving(player: Player)
	local data = PlayerManager._playerData[player]
	if data then
		for _, connection in ipairs(data.Connections) do
			pcall(function() connection:Disconnect() end)
		end
	end
	PlayerManager._playerData[player] = nil
	fire("PlayerRemoving", player)
end

function PlayerManager.GetCharacter(player: Player): Model?
	local data = PlayerManager._playerData[player]
	if data and data.Character and data.Character.Parent then
		return data.Character
	end
	local character = player.Character
	if character and character.Parent then
		if data then data.Character = character end
		return character
	end
	return nil
end

function PlayerManager.GetData(player: Player, key: string?): any
	local data = PlayerManager._playerData[player]
	if not data then return nil end
	if key then return data[key] end
	return data
end

function PlayerManager.SetData(player: Player, key: string, value: any)
	local data = PlayerManager._playerData[player]
	if not data then
		data = { Connections = {} }
		PlayerManager._playerData[player] = data
	end
	data[key] = value
end

function PlayerManager.HasCharacter(player: Player): boolean
	return PlayerManager.GetCharacter(player) ~= nil
end

function PlayerManager.GetLastPosition(player: Player): Vector3
	local character = PlayerManager.GetCharacter(player)
	if character then
		local root = character:FindFirstChild("HumanoidRootPart")
		if root and root:IsA("BasePart") then
			local data = PlayerManager._playerData[player]
			if data then data.LastPosition = root.Position end
			return root.Position
		end
	end
	local data = PlayerManager._playerData[player]
	return data and data.LastPosition or Vector3.new(0, 0, 0)
end

function PlayerManager.SetLastPosition(player: Player, position: Vector3)
	PlayerManager.SetData(player, "LastPosition", position)
end

function PlayerManager.On(eventName: string, callback: (...any) -> ()): RBXScriptConnection?
	local bindable = PlayerManager.Events[eventName]
	if bindable then
		return bindable.Event:Connect(callback)
	end
	warn("[PlayerManager] Evento não registrado: " .. eventName)
	return nil
end

function PlayerManager.Cleanup(player: Player)
	local data = PlayerManager._playerData[player]
	if data then
		for _, connection in ipairs(data.Connections) do
			pcall(function() connection:Disconnect() end)
		end
		PlayerManager._playerData[player] = nil
	end
end

function PlayerManager.Destroy()
	for player in pairs(PlayerManager._playerData) do
		PlayerManager.Cleanup(player)
	end
	for _, connection in ipairs(PlayerManager._connections) do
		pcall(function() connection:Disconnect() end)
	end
	PlayerManager._connections = {}
	for _, bindable in pairs(PlayerManager.Events) do
		if bindable then pcall(function() bindable:Destroy() end) end
	end
	PlayerManager._started = false
end

return PlayerManager
