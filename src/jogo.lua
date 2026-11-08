--[[
  Módulo de Manipulação de Jogo - Vessie Script Executor
  Referências de jogadores/personagem, teleport, voo, itens, sons e eventos.
--]]

local Jogo = {}

Jogo.jogoAtual = nil
Jogo.jogadores = {}
Jogo.personagem = nil
Jogo.usuario = nil

local eventosCustom = {}
local volumesOriginais = {}

function Jogo:inicializar()
    if not game then
        warn("[Jogo] Ambiente de jogo não detectado - algumas funções podem não funcionar")
        return self
    end
    Jogo.jogoAtual = game
    Jogo.usuario = game.Players.LocalPlayer
    Jogo.jogadores = game.Players:GetPlayers()
    Jogo.personagem = Jogo.usuario and Jogo.usuario.Character

    game.Players.PlayerAdded:Connect(function(jogador)
        table.insert(Jogo.jogadores, jogador)
        Jogo:dispararEvento("PlayerAdded", jogador)
    end)
    game.Players.PlayerRemoving:Connect(function(jogador)
        for i, j in ipairs(Jogo.jogadores) do
            if j == jogador then table.remove(Jogo.jogadores, i) break end
        end
        Jogo:dispararEvento("PlayerRemoving", jogador)
    end)
    if Jogo.usuario then
        Jogo.usuario.CharacterAdded:Connect(function(char)
            Jogo.personagem = char
            Jogo:dispararEvento("CharacterAdded", char)
        end)
    end

    print("[Jogo] Referências inicializadas - " .. #Jogo.jogadores .. " jogadores encontrados")
    return self
end

-- Registra callback para eventos comuns do jogo ou eventos customizados
function Jogo:adicionarEvento(nome, callback)
    if type(nome) ~= "string" or type(callback) ~= "function" then return false end
    if game then
        if nome == "PlayerAdded" then return game.Players.PlayerAdded:Connect(callback) end
        if nome == "PlayerRemoving" then return game.Players.PlayerRemoving:Connect(callback) end
        if nome == "CharacterAdded" and Jogo.usuario then return Jogo.usuario.CharacterAdded:Connect(callback) end
    end
    eventosCustom[nome] = eventosCustom[nome] or {}
    table.insert(eventosCustom[nome], callback)
    return true
end

function Jogo:dispararEvento(nome, ...)
    if eventosCustom[nome] then
        for _, cb in ipairs(eventosCustom[nome]) do
            local ok, err = pcall(cb, ...)
            if not ok then warn("[Jogo] Evento '" .. nome .. "' erro: " .. tostring(err)) end
        end
    end
end

function Jogo:obterJogador(nomeOuUsuario)
    if not game then return nil end
    local alvo = game.Players:FindFirstChild(tostring(nomeOuUsuario))
    if not alvo then
        local id = tonumber(nomeOuUsuario)
        if id then alvo = game.Players:GetPlayerByUserId(id) end
    end
    return alvo
end

function Jogo:teleportar(destino, tipo)
    tipo = tipo or "cframe"
    local personagem = Jogo.personagem
    if not personagem or not personagem.PrimaryPart then
        warn("[Jogo] Personagem não encontrado")
        return false
    end
    if tipo == "cframe" and typeof(destino) == "CFrame" then
        personagem:SetPrimaryPartCFrame(destino)
        return true
    elseif tipo == "position" and typeof(destino) == "Vector3" then
        personagem:SetPrimaryPartCFrame(CFrame.new(destino))
        return true
    end
    warn("[Jogo] Destino inválido para teleport")
    return false
end

function Jogo:criarModoVoo(ativo)
    local personagem = Jogo.personagem
    if not personagem then return false end
    local torso = personagem:FindFirstChild("UpperTorso") or personagem:FindFirstChild("Torso") or personagem.PrimaryPart
    if not torso then return false end

    local bodyVel = torso:FindFirstChild("BodyVelocity")
    if ativo then
        if not bodyVel then
            bodyVel = Instance.new("BodyVelocity")
            bodyVel.Name = "BodyVelocity"
            bodyVel.Parent = torso
        end
        bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVel.Velocity = Vector3.new(0, 0, 0)
        print("[Jogo] Modo voo ativado")
        return true
    else
        if bodyVel then bodyVel:Destroy() end
        print("[Jogo] Modo voo desativado")
        return true
    end
end

function Jogo:obterFerramenta(nome)
    local personagem = Jogo.personagem
    if not personagem then return nil end
    return personagem:FindFirstChild(nome)
end

function Jogo:darItem(nomeItem, quantidade)
    local personagem = Jogo.personagem
    if not personagem then return false end
    local item = Instance.new("Tool")
    item.Name = nomeItem
    item.RequiresHandle = false
    item.Parent = personagem
    print("[Jogo] Item '" .. nomeItem .. "' dado para o jogador")
    return true
end

function Jogo:silenciarSons(ativo)
    if not game then return false end
    if ativo then
        for _, obj in ipairs(game:GetDescendants()) do
            if obj:IsA("Sound") then
                if volumesOriginais[obj] == nil then volumesOriginais[obj] = obj.Volume end
                obj.Volume = 0
            end
        end
    else
        for som, volume in pairs(volumesOriginais) do
            if som and som.Parent then som.Volume = volume end
        end
        volumesOriginais = {}
    end
    return true
end

function Jogo:espelharPersonagem(ativo)
    local personagem = Jogo.personagem
    if not personagem then return false end
    -- Placeholder:alteraria escala/C0 dos motores
    print("[Jogo] Espelhamento " .. (ativo and "ativado" or "desativado"))
    return true
end

return Jogo