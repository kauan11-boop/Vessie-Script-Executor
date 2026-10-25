--!strict
-- Vessie Roblox Framework - SecurityManager (10)
-- Camada de segurança: validação de entrada, permissões, rate limiting

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local SecurityManager = {}

-- Rate Limiter implementation
local RateLimiter = {}
RateLimiter._tokens: {[Player]: {number, number}} = {} -- {player} = {tokens, lastTime}
RateLimiter._limits: {[string]: {limit: number, period: number}} = {}

-- Adicionar tokens ao balde (chamado periodicamente)
function RateLimiter.AddTokens(player: Player, amount: number)
	local data: any = RateLimiter._tokens[player]
	if not data then
		data = {amount, tick()}
		RateLimiter._tokens[player] = data
		return
	end
	
	data[1] = math.min(data[1] + amount, 100) -- capacidade máxima
	data[2] = tick()
end

-- Verificar se pode executar ação (token bucket)
-- @param player Player
-- @param cost number custo em tokens (padrão 1)
-- @return boolean podeExecutar
function RateLimiter.CanExecute(player: Player, cost: number?): boolean
	cost = cost or 1
	local data: any = RateLimiter._tokens[player]
	if not data then
		RateLimiter.AddTokens(player, cost)
		return true
	end
	
	local currentTime: number = tick()
	local elapsed: number = currentTime - data[2]
	
	-- Recuperar tokens baseados no tempo decorrido
	local recoverRate: number = 1 / (data.period or 1) -- tokens por segundo
	local recovered: number = math.floor(elapsed * recoverRate)
	if recovered > 0 then
		data[1] = math.min(data[1] + recovered, 100)
		data[2] = currentTime
	end
	
	if data[1] >= cost then
		data[1] = data[1] - cost
		return true
	end
	
	return false
end

-- Security Manager functions

-- Validar entrada do cliente para operação privilegiada
-- @param player Player
-- @param operation string nome da operação
-- @param args table argumentos recebidos
-- @return boolean validado, string mensagem erro|nil
function SecurityManager.ValidateClientOperation(player: Player, operation: string, args: any?): boolean
	-- Verificar se o player existe e é válido
	if not player or not player:IsA("Player") then
		return false, "Player inválido"
	end
	
	-- Verificar rate limit
	if not RateLimiter.CanExecute(player) then
		return false, "Rate limit exceeded. Tente novamente mais tarde."
	end
	
	-- Verificar se operação é permitida (lista branca simples)
	local allowedOperations = {
		["teleport"] = true,
		["heal"] = true,
		["kick"] = true,
		["setattribute"] = true,
	}
	
	if not allowedOperations[operation] then
		return false, "Operação não autorizada: " .. operation
	end
	
	-- Validar estrutura dos argumentos (mínima)
	if args and type(args) == "table" then
		-- Verificar se não contém dados suspeitos
		for key, value in pairs(args) do
			if type(value) == "string" and #value > 1000 then
				return false, "Argumento muito longo: " .. key
			end
		end
	end
	
	return true, "Validado"
end

-- Verificar permissão de administrador
-- @param player Player que está tentando executar
-- @param targetPlayer Player alvo (opcional, para operações como kick/heal)
-- @return boolean temPermissao, string mensagem
function SecurityManager.HasAdminPermission(player: Player, targetPlayer: Player?): boolean
	-- Verificar UserId contra lista de administradores
	-- Em um cenário real, isso viria de uma configuração do servidor
	local isAdmin: boolean = false
	
	-- Lista de admin placeholder - em produção viria de ConfigManager
	local admins: {string} = {} -- ConfigManager.Get("AdminList") ou similar
	
	for _, adminId: string: any in ipairs(admins) do
		if player.UserId == tonumber(adminId) then
			isAdmin = true
			break
		end
	end
	
	return isAdmin
end

-- Validar posição/área para teletransporte
-- @param player Player
-- @param cframe CFrame alvo
-- @return boolean validado, string mensagem|nil
function SecurityManager.ValidateTeleport(player: Player, cframe: CFrame?): boolean
	if not cframe then return false, "CFrame inválido" end
	
	-- Verificar se posição está dentro da experiência (simplificado)
	-- Em experiências maiores, isso seria mais complexo
	local character: Instance? = player.Character
	if character then
		local rootPart: BasePart? = character:FindFirstChild("HumanoidRootPart")
		if rootPart then
			-- Evitar teleportar para muito longe da área central
			local pos: Vector3 = rootPart.Position
			if math.abs(pos.X) > 10000 or math.abs(pos.Y) > 10000 or math.abs(pos.Z) > 10000 then
				return false, "Posição muito distante da área segura"
			end
		end
	end
	
	return true, "Validado"
end

-- Registrar operação suspeita para auditoria
-- @param player Player
-- @param operation string
-- @param details string detalhes
function SecurityManager.LogSuspiciousActivity(player: Player, operation: string, details: string?)
	if not player then return end
	local msg: string = string.format("[Security] Suspicious activity: %s by Player %s (%s)", operation, player.Name, player.UserId)
	if details then
		msg = msg .. " - " .. details
	end
	warn(msg)
end

-- Limpar rate limit de um jogador
function SecurityManager.ResetRateLimit(player: Player)
	RateLimiter._tokens[player] = nil
end

return SecurityManager