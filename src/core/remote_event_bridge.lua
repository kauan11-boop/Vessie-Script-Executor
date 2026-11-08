-- Remote Event Bridge for Public API
-- Conecta o sistema Public API aos remote events do jogo (execução não-visual)

local M = {}
local bridges = {}
local processor = nil
local session_counter = 0

-- Define a função que processa comandos (injetada pelo core; evita acoplamento direto)
function M.set_processor(func)
    if type(func) ~= "function" then return false, "Processor invalido" end
    processor = func
    return true
end

function M.create_bridge(remote_event_name)
    if type(remote_event_name) ~= "string" or remote_event_name == "" then
        return nil, "Nome do remote event invalido"
    end
    if bridges[remote_event_name] then
        return bridges[remote_event_name], "Bridge ja existente: " .. remote_event_name
    end

    session_counter = session_counter + 1
    local bridge = {
        name = remote_event_name,
        remote_event = nil, -- setado pelo executor
        command_queue = {},
        is_processing = false,
        listeners = {},
        session_id = "public_api_" .. tostring(os.time()) .. "_" .. tostring(session_counter),
    }

    function bridge:on_response(callback)
        if type(callback) == "function" then
            table.insert(self.listeners, callback)
            return true, "Listener registrado para bridge: " .. self.name
        end
        return false, "Callback invalido"
    end

    function bridge:trigger(command, args)
        if type(command) ~= "string" then return false, "Nome do comando invalido" end
        local payload = {
            command = command:lower(),
            session_id = self.session_id,
            timestamp = os.time(),
            nonvisual = true,
            args = args or {},
        }
        table.insert(self.command_queue, payload)
        self:process_next()
        return true, "Comando disparado: " .. payload.command
    end

    function bridge:process_next()
        if self.is_processing then return end
        self.is_processing = true
        while #self.command_queue > 0 do
            local payload = table.remove(self.command_queue, 1)
            self:_fire_remote(payload)
        end
        self.is_processing = false
    end

    function bridge:_fire_remote(payload)
        -- Em produção: self.remote_event:FireServer(payload)
        -- Aqui simulamos a resposta e notificamos os listeners.
        local success = true
        local data = { status = "executed", command = payload.command }
        if processor then
            local processed = processor(payload.command, payload.args)
            success = processed and processed.success or false
            data = processed and processed.result or data
        end
        for _, listener in ipairs(self.listeners) do
            local ok, err = pcall(listener, success, data)
            if not ok then warn("Erro no listener do bridge: " .. tostring(err)) end
        end
    end

    bridges[remote_event_name] = bridge
    return bridge, "Bridge criado para: " .. remote_event_name
end

function M.get_bridge(remote_event_name)
    return bridges[remote_event_name]
end

function M.remove_bridge(remote_event_name)
    if bridges[remote_event_name] then
        bridges[remote_event_name] = nil
        return true, "Bridge removido: " .. remote_event_name
    end
    return false, "Bridge nao encontrado: " .. tostring(remote_event_name)
end

function M.list_bridges()
    local list = {}
    for name in pairs(bridges) do table.insert(list, name) end
    table.sort(list)
    return list
end

-- Chamado pelo executor quando o jogo dispara um remote event
function M.process_remote_event(event_name, payload)
    local bridge = bridges[event_name]
    if not bridge then
        return false, "Nenhum bridge registrado para event: " .. tostring(event_name)
    end
    local command = payload and payload.command
    if not command then return false, "Payload nao contem comando" end

    local processed
    if processor then
        processed = processor(command, payload.args)
    else
        processed = { success = false, error = "Nenhum processor configurado" }
    end

    local success = processed and processed.success or false
    local data = processed and processed.result or { error = "Erro desconhecido" }
    for _, listener in ipairs(bridge.listeners) do
        local ok, err = pcall(listener, success, data)
        if not ok then warn("Erro no listener: " .. tostring(err)) end
    end
    return true, "Evento processado: " .. tostring(command)
end

function M.setup(remote_event_name)
    local bridge, msg = M.create_bridge(remote_event_name)
    if not bridge then error("Nao foi possivel criar bridge: " .. tostring(msg)) end
    -- O executor conecta o remote event aqui, ex.:
    -- bridge.remote_event = game:GetService("ReplicatedStorage"):WaitForChild(remote_event_name)
    -- bridge.remote_event.OnClientEvent:Connect(function(payload)
    --     M.process_remote_event(remote_event_name, payload)
    -- end)
    return bridge, msg
end

return M