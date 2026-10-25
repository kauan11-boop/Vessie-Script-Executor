-- Remote Event Bridge for Public API
-- Conecta o sistema Public API aos remote events do jogo
-- Permite execucao de comandos de forma nao-visual

local M = {}
local bridges = {}

-- Cria um bridge para um remote event específico
function M.create_bridge(remote_event_name)
    if not remote_event_name or type(remote_event_name) ~= "string" then
        return nil, "Nome do remote event invalido"
    end
    if bridges[remote_event_name] then
        return bridges[remote_event_name], "Bridge ja existente: " .. remote_event_name
    end

    local bridge = {
        name = remote_event_name,
        remote_event = nil, -- Setado pelo executor
        command_queue = {},
        is_processing = false,
        listeners = {},
        session_id = "public_api_" .. tostring(os.time()),
    }

    -- Registrar listener de resposta
    function bridge:on_response(callback)
        if type(callback) == "function" then
            table.insert(self.listeners, callback)
            return true, "Listener registrado para bridge: " .. self.name
        end
        return false, "Callback invalido"
    end

    -- Disparar comando via remote event
    function bridge:trigger(command, args)
        if not command or type(command) ~= "string" then
            return false, "Nome do comando invalido"
        end

        local cmd = command:lower()
        local payload = {
            command = cmd,
            session_id = self.session_id,
            timestamp = os.time(),
            nonvisual = true,
            args = args or {},
        }

        table.insert(self.command_queue, payload)

        -- Processar proximo comando se nao estiver processando
        if not self.is_processing then
            self:process_next()
        end

        return true, "Comando disparado: " .. cmd
    end

    -- Processar proximo comando da fila
    function bridge:process_next()
        if self.is_processing then
            return
        end

        if #self.command_queue == 0 then
            self.is_processing = false
            return
        end

        self.is_processing = true
        local payload = table.remove(self.command_queue, 1)

        -- Disparar remote event do jogo
        -- Isso sera implementado pelo executor especifico (Xeno, Delta, Mobile)
        if self.remote_event then
            -- executor: self.remote_event:FireServer(payload)
            self:_fire_remote(payload)
        end

        -- Marcar como nao mais processando e processar proximo
        self.is_processing = false
        self:process_next()
    end

    -- Fire remote event (implementacao especifica pelo executor)
    function bridge:_fire_remote(payload)
        -- Em producao, isso sera: self.remote_event:FireServer(payload)
        -- Aqui simulamos o processamento

        local success = true
        local data = { status = "executed", command = payload.command }

        -- Notificar listeners (resposta nao-visual)
        for _, listener in ipairs(self.listeners) do
            local ok, result = pcall(listener, success, data)
            if not ok then
                warn("Erro no listener do bridge: " .. tostring(result))
            end
        end
    end

    bridges[remote_event_name] = bridge
    return bridge, "Bridge criado para: " .. remote_event_name
end

-- Obter bridge existente
function M.get_bridge(remote_event_name)
    return bridges[remote_event_name]
end

-- Remover bridge
function M.remove_bridge(remote_event_name)
    if bridges[remote_event_name] then
        bridges[remote_event_name] = nil
        return true, "Bridge removido: " .. remote_event_name
    end
    return false, "Bridge nao encontrado: " .. remote_event_name
end

-- Listar todos bridges
function M.list_bridges()
    local list = {}
    for name, _ in pairs(bridges) do
        table.insert(list, name)
    end
    return list
end

-- Processar evento recebido do remote event do jogo
-- Esta funcao e chamada pelo executor quando o game dispara o event
function M.process_remote_event(event_name, payload)
    local bridge = bridges[event_name]
    if not bridge then
        return false, "Nenhum bridge registrado para event: " .. tostring(event_name)
    end

    -- Extrair comando do payload
    local command = payload and payload.command
    if not command then
        return false, "Payload nao contem comando"
    end

    -- Processar comando atraves da Public API
    local processed = M.process_command(command, payload and payload.args)

    -- Notificar listeners da resposta nao-visual
    if bridge.listeners and #bridge.listeners > 0 then
        local success = processed.success or false
        local data = processed.result or { error = "Erro desconhecido" }

        for _, listener in ipairs(bridge.listeners) do
            local ok, result = pcall(listener, success, data)
            if not ok then
                warn("Erro no listener: " .. tostring(result))
            end
        end
    end

    return true, "Evento processado: " .. tostring(command)
end

-- Setup do remote event no executor
-- Esta funcao deve ser chamada no main.lua do executor
function M.setup(remote_event_name)
    local bridge, msg = M.create_bridge(remote_event_name)
    if not bridge then
        error("Nao foi possivel criar bridge: " .. tostring(msg))
    end

    -- O executor conectara o remote event aqui
    -- Exemplo para executores Lua:
    -- local ReplicatedStorage = game:GetService("ReplicatedStorage")
    -- bridge.remote_event = ReplicatedStorage:WaitForChild(remote_event_name)
    -- 
    -- -- Quando o remote event e disparado, processa o evento
    -- bridge.remote_event.OnServerEvent:Connect(function(player, payload)
    --     M.process_remote_event(remote_event_name, payload)
    -- end)

    return bridge, msg
end

return M