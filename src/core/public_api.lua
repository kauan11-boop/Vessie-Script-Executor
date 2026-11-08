-- Public API System for Executor Lua
-- Sistema de API pública usando remote events do jogo (não-visual)
-- Compatível: Lua 5.1/5.2/5.3/5.4 | Executores: Xeno, Delta, Mobile

local M = {}

M.config = {
    prefix = "/public_api",
    enabled = true,
    secure = true,
    allowed_commands = { "fly", "speed", "godmode", "noclip", "teleport", "verify", "antiafk", "esp", "reload" },
}

local remote_connections = {}
local registered_commands = {}

local function function_list()
    local list = {}
    for name in pairs(registered_commands) do
        table.insert(list, name)
    end
    table.sort(list)
    return list
end

local function is_allowed(name)
    if not M.config.secure then return true end
    for _, cmd in ipairs(M.config.allowed_commands) do
        if cmd == name then return true end
    end
    return false
end

function M.register_command(name, func)
    if type(name) ~= "string" or name == "" then return false, "Nome inválido" end
    if type(func) ~= "function" then return false, "Função inválida" end
    name = name:lower()
    if registered_commands[name] then return false, "Comando já registrado: " .. name end
    if not is_allowed(name) then return false, "Comando não permitido: " .. name end
    registered_commands[name] = func
    return true, "Comando registrado: " .. name
end

function M.unregister_command(name)
    if type(name) ~= "string" then return false, "Nome inválido" end
    name = name:lower()
    if not registered_commands[name] then return false, "Comando não registrado: " .. name end
    registered_commands[name] = nil
    return true, "Comando removido: " .. name
end

function M.process_command(command, args)
    if type(command) ~= "string" then return { success = false, error = "Comando inválido" } end
    local cmd = command:lower()
    local func = registered_commands[cmd]
    if not func then
        return { success = false, error = "Comando não encontrado: " .. cmd, available = function_list() }
    end
    -- pcall com closure: compatível com Lua 5.1 (xpcall não aceita args extras em 5.1)
    local ok, result = pcall(function() return func(args) end)
    if not ok then
        return { success = false, error = "Erro: " .. tostring(result), command = cmd }
    end
    return { success = true, result = result, command = cmd }
end

function M.list_commands()
    return function_list()
end

function M.allow_command(name)
    if type(name) ~= "string" then return false, "Nome inválido" end
    name = name:lower()
    for _, cmd in ipairs(M.config.allowed_commands) do
        if cmd == name then return true, "Já permitido: " .. name end
    end
    table.insert(M.config.allowed_commands, name)
    return true, "Comando permitido: " .. name
end

function M.setup_remote_event(remote_event_name, callback)
    if type(remote_event_name) ~= "string" then return false, "Nome inválido" end
    if type(callback) ~= "function" then return false, "Callback inválido" end
    remote_connections[remote_event_name] = { name = remote_event_name, callback = callback, registered = os.time() }
    M._trigger_remote_event = callback
    return true, "Remote event configurado: " .. remote_event_name
end

function M.trigger_remote(command, args)
    if type(command) ~= "string" then return false, "Comando inválido" end
    local cmd = command:lower()
    if not registered_commands[cmd] then
        warn("[Public API] Comando desconhecido: " .. cmd)
        return false
    end
    local payload = { command = cmd, timestamp = os.time(), source = "public_api", nonvisual = true }
    if type(args) == "table" then payload.args = args end
    if M._trigger_remote_event then
        M._trigger_remote_event("public_api_" .. cmd, payload)
    end
    return true
end

function M.on_response(event_name, callback)
    if type(event_name) ~= "string" then return false, "Nome inválido" end
    if type(callback) ~= "function" then return false, "Callback inválido" end
    remote_connections[event_name] = remote_connections[event_name] or { listeners = {} }
    remote_connections[event_name].listeners = remote_connections[event_name].listeners or {}
    table.insert(remote_connections[event_name].listeners, callback)
    return true, "Listener registrado: " .. event_name
end

function M.send_response(request_id, success, data)
    local response = { request_id = request_id, success = success, data = data, timestamp = os.time(), nonvisual = true }
    if M._trigger_remote_event then
        M._trigger_remote_event("public_api_response", response)
    end
    return true, response
end

function M.init()
    return true, "Public API inicializada"
end

return M