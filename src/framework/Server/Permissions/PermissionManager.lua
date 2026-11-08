--!strict
-- Vessie Roblox Framework - PermissionManager (10)
-- Gerenciamento de papéis e permissões

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PermissionManager = {}

-- Sistema de papéis (Roles)
-- Cada jogador pode ter múltiplos papéis
PermissionManager._roles: {[string]: {string}} = {} -- {roleName} = {permission1, permission2, ...}
PermissionManager._playerRoles: {[Player]: {string}} = {} -- {player} = {role1, role2, ...}
PermissionManager._permissions: {[string]: {string}} = {} -- {permissionName} = {description, ...}

-- Definir um papel (deve ser chamado no servidor/initialization)
-- @param roleName string nome do papel
-- @param permissions {string} lista de permissões
function PermissionManager.DefineRole(roleName: string, permissions: {string})
	PermissionManager._roles[roleName] = permissions or {}
end

-- Atribuir papel a um jogador
-- @param player Player
-- @param roleName string nome do papel
function PermissionManager.AssignRole(player: Player, roleName: string)
	if not PermissionManager._roles[roleName] then
		warn("[PermissionManager] Papel não definido: " .. roleName)
		return false
	end
	
	PermissionManager._playerRoles[player] = PermissionManager._playerRoles[player] or {}
	table.insert(PermissionManager._playerRoles[player], roleName)
	
	-- Also add inherited permissions
	for _, perm: string: any in ipairs(PermissionManager._roles[roleName]) do
		PermissionManager._permissions[perm] = {role = roleName, grantedBy = tick()}
	end
	
	return true
end

-- Remover papel de um jogador
-- @param player Player
-- @param roleName string nome do papel
function PermissionManager.RemoveRole(player: Player, roleName: string)
	local roles: {string} = PermissionManager._playerRoles[player] or {}
	for i, role: string: any in ipairs(roles) do
		if role == roleName then
			table.remove(roles, i)
			-- Cleanup permissões associadas (simplificado)
			break
		end
	end
end

-- Verificar se jogador tem uma permissão específica
-- @param player Player
-- @param permission string permissão para verificar
-- @param targetPlayer Player|nil alvo (para operações que afetam outros jogadores)
-- @return boolean temPermissao
function PermissionManager.HasPermission(player: Player, permission: string, targetPlayer: Player?): boolean
	-- Primeiro, verificar papéis do jogador
	local playerRoles: {string} = PermissionManager._playerRoles[player] or {}
	
	for _, role: string: any in ipairs(playerRoles) do
		local perms: {string} = PermissionManager._roles[role] or {}
		for _, p: string: any in ipairs(perms) do
			if p == permission then return true end
		end
	end
	
	-- Verificar permissões diretas (se existirem)
	if PermissionManager._permissions[permission] then
		-- Verificar se tem expiry ou se ainda é válido
		local permData: any = PermissionManager._permissions[permission]
		if permData then
			-- Sem expiry por padrão = permanente
			return true
		end
	end
	
	return false
end

-- Verificar se jogador pode agir sobre outro jogador
-- @param executor Player que executa a ação
-- @param target Player alvo
-- @param permission string permissão necessária (ex: "admin:kick")
-- @return boolean podeExecutar
function PermissionManager.CanExecuteOn(executor: Player, target: Player, permission: string): boolean
	-- Verificar permissão do executor
	if not PermissionManager.HasPermission(executor, permission) then
		return false
	end
	
	-- Verificar se o target também tem a permissão (para impedir que admins se removam, por exemplo)
	if PermissionManager.HasPermission(target, permission) then
		return false -- Impedir auto-alvo em certas operações
	end
	
	return true
end

-- Listar todas as permissões de um jogador
-- @param player Player
-- @return {string} lista de permissões
function PermissionManager.GetPermissions(player: Player): {string}
	local perms: {string} = {}
	local roles: {string} = PermissionManager._playerRoles[player] or {}
	
	for _, role: string: any in ipairs(roles) do
		local rolePerms: {string} = PermissionManager._roles[role] or {}
		for _, p: string: any in ipairs(rolePerms) do
			if not table.find(perms, p) then
				table.insert(perms, p)
			end
		end
	end
	
	return perms
end

-- Listar todos os papéis definidos
-- @return {[string]: {string}} dicionário de roles
function PermissionManager.ListRoles(): {[string]: {string}}
	return PermissionManager._roles
end

-- Obter todas as permissões concedidas
-- @return {[string]: any} dicionário de permissões
function PermissionManager.ListPermissions(): {[string]: any}
	return PermissionManager._permissions
end

-- Verificar se jogador é dono da experiência (Owner)
-- @param player Player
-- @return boolean éDono
function PermissionManager.IsOwner(player: Player): boolean
	-- Em um cenário real, isso verificaria o Owner do jogo
	-- Por enquanto, retorna false (deve ser configurado via Place/Universe settings)
	return false
end

-- Obter nível de permissão (quantidade de papéis/permissões)
-- @param player Player
-- @return number nível (quantidade de papéis)
function PermissionManager.GetLevel(player: Player): number
	local roles: {string} = PermissionManager._playerRoles[player] or {}
	return #roles
end

return PermissionManager