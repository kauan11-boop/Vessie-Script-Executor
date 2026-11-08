--[[
  Módulo de Utilitários - Vessie Script Executor
  Comandos prontos de jogo em Utils.comandos.<nome> = { nome, descricao, funcao }.
  Comandos de toggle gerenciam suas conexões em Utils._conexoes (sem leaks).
--]]

local Utils = {}
Utils.comandos = {}
Utils._conexoes = {}

local function personagem()
    return game.Players.LocalPlayer.Character
end

local function humanoid()
    local char = personagem()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function root()
    local char = personagem()
    return char and (char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart)
end

local function desconectar(nome)
    if Utils._conexoes[nome] then
        Utils._conexoes[nome]:Disconnect()
        Utils._conexoes[nome] = nil
    end
end

Utils.comandos.fly = {
    nome = "fly",
    descricao = "Ativa/desativa voo (hover)",
    funcao = function(ativo)
        ativo = ativo ~= false
        local alvo = root()
        if not alvo then return warn("[Fly] Personagem nao encontrado") end
        local bodyVel = alvo:FindFirstChild("FlyBodyVelocity")
        if ativo then
            if not bodyVel then
                bodyVel = Instance.new("BodyVelocity")
                bodyVel.Name = "FlyBodyVelocity"
                bodyVel.Parent = alvo
            end
            bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVel.Velocity = Vector3.new(0, 0, 0)
            print("[Fly] Voo ativado")
        else
            if bodyVel then bodyVel:Destroy() end
            print("[Fly] Voo desativado")
        end
        return true
    end,
}

Utils.comandos.speed = {
    nome = "speed",
    descricao = "Define velocidade de movimento",
    funcao = function(velocidade)
        local hum = humanoid()
        if not hum then return warn("[Speed] Humanoid nao encontrado") end
        hum.WalkSpeed = tonumber(velocidade) or 16
        print("[Speed] Velocidade: " .. hum.WalkSpeed)
        return true
    end,
}

Utils.comandos.noclip = {
    nome = "noclip",
    descricao = "Ativa/desativa noclip",
    funcao = function(ativo)
        ativo = ativo ~= false
        local char = personagem()
        if not char then return false end
        desconectar("noclip")
        if ativo then
            Utils._conexoes.noclip = game:GetService("RunService").Stepped:Connect(function()
                for _, parte in ipairs(char:GetDescendants()) do
                    if parte:IsA("BasePart") then parte.CanCollide = false end
                end
            end)
        else
            for _, parte in ipairs(char:GetDescendants()) do
                if parte:IsA("BasePart") then parte.CanCollide = true end
            end
        end
        print("[Noclip] " .. (ativo and "ativado" or "desativado"))
        return true
    end,
}

Utils.comandos.godmode = {
    nome = "godmode",
    descricao = "Ativa/desativa god mode",
    funcao = function(ativo)
        ativo = ativo ~= false
        local hum = humanoid()
        if not hum then return warn("[Godmode] Humanoid nao encontrado") end
        desconectar("godmode")
        if ativo then
            Utils._conexoes.godmode = game:GetService("RunService").Heartbeat:Connect(function()
                if hum.Parent then
                    hum.MaxHealth = math.huge
                    hum.Health = math.huge
                end
            end)
        end
        print("[Godmode] " .. (ativo and "ativado" or "desativado"))
        return true
    end,
}

Utils.comandos.esp = {
    nome = "esp",
    descricao = "ESP simplificado (ativar/desativar)",
    funcao = function(acao)
        acao = acao or "ativar"
        local localPlayer = game.Players.LocalPlayer
        local runService = game:GetService("RunService")
        desconectar("esp")
        if acao == "ativar" then
            Utils._conexoes.esp = runService.RenderStepped:Connect(function()
                for _, player in ipairs(game.Players:GetPlayers()) do
                    if player ~= localPlayer and player.Character then
                        local head = player.Character:FindFirstChild("Head")
                        if head and not head:FindFirstChild("ESP_Billboard") then
                            local billboard = Instance.new("BillboardGui")
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
            end)
            print("[ESP] ativado")
        else
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player.Character then
                    local head = player.Character:FindFirstChild("Head")
                    local billboard = head and head:FindFirstChild("ESP_Billboard")
                    if billboard then billboard:Destroy() end
                end
            end
            print("[ESP] desativado")
        end
        return true
    end,
}

