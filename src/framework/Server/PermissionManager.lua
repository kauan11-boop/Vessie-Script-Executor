--!strict
-- Vessie Roblox Framework - PermissionManager
-- Papéis (roles) e permissões por jogador, sem vazamento entre jogadores

local PermissionManager = {}

PermissionManager._roles = {}
PermissionManager._playerRoles = {}
PermissionManager._playerPermissions = {}
PermissionManager._owners = {}

function PermissionManager.DefineRole(roleName: string, permissions: {string})
	if type(roleName) ~= "string" or #roleName == 0 then return false end
	PermissionManager._roles[roleName] = permissions or {}
	return true
end

function PermissionManager.AssignRole(player: Player, roleName: string): boolean
	if not PermissionManager._roles[roleName] then
		warn("[PermissionManager] Papel não definido: " .. roleName)
		return false
	end
	local roles = PermissionManager._playerRoles[player]
	if not roles then
		roles = {}
		PermissionManager._playerRoles[player] = roles
	end
	if not table.find(roles, roleName) then
		table.insert(roles, roleName)
	end
	return true
end

function PermissionManager.RemoveRole(player: Player, roleName: string)
	local roles = PermissionManager._playerRoles[player]
	if not roles then return end
	local index = table.find(roles, roleName)
	if index then table.remove(roles, index) end
end

function PermissionManager.GrantPermission(player: Player, permission: string)
	local perms = PermissionManager._playerPermissions[player]
	if not perms then
		perms = {}
		PermissionManager._playerPermissions[player] = perms
	end
	perms[permission] = { grantedAt = os.clock() }
end

function PermissionManager.RevokePermission(player: Player, permission: string)
	local perms = PermissionManager._playerPermissions[player]
	if perms then perms[permission] = nil end
end

function PermissionManager.HasPermission(player: Player, permission: string): boolean
	local roles = PermissionManager._playerRoles[player] or {}
	for _, roleName in ipairs(roles) do
		local rolePerms = PermissionManager._roles[roleName] or {}
		for _, perm in ipairs(rolePerms) do
			if perm == permission or perm == "*" then return true end
		end
	end

	local direct = PermissionManager._playerPermissions[player]
	if direct and (direct[permission] or direct["*"]) then return true end

	return false
end

function PermissionManager.CanExecuteOn(executor: Player, target: Player, permission: string): boolean
	if executor == target then return false end
	if not PermissionManager.HasPermission(executor, permission) then return false end
	if PermissionManager.HasPermission(target, permission) then return false end
	return true
end

function PermissionManager.GetPermissions(player: Player): {string}
	local perms = {}
	local roles = PermissionManager._playerRoles[player] or {}
	for _, roleName in ipairs(roles) do
		for _, perm in ipairs(PermissionManager._roles[roleName] or {}) do
			if not table.find(perms, perm) then table.insert(perms, perm) end
		end
	end
	local direct = PermissionManager._playerPermissions[player]
	if direct then
		for perm in pairs(direct) do
			if not table.find(perms, perm) then table.insert(perms, perm) end
		end
	end
	return perms
end

function PermissionManager.GetRoles(player: Player): {string}
	local copy = {}
	for _, role in ipairs(PermissionManager._playerRoles[player] or {}) do
		table.insert(copy, role)
	end
	return copy
end

function PermissionManager.ListRoles(): {[string]: {string}}
	return PermissionManager._roles
end

function PermissionManager.SetOwner(player: Player)
	PermissionManager._owners[player.UserId] = true
end

function PermissionManager.IsOwner(player: Player): boolean
	if PermissionManager._owners[player.UserId] then return true end
	return game.CreatorId > 0 and player.UserId == game.CreatorId
end

function PermissionManager.GetLevel(player: Player): number
	return #(PermissionManager._playerRoles[player] or {})
end

function PermissionManager.Cleanup(player: Player)
	PermissionManager._playerRoles[player] = nil
	PermissionManager._playerPermissions[player] = nil
end

return PermissionManager
