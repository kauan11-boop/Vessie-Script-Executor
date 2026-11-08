--!strict
-- Vessie Roblox Framework - SecurityManager
-- Validação de entrada, permissões de admin e rate limiting (token bucket)

local SecurityManager = {}

local RateLimiter = {}
RateLimiter._buckets = {}
RateLimiter._capacity = 20
RateLimiter._refillPerSecond = 2

function RateLimiter.Configure(capacity: number, refillPerSecond: number)
	RateLimiter._capacity = capacity
	RateLimiter._refillPerSecond = refillPerSecond
end

local function getBucket(player: Player)
	local bucket = RateLimiter._buckets[player]
	local now = os.clock()
	if not bucket then
		bucket = { tokens = RateLimiter._capacity, last = now }
		RateLimiter._buckets[player] = bucket
		return bucket
	end
	local elapsed = now - bucket.last
	bucket.tokens = math.min(RateLimiter._capacity, bucket.tokens + elapsed * RateLimiter._refillPerSecond)
	bucket.last = now
	return bucket
end

function RateLimiter.CanExecute(player: Player, cost: number?): boolean
	local bucket = getBucket(player)
	local needed = cost or 1
	if bucket.tokens >= needed then
		bucket.tokens = bucket.tokens - needed
		return true
	end
	return false
end

function RateLimiter.Reset(player: Player)
	RateLimiter._buckets[player] = nil
end

SecurityManager.RateLimiter = RateLimiter
SecurityManager._admins = {}
SecurityManager._allowedOperations = {
	teleport = true,
	heal = true,
	kick = true,
	setattribute = true,
}
SecurityManager._teleportBound = 100000

function SecurityManager.AllowOperation(operation: string, allowed: boolean?)
	SecurityManager._allowedOperations[operation] = if allowed == nil then true else allowed
end

function SecurityManager.SetAdmins(userIds: {number})
	SecurityManager._admins = {}
	for _, id in ipairs(userIds) do
		SecurityManager._admins[id] = true
	end
end

function SecurityManager.AddAdmin(userId: number)
	SecurityManager._admins[userId] = true
end

function SecurityManager.HasAdminPermission(player: Player): boolean
	if not player or not player:IsA("Player") then return false end
	return SecurityManager._admins[player.UserId] == true
end

function SecurityManager.SetTeleportBound(bound: number)
	SecurityManager._teleportBound = bound
end

function SecurityManager.ValidateClientOperation(player: Player, operation: string, args: any?): (boolean, string?)
	if not player or not player:IsA("Player") then
		return false, "Player inválido"
	end
	if not RateLimiter.CanExecute(player) then
		return false, "Rate limit excedido. Tente novamente mais tarde."
	end
	if not SecurityManager._allowedOperations[operation] then
		return false, "Operação não autorizada: " .. tostring(operation)
	end
	if type(args) == "table" then
		for key, value in pairs(args) do
			if type(value) == "string" and #value > 1000 then
				return false, "Argumento muito longo: " .. tostring(key)
			end
		end
	end
	return true, nil
end

function SecurityManager.ValidateTeleport(player: Player, cframe: CFrame?): (boolean, string?)
	if typeof(cframe) ~= "CFrame" then return false, "CFrame inválido" end
	local position = cframe.Position
	local bound = SecurityManager._teleportBound
	if math.abs(position.X) > bound or math.abs(position.Y) > bound or math.abs(position.Z) > bound then
		return false, "Destino fora da área segura"
	end
	return true, nil
end

function SecurityManager.LogSuspiciousActivity(player: Player, operation: string, details: string?)
	if not player then return end
	local message = string.format("[Security] Atividade suspeita: %s por %s (%d)", operation, player.Name, player.UserId)
	if details then message = message .. " - " .. details end
	warn(message)
end

function SecurityManager.ResetRateLimit(player: Player)
	RateLimiter.Reset(player)
end

function SecurityManager.Cleanup(player: Player)
	RateLimiter.Reset(player)
end

return SecurityManager
