--!strict
-- Vessie - CharacterManager
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")

local CharacterManager = {}

function CharacterManager.Init() end

function CharacterManager.Register(character: Model, config: any?)
	if not character:IsA("Model") then return end
	local hm = character:FindFirstChildOfClass("Humanoid")
	if not hm then return end
	CharacterManager._data[character] = {
		RigType = hm.RigType.Name,
		RootPart = hm.RootPart,
		Humanoid = hm,
		Points = {},
		Config = config or {},
	}
	CharacterManager._Setup(character)
end

function CharacterManager._Setup(character: Model)
	local hm = character:FindFirstChildOfClass("Humanoid")
	if not hm then return end
	
	hm.StateChanged:Connect(function(old, new) end)
	
	character.Destroying:Connect(function()
		CharacterManager._data[character] = nil
	end)
end

function CharacterManager.DetectRigType(character: Model): string
	local hm = character:FindFirstChildOfClass("Humanoid")
	return hm and hm.RigType.Name or "Unknown"
end

function CharacterManager.GetRootPart(character: Model): BasePart?
	local hm = character:FindFirstChildOfClass("Humanoid")
	return hm and hm.RootPart or nil
end

function CharacterManager.IsAlive(character: Model): boolean
	local hm = character:FindFirstChildOfClass("Humanoid")
	return hm and hm.Health > 0 and hm:GetState() ~= Enum.HumanidStateType.Dead
end

function CharacterManager.IsOnGround(character: Model): boolean
	local hm = character:FindFirstChildOfClass("Humanoid")
	if not hm then return false end
	return hm:GetState() ~= Enum.HumanidStateType.Freefall
		and hm:GetState() ~= Enum.HumanidStateType.FallingDown
end

function CharacterManager.GetPosition(character: Model): Vector3
	local root = CharacterManager.GetRootPart(character)
	return root and root.Position or character:GetPivot().Position
end

function CharacterManager.GetMoveDirection(character: Model): Vector3
	local hm = character:FindFirstChildOfClass("Humanoid")
	if not hm or hm.MoveDirection.Magnitude == 0 then return Vector3.new(0,0,0) end
	local d = hm.MoveDirection
	d.Y = 0
	return d.Magnitude > 0 and d.Unit or Vector3.new(0,0,0)
end

function CharacterManager.Jump(character: Model)
	local hm = character:FindFirstChildOfClass("Humanoid")
	if hm then hm:ChangeState(Enum.HumanidStateType.Jumping) end
end

function CharacterManager.Respawn(character: Model, location: CFrame?)
	local hm = character:FindFirstChildOfClass("Humanoid")
	if hm and location then
		local rp = CharacterManager.GetRootPart(character)
		if rp then rp.CFrame = location end
		hm:ChangeState(Enum.HumanidStateType.Respawn)
	end
end

function CharacterManager.IsDead(character: Model): boolean
	local hm = character:FindFirstChildOfClass("Humanoid")
	return hm and hm.Health <= 0
end

function CharacterManager.RegisterInteractionPoint(character: Model, point: BasePart, itype: string)
	local d = CharacterManager._data[character]
	if not d then return end
	d.Points[itype] = d.Points[itype] or {}
	table.insert(d.Points[itype], point)
end

return CharacterManager