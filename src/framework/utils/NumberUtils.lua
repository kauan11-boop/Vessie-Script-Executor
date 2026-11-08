--!strict
-- Vessie Roblox Framework - NumberUtils
-- Utilitários numéricos: clamp, lerp, arredondamento, aproximação

local NumberUtils = {}

function NumberUtils.Clamp(value: number, min: number, max: number): number
	return math.clamp(value, min, max)
end

function NumberUtils.Lerp(a: number, b: number, t: number): number
	return a + (b - a) * t
end

function NumberUtils.Round(value: number, decimals: number?): number
	local mult = 10 ^ (decimals or 0)
	return math.floor(value * mult + 0.5) / mult
end

-- Finito: não é NaN nem infinito (math.type não existe em Luau)
function NumberUtils.IsFinite(value: number): boolean
	return value == value and value ~= math.huge and value ~= -math.huge
end

function NumberUtils.Approximately(a: number, b: number, tolerance: number?): boolean
	return math.abs(a - b) <= (tolerance or 1e-9)
end

function NumberUtils.RadiansToDegrees(radians: number): number
	return radians * (180 / math.pi)
end

function NumberUtils.DegreesToRadians(degrees: number): number
	return degrees * (math.pi / 180)
end

function NumberUtils.Random(min: number, max: number, isInteger: boolean?): number
	if isInteger then
		return math.random(math.floor(min), math.floor(max))
	end
	return math.random() * (max - min) + min
end

function NumberUtils.Map(value: number, inMin: number, inMax: number, outMin: number, outMax: number): number
	if inMax == inMin then return outMin end
	return outMin + (value - inMin) * (outMax - outMin) / (inMax - inMin)
end

function NumberUtils.Wrap(value: number, min: number, max: number, cycleLength: number?): number
	local range = max - min
	if range <= 0 then return min end
	local cycle = cycleLength or range
	if cycle <= 0 then return min end
	local normalized = (value - min) % cycle
	return min + normalized
end

return NumberUtils