Utils.comandos.verificar = {
    nome = "verificar",
    descricao = "Mostra info do servidor (jogadores, place, FPS)",
    funcao = function()
        local players = #game.Players:GetPlayers()
        local maxPlayers = game.Players.MaxPlayers
        print("[Verificar] Servidor: " .. players .. "/" .. maxPlayers .. " players | PlaceId: " .. game.PlaceId)
        return true
    end,
}

Utils.comandos.antiafk = {
    nome = "antiafk",
    descricao = "Previne kick por inatividade",
    funcao = function(ativo)
        ativo = ativo ~= false
        desconectar("antiafk")
        if ativo then
            local ok, virtualUser = pcall(function() return game:GetService("VirtualUser") end)
            if ok and virtualUser then
                Utils._conexoes.antiafk = game.Players.LocalPlayer.Idled:Connect(function()
                    virtualUser:CaptureController()
                    virtualUser:ClickButton2(Vector2.new())
                end)
                print("[Anti-AFK] ativado")
                return true
            end
            warn("[Anti-AFK] VirtualUser indisponível neste executor")
            return false
        end
        print("[Anti-AFK] desativado")
        return true
    end,
}

Utils.comandos.teleport = {
    nome = "teleport",
    descricao = "Teleporta até um jogador (nome) ou posição",
    funcao = function(alvo)
        local rp = root()
        if not rp then return warn("[Teleport] Personagem nao encontrado") end
        if type(alvo) == "string" then
            local player = game.Players:FindFirstChild(alvo)
            local alvoRoot = player and player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not alvoRoot then return warn("[Teleport] Jogador nao encontrado: " .. alvo) end
            rp.CFrame = alvoRoot.CFrame
        elseif typeof(alvo) == "Vector3" then
            rp.CFrame = CFrame.new(alvo)
        elseif typeof(alvo) == "CFrame" then
            rp.CFrame = alvo
        else
            return warn("[Teleport] Alvo inválido")
        end
        print("[Teleport] realizado")
        return true
    end,
}

Utils.comandos.fullbright = {
    nome = "fullbright",
    descricao = "Ativa/desativa iluminação máxima",
    funcao = function(ativo)
        ativo = ativo ~= false
        local lighting = game:GetService("Lighting")
        if ativo then
            Utils._fullbright = { Brightness = lighting.Brightness, ClockTime = lighting.ClockTime, FogEnd = lighting.FogEnd, GlobalShadows = lighting.GlobalShadows }
            lighting.Brightness = 2
            lighting.ClockTime = 14
            lighting.FogEnd = 1e9
            lighting.GlobalShadows = false
        elseif Utils._fullbright then
            for prop, valor in pairs(Utils._fullbright) do lighting[prop] = valor end
            Utils._fullbright = nil
        end
        print("[Fullbright] " .. (ativo and "ativado" or "desativado"))
        return true
    end,
}

Utils.comandos.gravity = {
    nome = "gravity",
    descricao = "Define a gravidade do workspace",
    funcao = function(valor)
        workspace.Gravity = tonumber(valor) or 196.2
        print("[Gravity] " .. workspace.Gravity)
        return true
    end,
}

Utils.comandos.reset = {
    nome = "reset",
    descricao = "Reseta o personagem (mata)",
    funcao = function()
        local hum = humanoid()
        if not hum then return false end
        hum.Health = 0
        return true
    end,
}

Utils.comandos.sit = {
    nome = "sit",
    descricao = "Senta/levanta o personagem",
    funcao = function(ativo)
        local hum = humanoid()
        if not hum then return false end
        hum.Sit = ativo ~= false
        return true
    end,
}

Utils.comandos.jump = {
    nome = "jump",
    descricao = "Define a força do pulo",
    funcao = function(valor)
        local hum = humanoid()
        if not hum then return false end
        hum.UseJumpPower = true
        hum.JumpPower = tonumber(valor) or 50
        print("[Jump] JumpPower: " .. hum.JumpPower)
        return true
    end,
}

