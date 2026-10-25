--!strict
-- Vessie Roblox Framework - ThemeManager
-- Gerenciamento de tema: cores, tipografia, espaçamento

local ThemeManager = {}

-- Tema padrão (claro)
ThemeManager.Themes = {
	Light = {
		PrimaryColor = Color3.fromRGB(63, 81, 181),
		SecondaryColor = Color3.fromRGB(99, 102, 241),
		BackgroundColor = Color3.fromRGB(245, 245, 245),
		TextColor = Color3.fromRGB(30, 30, 30),
		ErrorColor = Color3.fromRGB(220, 53, 69),
		SuccessColor = Color3.fromRGB(76, 175, 80),
		WarningColor = Color3.fromRGB(255, 193, 7),
		Font = Enum.Font.Gotham,
		FontSize = 14,
		SpacingSmall = 4,
		SpacingMedium = 8,
		SpacingLarge = 16,
		BorderRadius = 4,
	},
	Dark = {
		PrimaryColor = Color3.fromRGB(99, 102, 241),
		SecondaryColor = Color3.fromRGB(117, 117, 137),
		BackgroundColor = Color3.fromRGB(20, 20, 25),
		TextColor = Color3.fromRGB(220, 220, 230),
		ErrorColor = Color3.fromRGB(224, 64, 68),
		SuccessColor = Color3.fromRGB (82, 197, 106),
		WarningColor = Color3.fromRGB(251, 191, 36),
		Font = Enum.Font.Gotham,
		FontSize = 14,
		SpacingSmall = 4,
		SpacingMedium = 8,
		SpacingLarge = 16,
		BorderRadius = 4,
	},
}

-- Tema atual
ThemeManager.CurrentTheme: string = "Light"

-- Obter cor atual
-- @param key string chave da cor
-- @return Color3
function ThemeManager.GetColor(key: string): Color3
	local theme: any = ThemeManager.Themes[ThemeManager.CurrentTheme]
	if theme and theme[key] then
		return theme[key]
	end
	return ThemeManager.Themes.Light[key] or Color3.new(1, 1, 1)
end

-- Definir tema
-- @param themeName string "Light" ou "Dark"
function ThemeManager.SetTheme(themeName: string)
	if ThemeManager.Themes[themeName] then
		ThemeManager.CurrentTheme = themeName
		return true
	end
	return false, "Tema não encontrado: " .. themeName
end

-- Obter fonte
-- @return Font
function ThemeManager.GetFont(): Font
	return ThemeManager.GetColor("Font") -- retorna enum, mas simplificado
	-- Nota: Font precisa ser criado com Family e Weight
	return Enum.Font.Gotham
end

-- Obter tamanho de fonte
-- @return number
function ThemeManager.GetFontSize(): number
	return ThemeManager.Themes[ThemeManager.CurrentTheme].FontSize or 14
end

-- Obter espaçamento
-- @param size string "Small"|"Medium"|"Large"
-- @return number
function ThemeManager.GetSpacing(size: string): number
	local spacing: {number} = {
		Small = ThemeManager.Themes[ThemeManager.CurrentTheme].SpacingSmall or 4,
		Medium = ThemeManager.Themes[ThemeManager.CurrentTheme].SpacingMedium or 8,
		Large = ThemeManager.Themes[ThemeManager.CurrentTheme].SpacingLarge or 16,
	}
	return spacing[size] or 8
end

-- Obter raio de border
-- @return number
function ThemeManager.GetBorderRadius(): number
	return ThemeManager.Themes[ThemeManager.CurrentTheme].BorderRadius or 4
end

-- Gerar estrutura de tema para UI
-- @param customTheme table tema personalizado
function ThemeManager.ApplyCustomTheme(customTheme: {}?)
	local base: {} = ThemeManager.Themes.Light
	if customTheme then
		for k, v: any: any in pairs(customTheme) do
			base[k] = v
		end
	end
	ThemeManager.Themes.Custom = base
	return true
end

return ThemeManager