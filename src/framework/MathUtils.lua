--!strict
-- Vessie Roblox Framework - MathUtils (6.5)
-- Utilitários matemáticos: vetores, CFrame, geometria

local MathUtils = {}

-- Interpolar entre dois valores (Lerp)
-- @param a number|Vector3|CFrame
-- @param b number|Vector3|CFrame
-- @param t number 0-1
-- @return number|Vector3|CFrame interpolado
function MathUtils.Lerp(a: number | Vector3 | CFrame, b: number | Vector3 | CFrame, t: number): number | Vector3 | CFrame
	if type(a) == "number" and type(b) == "number" then
		return a + (b - a) * t
	elseif type(a) == "Vector3" and type(b) == "Vector3" then
		return a:Lerp(b, t)
	elseif type(a) == "CFrame" and type(b) == "CFrame" then
		return a:Lerp(b, t)
	end
	return a
end

-- Clamp de Vector3 (cada componente)
-- @param v Vector3
-- @param min Vector3
-- @param max Vector3
-- @return Vector3
function MathUtils.ClampVec(v: Vector3, min: Vector3, max: Vector3): Vector3
	return Vector3.new(
		math.clamp(v.X, min.X, max.X),
		math.clamp(v.Y, min.Y, max.Y),
		math.clamp(v.Z, min.Z, max.Z)
	)
end

-- Normalizar vetor
-- @param v Vector3
-- @return Vector3 normalized (ou Zero se magnitude for 0)
function MathUtils.Normalize(v: Vector3): Vector3
	local magnitude: number = v.Magnitude
	if magnitude == 0 then return Vector3.new(0, 0, 0) end
	return v / magnitude
end

-- Distância entre dois pontos Vector3
-- @param a Vector3
-- @param b Vector3
-- @return number magnitude
function MathUtils.Distance(a: Vector3, b: Vector3): number
	return (a - b).Magnitude
end

-- Ângulo entre dois vetores
-- @param a Vector3
-- @param b Vector3
-- @return number radianos
function MathUtils.AngleBetween(a: Vector3, b: Vector3): number
	local dot: number = a:Dot(b)
	local mags: number = a.Magnitude * b.Magnitude
	if mags == 0 then return 0 end
	return math.acos(dot / mags)
end

-- Projetar vetor sobre plano (remover componente)
-- @param v Vector3 vetor original
-- @param planeNormal Vector3 normal do plano
-- @return Vector3 projected
function MathUtils.ProjectOnPlane(v: Vector3, planeNormal: Vector3): Vector3
	local normal: Vector3 = MathUtils.Normalize(planeNormal)
	return v - normal * (v:Dot(normal))
end

-- Calcular CFrame olhando de uma posição para outra
-- @param from Vector3 posição inicial
-- @param to Vector3 posição alvo
-- @return CFrame lookAt
function MathUtils.LookAt(from: Vector3, to: Vector3): CFrame
	local direction: Vector3 = (to - from).Unit
	return CFrame.lookAt(from, from + direction)
end

-- Converter euler angles (graus) para CFrame
-- @param pitch number graus eixo X
-- @param yaw number graus eixo Y
-- @param roll number graus eixo Z
-- @return CFrame
function MathUtils.EulerToCFrame(pitch: number, yaw: number, roll: number): CFrame
	local cy: number = math.cos(yaw * 0.5)
	local sy: number = math.sin(yaw * 0.5)
	local cp: number = math.cos(pitch * 0.5)
	local sp: number = math.sin(pitch * 0.5)
	local cr: number = math.cos(roll * 0.5)
	local sr: number = math.sin(roll * 0.5)

	local qw: number = cp * cy * cr + sp * sy * sr
	local qx: number = cp * sy * cr + sp * cy * sr
	local qy: number = sp * cy * cr - cp * sy * sr
	local qz: number = cp * cy * sr - sp * sy * cr

	return CFrame.new(0, 0, 0, qw, qx, qy, qz)
end

-- Extrair euler angles de CFrame
-- @param cframe CFrame
-- @return pitch yaw roll em radianos
function MathUtils.CFrameToEuler(cframe: CFrame): {number, number, number}
	local wx, wy, wz, w0 = cframe:GetComponents()
	local unitX: Vector3 = cframe.LookVector
	local unitY: Vector3 = cframe.UpVector

	pitch: number = math.asin(-wy)
	if math.abs(pitch) < math.pi / 2 then
		yaw: number = math.atan2(unitX.Z, unitX.X)
		roll: number = math.atan2(unitY.Z, unitY.Y)
	else
		yaw: number = math.atan2(-unitY.X, unitX.X)
		roll: number = 0
	end
	return pitch, yaw, roll
end

-- Rotacionar vetor por CFrame
-- @param v Vector3
-- @param c CFrame
-- @return Vector3 rotated
function MathUtils.RotateVector(v: Vector3, c: CFrame): Vector3
	return (c * v * c:Inverse()).Position
end

-- Calcular projecção perpendicular
-- @param a Vector3 vetor A
-- @param b Vector3 vetor B
-- @return number|nil projecção ou nil se colinear
function MathUtils.ProjectAOnB(a: Vector3, b: Vector3): Vector3
	local magB: number = b.Magnitude
	if magB == 0 then return Vector3.new(0, 0, 0) end
	return (a:Dot(b / magB)) * (b / magB)
end

return MathUtils