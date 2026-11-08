--!strict
-- Vessie Roblox Framework - ThemeManager
-- Gerenciamento de tema: cores, tipografia, espaçamento

local ThemeManager = {}

ThemeManager.Themes = {
	Light = {
		PrimaryColor = Color3.fromRGB(63, 81, 181),
		SecondaryColor = Color3.fromRGB(99, 102, 241),
		BackgroundColor = Color3.fromRGB(245, 245, 245),
		SurfaceColor = Color3.fromRGB(255, 255, 255),
		TextColor = Color3.fromRGB(30, 30, 30),
		ErrorColor = Color3.fromRGB(220, 53, 69),
		SuccessColor = Color3.fromRGB(76, 175, 80),
		WarningColor = Color3.fromRGB(255, 193, 7),
		InfoColor = Color3.fromRGB(52, 152, 219),
		Font = Enum.Font.Gotham,
		FontSize = 14,
		SpacingSmall = 4,
		SpacingMedium = 8,
		SpacingLarge = 16,
		BorderRadius = 6,
	},
	Dark = {
		PrimaryColor = Color3.fromRGB(99, 102, 241),
		SecondaryColor = Color3.fromRGB(117, 117, 137),
		BackgroundColor = Color3.fromRGB(20, 20, 25),
		SurfaceColor = Color3.fromRGB(32, 32, 40),
		TextColor = Color3.fromRGB(220, 220, 230),
		ErrorColor = Color3.fromRGB(224, 64, 68),
		SuccessColor = Color3.fromRGB(82, 197, 106),
		WarningColor = Color3.fromRGB(251, 191, 36),
		InfoColor = Color3.fromRGB(56, 152, 236),
		Font = Enum.Font.Gotham,
		FontSize = 14,
		SpacingSmall = 4,
		SpacingMedium = 8,
		SpacingLarge = 16,
		BorderRadius = 6,
	},
}

ThemeManager.CurrentTheme = "Light"

local function currentTheme(): any
	return ThemeManager.Themes[ThemeManager.CurrentTheme] or ThemeManager.Themes.Light
end

function ThemeManager.GetColor(key: string): Color3
	local theme = currentTheme()
	local value = theme[key]
	if typeof(value) == "Color3" then
		return value
	end
	return ThemeManager.Themes.Light[key] or Color3.new(1, 1, 1)
end

function ThemeManager.SetTheme(themeName: string): (boolean, string?)
	if ThemeManager.Themes[themeName] then
		ThemeManager.CurrentTheme = themeName
		return true, nil
	end
	return false, "Tema não encontrado: " .. themeName
end

function ThemeManager.GetFont(): Enum.Font
	local theme = currentTheme()
	return theme.Font or Enum.Font.Gotham
end

function ThemeManager.GetFontSize(): number
	return currentTheme().FontSize or 14
end

function ThemeManager.GetSpacing(size: string): number
	local theme = currentTheme()
	local spacing = {
		Small = theme.SpacingSmall or 4,
		Medium = theme.SpacingMedium or 8,
		Large = theme.SpacingLarge or 16,
	}
	return spacing[size] or 8
end

function ThemeManager.GetBorderRadius(): number
	return currentTheme().BorderRadius or 6
end

function ThemeManager.Get(key: string): any
	return currentTheme()[key]
end

function ThemeManager.ApplyCustomTheme(customTheme: {[string]: any}?)
	local base = {}
	for k, v in pairs(ThemeManager.Themes.Light) do
		base[k] = v
	end
	if customTheme then
		for k, v in pairs(customTheme) do
			base[k] = v
		end
	end
	ThemeManager.Themes.Custom = base
	ThemeManager.CurrentTheme = "Custom"
	return true
end

return ThemeManager
