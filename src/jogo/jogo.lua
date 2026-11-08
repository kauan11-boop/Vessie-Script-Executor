--[[
  Módulo de Manipulação de Jogo - Roblox Executor Library
  Funções para interagir com o jogo Roblox
--]]

local Jogo = {}

-- Referências ao jogo atual
Jogo.jogoAtual = nil
Jogo.jogadores = {}
Jogo.personagem = nil
Jogo.usuario = nil

-- Inicializar referências do jogo
function Jogo:inicializar()
    -- Verificar se estamos no ambiente Roblox
    if game then
        Jogo.jogoAtual = game
        Jogo.jogadores = game.Players:GetPlayers()
        Jogo.usuario = game.Players.LocalPlayer
        Jogo.personagem = Jogo.usuario and Jogo.usuario.Character
        
        -- Configurar observadores de eventos
        game.Players.PlayerAdded:Conectar(function(jogador)
            table.insert(Jogo.jogadores, jogador)
        end)
        
        game.Players.PlayerRemoving:Conectar(function(jogador)
            -- Remover da tabela
            for i, j in ipairs(Jogo.jogadores) do
                if j == jogador then
                    table.remove(Jogo.jogadores, i)
                    break
                end
            end
        end)
        
        print("[Jogo] Referências inicializadas - " #Jogo.jogadores .. " jogadores encontrados")
    else
        warn("[Jogo] Ambiente de jogo não detectado - algumas funções podem não funcionar")
    end
    return self
end

-- Função para obter um jogador pelo nome
function Jogo:obterJogador(nomeOuUsuario)
    local alvo = nil
    
    -- Tentar como nome de jogador
    alvo = game.Players:FindFirstChild(nomeOuUsuario)
    
    -- Se não encontrou, tentar como UserId
    if not alvo then
        alvo = game.Players:GetPlayerByUserId(tonumber(nomeOuUsuario))
    end
    
    return alvo
end

-- Função para teleportar jogador
function Jogo:teleportar(destino, tipo)
    tipo = tipo or "cframe" -- cframe ou position
    
    local personagem = Jogo.personagem
    if not personagem then
        warn("[Jogo] Personagem não encontrado")
        return false
    end
    
    local sucesso = false
    
    if tipo == "cframe" and destino then
        -- Teleport via CFrame
        personagem:SetPrimaryPartCFrame(destino)
        sucesso = true
    elseif tipo == "position" and destino then
        -- Teleport via posição
        if personagem.PrimaryPart then
            personagem.PrimaryPart.Position = destino.Position
            sucesso = true
        end
    end
    
    if sucesso then
        print("[Jogo] Teleportação realizada para " .. tostring(tipo))
    end
    
    return sucesso
end

-- Função para criar espelho (noclip, fly, etc.)
function Jogo:criarModoVoo(ativo)
    local personagem = Jogo.personagem
    if not personagem then return false end
    
    -- Setup do BodyVelocity para voo
    local torso = personagem:FindFirstChild("UpperTorso") or personagem:FindFirstChild("Torso")
    if not torso then return false end
    
    if ativo then
        -- Criar ou reativar BodyVelocity
        local bodyVel = torso:FindFirstChild("BodyVelocity")
        if not bodyVel then
            bodyVel = Instance.new("BodyVelocity")
            bodyVel.Name = "BodyVelocity"
            bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVel.Velocity = Vector3.new(0, 0, 0)
            bodyVel.Parent = torso
        else
            bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVel.Velocity = Vector3.new(0, 0, 0)
        end
        
        -- Também pode precisar do BodyPosition/RotVelocity para manter altura
        print("[Jogo] Modo voo ativado")
        return true
    else
        -- Remover BodyVelocity
        local bodyVel = torso:FindFirstChild("BodyVelocity")
        if bodyVel then
            bodyVel:Destroy()
            print("[Jogo] Modo voo desativado")
            return true
        end
    end
    
    return false
end

-- Função para obter ferramenta/weapon
function Jogo:obterFerramenta(nome)
    local personagem = Jogo.personagem
    if not personagem then return nil end
    
    return personagem:FindFirstChild(nome)
end

-- Função para dar item/arma
function Jogo:darItem(nomeItem, quantidade)
    local personagem = Jogo.personagem
    if not personagem then return false end
    
    -- Criar ferramenta ou dar dano, etc.
    local item = Instance.new("Tool")
    item.Name = nomeItem
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1, 1, 1)
    handle.Parent = item
    
    item.Parent = personagem
    
    print("[Jogo] Item '" .. nomeItem .. "' dado para o jogador")
    return true
end

-- Função para silenciar som
function Jogo:silenciarSons(ativo)
    -- Remover ou silenciar todos os Sound objects
    if game then
        if ativo then
            -- Conectar evento para silenciar sons novos
            local sonsAntigos = game:GetDescendants()
            for _, obj in ipairs(sonsAntigos) do
                if obj:IsA("Sound") then
                    obj.Volume = 0
                end
            end
        else
            -- Restaurar volumes
        end
    end
    return true
end

-- Função para espelhar personagem (opcional)
function Jogo:espelharPersonagem(ativo)
    local personagem = Jogo.personagem
    if not personagem then return false end
    
    -- Isso alteraria a escala ou C0/C1 dos motores
    -- Placeholder para futura implementação
    print("[Jogo] Espelhamento " .. (ativo and "ativado" or "desativado"))
    return true
end

return Jogo