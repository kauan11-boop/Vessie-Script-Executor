-- Public API System for Executor Lua
-- Versão: 1.0.0
-- Descrição: Sistema de API pública usando remote events do jogo
-- Compatível: Lua 5.1/5.2/5.3/5.4
-- Executores: Xeno, Delta, Mobile

local M = {}

M.config = {
    prefix = "/public_api",
    enabled = true,
    secure = true,
    allowed_commands = { "fly", "speed", "godmode", "noclip", "teleport", "verify", "antiafk", "esp", "reload" }
}

remote_connections = {}
registered_commands = {}

function M.register_command(name, func)
    if not name or type(name) ~= "string" then return false, "Nome inválido" end
    name = name:lower()
    if registered_commands[name] then return false, "Comando já registrado: " .. name end
    if M.config.secure then
        local allowed = false
        for _, cmd in ipairs(M.config.allowed_commands) do if cmd == name then allowed = true break end end
        if not allowed then return false, "Comando não permitido: " .. name end
    end
    registered_commands[name] = func
    return true, "Comando registrado: " .. name
end

function M.process_command(command, args)
    local cmd = command:lower()
    local func = registered_commands[cmd]
    if not func then return { success = false, error = "Comando não encontrado: " .. cmd, available = function_list() } end
    local success, result
    if M.config.secure then success, result = pcall(func, args)
    else success, result = xpcall(func, function(err) return { error = "Erro: " .. err } end, args) end
    return { success = success, result = result, command = cmd }
end

function function_list()
    local list = {}
    for name, _ in pairs(registered_commands) do table.insert(list, name) end
    return list
end

function M.setup_remote_event(remote_event_name, callback)
    if not remote_event_name or type(remote_event_name) ~= "string" then return false, "Nome inválido" end
    if not callback or type(callback) ~= "function" then return false, "Callback inválido" end
    remote_connections[remote_event_name] = { name = remote_event_name, callback = callback, registered = os.time() }
    M._trigger_remote_event = function(...) end
    return true, "Remote event configurado: " .. remote_event_name
end

function M.trigger_remote(command, args)
    local cmd = command:lower()
    if not registered_commands[cmd] then warn("[Public API] Comando desconhecido: " .. cmd) return false end
    local payload = { command = cmd, timestamp = os.time(), source = "public_api", nonvisual = true }
    if args and type(args) == "table" then payload.args = args end
    if M._trigger_remote_event then M._trigger_remote_event("public_api_" .. cmd, payload) end
    return true
end

function M.on_response(event_name, callback)
    if not event_name or type(event_name) ~= "string" then return false, "Nome inválido" end
    if not callback or type(callback) ~= "function" then return false, "Callback inválido" end
    if not remote_connections[event_name] then remote_connections[event_name] = { listeners = {} } end
    table.insert(remote_connections[event_name].listeners, callback)
    return true, "Listener registrado: " .. event_name
end

function M.send_response(request_id, success, data)
    local response = { request_id = request_id, success = success, data = data, timestamp = os.time(), nonvisual = true }
    -- Executor envia isso de volta pelo remote event
    return true
end

function M.init()
    M.register_command("fly", function(args) return { status = "fly_executed", args = args or {} } end)
    M.register_command("speed", function(args) local speed = args and args.speed or 16; return { status = "speed_set", speed = speed } end)
    M.register_command("godmode", function(args) return { status = "godmode_toggled" } end)
    M.register_command("teleport", function(args) local target = args and args.target or "player"; return { status = "teleported", target = target } end)
    M.register_command("noclip", function(args) return { status = "noclip_toggled" } end)
    M.register_command("verify", function(args) return { status = "verified" } end)
    M.register_command("antiafk", function(args) local enable = args and args.enable ~= false; return { status = "antiafk_" .. (enable and "enabled" or "disabled") } end)
    M.register_command("esp", function(args) local enable = args and args.enable ~= false; return { status = "esp_" .. (enable and "enabled" or "disabled") } end)
    M.register_command("reload", function(args) return { status = "reload_executed" } end)
    return true, "Public API inicializada com " .. #registered_commands .. " comandos"
end

local status, err = M.init()
if not status then error("Erro ao inicializar Public API: " .. (err or "unknown")) end

return M