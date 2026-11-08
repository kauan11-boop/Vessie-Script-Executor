--[[
  Módulo de Interface - Roblox Executor Library
  Criação de UIs e menus para o executor
--]]

local UI = {}

-- Criar ScreenGui
function UI:criarGui(nome, pais)
    nome = nome or "UIExecutor"
    pais = pais or game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local gui = Instance.new("ScreenGui")
    gui.Name = nome
    gui.ResetOnSpawn = false
    gui.Parent = pais
    
    return gui
end

-- Criar Frame principal
function UI:criarFrame(gui, titulo, posicao, tamanho, corFundo)
    posicao = posicao or UDim2.new(0.5, -200, 0.5, -200)
    tamanho = tamanho or UDim2.new(0, 400, 0, 400)
    corFundo = corFundo or Color3.new(0.1, 0.1, 0.1)
    
    local frame = Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Size = tamanho
    frame.Position = posicao
    frame.BackgroundColor3 = corFundo
    frame.Parent = gui
    frame.Active = true
    frame.Draggable = true
    
    -- Título
    if titulo then
        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.Size = UDim2.new(1, 0, 0, 30)
        title.Position = UDim2.new(0, 0, 0, 0)
        title.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
        title.Text = titulo
        title.TextColor3 = Color3.new(1, 1, 1)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 14
        title.Parent = frame
    end
    
    return frame
end

-- Criar botão
function UI:criarBotao(frame, texto, posicao, tamanho, cor, callback)
    botao = Instance.new("TextButton")
    botao.Name = "Button_" .. texto
    botao.Size = tamanho or UDim2.new(1, -20, 0, 30)
    botao.Position = posicao or UDim2.new(0, 10, 0, 0)
    botao.BackgroundColor3 = cor or Color3.new(0.2, 0.2, 0.2)
    botao.Text = texto
    botao.TextColor3 = Color3.new(1, 1, 1)
    botao.Font = Enum.Font.Gotham
    botao.TextSize = 14
    botao.Parent = frame
    
    -- Conectar callback
    if callback then
        botao.MouseButton1Click:Conectar(callback)
    end
    
    return botao
end

-- Criar Toggle (botão ligar/desligar)
function UI:criarToggle(frame, texto, posicao, ligadoInicial)
    local toggle = {
        ativado = ligadoInicial or false,
        botao = nil
    }
    
    toggle.botao = UI:criarBotao(frame, texto .. " [OFF]", posicao or UDim2.new(0, 10, 0, 50), 
        UDim2.new(1, -20, 0, 30), Color3.new(0.3, 0.3, 0.3), function()
            toggle.ativado = not toggle.ativado
            toggle.botao.Text = texto .. " [" .. (toggle.ativado and "ON" or "OFF") .. "]"
            
            -- Chamar callback se existir
            if toggle.callback then
                toggle.callback(toggle.ativado)
            end
        end)
    
    return toggle
end

-- Criar caixa de texto
function UI:criarCaixaTexto(frame, textoPlaceholder, posicao, tamanho)
    local caixa = Instance.new("TextBox")
    caixa.Size = tamanho or UDim2.new(1, -20, 0, 30)
    caixa.Position = posicao or UDim2.new(0, 10, 0, 90)
    caixa.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    caixa.PlaceholderText = textoPlaceholder or "Digite algo..."
    caixa.Text = ""
    caixa.Font = Enum.Font.Gotham
    caixa.TextSize = 14
    caixa.Parent = frame
    
    return caixa
end

-- Criar rótulo
function UI:criarRotulo(frame, texto, posicao, tamanho, corTexto)
    local rotulo = Instance.new("TextLabel")
    rotulo.Size = tamanho or UDim2.new(1, -20, 0, 20)
    rotulo.Position = posicao or UDim2.new(0, 10, 0, 0)
    rotulo.BackgroundTransparency = 1
    rotulo.Text = texto
    rotulo.TextColor3 = corTexto or Color3.new(1, 1, 1)
    rotulo.Font = Enum.Font.Gotham
    rotulo.TextSize = 14
    rotulo.Parent = frame
    
    return rotulo
end

-- Criar lista rolável
function UI:criarLista(frame, posicao, tamanho)
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = tamanho or UDim2.new(1, -20, 1, -50)
    scrollingFrame.Position = posicao or UDim2.new(0, 10, 0, 50)
    scrollingFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    scrollingFrame.ScrollBarThickness = 6
    scrollingFrame.Parent = frame
    
    return scrollingFrame
end

-- Adicionar item à lista
function UI:adicionarItemLista(scrollFrame, texto, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 30)
    button.BackgroundTransparency = 1
    button.Text = texto
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = scrollFrame
    
    if callback then
        button.MouseButton1Click:Conectar(callback)
    end
    
    return button
end

-- Remover GUI
function UI:removerGui(nome)
    local gui = game.CoreGui:FindFirstChild(nome) or game.Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild(nome)
    if gui then
        gui:Destroy()
        print("[UI] GUI removida: " .. nome)
    end
    return gui ~= nil
end

return UI