--!strict
-- Vessie Roblox Framework - EventBus
-- Pub/sub por nome (puro, sem RBXScriptSignal). On/Once retornam conexao com Disconnect.

local EventBus = {}
EventBus.__index = EventBus

local unpack = table.unpack or unpack

function EventBus.new()
	local self = setmetatable({}, EventBus)
	self._listeners = {}
	return self
end

local function addListener(self, eventName, callback, once)
	if type(eventName) ~= "string" or type(callback) ~= "function" then return nil end
	self._listeners[eventName] = self._listeners[eventName] or {}
	local entry = { callback = callback, once = once, connected = true }
	table.insert(self._listeners[eventName], entry)
	local connection = {}
	function connection:Disconnect()
		entry.connected = false
	end
	return connection
end

function EventBus:On(eventName: string, callback: any)
	return addListener(self, eventName, callback, false)
end

function EventBus:Once(eventName: string, callback: any)
	return addListener(self, eventName, callback, true)
end

function EventBus:Off(eventName: string?, connection: any?): boolean
	if connection and type(connection.Disconnect) == "function" then
		connection:Disconnect()
		return true
	elseif eventName and self._listeners[eventName] then
		self._listeners[eventName] = nil
		return true
	end
	return false
end

function EventBus:Clear(eventName: string): boolean
	if self._listeners[eventName] then
		self._listeners[eventName] = nil
		return true
	end
	return false
end

function EventBus:Emit(eventName: string, ...): boolean
	local list = self._listeners[eventName]
	if not list then return false end
	local args = { ... }
	for _, entry in ipairs(list) do
		if entry.connected then
			if entry.once then entry.connected = false end
			local ok, err = pcall(function() entry.callback(unpack(args)) end)
			if not ok then warn("[EventBus] Listener erro em " .. eventName .. ": " .. tostring(err)) end
		end
	end
	for i = #list, 1, -1 do
		if not list[i].connected then table.remove(list, i) end
	end
	return true
end

function EventBus:HasListeners(eventName: string): boolean
	local list = self._listeners[eventName]
	if not list then return false end
	for _, entry in ipairs(list) do
		if entry.connected then return true end
	end
	return false
end

function EventBus:Count(): number
	local count = 0
	for _, list in pairs(self._listeners) do
		for _, entry in ipairs(list) do
			if entry.connected then count = count + 1 end
		end
	end
	return count
end

function EventBus:Destroy(): boolean
	self._listeners = {}
	return true
end

return EventBus
