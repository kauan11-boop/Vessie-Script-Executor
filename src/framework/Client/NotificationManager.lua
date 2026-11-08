--!strict
-- Vessie Roblox Framework - NotificationManager
-- Sistema de notificações com fila, duração configurável e tema integrado

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local ThemeManager = require("src.framework.Client.ThemeManager")

local NotificationManager = {}

NotificationManager._queue = {}
NotificationManager._active = {}
NotificationManager._container = nil
NotificationManager._maxVisible = 5

local TYPE_COLORS = {
	info = "InfoColor",
	success = "SuccessColor",
	warning = "WarningColor",
	error = "ErrorColor",
}

function NotificationManager._EnsureContainer()
	if NotificationManager._container and NotificationManager._container.Parent then
		return NotificationManager._container
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "VessieNotificationGUI"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.DisplayOrder = 100
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local frame = Instance.new("Frame")
	frame.Name = "NotificationContainer"
	frame.AnchorPoint = Vector2.new(1, 0)
	frame.Size = UDim2.new(0, 300, 1, -40)
	frame.Position = UDim2.new(1, -20, 0, 20)
	frame.BackgroundTransparency = 1
	frame.Parent = screenGui

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 8)
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = frame

	local parent = Players.LocalPlayer and Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
	screenGui.Parent = parent or game:GetService("CoreGui")
	NotificationManager._container = screenGui
	return screenGui
end

local function buildNotification(title: string, text: string, ntype: string): Frame
	local accent = ThemeManager.GetColor(TYPE_COLORS[ntype] or "InfoColor")

	local notification = Instance.new("Frame")
	notification.Name = "Notification"
	notification.Size = UDim2.new(1, 0, 0, 0)
	notification.AutomaticSize = Enum.AutomaticSize.Y
	notification.BackgroundColor3 = ThemeManager.GetColor("SurfaceColor")
	notification.BackgroundTransparency = 0.05
	notification.BorderSizePixel = 0
	notification.ClipsDescendants = true

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, ThemeManager.GetBorderRadius())
	corner.Parent = notification

	local stroke = Instance.new("UIStroke")
	stroke.Color = accent
	stroke.Thickness = 1
	stroke.Transparency = 0.5
	stroke.Parent = notification

	local bar = Instance.new("Frame")
	bar.Name = "Accent"
	bar.Size = UDim2.new(0, 4, 1, 0)
	bar.BackgroundColor3 = accent
	bar.BorderSizePixel = 0
	bar.Parent = notification

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 14)
	padding.PaddingRight = UDim.new(0, 10)
	padding.PaddingTop = UDim.new(0, 8)
	padding.PaddingBottom = UDim.new(0, 8)
	padding.Parent = notification

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 4)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = notification

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.LayoutOrder = 1
	titleLabel.Size = UDim2.new(1, 0, 0, 18)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 14
	titleLabel.TextColor3 = accent
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Text = title
	titleLabel.Parent = notification

	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "Text"
	textLabel.LayoutOrder = 2
	textLabel.Size = UDim2.new(1, 0, 0, 0)
	textLabel.AutomaticSize = Enum.AutomaticSize.Y
	textLabel.BackgroundTransparency = 1
	textLabel.Font = ThemeManager.GetFont()
	textLabel.TextSize = 12
	textLabel.TextColor3 = ThemeManager.GetColor("TextColor")
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.TextWrapped = true
	textLabel.Text = text
	textLabel.Parent = notification

	return notification
end

function NotificationManager._Display(request: any)
	local container = NotificationManager._EnsureContainer()
	local holder = container:FindFirstChild("NotificationContainer")
	if not holder then return end

	local notification = buildNotification(request.title, request.text, request.ntype)
	notification.Parent = holder
	table.insert(NotificationManager._active, notification)

	notification.BackgroundTransparency = 1
	TweenService:Create(notification, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 0.05,
	}):Play()

	task.delay(request.duration, function()
		if not notification.Parent then return end
		local tween = TweenService:Create(notification, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
		})
		tween:Play()
		tween.Completed:Connect(function()
			local index = table.find(NotificationManager._active, notification)
			if index then table.remove(NotificationManager._active, index) end
			notification:Destroy()
			NotificationManager._ProcessQueue()
		end)
	end)
end

function NotificationManager._ProcessQueue()
	while #NotificationManager._active < NotificationManager._maxVisible and #NotificationManager._queue > 0 do
		local request = table.remove(NotificationManager._queue, 1)
		NotificationManager._Display(request)
	end
end

function NotificationManager.Show(title: string, text: string, duration: number?, ntype: string?)
	table.insert(NotificationManager._queue, {
		title = title,
		text = text,
		duration = duration or 5,
		ntype = ntype or "info",
	})
	NotificationManager._ProcessQueue()
end

function NotificationManager.Clear()
	NotificationManager._queue = {}
	for _, notification in ipairs(NotificationManager._active) do
		pcall(function() notification:Destroy() end)
	end
	NotificationManager._active = {}
end

function NotificationManager.Destroy()
	NotificationManager.Clear()
	if NotificationManager._container then
		pcall(function() NotificationManager._container:Destroy() end)
		NotificationManager._container = nil
	end
end

return NotificationManager
