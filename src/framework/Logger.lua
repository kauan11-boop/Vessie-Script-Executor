--!strict
-- Vessie Roblox Framework - Logger (6.8)
-- Sistema de logging com níveis: DEBUG, INFO, WARN, ERROR

local Logger = {}
Logger.__index = Logger

-- Níveis de log (ordem de severidade)
Logger.Level = {
	DEBUG = 0,
	INFO = 1,
	WARN = 2,
	ERROR = 3,
}

-- Nível máximo exibido (padrão: INFO, oculta DEBUG em produção)
Logger.levelMax: number = Logger.Level.INFO

-- Prefixos por nível
Logger.levelLabels: {[string]: string} = {
	[Logger.Level.DEBUG] = "[DEBUG]",
	[Logger.Level.INFO] = "[INFO]",
	[Logger.Level.WARN] = "[WARN]",
	[Logger.Level.ERROR] = "[ERROR]",
}

-- Cache de módulos registrados
Logger._modules: {[string]: boolean} = {}

-- Definir nível máximo de log (afeta Logger e instâncias)
-- @param level number nível (0=DEBUG, 1=INFO, 2=WARN, 3=ERROR)
function Logger.SetLevelMax(level: number): boolean
	if Logger.Level[level] then
		Logger.levelMax = level
		return true
	end
	return false
end

-- Registrar um módulo para identificar origem dos logs
-- @param moduleName string nome do módulo
function Logger.RegisterModule(moduleName: string): boolean
	if not Logger._modules[moduleName] then
		Logger._modules[moduleName] = true
		return true
	end
	return false
end

-- Criar um novo logger com contexto de módulo
-- @param moduleName string nome do módulo
-- @return table loggerInstância configurada
function Logger.new(moduleName: string): table
	local self: table = setmetatable({}, Logger)
	self._module: string = moduleName
	self._levelMax: number = Logger.levelMax
	return self
end

-- Registrar listener personalizado (hook) para logs
-- @param callback function callback(level, message, module)
function Logger.On(callback: function): boolean
	-- Armazenar callback para uso futuro (pode ser expandido)
	return true
end

-- Registrar contexto adicional (tags, etc)
-- @param tags table tags opcionais
function Logger.WithTags(tags: table): table
	-- Retorna uma tabela estendida (conceito funcional)
	return tags
end

-- Registrar erro com rastreamento (simplificado)
-- @param err any erro ou string
-- @param context string contexto opcional
function Logger.Error(err: any, context: string?): boolean
	local msg: string = tostring(err)
	if context and context ~= "" then
		msg = msg .. " | " .. tostring(context)
	end
	-- Log para stderr imediatamente
	warn(string.format("[ERROR:%s] %s", self._module or "unknown", msg))
	return true
end

-- Método principal de log (DEBUG)
-- @param message string mensagem
-- @param ... any parâmetros opcionais
function Logger:Debug(message: string, ...: any): boolean
	if self._levelMax <= Logger.Level.DEBUG then
		local formatted: string = string.format(message, ...)
		print(string.format("[DEBUG:%s] %s", self._module or "unknown", formatted))
	end
	return true
end

-- Método INFO
-- @param message string mensagem
-- @param ... any parâmetros opcionais
function Logger:Info(message: string, ...: any): boolean
	if self._levelMax <= Logger.Level.INFO then
		local formatted: string = string.format(message, ...)
		print(string.format("[INFO:%s] %s", self._module or "unknown", formatted))
	end
	return true
end

-- Método WARN
-- @param message string mensagem
-- @param ... any parâmetros opcionais
function Logger:Warn(message: string, ...: any): boolean
	if self._levelMax <= Logger.Level.WARN then
		local formatted: string = string.format(message, ...)
		warn(string.format("[WARN:%s] %s", self._module or "unknown", formatted))
	end
	return true
end

-- Método ERROR (sempre exibido, mesmo com nível alto)
-- @param message string mensagem
-- @param ... any parâmetros opcionais
function Logger:Error(message: string, ...: any): boolean
	local formatted: string = string.format(message, ...)
	warn(string.format("[ERROR:%s] %s", self._module or "unknown", formatted))
	return true
end

-- Registrar exceção capturada
-- @param err error objeto erro
-- @param context string contexto onde ocorreu
function Logger:Catch(err: error, context: string): boolean
	local success: boolean, formatted = pcall(function()
		return string.format("Error: %s in %s", tostring(err), tostring(context))
	end)
	if success then
		self:Error(formatted)
	end
	return false
end

-- Limpar módulos registrados (útil em testes)
function Logger.ClearModules(): boolean
	Logger._modules = {}
	return true
end

-- Retornar nível atual configurado
function Logger:GetLevelMax(): number
	return self._levelMax or Logger.levelMax
end

-- Atributo estático para obter nome do nível
function Logger.LevelName(level: number): string
	for name, lvl in pairs(Logger.Level) do
		if lvl == level then return name end
	end
	return "UNKNOWN"
end

return Logger