--!strict
-- Vessie Roblox Framework - ModuleRegistry (6.10)
-- Registro de módulos com validação de nomes, dependências e detecção de ciclos

local ModuleRegistry = {}
ModuleRegistry.__index = ModuleRegistry

-- Criar um novo ModuleRegistry
-- @return table registry instância nova
function ModuleRegistry.new(): table
	local self: table = setmetatable({}, ModuleRegistry)
	self._modules: {[string]: any} = {} -- name -> module
	self._dependencies: {[string]: {string}} = {} -- name -> {dependencyNames}
	self._order: {[string]: boolean} = {} -- registered status
	return self
end

-- Registrar um módulo
-- @param name string nome único do módulo
-- @param module any módulo a registrar (função ou tabela)
-- @param dependencies table|nil nomes de módulos dependentes (opcional)
-- @return boolean success
-- @return string|nil errorMessage
function ModuleRegistry:Register(name: string, module: any, dependencies: {string}?): boolean, string?
	-- Validar nome
	if type(name) ~= "string" or name == "" then
		return false, "Nome do módulo deve ser uma string não vazia"
	end

	-- Verificar se já existe
	if self._modules[name] then
		return false, "Módulo já registrado: " .. name
	end

	-- Armazenar módulo
	self._modules[name] = module

	-- Armazenar dependências (se fornecidas)
	if dependencies then
		self._dependencies[name] = dependencies
	else
		self._dependencies[name] = {}
	end

	-- Marcar como registrado
	self._order[name] = true

	return true, nil
end

-- Obter um módulo registrado
-- @param name string nome do módulo
-- @return any|nil módulo ou nil se não encontrado
function ModuleRegistry:Get(name: string): any
	return self._modules[name]
end

-- Verificar se um módulo está registrado
-- @param name string nome do módulo
-- @return boolean isRegistered
function ModuleRegistry:IsRegistered(name: string): boolean
	return self._modules[name] ~= nil
end

-- Validar dependências de um módulo
-- @param name string nome do módulo a validar
-- @return boolean valid
-- @return string|nil errorMessage
function ModuleRegistry:ValidateDependencies(name: string): boolean, string?
	local deps: {string} = self._dependencies[name] or {}

	-- Verificar se todas as dependências estão registradas
	for _, depName: string: any in ipairs(deps) do
		if not self:IsRegistered(depName) then
			return false, "Dependência não encontrada: " .. depName .. " (módulo: " .. name .. ")"
		end
	end

	-- Verificar dependências circulares
	local visited: {[string]: boolean} = {}
	local function checkCycle(current: string, path: {string}): boolean
		if visited[current] then return true end -- ciclo detectado
		visited[current] = true

		local currentDeps: {string} = self._dependencies[current] or {}
		for _, dep: string: any in ipairs(currentDeps) do
			if dep == name then return true end -- ciclo com o módulo original
			if checkCycle(dep, {current, unpack(path) or {}}) then return true end
		end
		return false
	end

	if checkCycle(name, {}) then
		return false, "Dependência circular detectada envolvendo: " .. name
	end

	return true, nil
end

-- Obter ordem topológica de inicialização (respectando dependências)
-- @return {string}[] ordem de nomes de módulos
function ModuleRegistry:GetInitOrder(): {string}
	local registered: {[string]: boolean} = {}
	local result: {string} = {}

	-- Coletar todos módulos registrados
	for name: string: any in pairs(self._modules) do
		registered[name] = true
	end

	-- DFS para topologia
	local explored: {[string]: boolean} = {}

	local function visit(moduleName: string)
		if explored[moduleName] then return end
		explored[moduleName] = true

		-- Visitar dependências primeiro
		local deps: {string} = self._dependencies[moduleName] or {}
		for _, dep: string: any in ipairs(deps) do
			if registered[dep] then
				visit(dep)
			end
		end

		-- Adicionar após dependências
		table.insert(result, moduleName)
	end

	-- Visitar todos módulos
	for name: string: any in pairs(registered) do
		visit(name)
	end

	return result
end

-- Remover um módulo registrado
-- @param name string nome do módulo
-- @return boolean removed
function ModuleRegistry:Remove(name: string): boolean
	if not self._modules[name] then return false end

	-- Remover dependências associadas
	self._modules[name] = nil
	self._dependencies[name] = nil
	self._order[name] = nil

	-- Remover referências de outros módulos que dependem deste
	local toRemove: {string} = {}
	for modName: string: any in pairs(self._modules) do
		local deps: {string} = self._dependencies[modName] or {}
		for _, dep: string: any in ipairs(deps) do
			if dep == name then
				table.insert(toRemove, modName)
				break
			end
		end
	end

	-- Remover módulos que dependiam deste (cascata simplificada)
	for _, modName: string: any in ipairs(toRemove) do
		self:Remove(modName)
	end

	return true
end

-- Obter todos os nomes de módulos registrados
-- @return {string}[] names
function ModuleRegistry:GetNames(): {string}
	local names: {string} = {}
	for name: string: any in pairs(self._modules) do
		table.insert(names, name)
	end
	return names
end

-- Verificar se há dependências não resolvidas em todos os módulos
-- @return boolean hasIssues
-- @return {string}[] problemas
function ModuleRegistry:CheckAllDependencies(): boolean, {string}?
	local issues: {string} = {}

	for name: string: any in pairs(self._modules) do
		local valid: boolean, err: string? = self:ValidateDependencies(name)
		if not valid then
			table.insert(issues, err or "Erro desconhecido em: " .. name)
		end
	end

	if #issues > 0 then return true, issues end
	return false, nil
end

return ModuleRegistry