--!strict
-- Vessie Roblox Framework - NetworkingManager
-- Wrapper de RemoteEvent/RemoteFunction com criação automática e limpeza de conexões

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local NetworkingManager = {}

NetworkingManager._folderName = "VessieNetwork"
NetworkingManager._remotes = {}
NetworkingManager._connections = {}

local function getFolder()
	local folder = ReplicatedStorage:FindFirstChild(NetworkingManager._folderName)
	if not folder then
		if RunService:IsServer() then
			folder = Instance.new("Folder")
			folder.Name = NetworkingManager._folderName
			folder.Parent = ReplicatedStorage
		else
			folder = ReplicatedStorage:WaitForChild(NetworkingManager._folderName, 10)
		end
	end
	return folder
end

local function getRemote(name: string, className: string): Instance?
	local cached = NetworkingManager._remotes[name]
	if cached and cached.Parent then return cached end

	local folder = getFolder()
	if not folder then return nil end

	local remote = folder:FindFirstChild(name)
	if not remote then
		if RunService:IsServer() then
			remote = Instance.new(className)
			remote.Name = name
			remote.Parent = folder
		else
			remote = folder:WaitForChild(name, 10)
		end
	end
	if remote then NetworkingManager._remotes[name] = remote end
	return remote
end

function NetworkingManager.GetEvent(name: string): RemoteEvent?
	local remote = getRemote(name, "RemoteEvent")
	if remote and remote:IsA("RemoteEvent") then return remote end
	return nil
end

function NetworkingManager.GetFunction(name: string): RemoteFunction?
	local remote = getRemote(name, "RemoteFunction")
	if remote and remote:IsA("RemoteFunction") then return remote end
	return nil
end

local function track(connection: RBXScriptConnection): RBXScriptConnection
	table.insert(NetworkingManager._connections, connection)
	return connection
end

-- Lado servidor
function NetworkingManager.OnServerEvent(name: string, callback: (Player, ...any) -> ()): RBXScriptConnection?
	local remote = NetworkingManager.GetEvent(name)
	if not remote then return nil end
	return track(remote.OnServerEvent:Connect(callback))
end

function NetworkingManager.SetCallback(name: string, callback: (Player, ...any) -> ...any): boolean
	local remote = NetworkingManager.GetFunction(name)
	if not remote then return false end
	remote.OnServerInvoke = callback
	return true
end

function NetworkingManager.FireClient(name: string, player: Player, ...): boolean
	local remote = NetworkingManager.GetEvent(name)
	if not remote then return false end
	remote:FireClient(player, ...)
	return true
end

function NetworkingManager.FireAllClients(name: string, ...): boolean
	local remote = NetworkingManager.GetEvent(name)
	if not remote then return false end
	remote:FireAllClients(...)
	return true
end

-- Lado cliente
function NetworkingManager.OnClientEvent(name: string, callback: (...any) -> ()): RBXScriptConnection?
	local remote = NetworkingManager.GetEvent(name)
	if not remote then return nil end
	return track(remote.OnClientEvent:Connect(callback))
end

function NetworkingManager.FireServer(name: string, ...): boolean
	local remote = NetworkingManager.GetEvent(name)
	if not remote then return false end
	remote:FireServer(...)
	return true
end

function NetworkingManager.InvokeServer(name: string, ...): any
	local remote = NetworkingManager.GetFunction(name)
	if not remote then return nil end
	return remote:InvokeServer(...)
end

function NetworkingManager.DisconnectAll()
	for _, connection in ipairs(NetworkingManager._connections) do
		pcall(function() connection:Disconnect() end)
	end
	NetworkingManager._connections = {}
end

function NetworkingManager.Destroy()
	NetworkingManager.DisconnectAll()
	if RunService:IsServer() then
		for _, remote in pairs(NetworkingManager._remotes) do
			pcall(function() remote:Destroy() end)
		end
		local folder = ReplicatedStorage:FindFirstChild(NetworkingManager._folderName)
		if folder then pcall(function() folder:Destroy() end) end
	end
	NetworkingManager._remotes = {}
end

return NetworkingManager
