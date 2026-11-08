--!strict
-- Vessie Roblox Framework - CharacterManager
-- Registro e consulta de personagens (rig, root, estado, movimento)

local CharacterManager = {}

CharacterManager._data = {}

local function getHumanoid(character: Model): Humanoid?
	if not character or not character:IsA("Model") then return nil end
	return character:FindFirstChildOfClass("Humanoid")
end

function CharacterManager.Init() end

function CharacterManager.Register(character: Model, config: any?)
	local humanoid = getHumanoid(character)
	if not humanoid then return false end
	if CharacterManager._data[character] then return true end

	CharacterManager._data[character] = {
		RigType = humanoid.RigType.Name,
		RootPart = humanoid.RootPart,
		Humanoid = humanoid,
		Points = {},
		Config = config or {},
	}
	CharacterManager._Setup(character)
	return true
end

function CharacterManager._Setup(character: Model)
	local data = CharacterManager._data[character]
	if not data then return end

	character.Destroying:Connect(function()
		CharacterManager._data[character] = nil
	end)

	local humanoid = data.Humanoid
	if humanoid then
		humanoid.Died:Connect(function()
			data.Dead = true
		end)
	end
end

function CharacterManager.Unregister(character: Model)
	CharacterManager._data[character] = nil
end

function CharacterManager.GetData(character: Model): any
	return CharacterManager._data[character]
end

function CharacterManager.GetHumanoid(character: Model): Humanoid?
	return getHumanoid(character)
end

function CharacterManager.DetectRigType(character: Model): string
	local humanoid = getHumanoid(character)
	return humanoid and humanoid.RigType.Name or "Unknown"
end

function CharacterManager.GetRootPart(character: Model): BasePart?
	local humanoid = getHumanoid(character)
	return humanoid and humanoid.RootPart or nil
end

function CharacterManager.IsAlive(character: Model): boolean
	local humanoid = getHumanoid(character)
	return humanoid ~= nil and humanoid.Health > 0
end

function CharacterManager.IsDead(character: Model): boolean
	local humanoid = getHumanoid(character)
	return humanoid ~= nil and humanoid.Health <= 0
end

function CharacterManager.IsOnGround(character: Model): boolean
	local humanoid = getHumanoid(character)
	if not humanoid then return false end
	return humanoid.FloorMaterial ~= Enum.Material.Air
end

function CharacterManager.GetPosition(character: Model): Vector3
	local root = CharacterManager.GetRootPart(character)
	if root then return root.Position end
	if character and character:IsA("Model") then
		return character:GetPivot().Position
	end
	return Vector3.new(0, 0, 0)
end

function CharacterManager.GetMoveDirection(character: Model): Vector3
	local humanoid = getHumanoid(character)
	if not humanoid then return Vector3.new(0, 0, 0) end
	local direction = humanoid.MoveDirection
	if direction.Magnitude == 0 then return Vector3.new(0, 0, 0) end
	local flat = Vector3.new(direction.X, 0, direction.Z)
	return flat.Magnitude > 0 and flat.Unit or Vector3.new(0, 0, 0)
end

function CharacterManager.Jump(character: Model)
	local humanoid = getHumanoid(character)
	if humanoid and humanoid.Health > 0 then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end

function CharacterManager.Respawn(character: Model, location: CFrame?)
	local root = CharacterManager.GetRootPart(character)
	if root and location then
		root.CFrame = location
	end
end

function CharacterManager.RegisterInteractionPoint(character: Model, point: BasePart, itype: string)
	local data = CharacterManager._data[character]
	if not data then return false end
	data.Points[itype] = data.Points[itype] or {}
	table.insert(data.Points[itype], point)
	return true
end

function CharacterManager.GetInteractionPoints(character: Model, itype: string): {BasePart}
	local data = CharacterManager._data[character]
	if not data then return {} end
	return data.Points[itype] or {}
end

return CharacterManager
