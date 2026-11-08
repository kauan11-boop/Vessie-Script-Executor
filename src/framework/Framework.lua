--!strict
-- Vessie Roblox Framework - Core Module
-- Módulo núcleo responsável pela inicialização, registro e gerenciamento do framework

local Framework = {}
Framework._version = "1.0.0"
Framework._modules: {[string]: any} = {}
Framework._initialized: boolean = false

-- Maid para gerenciamento de limpeza de recursos
local Maid = {}
Maid.__index = Maid

function Maid.new()
	return setmetatable({_tasks = {}, _connections = {}, _instances = {}}, Maid)
end

function Maid:GiveTask(task: () -> (), name: string?)
	table.insert(self._tasks, {task = task, name = name})
end

function Maid:DoCleaning()
	for _, connection: RBXScriptConnection in ipairs(self._connections) do
		pcall(function()
			connection:Disconnect()
		end)
	end
	self._connections = {}

	for _, task: () -> () in ipairs(self._tasks) do
		if type(task) == "function" then
			pcall(task)
		end
	end
	self._tasks = {}

	for _, instance: Instance in ipairs(self._instances) do
		if instance and instance.Parent then
			pcall(function()
				instance:Destroy()
			end)
		end
	end
	self._instances = {}
end

function Maid:Destroy()
	self:DoCleaning()
end

Framework._maid = Maid.new()

function Framework.Register(name: string, module: any)
	if Framework._initialized then
		return false, "Framework já inicializado"
	end

	if type(name) ~= "string" or #name == 0 then
		return false, "Nome inválido"
	end

	if Framework._modules[name] then
		return false, "Módulo já registrado: " .. name
	end

	Framework._modules[name] = {
		module = module,
		status = "registered",
		initialized = false,
	}

	return true, "Módulo registrado: " .. name
end

function Framework.Get(name: string)
	return Framework._modules[name] and Framework._modules[name].module or nil
end

function Framework.Start()
	Framework._initialized = true

	for name, data: any in pairs(Framework._modules) do
		if data.module and data.module.Init then
			local ok, err: any = pcall(function()
				data.module:Init()
			end)
			if ok then
				data.initialized = true
				data.status = "initialized"
			end
		else
			data.initialized = true
			data.status = "initialized"
		end
	end

	for name, data: any in pairs(Framework._modules) do
		if data.initialized and data.module and data.module.Start then
			pcall(function()
				data.module:Start()
			end)
		end
	end

	return true, "Framework iniciado"
end

function Framework.Stop()
	if not Framework._initialized then return true end
	Framework._initialized = false

	for name, data: any in pairs(Framework._modules) do
		if data.module and data.module.Cleanup then
			pcall(function()
				data.module:Cleanup()
			end)
		end
		Framework._modules[name] = nil
	end

	Framework._maid:Destroy()
	Framework._maid = Maid.new()

	return true
end

function Framework.IsInitialized()
	return Framework._initialized
end

function Framework.GetModules()
	local names: {string} = {}
	for name in pairs(Framework._modules) do
		table.insert(names, name)
	end
	return names
end

return Framework