Utils.comandos.hipheight = {
    nome = "hipheight",
    descricao = "Define a altura do quadril",
    funcao = function(valor)
        local hum = humanoid()
        if not hum then return false end
        hum.HipHeight = tonumber(valor) or 0
        return true
    end,
}

Utils.comandos.fov = {
    nome = "fov",
    descricao = "Define o campo de visão da câmera",
    funcao = function(valor)
        local camera = workspace.CurrentCamera
        if not camera then return false end
        camera.FieldOfView = tonumber(valor) or 70
        return true
    end,
}

local function ehEfeito(obj)
    return obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
        or obj:IsA("Sparkles") or obj:IsA("Fire") or obj:IsA("Smoke")
end

local function ehTextura(obj)
    return obj:IsA("Decal") or obj:IsA("Texture")
end

Utils.comandos.otimizar = {
    nome = "otimizar",
    descricao = "FPS boost: sombras, efeitos, texturas e agua (com restauracao)",
    funcao = function(ativo)
        ativo = ativo ~= false
        local lighting = game:GetService("Lighting")
        if ativo then
            if Utils._otimizar then return true end
            local snap = { lighting = {}, efeitos = {}, texturas = {}, terreno = {} }
            for _, prop in ipairs({ "GlobalShadows", "FogEnd", "FogStart", "Brightness" }) do
                snap.lighting[prop] = lighting[prop]
            end
            pcall(function()
                lighting.GlobalShadows = false
                lighting.FogEnd = 1e9
                lighting.FogStart = 1e9
            end)
            local terreno = workspace:FindFirstChildOfClass("Terrain")
            if terreno then
                for _, prop in ipairs({ "WaterWaveSize", "WaterReflectance", "WaterTransparency" }) do
                    snap.terreno[prop] = terreno[prop]
                end
                pcall(function()
                    terreno.WaterWaveSize = 0
                    terreno.WaterReflectance = 0
                    terreno.WaterTransparency = 1
                end)
            end
            for _, obj in ipairs(game:GetDescendants()) do
                pcall(function()
                    if ehEfeito(obj) then
                        snap.efeitos[obj] = obj.Enabled
                        obj.Enabled = false
                    elseif ehTextura(obj) then
                        table.insert(snap.texturas, { obj = obj, parent = obj.Parent })
                        obj.Parent = nil
                    end
                end)
            end
            Utils._otimizar = snap
            print("[Otimizar] ativado - efeitos/texturas/sombras reduzidos")
        else
            local snap = Utils._otimizar
            if not snap then return true end
            pcall(function()
                for prop, valor in pairs(snap.lighting) do lighting[prop] = valor end
            end)
            local terreno = workspace:FindFirstChildOfClass("Terrain")
            if terreno then
                pcall(function()
                    for prop, valor in pairs(snap.terreno) do terreno[prop] = valor end
                end)
            end
            for obj, enabled in pairs(snap.efeitos) do
                pcall(function() if obj and obj.Parent then obj.Enabled = enabled end end)
            end
            for _, item in ipairs(snap.texturas) do
                pcall(function() if item.obj then item.obj.Parent = item.parent end end)
            end
            Utils._otimizar = nil
            print("[Otimizar] desativado - estado restaurado")
        end
        return true
    end,
}

Utils.comandos.removerefeitos = {
    nome = "removerefeitos",
    descricao = "Ativa/desativa efeitos visuais (particulas, trails, beams, fogo)",
    funcao = function(ativo)
        ativo = ativo ~= false
        if ativo then
            if Utils._efeitos then return true end
            local snap = {}
            for _, obj in ipairs(game:GetDescendants()) do
                pcall(function()
                    if ehEfeito(obj) then
                        snap[obj] = obj.Enabled
                        obj.Enabled = false
                    end
                end)
            end
            Utils._efeitos = snap
            print("[RemoverEfeitos] ativado")
        else
            local snap = Utils._efeitos
            if not snap then return true end
            for obj, enabled in pairs(snap) do
                pcall(function() if obj and obj.Parent then obj.Enabled = enabled end end)
            end
            Utils._efeitos = nil
            print("[RemoverEfeitos] desativado")
        end
        return true
    end,
}

