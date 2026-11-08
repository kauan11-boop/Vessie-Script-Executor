-- Security Wrapper for Public API
-- Wrapper de seguranca para comandos remotos: allowlist/blocklist, rate limit e historico

local M = {}

local security_config = {
    enabled = true,
    allowed_commands = { "fly", "speed", "godmode", "noclip", "teleport", "verify", "antiafk", "esp", "reload" },
    blocked_commands = {},
    require_approval = false,
    max_executions_per_minute = 60,
}

local execution_history = {}
local execution_timers = {}

local function contains(list, value)
    for _, item in ipairs(list) do
        if item == value then return true end
    end
    return false
end

function M.is_command_allowed(command_name)
    if type(command_name) ~= "string" then return false, "Comando invalido" end
    local name = command_name:lower()
    if not security_config.enabled then return true end
    if contains(security_config.blocked_commands, name) then
        return false, "Comando bloqueado: " .. name
    end
    if #security_config.allowed_commands > 0 then
        if contains(security_config.allowed_commands, name) then return true end
        return false, "Comando nao na lista permitida: " .. name
    end
    return true
end

function M.block_command(command_name)
    if type(command_name) ~= "string" then return false, "Nome invalido" end
    local name = command_name:lower()
    if contains(security_config.blocked_commands, name) then
        return false, "Comando ja bloqueado: " .. name
    end
    table.insert(security_config.blocked_commands, name)
    return true, "Comando bloqueado: " .. name
end

function M.allow_command(command_name)
    if type(command_name) ~= "string" then return false, "Nome invalido" end
    local name = command_name:lower()
    if contains(security_config.allowed_commands, name) then
        return false, "Comando ja na lista de permissoes: " .. name
    end
    table.insert(security_config.allowed_commands, name)
    return true, "Comando permitido: " .. name
end

function M.check_rate_limit(command_name)
    if type(command_name) ~= "string" then return false, "Comando invalido" end
    local name = command_name:lower()
    local current_time = os.time()
    local timer = execution_timers[name]
    if not timer then
        timer = { count = 0, first_time = current_time }
        execution_timers[name] = timer
    end
    if current_time - timer.first_time >= 60 then
        timer.count = 0
        timer.first_time = current_time
    end
    timer.count = timer.count + 1
    local max = security_config.max_executions_per_minute
    if timer.count > max then
        return false, "Limite de executacoes excedido: " .. timer.count .. "/" .. max .. " exec/min"
    end
    return true, "Limite OK: " .. timer.count .. "/" .. max .. " exec/min"
end

function M.record_execution(command_name, success, args)
    if type(command_name) ~= "string" then return false end
    table.insert(execution_history, {
        command = command_name:lower(),
        success = success and true or false,
        timestamp = os.time(),
        args = args or {},
    })
    if #execution_history > 100 then
        table.remove(execution_history, 1)
    end
    return true
end

function M.get_execution_history()
    return execution_history
end

function M.get_config()
    return security_config
end

function M.set_config(new_config)
    if type(new_config) ~= "table" then return false, "Nenhuma configuracao fornecida" end
    if new_config.enabled ~= nil then security_config.enabled = new_config.enabled and true or false end
    if new_config.allowed_commands then security_config.allowed_commands = new_config.allowed_commands end
    if new_config.blocked_commands then security_config.blocked_commands = new_config.blocked_commands end
    if new_config.max_executions_per_minute then
        security_config.max_executions_per_minute = tonumber(new_config.max_executions_per_minute) or 60
    end
    return true, "Configuracao atualizada"
end

return M