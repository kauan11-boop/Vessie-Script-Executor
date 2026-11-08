-- NonVisual Channel for Public API
-- Canal de comunicacao nao-visual para enviar/receber informacoes
-- Sem interfaces graficas, apenas troca de dados por remote events

local M = {}

-- Canal ativo
local active_channel = nil

-- Definir canal ativo
function M.set_channel(channel_data)
    if not channel_data then
        active_channel = nil
        return true, "Canal desativado"
    end
    active_channel = {
        name = channel_data.name or "default",
        identifier = channel_data.identifier or "public_api",
        max_payload_size = channel_data.max_payload_size or 4096,
        timestamp = os.time(),
    }
    return true, "Canal definido: " .. (active_channel.name or "default")
end

-- Obter canal ativo
function M.get_channel()
    return active_channel
end

-- Enviar dados pelo canal nao-visual
function M.send(data, target)
    if not active_channel then
        return false, "Nenhum canal ativo. Use M.set_channel() primeiro."
    end

    if not data then
        return false, "Dados nao informados"
    end

    -- Preparar payload para remote event
    local payload = {
        channel = active_channel.identifier,
        data = data,
        timestamp = os.time(),
        nonvisual = true,
        source = "public_api",
    }

    -- Se target especificado, adicionar
    if target then
        payload.target = target
    end

    -- Retornar payload pronto para ser enviado via remote event
    -- O executor ira dispatchar isso para o remote event
    return true, payload
end

-- Receber dados do canal nao-visual
-- Esta funcao e chamada pelo executor quando remote event chega
function M.receive(event_name, payload)
    if not active_channel then
        return nil, "Nenhum canal ativo"
    end

    -- Verificar se e o canal correto
    if payload and payload.channel and payload.channel ~= active_channel.identifier then
        return nil, "Canal nao corresponde: " .. tostring(payload.channel)
    end

    -- Retornar dados recebidos
    local received_data = payload and payload.data
    return received_data, "Dados recebidos via canal: " .. tostring(active_channel.name)
end

-- Verificar se canal esta ativo
function M.is_channel_active()
    return active_channel ~= nil
end

-- Gerar ID de mensagem unico
function M.generate_message_id()
    return "msg_" .. tostring(os.time()) .. "_" .. tostring(math.random(1000, 9999))
end

return M