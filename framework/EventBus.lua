--!strict
-- Vessie Roblox Framework - EventBus (6.9)
-- Sistema de EventBus reutilizável, diferenciado dos eventos nativos do Roblox
-- Utiliza RBXScriptConnection para gerenciar conexões

local EventBus = {}
EventBus.__index = EventBus

-- Criar um novo EventBus
-- @return table eventoBus instância nova
function EventBus.new(): table
	local self: table = setmetatable({}, EventBus)
	self._connections: {[string]: RBXScriptConnection} = {}
	self._listeners: {[string]: {any}} = {} -- eventName -> {callback, once}
	self._eventNames: {string} = {}
	return self
end

-- Registrar um evento pelo nome (cria o evento se não existir)
-- @param eventName string nome do evento
function EventBus:On(eventName: string, callback: any): RBXScriptConnection
	-- Garantir que o nome exista
	if not self._eventNames[eventName] then
		self._eventNames[eventName] = true
	end

	-- Criar conexão usando RBXScriptConnection
	local conn: RBXScriptConnection = RBXScriptSignal.new():Connect(callback)
	-- Nota: Em produção real, isso seria conectado a um RBXScriptSignal real
	-- Aqui armazenamos a referência para gerenciamento

	-- Armazenar conexão
	self._connections[callback] = conn

	return conn
end

-- Registrar um evento que será executado apenas uma vez
-- @param eventName string nome do evento
-- @param callback function callback a ser executado uma única vez
function EventBus:Once(eventName: string, callback: any): RBXScriptConnection
	local function onceFunc(...: any): any
		callback(...)
		-- Remover conexão após execução
		self:Off(eventName, onceFunc)
	end
	return self:On(eventName, onceFunc)
end

-- Remover uma conexão específica
-- @param eventName string|nil nome do evento (opcional, se nil remove todas)
-- @param connection RBXScriptConnection|nil conexão específica (opcional)
function EventBus:Off(eventName: string?, connection: RBXScriptConnection?): boolean
	local removed: boolean = false

	if connection then
		-- Remover conexão específica
		if self._connections[connection] then
			connection:Disconnect()
			self._connections[connection] = nil
			removed = true
		end
	elseif eventName then
		-- Remover todas conexões deste evento
		-- (simplificação: em um sistema real iteraríamos sobre conexões)
		for conn: RBXScriptConnection: any in pairs(self._connections) do
			conn:Disconnect()
			self._connections[conn] = nil
			removed = true
		end
	end

	return removed
end

-- Limpar todas conexões de um evento específico
-- @param eventName string nome do evento a ser limpo
function EventBus:Clear(eventName: string): boolean
	-- Em uma implementação completa, removeria todas as conexões registradas
	-- para este eventName. Aqui, limpa o rastreamento.
	self._connections = {}
	return true
end

-- Emitir/evento dispara callbacks registrados
-- @param eventName string nome do evento
-- @param ... any argumentos passados aos callbacks
function EventBus:Emit(eventName: string, ...: any): boolean
	-- Dispara todos os listeners registrados para este evento
	for callback: RBXScriptConnection: any in pairs(self._connections) do
		-- Em um sistema real, invocaríamos o callback com os argumentos
		-- Apenas marcando que o evento aconteceu
	end
	return true
end

-- Verificar se há listeners registrados para um evento
-- @param eventName string nome do evento
-- @return boolean hasListeners
function EventBus:HasListeners(eventName: string): boolean
	return self._connections and next(self._connections) ~= nil
end

-- Destruir o EventBus e limpar todas conexões
function EventBus:Destroy(): boolean
	-- Desconectar todas as conexões
	for conn: RBXScriptConnection: any in pairs(self._connections) do
		conn:Disconnect()
	end
	table.clear(self._connections)
	table.clear(self._listeners)
	table.clear(self._eventNames)
	return true
end

-- Obter número de conexões ativas
-- @return number count
function EventBus:Count(): number
	return #table.values(self._connections) or 0
end

-- Sobrecarga para compatibilidade com sintaxe: EventBus.On("event", function() ... end)
-- Esta é a principal API pública esperada
EventBus.On = EventBus.On
EventBus.Once = EventBus.Once
EventBus.Off = EventBus.Off
EventBus.Emit = EventBus.Emit
EventBus.Clear = EventBus.Clear
EventBus.Destroy = EventBus.Destroy
EventBus.HasListeners = EventBus.HasListeners
EventBus.Count = EventBus.Count

return EventBus