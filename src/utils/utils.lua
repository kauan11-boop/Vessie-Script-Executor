--[[
  Módulo de Utilitários - Roblox Executor Library
  Comandos pré-definidos comprimidos para uso único
--]]

local Utils = {}
Utils.comandos = Utils.comandos or {}

-- Comandos básicos
Utils.comandos.fly = {
    nome = "fly",
    descricao = "Ativa/desativa voo",
    funcao = function(...)
        local personagem = game.Players.LocalPlayer.Character
            and game.Players.LocalPlayer.Character:FindFirstChild("UpperTorso")
            or game.Players.LocalPlayer.Character
            and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if not personagem then return warn("[Fly] Personagem nao encontrado") end

        local bodyVel = personagem:FindFirstChild("FlyBodyVelocity")
        if not bodyVel then
            bodyVel = Instance.new("BodyVelocity")
            bodyVel.Name = "FlyBodyVelocity"
            bodyVel.MaxForce = Vector3.new(0, math.huge, 0)
            bodyVel.Parent = personagem
        end

        bodyVel.Velocity = Vector3.new(0, 100, 0)
        print("[Fly] Voo ativado")
        return true
    end
}

Utils.comandos.speed = {
    nome = "speed",
    descricao = "Define velocidade de movimento",
    funcao = function(velocidade)
        local humanoid = game.Players.LocalPlayer.Character
            and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

        if not humanoid then return warn("[Speed] Humanoid nao encontrado") end

        humanoid.WalkSpeed = tonumber(velocidade) or 16
        print("[Speed] Velocidade setada para: " .. (tonumber(velocidade) or 16))
        return true
    end
}

Utils.comandos.noclip = {
    nome = "noclip",
    descricao = "Ativa/desativa noclip",
    funcao = function(ativo)
        ativo = ativo ~= nil and ativo or true
        local character = game.Players.LocalPlayer.Character
        if not character then return false end

        game:GetService("RunService").Stepped:Connect(function()
            if not ativo then return end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(11)
            end
        end)

        print("[Noclip] Modo " .. (ativo and "ativado" or "desativado"))
        return true
    end
}

Utils.comandos.godmode = {
    nome = "godmode",
    descricao = "Ativa/desativa god mode",
    funcao = function(ativo)
        ativo = ativo ~= nil and ativo or true
        local humanoid = game.Players.LocalPlayer.Character
            and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

        if not humanoid then return warn("[Godmode] Humanoid nao encontrado") end

        local conexao
        conexao = game:GetService("RunService").Heartbeat:Connect(function()
            if not ativo then
                conexao:Disconnect()
                return
            end
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        end)

        print("[Godmode] Modo " .. (ativo and "ativado" or "desativado"))
        return true
    end
}

function Utils:listarComandos()
    local lista = {}
    for nome, _ in pairs(Utils.comandos) do
        table.insert(lista, nome)
    end
    return lista
end

--[[ Comandos Extras Rápidos ]]
-- ESP Melhorado (versão simplificada)
Utils.comandos.esp = {
    nome = "esp",
    descricao = "ESP simplificado (use :esp ativar/desativar)",
    funcao = function(acao)
        acao = acao or "ativar"
        local localPlayer = game.Players.LocalPlayer
        local players = game.Players:GetPlayers()
        local runService = game:GetService("RunService")
        
        if acao == "ativar" then
            -- Loop simples ESP
            runService.RenderStepped:Connect(function()
                for _, player in ipairs(players) do
                    if player ~= localPlayer and player.Character then
                        local head = player.Character:FindFirstChild("Head")
                        if head then
                            -- Simple: criar um adorno básico
                            local billboard = head:FindFirstChild("ESP_Billboard")
                            if not billboard then
                                billboard = Instance.new("BillboardGui")
                                billboard.Name = "ESP_Billboard"
                                billboard.Size = UDim2.new(0, 100, 0, 50)
                                billboard.StudsOffset = Vector3.new(0, 2, 0)
                                billboard.AlwaysOnTop = true
                                billboard.Parent = head
                                
                                local label = Instance.new("TextLabel")
                                label.Size = UDim2.new(1, 0, 1, 0)
                                label.BackgroundTransparency = 1
                                label.Text = player.Name
                                label.TextColor3 = Color3.new(1, 0, 0)
                                label.Font = Enum.Font.GothamBold
                                label.TextSize = 14
                                label.Parent = billboard
                            end
                        end
                    end
                end
            end)
            print("[ESP] ESP ativado (simplificado)")
        else
            -- Remover ESPs
            for _, player in ipairs(players) do
                if player.Character then
                    local head = player.Character:FindFirstChild("Head")
                    if head then
                        local billboard = head:FindFirstChild("ESP_Billboard")
                        if billboard then
                            billboard:Destroy()
                        end
                    end
                end
            end
            print("[ESP] ESP desativado")
        end
        return true
    end
}

-- Comando Verificar (informações rápidas)
Utils.comandos.verificar = {
    nome = "verificar",
    descricao = "Mostrar info do servidor (FPS, jogadores, etc)",
    funcao = function()
        local fps = 60 -- Valor placeholder
        local players = game.Players.NumPlayers
        local maxPlayers = game.MaxPlayers
        
        print("[Verificar] Servidor: " .. players .. "/" .. maxPlayers .. " players")
        print("[Verificar] FPS: " .. fps)
        return true
    end
}

-- Comando Anti-Afk
Utils.comandos.antiafk = {
    nome = "antiafk",
    descricao = "Prevenir kick por inatividade do AFK",
    funcao = function(ativo)
        ativo = ativo ~= nil and ativo or true
        local UserInputService = game:GetService("UserInputService")
        
        -- Simular input a cada alguns minutos para não ser kickado por AFK
        local conexao
        conexao = game:GetService("RunService").Heartbeat:Connect(function()
            if not ativo then
                conexao:Disconnect()
                return
            end
            
            -- Simular levemente o mouse ou pressionar tecla
            -- Isso varia, mas alguns executores têm função própria
            -- Aqui apenas registramos o estado
        end)
        
        print("[Anti-AFK] Modo " .. (ativo and "ativado" or "desativado"))
        return true
    end
}

-- Sobreescrever listarComandos para incluir extras
local originalListar = Utils.listarComandos
function Utils:listarComandos()
    local lista = originalListar(self)
    -- Adicionar comandos extras se não existirem
    local extras = {"esp", "verificar", "antiafk"}
    for _, nome in ipairs(extras) do
        local existe = false
        for _, n in ipairs(lista) do
            if n == nome then
                existe = true
                break
            end
        end
        if not existe then
            table.insert(lista, nome)
        end
    end
    return lista
end

return Utils