-- Command Dispatcher for Public API
-- Despacho de comandos recebidos via remote events
-- Compatibilidade: Lua 5.1/5.2/5.3/5.4

local M = {}

local command_handlers = {}

local function function_list()
    local list = {}
    for name in pairs(command_handlers) do
        table.insert(list, name)
    end
    table.sort(list)
    return list
end

function M.register_handler(command_name, handler_func)
    if type(command_name) ~= "string" or command_name == "" then
        return false, "Nome do comando invalido"
    end
    if type(handler_func) ~= "function" then
        return false, "Handler funcao invalida"
    end
    command_handlers[command_name:lower()] = handler_func
    return true, "Handler registrado: " .. command_name
end

function M.get_handler(command_name)
    if type(command_name) ~= "string" then return nil end
    return command_handlers[command_name:lower()]
end

function M.dispatch(command_name, args)
    if type(command_name) ~= "string" then
        return { success = false, error = "Comando invalido" }
    end
    local name = command_name:lower()
    local handler = command_handlers[name]
    if not handler then
        return { success = false, error = "Comando nao encontrado: " .. command_name, available = function_list() }
    end
    local ok, result = pcall(function() return handler(args) end)
    if not ok then
        return { success = false, error = "Erro na execucao: " .. tostring(result), command = command_name }
    end
    return { success = true, result = result, command = command_name }
end

function M.list_commands()
    return function_list()
end

function M.set_secure(secure)
    M._is_secure = secure and true or false
    return true, "Modo " .. (M._is_secure and "seguro" or "inseguro") .. " definido"
end

return M