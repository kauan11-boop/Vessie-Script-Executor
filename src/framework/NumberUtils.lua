--!strict
-- Vessie Roblox Framework - NumberUtils (6.7)
-- Utilitários numéricos: clamp, lerp, arredondamento, aproximação

local NumberUtils = {}

-- Limitar valor entre um min e max
-- @param value number valor a ser limitado
-- @param min number limite mínimo
-- @param max number limite máximo
-- @return number valor limitado
function NumberUtils.Clamp(value: number, min: number, max: number): number
	return math.clamp(value, min, max)
end

-- Interpolação linear entre dois números
-- @param a number inicio
-- @param b number fim
-- @param t number taxa (0 a 1)
-- @return number interpolado
function NumberUtils.Lerp(a: number, b: number, t: number): number
	return a + (b - a) * t
end

-- Arredondar para casas decimais
-- @param value number valor
-- @param decimals number quantidade de casas decimais (padrão 0)
-- @return number arredondado
function NumberUtils.Round(value: number, decimals: number): number
	local mult: number = 10 ^ (decimals or 0)
	return math.floor(value * mult + 0.5) / mult
end

-- Verificar se um número é finito (não é NaN ou infinito)
-- @param value number
-- @return boolean isFinite
function NumberUtils.IsFinite(value: number): boolean
	return value == value and math.type(value) ~= "NaN" and math.type(value) ~= "Inf"
end

-- Aproximar dois números (comparar com tolerância)
-- @param a number primeiro valor
-- @param b number segundo valor
-- @param tolerance number tolerância opcional (padrão 1e-9)
-- @return boolean approximatelyEqual
function NumberUtils.Approximately(a: number, b: number, tolerance: number): boolean
	tolerance = tolerance or 1e-9
	return math.abs(a - b) <= tolerance
end

-- Converter radianos para graus
-- @param radians number em radianos
-- @return number em graus
function NumberUtils.RadiansToDegrees(radians: number): number
	return radians * (180 / math.pi)
end

-- Converter graus para radianos
-- @param degrees number em graus
-- @return number em radianos
function NumberUtils.DegreesToRadians(degrees: number): number
	return degrees * (math.pi / 180)
end

-- Gerar número aleatório dentro de um intervalo (inteiro ou float)
-- @param min number|integer mínima possível
-- @param max number|integer máxima possível
-- @param isInteger boolean se quer número inteiro (padrão false)
-- @return number|integer aleatório
function NumberUtils.Random(min: number, max: number, isInteger: boolean): number | integer
	local randomValue: number = math.random() * (max - min) + min
	if isInteger then
		return math.floor(randomValue) + 1 -- Roblox math.random lida com inteiros
	else
		return randomValue
	end
end

-- Mapear valor de um intervalo para outro
-- @param value number valor a mapear
-- @param inMin number intervalo de entrada mínimo
-- @param inMax number intervalo de entrada máximo
-- @param outMin number intervalo de saída mínimo
-- @param outMax number intervalo de saída máximo
-- @return number valor mapeado
function NumberUtils.Map(value: number, inMin: number, inMax: number, outMin: number, outMax: number): number
	return outMin + (value - inMin) * (outMax - outMin) / (inMax - inMin)
end

-- Garantir que o valor esteja dentro de um intervalo circular (wrap around)
-- @param value number valor atual
-- @param min number limite inferior
-- @param max number limite superior
-- @param cycleLength number comprimento total do ciclo
-- @return number valor ajustado
function NumberUtils.Wrap(value: number, min: number, max: number, cycleLength: number): number
	local range: number = max - min
	if range <= 0 then return min end
	local normalized: number = (value - min) % cycleLength
	if normalized < 0 then normalized = normalized + cycleLength end
	return min + normalized
end

return NumberUtils