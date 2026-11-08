--!strict
-- Vessie Roblox Framework - Logger
-- Logging com niveis DEBUG/INFO/WARN/ERROR e contexto de modulo.
-- levelMax = severidade MINIMA exibida (INFO oculta DEBUG). ERROR sempre aparece.

local Logger = {}
Logger.__index = Logger

Logger.Level = { DEBUG = 0, INFO = 1, WARN = 2, ERROR = 3 }
Logger.levelMax = Logger.Level.INFO
Logger._modules = {}
Logger._listeners = {}

function Logger.LevelName(level: number): string
	for name, lvl in pairs(Logger.Level) do
		if lvl == level then return name end
	end
	return "UNKNOWN"
end

function Logger.SetLevelMax(level: any): boolean
	if type(level) == "number" and level >= 0 and level <= 3 then
		Logger.levelMax = level
		return true
	end
	if type(level) == "string" and Logger.Level[level] ~= nil then
		Logger.levelMax = Logger.Level[level]
		return true
	end
	return false
end

function Logger.RegisterModule(moduleName: string): boolean
	if type(moduleName) ~= "string" then return false end
	if Logger._modules[moduleName] then return false end
	Logger._modules[moduleName] = true
	return true
end

function Logger.new(moduleName: string?)
	local self = setmetatable({}, Logger)
	self._module = moduleName or "unknown"
	return self
end

function Logger.On(callback: any): boolean
	if type(callback) ~= "function" then return false end
	table.insert(Logger._listeners, callback)
	return true
end

function Logger.WithTags(tags: any): any
	return tags
end

local function formatMessage(message, ...): string
	local ok, result = pcall(string.format, message, ...)
	return ok and result or tostring(message)
end

local function emit(level: number, module: string, msg: string)
	if level < Logger.levelMax and level ~= Logger.Level.ERROR then return end
	local line = string.format("[%s:%s] %s", Logger.LevelName(level), module, msg)
	if level >= Logger.Level.WARN then warn(line) else print(line) end
	for _, cb in ipairs(Logger._listeners) do
		pcall(cb, level, msg, module)
	end
end

function Logger:Debug(message: string, ...): boolean
	emit(Logger.Level.DEBUG, self._module, formatMessage(message, ...))
	return true
end

function Logger:Info(message: string, ...): boolean
	emit(Logger.Level.INFO, self._module, formatMessage(message, ...))
	return true
end

function Logger:Warn(message: string, ...): boolean
	emit(Logger.Level.WARN, self._module, formatMessage(message, ...))
	return true
end

function Logger:Error(message: string, ...): boolean
	emit(Logger.Level.ERROR, self._module, formatMessage(message, ...))
	return true
end

-- Helper estatico (sem self) para erros pontuais
function Logger.LogError(err: any, context: string?): boolean
	local msg = tostring(err)
	if context and context ~= "" then msg = msg .. " | " .. tostring(context) end
	emit(Logger.Level.ERROR, "global", msg)
	return true
end

function Logger:Catch(err: any, context: string?): boolean
	self:Error("Error: %s in %s", tostring(err), tostring(context or "unknown"))
	return true
end

function Logger.ClearModules(): boolean
	Logger._modules = {}
	return true
end

function Logger:GetLevelMax(): number
	return Logger.levelMax
end

return Logger
