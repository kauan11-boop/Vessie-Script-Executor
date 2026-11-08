-- Command Dispatcher for Public API
-- Responsavel por dispatcher de comandos recebidos via remote events
-- Compatibilidade: Lua 5.1/5.2/5.3/5.4

local M = {}

-- Tabela de handlers de comandos
local command_handlers = {}

-- Registrar handler de comando
function M.register_handler(command_name, handler_func)
    if not command_name or type(command_name) ~= "string" then
        return false, "Nome do comando invalido"
    end
    if not handler_func or type(handler_func) ~= "function" then
        return false, "Handler funcao invalida"
    end
    command_handlers[command_name:lower()] = handler_func
    return true, "Handler registrado: " .. command_name
end

-- Obter handler de comando
function M.get_handler(command_name)
    return command_handlers[command_name:lower()]
end

-- Dispatcher de comando
-- Processa um comando e chama o handler apropriado
function M.dispatch(command_name, args)
    local name = command_name:lower()
    local handler = command_handlers[name]

    if not handler then
        return {
            success = false,
            error = "Comando nao encontrado: " .. command_name,
            available = function_list()
        }
    end

    -- Executar handler com protecao de erro
    local success, result
    if M._is_secure then
        success, result = pcall(handler, args)
    else
        success, result = xpcall(handler, function(err)
            return { error = "Erro na execucao: " .. tostring(err) }
        end, args)
    end

    return {
        success = success,
        result = result,
        command = command_name
    }
end

-- Listar comandos disponiveis
function function_list()
    local list = {}
    for name, _ in pairs(command_handlers) do
        table.insert(list, name)
    end
    return list
end

-- Definir modo seguro
function M.set_secure(secure)
    M._is_secure = secure
    return true, "Modo " .. (secure and "seguro" or "inseguro") .. " definido"
end

return M