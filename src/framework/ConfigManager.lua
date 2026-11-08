--!strict
-- Vessie Roblox Framework - ConfigManager (6.12)
-- Gerencia configurações com valores padrão, validação e persistência

local ConfigManager = {}
ConfigManager.__index = ConfigManager

-- Níveis de leitura/escrita
ConfigManager.Access = {
	ReadWrite = "ReadWrite",
	ReadOnly = "ReadOnly",
	ServerOnly = "ServerOnly",
}

-- Criar um novo gerenciador de configurações
-- @param configTable table tabela de configurações padrão
-- @return table configManager instância nova
function ConfigManager.new(configTable: table): table
	local self: table = setmetatable({}, ConfigManager)
	self._config: {[string]: any} = configTable or {}
	self._overrides: {[string]: any} = {}
	self._readonly: {[string]: boolean} = {}
	self._access: {[string]: string} = {}
	return self
end

-- Definir valor de configuração
-- @param key string chave da configuração
-- @param value any valor
-- @param access string|nil nível de acesso (ReadWrite, ReadOnly, ServerOnly)
-- @param readonly boolean|nil se é somente leitura
function ConfigManager:Set(key: string, value: any, access: string?, readonly: boolean?): boolean
	if not key or key == "" then return false end

	-- Verificar se é somente leitura
	if self._readonly[key] then
		warn("[ConfigManager] Tentativa de modificar configuração somente de leitura: " .. key)
		return false
	end

	-- Verificar acesso ServerOnly no cliente
	if access == ConfigManager.Access.ServerOnly and game:GetService("RunService"):IsClient() then
		warn("[ConfigManager] Configuração ServerOnly não pode ser definida no cliente")
		return false
	end

	self._config[key] = value
	self._access[key] = access or ConfigManager.Access.ReadWrite
	if readonly then self._readonly[key] = true end
	return true
end

-- Obter valor de configuração
-- @param key string chave da configuração
-- @param default any valor padrão caso não exista
-- @return any valor (ou default)
function ConfigManager:Get(key: string, default: any): any
	if not key or key == "" then return default end

	-- Verificar overrides primeiro
	if self._overrides[key] ~= nil then
		return self._overrides[key]
	end

	return self._config[key] ~= nil and self._config[key] or default
end

-- Definir valor padrão (será usado se chave não existir)
-- @param key string chave
-- @param default any valor padrão
-- @param access string nível de acesso
function ConfigManager:SetDefault(key: string, default: any, access: string?): boolean
	if not key or key == "" then return false end
	self._config[key] = default
	self._access[key] = access or ConfigManager.Access.ReadWrite
	return true
end

-- Definir configuração somente de leitura
-- @param key string chave
-- @param value any valor atual (marca como readonly)
function ConfigManager:SetReadOnly(key: string, value: any): boolean
	if not key or key == "" then return false end
	self._config[key] = value
	self._readonly[key] = true
	return true
end

-- Verificar se configuração existe
-- @param key string chave
-- @return boolean exists
function ConfigManager:Exists(key: string): boolean
	if not key or key == "" then return false end
	return self._config[key] ~= nil or self._overrides[key] ~= nil
end

-- Remover configuração
-- @param key string chave
-- @return boolean removed
function ConfigManager:Remove(key: string): boolean
	if not self._config[key] then return false end
	self._config[key] = nil
	self._access[key] = nil
	self._readonly[key] = nil
	return true
end

-- Sobrepor configuração (útil para ambientes específicos)
-- @param key string chave
-- @param value any novo valor
function ConfigManager:Override(key: string, value: any): boolean
	if not key or key == "" then return false end
	self._overrides[key] = value
	return true
end

-- Obter todas as chaves
-- @return {string} keys
function ConfigManager:GetKeys(): {string}
	local keys: {string} = {}
	for key: string: any in pairs(self._config) do
		table.insert(keys, key)
	end
	for key: string: any in pairs(self._overrides) do
		table.insert(keys, key)
	end
	return keys
end

-- Obter todas as chaves com acesso ReadWrite
-- @return {string} keys
function ConfigManager:GetReadWriteKeys(): {string}
	local keys: {string} = {}
	for key: string: any in pairs(self._config) do
		if self._access[key] ~= ConfigManager.Access.ReadOnly then
			table.insert(keys, key)
		end
	end
	return keys
end

-- Validar se todas as chaves obrigatórias existem
-- @param required {string} lista de chaves obrigatórias
-- @return boolean valid
-- @return {string}[] missing
function ConfigManager:ValidateRequired(required: {string}): boolean, {string}?
	local missing: {string} = {}
	for _, key: string: any in ipairs(required) do
		if not self:Exists(key) then
			table.insert(missing, key)
		end
	end
	if #missing > 0 then return false, missing end
	return true, nil
end

-- Exportar configurações (serializável)
-- @return table cópia serializável
function ConfigManager:Export(): table
	local export: table = {}
	for key: string, value: any: any in pairs(self._config) do
		export[key] = value
	end
	for key: string, value: any: any in pairs(self._overrides) do
		export[key] = value
	end
	return export
end

-- Importar configurações (substitui ou sobreescreve)
-- @param importedTable table configurações para importar
function ConfigManager:Import(importedTable: table): boolean
	if type(importedTable) ~= "table" then return false end
	for key: string, value: any: any in pairs(importedTable) do
		self:Set(key, value)
	end
	return true
end

return ConfigManager