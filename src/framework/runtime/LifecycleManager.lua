--!strict
-- Vessie Roblox Framework - LifecycleManager (6.11)
-- Gerencia ciclos de vida dos componentes com estados previsíveis

local LifecycleManager = {}
LifecycleManager.__index = LifecycleManager

LifecycleManager.States = {
	Registered = "Registered",
	Initializing = "Initializing",
	Initialized = "Initialized",
	Starting = "Starting",
	Running = "Running",
	Stopping = "Stopping",
	Stopped = "Stopped",
	Failed = "Failed",
}

function LifecycleManager.new(name)
	local self = setmetatable({}, LifecycleManager)
	self._name = name
	self._currentState = LifecycleManager.States.Registered
	self._previousState = nil
	self._error = nil
	self._connections = {}
	return self
end

function LifecycleManager:SetState(newState, errorMessage)
	local valid = {self.States.Registered, self.States.Initializing, self.States.Initialized, self.States.Starting, self.States.Running, self.States.Stopping, self.States.Stopped, self.States.Failed}
	local isValid = false
	for _, s in ipairs(valid) do if s == newState then isValid = true break end end
	if not isValid then return false, "Estado inválido" end

	self._previousState = self._currentState
	self._currentState = newState
	if newState == self.States.Failed and errorMessage then self._error = errorMessage end
	return true, nil
end

function LifecycleManager:GetState() return self._currentState end
function LifecycleManager:GetPreviousState() return self._previousState end
function LifecycleManager:GetError() return self._error end
function LifecycleManager:IsState(state) return self._currentState == state end

function LifecycleManager:Destroy()
	for _, c in ipairs(self._connections) do if c.Disconnect then c:Disconnect() end end
	table.clear(self._connections)
	self._currentState = self.States.Stopped
	return true
end

return LifecycleManager