Utils.comandos.notextures = {
    nome = "notextures",
    descricao = "Remove/restaura decals e texturas (mais FPS)",
    funcao = function(ativo)
        ativo = ativo ~= false
        if ativo then
            if Utils._texturas then return true end
            local snap = {}
            for _, obj in ipairs(game:GetDescendants()) do
                pcall(function()
                    if ehTextura(obj) then
                        table.insert(snap, { obj = obj, parent = obj.Parent })
                        obj.Parent = nil
                    end
                end)
            end
            Utils._texturas = snap
            print("[NoTextures] ativado - " .. #snap .. " texturas removidas")
        else
            local snap = Utils._texturas
            if not snap then return true end
            for _, item in ipairs(snap) do
                pcall(function() if item.obj then item.obj.Parent = item.parent end end)
            end
            Utils._texturas = nil
            print("[NoTextures] desativado")
        end
        return true
    end,
}

Utils.comandos.nofog = {
    nome = "nofog",
    descricao = "Ativa/desativa remocao de neblina",
    funcao = function(ativo)
        ativo = ativo ~= false
        local lighting = game:GetService("Lighting")
        if ativo then
            if Utils._fog then return true end
            Utils._fog = { FogEnd = lighting.FogEnd, FogStart = lighting.FogStart }
            pcall(function()
                lighting.FogEnd = 1e9
                lighting.FogStart = 1e9
            end)
            print("[NoFog] ativado")
        elseif Utils._fog then
            pcall(function()
                lighting.FogEnd = Utils._fog.FogEnd
                lighting.FogStart = Utils._fog.FogStart
            end)
            Utils._fog = nil
            print("[NoFog] desativado")
        end
        return true
    end,
}

Utils.comandos.daytime = {
    nome = "daytime",
    descricao = "Define a hora do dia (0-24)",
    funcao = function(hora)
        local lighting = game:GetService("Lighting")
        local valor = tonumber(hora) or 14
        valor = math.max(0, math.min(24, valor))
        pcall(function() lighting.ClockTime = valor end)
        print("[Daytime] ClockTime: " .. valor)
        return true
    end,
}

Utils.comandos.antivoid = {
    nome = "antivoid",
    descricao = "Teleporta de volta ao cair abaixo de um limite Y",
    funcao = function(ativo, limite)
        ativo = ativo ~= false
        limite = tonumber(limite) or -150
        desconectar("antivoid")
        if ativo then
            local seguro = Vector3.new(0, 50, 0)
            Utils._conexoes.antivoid = game:GetService("RunService").Heartbeat:Connect(function()
                local rp = root()
                if not rp then return end
                if rp.Position.Y > limite then
                    seguro = rp.Position
                elseif rp.Position.Y < limite then
                    pcall(function()
                        rp.CFrame = CFrame.new(seguro + Vector3.new(0, 5, 0))
                        rp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    end)
                end
            end)
            print("[AntiVoid] ativado (limite Y: " .. limite .. ")")
        else
            print("[AntiVoid] desativado")
        end
        return true
    end,
}

Utils.comandos.fps = {
    nome = "fps",
    descricao = "Mede e mostra o FPS atual (amostra de 1s)",
    funcao = function()
        local ok, resultado = pcall(function()
            local runService = game:GetService("RunService")
            local frames = 0
            local conexao = runService.Heartbeat:Connect(function() frames = frames + 1 end)
            local inicio = os.clock()
            task.wait(1)
            conexao:Disconnect()
            local fps = math.floor(frames / math.max(os.clock() - inicio, 1e-3))
            print("[FPS] " .. fps .. " quadros/s")
            return fps
        end)
        if not ok then
            warn("[FPS] Medicao indisponivel: " .. tostring(resultado))
            return false
        end
        return resultado
    end,
}

function Utils:listarComandos()
    local lista = {}
    for nome in pairs(Utils.comandos) do table.insert(lista, nome) end
    table.sort(lista)
    return lista
end

function Utils:executar(nome, ...)
    local cmd = Utils.comandos[nome]
    if not cmd then return false, "Comando desconhecido: " .. tostring(nome) end
    return cmd.funcao(...)
end

return Utils