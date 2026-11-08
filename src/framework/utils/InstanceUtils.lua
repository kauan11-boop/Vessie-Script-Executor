--!strict
-- Vessie Roblox Framework - InstanceUtils
-- Utilitarios seguros para instancias do Roblox

local InstanceUtils = {}

function InstanceUtils.FindFirstChildSafe(parent: Instance, name: string, className: string?): Instance?
	if not parent then return nil end
	local found = parent:FindFirstChild(name, true)
	if found and className and not found:IsA(className) then return nil end
	return found
end

function InstanceUtils.CreateWithValidation(className: string, properties: {[string]: any}): Instance?
	local ok, inst = pcall(function()
		local i = Instance.new(className)
		for p, v in pairs(properties) do
			pcall(function() i[p] = v end)
		end
		return i
	end)
	return ok and inst or nil
end

function InstanceUtils.SetProperties(inst: Instance, properties: {[string]: any}): boolean
	if not inst then return false end
	local success = true
	for p, v in pairs(properties) do
		local ok = pcall(function() inst[p] = v end)
		if not ok then success = false end
	end
	return success
end

function InstanceUtils.DestroySafe(inst: Instance?)
	if inst then
		pcall(function() inst:Destroy() end)
	end
end

-- Usa IsA (hierarquia de classes), nao a cadeia de Parent
function InstanceUtils.IsClass(instance: Instance, className: string): boolean
	if not instance then return false end
	return instance:IsA(className)
end

function InstanceUtils.CFrameFromPositionRotation(position: any, euler: any): CFrame
	local px = type(position) == "table" and position.x or position.X
	local py = type(position) == "table" and position.y or position.Y
	local pz = type(position) == "table" and position.z or position.Z
	local pitch = type(euler) == "table" and (euler.x or euler.Pitch) or euler.X
	local yaw = type(euler) == "table" and (euler.y or euler.Yaw) or euler.Y
	local roll = type(euler) == "table" and (euler.z or euler.Roll) or euler.Z
	return CFrame.new(px, py, pz) * CFrame.fromEulerAnglesXYZ(pitch or 0, yaw or 0, roll or 0)
end

return InstanceUtils
