--!strict
-- Vessie Roblox Framework - Notification System
-- Sistema de notificações com fila, duração configurável

local NotificationManager = {}

-- Estrutura de notificação
-- @param title string título
-- @param text string texto
-- @param duration number duração em segundos (padrão 5)
-- @param type string tipo ("info", "success", "warning", "error")
-- @return table instância da notificação

NotificationManager._queue: {any} = {}
NotificationManager._isShowing: boolean = false
NotificationManager._container: Instance? = nil

-- Criar container se não existir
function NotificationManager._EnsureContainer()
	if not NotificationManager._container then
		local screenGui: ScreenGui = Instance.new("ScreenGui")
		screenGui.Name = "VessieNotificationGUI"
		screenGui.IgnoreGuiInset = true
		screenGui.DisplayOrder = 10
		screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		
		-- Frame principal
		local frame: Frame = Instance.new("Frame")
		frame.Name = "NotificationContainer"
		frame.Size = UDim2.new(0, 300, 0, 0)
		frame.Position = UDim2.new(0.5, -150, 0, -100)
		frame.BackgroundTransparency = 1
		frame.Parent = screenGui
		
		-- UI List Layout para fila
		local listLayout: UIListLayout = Instance.new("UIListLayout")
		listLayout.Padding = UDim.new(0, 8)
		listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		listLayout.SortOrder = Enum.SortOrder.LayoutOrder
		listLayout.Parent = frame
		
		screenGui.Parent = game:GetService("CoreGui")
		NotificationManager._container = screenGui
	end
end

-- Mostrar notificação
-- @param title string
-- @param text string
-- @param duration number|nil
-- @param type string|nil
function NotificationManager.Show(title: string, text: string, duration: number?, type: string?)
	duration = duration or 5
	type = type or "info"
	
	NotificationManager._EnsureContainer()
	
	-- Criar notificação
	local notification: Frame = Instance.new("Frame")
	notification.Name = "Notification"
	notification.Size = UDim2.new(1, -20, 0, 80)
	notification.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	notification.BackgroundTransparency = 1
	notification.AutomaticSize = Enum.AutomaticSize.Y
	
	-- Border
	local corner: UICorner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = notification
	
-- Título
	local titleLabel: TextLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, 0, 0, 20)
	titleLabel.Position = UDim2.new(0, 0, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 14
	titleLabel.TextColor3 = ThemeManager.GetColor("PrimaryColor")
	titleLabel.Text = title
	titleLabel.Parent = notification
	
-- Texto
	local textLabel: TextLabel = Instance.new("TextLabel")
	textLabel.Name = "Text"
	textLabel.Size = UDim2.new(1, 0, 0, 40)
	textLabel.Position = UDim2.new(0, 0, 0, 22)
	textLabel.BackgroundTransparency = 1
	textLabel.Font = Enum.Font.Gotham
	textLabel.TextSize = 12
	textLabel.TextColor3 = ThemeManager.GetColor("TextColor")
	textLabel.Text = text
	textLabel.TextWrapped = true
	textLabel.Parent = notification
	
-- Ícone/tipo
local iconProps = {
		info = {Color3.fromRGB(52, 152, 219), "📝"},
		success = {Color3.fromRGB(39, 174, 96), "✅"},
		warning = {Color3.fromRGB(243, 156, 18), "⚠️"},
		error = {Color3.fromRGB(192, 57, 43), "❌"},
	}
local iconData = iconProps[type] or iconProps.info
local iconLabel: TextLabel = Instance.new("TextLabel")
iconLabel.Name = "Icon"
iconLabel.Size = UDim2.new(0, 16, 0, 16)
iconLabel.Position = UDim2.new(0, 8, 0, 8)
iconLabel.BackgroundTransparency = 1
iconLabel.Font = Enum.Font.Glyph
iconLabel.TextSize = 16
iconLabel.TextColor3 = iconData[1]
iconLabel.Text = iconData[2]
iconLabel.Parent = notification

-- Adicionar ao container
notification.Parent = NotificationManager._container:FindFirstChild("NotificationContainer")

-- Animação de entrada
notification.Size = UDim2.new(1, -20, 0, 0)
game:GetService("TweenService"):Create(notification, TweenInfo.new(0.3), {
	Size = UDim2.new(1, -20, 0, 80)
}):Play()

-- Agendar remoção
task.delay(duration, function()
	-- Animação de saída
	game:GetService("TweenService"):Create(notification, TweenInfo.new(0.3), {
		Position = UDim2.new(0.5, -150, 0, 9999) -- mover para fora
	}):Play()
	
	task.wait(0.3)
	notification:Destroy()
	
	-- Processar próxima na fila
	NotificationManager._ProcessQueue()
end)

-- Adicionar à fila para tracking
table.insert(NotificationManager._queue, {
	frame = notification,
	expireAt = tick() + (duration or 5),
})

return NotificationManager