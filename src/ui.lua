--[[
  Módulo de Interface - Vessie Script Executor
  Criação de UIs e menus para o executor (ScreenGui, frames, botões, toggles, etc.)
--]]

local UI = {}

function UI:criarGui(nome, pais)
    nome = nome or "UIExecutor"
    pais = pais or game.Players.LocalPlayer:WaitForChild("PlayerGui")
    local gui = Instance.new("ScreenGui")
    gui.Name = nome
    gui.ResetOnSpawn = false
    gui.Parent = pais
    return gui
end

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

    if titulo then
        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.Size = UDim2.new(1, 0, 0, 30)
        title.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
        title.Text = titulo
        title.TextColor3 = Color3.new(1, 1, 1)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 14
        title.Parent = frame
    end
    return frame
end

function UI:criarBotao(frame, texto, posicao, tamanho, cor, callback)
    local botao = Instance.new("TextButton")
    botao.Name = "Button_" .. texto
    botao.Size = tamanho or UDim2.new(1, -20, 0, 30)
    botao.Position = posicao or UDim2.new(0, 10, 0, 0)
    botao.BackgroundColor3 = cor or Color3.new(0.2, 0.2, 0.2)
    botao.Text = texto
    botao.TextColor3 = Color3.new(1, 1, 1)
    botao.Font = Enum.Font.Gotham
    botao.TextSize = 14
    botao.Parent = frame

    if callback then
        botao.MouseButton1Click:Connect(callback)
    end
    return botao
end

function UI:criarToggle(frame, texto, posicao, ligadoInicial)
    local toggle = { ativado = ligadoInicial or false, botao = nil, callback = nil }
    toggle.botao = UI:criarBotao(frame, texto .. " [" .. (toggle.ativado and "ON" or "OFF") .. "]",
        posicao or UDim2.new(0, 10, 0, 50), UDim2.new(1, -20, 0, 30), Color3.new(0.3, 0.3, 0.3),
        function()
            toggle.ativado = not toggle.ativado
            toggle.botao.Text = texto .. " [" .. (toggle.ativado and "ON" or "OFF") .. "]"
            if toggle.callback then toggle.callback(toggle.ativado) end
        end)
    return toggle
end

function UI:criarCaixaTexto(frame, textoPlaceholder, posicao, tamanho)
    local caixa = Instance.new("TextBox")
    caixa.Size = tamanho or UDim2.new(1, -20, 0, 30)
    caixa.Position = posicao or UDim2.new(0, 10, 0, 90)
    caixa.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    caixa.PlaceholderText = textoPlaceholder or "Digite algo..."
    caixa.Text = ""
    caixa.Font = Enum.Font.Gotham
    caixa.TextSize = 14
    caixa.ClearTextOnFocus = false
    caixa.Parent = frame
    return caixa
end

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

function UI:criarLista(frame, posicao, tamanho)
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = tamanho or UDim2.new(1, -20, 1, -50)
    scrollingFrame.Position = posicao or UDim2.new(0, 10, 0, 50)
    scrollingFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    scrollingFrame.ScrollBarThickness = 6
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollingFrame.Parent = frame

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = scrollingFrame
    return scrollingFrame
end

function UI:adicionarItemLista(scrollFrame, texto, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 30)
    button.BackgroundTransparency = 1
    button.Text = texto
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = scrollFrame
    if callback then button.MouseButton1Click:Connect(callback) end
    return button
end

function UI:removerGui(nome)
    local gui = game.Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild(nome)
    if not gui and game:FindFirstChild("CoreGui") then
        gui = game.CoreGui:FindFirstChild(nome)
    end
    if gui then
        gui:Destroy()
        print("[UI] GUI removida: " .. nome)
        return true
    end
    return false
end

return UI