-- Security Wrapper for Public API
-- Wrapper de seguranca para comandos remotos
-- Evita execucao de comandos nao autorizados e protege o executor

local M = {}

-- Configuracoes de seguranca
local security_config = {
    enabled = true,
    allowed_commands = {
        "fly",
        "speed",
        "godmode",
        "noclip",
        "teleport",
        "verify",
        "antiafk",
        "esp",
        "reload",
    },
    blocked_commands = {},
    require_approval = false,
    max_executions_per_minute = 60,
}

-- Historico de executados
local execution_history = {}
local execution_timers = {}

-- Verificar se comando e permitido
function M.is_command_allowed(command_name)
    local name = command_name:lower()

    -- Se seguranca desativada, permitir tudo
    if not security_config.enabled then
        return true
    end

    -- Verificar lista de comandos permitidos
    if #security_config.allowed_commands > 0 then
        -- Apenas comandos da lista permitida
        for _, allowed in ipairs(security_config.allowed_commands) do
            if allowed == name then
                return true
            end
        end
        return false, "Comando nao na lista permitida: " .. name
    end

    -- Verificar lista de comandos bloqueados
    for _, blocked in ipairs(security_config.blocked_commands) do
        if blocked == name then
            return false, "Comando bloqueado: " .. name
        end
    end

    -- Se nao tem lista de permissoes nem bloqueios, permitir por padrao
    return true
end

-- Registrar comando bloqueado
function M.block_command(command_name)
    local name = command_name:lower()
    if not security_config.blocked_commands[name] then
        table.insert(security_config.blocked_commands, name)
        return true, "Comando bloqueado: " .. name
    end
    return false, "Comando ja bloqueado: " .. name
end

-- Registrar comando permitido
function M.allow_command(command_name)
    local name = command_name:lower()
    if not security_config.allowed_commands[name] then
        table.insert(security_config.allowed_commands, name)
        return true, "Comando permitido: " .. name
    end
    return false, "Comando ja na lista de permissoes: " .. name
end

-- Verificar limite de executacoes por minuto
function M.check_rate_limit(command_name)
    local name = command_name:lower()
    local current_time = os.time()

    -- Inicializar timer se nao existir
    if not execution_timers[name] then
        execution_timers[name] = {
            count = 0,
            first_time = current_time,
        }
    end

    local timer = execution_timers[name]

    -- Resetar contador se passou 1 minuto
    if current_time - timer.first_time >= 60 then
        timer.count = 0
        timer.first_time = current_time
    end

    -- Incrementar contador
    timer.count = timer.count + 1

    -- Verificar limite
    if timer.count > security_config.max_executions_per_minute then
        return false, "Limite de executacoes excedido: " .. timer.count .. " exec/min"
    end

    return true, "Limite OK: " .. timer.count .. "/60 exec/min"
end

-- Registrar executado na historia
function M.record_execution(command_name, success, args)
    local name = command_name:lower()
    table.insert(execution_history, {
        command = name,
        success = success,
        timestamp = os.time(),
        args = args or {},
    })

    -- Manter historia tamanha (ultimos 100)
    if #execution_history > 100 then
        table.remove(execution_history, 1)
    end

    return true
end

-- Obter historico de executados
function M.get_execution_history()
    return execution_history
end

-- Obter configuracao de seguranca
function M.get_config()
    return security_config
end

-- Definir configuracao
function M.set_config(new_config)
    if not new_config then
        return false, "Nenhuma configuracao fornecida"
    end

    if new_config.enabled ~= nil then
        security_config.enabled = new_config.enabled
    end
    if new_config.allowed_commands then
        security_config.allowed_commands = new_config.allowed_commands
    end
    if new_config.blocked_commands then
        security_config.blocked_commands = new_config.blocked_commands
    end
    if new_config.max_executions_per_minute then
        security_config.max_executions_per_minute = new_config.max_executions_per_minute
    end

    return true, "Configuracao atualizada"
end

return M