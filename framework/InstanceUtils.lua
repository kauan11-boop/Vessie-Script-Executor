--!strict
-- Vessie Roblox Framework - InstanceUtils (6.4)
-- Utilitários básicos para instâncias do Roblox

local InstanceUtils = {}

function InstanceUtils.FindFirstChildSafe(parent: Instance, name: string, className: string?): Instance?
	return parent:FindFirstChild(name, true)
end

function InstanceUtils.CreateWithValidation(className: string, properties: table): Instance?
	local ok, inst = pcall(function()
		local i = Instance.new(className)
		for p, v in pairs(properties) do pcall(function() i[p] = v end) end
		return i
	end)
	return ok and inst or nil
end

function InstanceUtils.SetProperties(inst: Instance, properties: table): boolean
	if not inst or not inst.Parent then return false end
	local success = true
	for p, v in pairs(properties) do
		pcall(function() inst[p] = v end)
	end
	return success
end

function InstanceUtils.DestroySafe(inst: Instance?)
	if inst and inst.Parent then inst:Destroy() end
end

function InstanceUtils.IsClass(instance: Instance, className: string): boolean
	if not instance then return false end
	local current = instance.ClassName
	if current == className then return true end
	local parent = instance.Parent
	while parent do
		if parent.ClassName == className then return true end
		parent = parent.Parent
	end
	return false
end

function InstanceUtils.CFrameFromPositionRotation(position: Vector3 | table, euler: Vector3 | table): CFrame
	local x = type(position) == "table" and position.x or position.X
	local y = type(position) == "table" and position.y or position.Y
	local z = type(position) == "table" and position.z or position.Z
	local p = type(euler) == "table" and euler.x or euler.Pitch or 0
	local y = type(euler) == "table" and euler.y or euler.Yaw or 0
	local r = type(euler) == "table" and euler.z or euler.Roll or 0
	return CFrame.new(x, y, z) * CFrame.fromEulerAnglesXYZ(p, y, r)
end

return InstanceUtils