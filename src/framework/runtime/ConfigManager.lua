--!strict
-- Vessie Roblox Framework - ConfigManager
-- Configuracoes com defaults, overrides, readonly e niveis de acesso

local ConfigManager = {}
ConfigManager.__index = ConfigManager

ConfigManager.Access = {
	ReadWrite = "ReadWrite",
	ReadOnly = "ReadOnly",
	ServerOnly = "ServerOnly",
}

function ConfigManager.new(configTable: {[string]: any}?)
	local self = setmetatable({}, ConfigManager)
	self._config = configTable or {}
	self._overrides = {}
	self._readonly = {}
	self._access = {}
	return self
end

function ConfigManager:Set(key: string, value: any, access: string?, readonly: boolean?): boolean
	if type(key) ~= "string" or key == "" then return false end
	if self._readonly[key] then
		warn("[ConfigManager] Config somente de leitura: " .. key)
		return false
	end
	if access == ConfigManager.Access.ServerOnly and game:GetService("RunService"):IsClient() then
		warn("[ConfigManager] ServerOnly nao pode ser definido no cliente: " .. key)
		return false
	end
	self._config[key] = value
	self._access[key] = access or ConfigManager.Access.ReadWrite
	if readonly then self._readonly[key] = true end
	return true
end

function ConfigManager:Get(key: string, default: any): any
	if type(key) ~= "string" or key == "" then return default end
	if self._overrides[key] ~= nil then return self._overrides[key] end
	if self._config[key] ~= nil then return self._config[key] end
	return default
end

function ConfigManager:SetDefault(key: string, default: any, access: string?): boolean
	if type(key) ~= "string" or key == "" then return false end
	self._config[key] = default
	self._access[key] = access or ConfigManager.Access.ReadWrite
	return true
end

function ConfigManager:SetReadOnly(key: string, value: any): boolean
	if type(key) ~= "string" or key == "" then return false end
	self._config[key] = value
	self._readonly[key] = true
	return true
end

function ConfigManager:Exists(key: string): boolean
	if type(key) ~= "string" or key == "" then return false end
	return self._config[key] ~= nil or self._overrides[key] ~= nil
end

function ConfigManager:Remove(key: string): boolean
	if self._config[key] == nil then return false end
	self._config[key] = nil
	self._access[key] = nil
	self._readonly[key] = nil
	return true
end

function ConfigManager:Override(key: string, value: any): boolean
	if type(key) ~= "string" or key == "" then return false end
	self._overrides[key] = value
	return true
end

function ConfigManager:GetKeys(): {string}
	local keys, seen = {}, {}
	for key in pairs(self._config) do
		if not seen[key] then seen[key] = true table.insert(keys, key) end
	end
	for key in pairs(self._overrides) do
		if not seen[key] then seen[key] = true table.insert(keys, key) end
	end
	return keys
end

function ConfigManager:GetReadWriteKeys(): {string}
	local keys = {}
	for key in pairs(self._config) do
		if self._access[key] ~= ConfigManager.Access.ReadOnly then table.insert(keys, key) end
	end
	return keys
end

function ConfigManager:ValidateRequired(required: {string}): (boolean, {string}?)
	local missing = {}
	for _, key in ipairs(required) do
		if not self:Exists(key) then table.insert(missing, key) end
	end
	if #missing > 0 then return false, missing end
	return true, nil
end

function ConfigManager:Export(): {[string]: any}
	local export = {}
	for key, value in pairs(self._config) do export[key] = value end
	for key, value in pairs(self._overrides) do export[key] = value end
	return export
end

function ConfigManager:Import(importedTable: {[string]: any}): boolean
	if type(importedTable) ~= "table" then return false end
	for key, value in pairs(importedTable) do self:Set(key, value) end
	return true
end

return ConfigManager
