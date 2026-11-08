-- State Manager for Public API
-- Gerencia estado nao-visual entre requisicoes via remote events
-- Mantem estado em memoria sem interfaces graficas

local M = {}

-- Estado global do sistema
local system_state = {
    initialized = false,
    command_count = 0,
    last_activity = 0,
    sessions = {},
    data = {},
}

-- Inicializar sistema de estado
function M.init()
    system_state = {
        initialized = true,
        command_count = 0,
        last_activity = os.time(),
        sessions = {},
        data = {},
    }
    return true, "Sistema de estado inicializado"
end

-- Obter estado atual
function M.get_state()
    return system_state
end

-- Atualizar estado
function M.update_state(key, value)
    if not key then
        return false, "Chave nao informada"
    end
    system_state.data = system_state.data or {}
    system_state.data[key] = value
    system_state.last_activity = os.time()
    return true, "Estado atualizado: " .. tostring(key)
end

-- Incrementar contador de comandos
function M.increment_command_count()
    system_state.command_count = (system_state.command_count or 0) + 1
    system_state.last_activity = os.time()
    return system_state.command_count
end

-- Registrar sessao
function M.register_session(session_id, session_data)
    system_state.sessions = system_state.sessions or {}
    system_state.sessions[session_id] = session_data or {}
    system_state.last_activity = os.time()
    return true, "Sessao registrada: " .. tostring(session_id)
end

-- Obter sessao
function M.get_session(session_id)
    system_state.sessions = system_state.sessions or {}
    return system_state.sessions[session_id], "Sessao: " .. tostring(session_id)
end

-- Remover sessao
function M.remove_session(session_id)
    system_state.sessions = system_state.sessions or {}
    if system_state.sessions[session_id] then
        system_state.sessions[session_id] = nil
        system_state.last_activity = os.time()
        return true, "Sessao removida: " .. tostring(session_id)
    end
    return false, "Sessao nao encontrada: " .. tostring(session_id)
end

-- Reiniciar estado (limpar tudo)
function M.reset()
    system_state = {
        initialized = false,
        command_count = 0,
        last_activity = 0,
        sessions = {},
        data = {},
    }
    return true, "Estado reiniciado"
end

-- Verificar se sistema foi inicializado
function M.is_initialized()
    return system_state.initialized or false
end

return M