--!strict
-- Vessie Roblox Framework - MathUtils
-- Utilitarios matematicos: vetores, CFrame, geometria

local MathUtils = {}

function MathUtils.Lerp(a: any, b: any, t: number): any
	if type(a) == "number" and type(b) == "number" then
		return a + (b - a) * t
	elseif typeof(a) == "Vector3" and typeof(b) == "Vector3" then
		return a:Lerp(b, t)
	elseif typeof(a) == "CFrame" and typeof(b) == "CFrame" then
		return a:Lerp(b, t)
	end
	return a
end

function MathUtils.ClampVec(v: Vector3, min: Vector3, max: Vector3): Vector3
	return Vector3.new(
		math.clamp(v.X, min.X, max.X),
		math.clamp(v.Y, min.Y, max.Y),
		math.clamp(v.Z, min.Z, max.Z)
	)
end

function MathUtils.Normalize(v: Vector3): Vector3
	local magnitude = v.Magnitude
	if magnitude == 0 then return Vector3.zero end
	return v / magnitude
end

function MathUtils.Distance(a: Vector3, b: Vector3): number
	return (a - b).Magnitude
end

function MathUtils.AngleBetween(a: Vector3, b: Vector3): number
	local mags = a.Magnitude * b.Magnitude
	if mags == 0 then return 0 end
	local cos = math.clamp(a:Dot(b) / mags, -1, 1)
	return math.acos(cos)
end

function MathUtils.ProjectOnPlane(v: Vector3, planeNormal: Vector3): Vector3
	local normal = MathUtils.Normalize(planeNormal)
	return v - normal * v:Dot(normal)
end

function MathUtils.LookAt(from: Vector3, to: Vector3): CFrame
	return CFrame.lookAt(from, to)
end

-- Euler em GRAUS -> CFrame
function MathUtils.EulerToCFrame(pitch: number, yaw: number, roll: number): CFrame
	return CFrame.fromEulerAnglesXYZ(math.rad(pitch), math.rad(yaw), math.rad(roll))
end

-- CFrame -> euler em radianos (pitch, yaw, roll)
function MathUtils.CFrameToEuler(cframe: CFrame): (number, number, number)
	local pitch, yaw, roll = cframe:ToEulerAnglesXYZ()
	return pitch, yaw, roll
end

-- Rotacionar vetor (apenas rotacao, sem translacao)
function MathUtils.RotateVector(v: Vector3, c: CFrame): Vector3
	return c:VectorToWorldSpace(v)
end

function MathUtils.ProjectAOnB(a: Vector3, b: Vector3): Vector3
	local magB = b.Magnitude
	if magB == 0 then return Vector3.zero end
	local unit = b / magB
	return unit * a:Dot(unit)
end

return MathUtils
