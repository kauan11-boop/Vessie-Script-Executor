--!strict
-- Vessie Roblox Framework - PlayerManager (7)
-- Gerencia jogadores, entrada, carregamento de personagens e respawns

local Players = game:GetService("Players")
local PlayerManager = {}

-- Tabela de dados de jogadores ( Cliente-Servidor separado )
PlayerManager._playerData: {[Player]: any} = {}
PlayerManager._characterData: {[Player]: {}} = {}

-- Eventos internos
PlayerManager.Events = {
	PlayerAdded = nil,
	PlayerRemoving = nil,
	CharacterAdded = nil,
	CharacterRemoving = nil,
	PlayerRespawned = nil,
}

-- Inicializar eventos do framework
function PlayerManager.Init()
	PlayerManager.Events.PlayerAdded = Instance.new("BindableEvent")
	PlayerManager.Events.PlayerRemoving = Instance.new("BindableEvent")
	PlayerManager.Events.CharacterAdded = Instance.new("BindableEvent")
	PlayerManager.Events.CharacterRemoving = Instance.new("BindableEvent")
	PlayerManager.Events.PlayerRespawned = Instance.new("BindableEvent")
end

-- Detectar entrada e saída de jogadores
-- Isto deve ser chamado quando o Player é adicionado
function PlayerManager.OnPlayerAdded(player: Player)
	-- Inicializar dados do jogador
	PlayerManager._playerData[player] = {
		Character = nil,
		LastPosition = Vector3.new(0, 0, 0),
		JoinTime = tick(),
	})

	-- Conectar eventos do Roblox
	player.CharacterAdded:Connect(function(character)
		PlayerManager._playerData[player].Character = character
		PlayerManager.Events.CharacterAdded:Fire(player, character)
		
		-- Aguardar Humanoid estar pronto
		local humanoid: Humanoid = player:WaitForChild("Character", 5):WaitForChild("Humanoid", 5)
		if humanoid then
			-- Conectar eventos de estado do personagem
			humanoid.StateChanged:Connect(function(oldState, newState)
				-- Podemos registrar transições de estado aqui
			end)
		end
	end)

	player.CharacterRemoving:Connect(function(character)
		PlayerManager._playerData[player].Character = nil
		PlayerManager.Events.CharacterRemoving:Fire(player, character)
	end)

	player:GetAttributeChangedSignal("_"):Connect(function()
		-- Placeholder para futuras melhorias
	end)

	-- Evento de saída do jogador
	player.PlayerRemoving:Connect(function()
		PlayerManager._playerData[player] = nil
		PlayerManager.Events.PlayerRemoving:Fire(player)
	end)
end

-- Detectar respawn (quando personagem é destruído e recriado automaticamente)
function PlayerManager.OnPlayerRemoving(player: Player)
	-- Limpeza de recursos
	PlayerManager._playerData[player] = nil
end

-- Acompanhar personagem atual de um jogador
-- @param player Player
-- @return Instance|nil personagem ou nil se indisponível
function PlayerManager.GetCharacter(player: Player): Instance?
	local data: any = PlayerManager._playerData[player]
	if data and data.Character and data.Character.Parent then
		return data.Character
	end
	-- Tentar obter personagem atual do Roblox
	local char: Instance? = player.Character
	if char and char.Parent then
		PlayerManager._playerData[player].Character = char
		return char
	end
	return nil
end

-- Acessar dados do jogador
-- @param player Player
-- @param key string|nil chave específica
-- @return any valor ou tabela completa
function PlayerManager.GetData(player: Player, key: string?): any
	local data: any = PlayerManager._playerData[player]
	if not data then return nil end
	if key then return data[key] end
	return data
end

-- Definir dado do jogador
-- @param player Player
-- @param key string chave
-- @param value any valor
function PlayerManager.SetData(player: Player, key: string, value: any)
	if not PlayerManager._playerData[player] then
		PlayerManager._playerData[player] = {}
	end
	PlayerManager._playerData[player][key] = value
end

-- Verificar se jogador tem personagem carregado
-- @param player Player
-- @return boolean temPersonagem
function PlayerManager.HasCharacter(player: Player): boolean
	local char: Instance? = PlayerManager.GetCharacter(player)
	return char ~= nil and char.Parent ~= nil
end

-- Obter posição última conhecida do personagem
-- @param player Player
-- @return Vector3 posição
function PlayerManager.GetLastPosition(player: Player): Vector3
	local data: any = PlayerManager._playerData[player]
	if data and data.LastPosition then
		return data.LastPosition
	end
	-- Fallback: posição do personagem
	local char: Instance? = PlayerManager.GetCharacter(player)
	if char then
		local hum: Humanoid? = char:FindFirstChildOfClass("Humanoid")
		if hum then
			return hum.RootPart.Position
		end
	end
	return Vector3.new(0, 0, 0)
end

-- Definir posição última conhecida
-- @param player Player
-- @param position Vector3
function PlayerManager.SetLastPosition(player: Player, position: Vector3)
	if not PlayerManager._playerData[player] then
		PlayerManager._playerData[player] = {}
	end
	PlayerManager._playerData[player].LastPosition = position
end

-- Fornecer eventos internos (wrapper para BindableEvents)
-- @param eventName string nome do evento
-- @return RBXScriptConnection conexão
function PlayerManager.On(eventName: string, callback: ...)
	local bindable: Instance = PlayerManager.Events[eventName]
	if bindable then
		return bindable.Event:Connect(callback)
	end
	warn("[PlayerManager] Evento não registrado: " .. eventName)
	return nil
end

-- Limpar recursos associados a um jogador
-- @param player Player
function PlayerManager.Cleanup(player: Player)
	if PlayerManager._playerData[player] then
		PlayerManager._playerData[player].Character = nil
		PlayerManager._playerData[player] = nil
	end
	-- Desconectar todos os eventos conectados a este jogador
	-- (Acontece automaticamente quando o jogador sai, mas pode ser chamado manualmente)
end

return PlayerManager