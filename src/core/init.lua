-- Core da Public API — agrega o sistema de comandos não-visual
-- Ponto único de acesso: registro, execução segura, estado, bridge e canal.

local Core = {}

local public_api = require("src.core.public_api")
local dispatcher = require("src.core.command_dispatcher")
local security = require("src.core.security_wrapper")
local state = require("src.core.state_manager")
local bridge = require("src.core.remote_event_bridge")
local channel = require("src.core.nonvisual_channel")

Core.public_api = public_api
Core.dispatcher = dispatcher
Core.security = security
Core.state = state
Core.bridge = bridge
Core.channel = channel

function Core:inicializar()
    state.init()
    public_api.init()
    bridge.set_processor(public_api.process_command)
    channel.set_channel({ name = "public_api", identifier = "public_api" })
    return self
end

-- Registra um comando liberando-o nas allowlists (security + public_api)
function Core:registrarComando(nome, funcao)
    security.allow_command(nome)
    public_api.allow_command(nome)
    return public_api.register_command(nome, funcao)
end

-- Executa um comando com verificação de segurança, rate limit, histórico e estado
function Core:executar(comando, args)
    local permitido, msg = security.is_command_allowed(comando)
    if not permitido then return { success = false, error = msg } end

    local rateOk, rateMsg = security.check_rate_limit(comando)
    if not rateOk then return { success = false, error = rateMsg } end

    local resultado = public_api.process_command(comando, args)
    security.record_execution(comando, resultado.success, args)
    state.increment_command_count()
    return resultado
end

function Core:listarComandos()
    return public_api.list_commands()
end

return Core