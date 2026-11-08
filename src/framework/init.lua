--!strict
-- Vessie Roblox Framework - Core (init)
-- Registro de modulos e ciclo de vida Init -> Start -> Cleanup, com Maid p/ limpeza.

local Framework = {}
Framework._version = "1.0.0"
Framework._modules = {}
Framework._initialized = false

-- Maid: gerencia tarefas, conexoes e instances para limpeza
local Maid = {}
Maid.__index = Maid

function Maid.new()
	return setmetatable({ _tasks = {}, _connections = {}, _instances = {} }, Maid)
end

function Maid:GiveTask(task, name)
	table.insert(self._tasks, { task = task, name = name })
end

function Maid:GiveConnection(connection)
	table.insert(self._connections, connection)
	return connection
end

function Maid:GiveInstance(instance)
	table.insert(self._instances, instance)
	return instance
end

function Maid:DoCleaning()
	for _, connection in ipairs(self._connections) do
		pcall(function() connection:Disconnect() end)
	end
	self._connections = {}

	for _, item in ipairs(self._tasks) do
		if type(item.task) == "function" then
			pcall(item.task)
		end
	end
	self._tasks = {}

	for _, instance in ipairs(self._instances) do
		pcall(function()
			if instance and instance.Parent then instance:Destroy() end
		end)
	end
	self._instances = {}
end

function Maid:Destroy()
	self:DoCleaning()
end

Framework._maid = Maid.new()
Framework.Maid = Maid

function Framework.Register(name: string, module: any): (boolean, string?)
	if Framework._initialized then return false, "Framework ja inicializado" end
	if type(name) ~= "string" or #name == 0 then return false, "Nome invalido" end
	if Framework._modules[name] then return false, "Modulo ja registrado: " .. name end
	Framework._modules[name] = { module = module, status = "registered", initialized = false }
	return true, "Modulo registrado: " .. name
end

function Framework.Get(name: string): any
	local entry = Framework._modules[name]
	return entry and entry.module or nil
end

function Framework.Start(): (boolean, string)
	Framework._initialized = true
	for _, data in pairs(Framework._modules) do
		if data.module and data.module.Init then
			local ok = pcall(function() data.module:Init() end)
			if ok then data.initialized = true data.status = "initialized" end
		else
			data.initialized = true
			data.status = "initialized"
		end
	end
	for _, data in pairs(Framework._modules) do
		if data.initialized and data.module and data.module.Start then
			pcall(function() data.module:Start() end)
		end
	end
	return true, "Framework iniciado"
end

function Framework.Stop(): boolean
	if not Framework._initialized then return true end
	Framework._initialized = false
	for name, data in pairs(Framework._modules) do
		if data.module and data.module.Cleanup then
			pcall(function() data.module:Cleanup() end)
		end
		Framework._modules[name] = nil
	end
	Framework._maid:Destroy()
	Framework._maid = Maid.new()
	return true
end

function Framework.IsInitialized(): boolean
	return Framework._initialized
end

function Framework.GetModules(): {string}
	local names = {}
	for name in pairs(Framework._modules) do table.insert(names, name) end
	return names
end

return Framework
