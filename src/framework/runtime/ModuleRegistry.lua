--!strict
-- Vessie Roblox Framework - ModuleRegistry
-- Registro de modulos com dependencias, detecao de ciclos e ordem topologica

local ModuleRegistry = {}
ModuleRegistry.__index = ModuleRegistry

function ModuleRegistry.new()
	local self = setmetatable({}, ModuleRegistry)
	self._modules = {}
	self._dependencies = {}
	return self
end

function ModuleRegistry:Register(name: string, module: any, dependencies: {string}?): (boolean, string?)
	if type(name) ~= "string" or name == "" then
		return false, "Nome do modulo deve ser uma string nao vazia"
	end
	if self._modules[name] then
		return false, "Modulo ja registrado: " .. name
	end
	self._modules[name] = module
	self._dependencies[name] = dependencies or {}
	return true, nil
end

function ModuleRegistry:Get(name: string): any
	return self._modules[name]
end

function ModuleRegistry:IsRegistered(name: string): boolean
	return self._modules[name] ~= nil
end

function ModuleRegistry:ValidateDependencies(name: string): (boolean, string?)
	local deps = self._dependencies[name] or {}
	for _, depName in ipairs(deps) do
		if not self:IsRegistered(depName) then
			return false, "Dependencia nao encontrada: " .. depName .. " (modulo: " .. name .. ")"
		end
	end

	-- Detecao de ciclo com pilha de recursao (sem falso positivo em deps compartilhadas)
	local stack, visited = {}, {}
	local function hasCycle(node)
		if stack[node] then return true end
		if visited[node] then return false end
		visited[node] = true
		stack[node] = true
		for _, dep in ipairs(self._dependencies[node] or {}) do
			if hasCycle(dep) then return true end
		end
		stack[node] = false
		return false
	end
	if hasCycle(name) then
		return false, "Dependencia circular detectada envolvendo: " .. name
	end
	return true, nil
end

function ModuleRegistry:GetInitOrder(): {string}
	local result = {}
	local explored = {}
	local function visit(moduleName)
		if explored[moduleName] then return end
		explored[moduleName] = true
		for _, dep in ipairs(self._dependencies[moduleName] or {}) do
			if self._modules[dep] then visit(dep) end
		end
		table.insert(result, moduleName)
	end
	for name in pairs(self._modules) do visit(name) end
	return result
end

function ModuleRegistry:Remove(name: string): boolean
	if not self._modules[name] then return false end
	self._modules[name] = nil
	self._dependencies[name] = nil

	local toRemove = {}
	for modName in pairs(self._modules) do
		for _, dep in ipairs(self._dependencies[modName] or {}) do
			if dep == name then table.insert(toRemove, modName) break end
		end
	end
	for _, modName in ipairs(toRemove) do self:Remove(modName) end
	return true
end

function ModuleRegistry:GetNames(): {string}
	local names = {}
	for name in pairs(self._modules) do table.insert(names, name) end
	return names
end

function ModuleRegistry:CheckAllDependencies(): (boolean, {string}?)
	local issues = {}
	for name in pairs(self._modules) do
		local valid, err = self:ValidateDependencies(name)
		if not valid then table.insert(issues, err or ("Erro desconhecido em: " .. name)) end
	end
	if #issues > 0 then return true, issues end
	return false, nil
end

return ModuleRegistry
