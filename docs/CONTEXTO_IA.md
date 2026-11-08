# Contexto do repositório para IA

> Gerado automaticamente por `tools/gerar-contexto.mjs` em 2026-11-08T21:42:16.180Z.
> Não edite manualmente: altere `tools/descricoes-modulos.json` e rode `node tools/gerar-contexto.mjs`.

Total: **38 scripts Lua**. Versão machine-readable: `docs/contexto.json`.

Para entender um módulo em profundidade, leia o arquivo fonte indicado em cada seção.

## Leitura via raw do GitHub

Cada script tem uma URL raw para leitura direta por IA/agentes (sem clonar o repositório).
Base: `https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/` — some o caminho relativo do arquivo para obter o conteúdo integral.

Lista completa (caminho -> URL raw):

- `main.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/main.lua
- `src/apis.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/apis.lua
- `src/core/command_dispatcher.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/core/command_dispatcher.lua
- `src/core/init.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/core/init.lua
- `src/core/nonvisual_channel.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/core/nonvisual_channel.lua
- `src/core/public_api.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/core/public_api.lua
- `src/core/remote_event_bridge.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/core/remote_event_bridge.lua
- `src/core/security_wrapper.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/core/security_wrapper.lua
- `src/core/state_manager.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/core/state_manager.lua
- `src/framework/Client/NotificationManager.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/Client/NotificationManager.lua
- `src/framework/Client/PlayerManager.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/Client/PlayerManager.lua
- `src/framework/Client/ThemeManager.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/Client/ThemeManager.lua
- `src/framework/init.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/init.lua
- `src/framework/runtime/ConfigManager.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/runtime/ConfigManager.lua
- `src/framework/runtime/EventBus.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/runtime/EventBus.lua
- `src/framework/runtime/LifecycleManager.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/runtime/LifecycleManager.lua
- `src/framework/runtime/Logger.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/runtime/Logger.lua
- `src/framework/runtime/ModuleRegistry.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/runtime/ModuleRegistry.lua
- `src/framework/Server/CharacterManager.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/Server/CharacterManager.lua
- `src/framework/Server/PermissionManager.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/Server/PermissionManager.lua
- `src/framework/Server/SecurityManager.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/Server/SecurityManager.lua
- `src/framework/Shared/DataManager.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/Shared/DataManager.lua
- `src/framework/Shared/NetworkingManager.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/Shared/NetworkingManager.lua
- `src/framework/utils/CollectionUtils.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/utils/CollectionUtils.lua
- `src/framework/utils/InstanceUtils.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/utils/InstanceUtils.lua
- `src/framework/utils/MathUtils.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/utils/MathUtils.lua
- `src/framework/utils/NumberUtils.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/utils/NumberUtils.lua
- `src/framework/utils/StringUtils.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/utils/StringUtils.lua
- `src/framework/utils/TableUtils.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/utils/TableUtils.lua
- `src/jogo.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/jogo.lua
- `src/memoria.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/memoria.lua
- `src/neural/ativacoes.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/neural/ativacoes.lua
- `src/neural/camadas.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/neural/camadas.lua
- `src/neural/init.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/neural/init.lua
- `src/neural/matriz.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/neural/matriz.lua
- `src/neural/serializacao.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/neural/serializacao.lua
- `src/ui.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/ui.lua
- `src/utils.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/utils.lua

---

## `main.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/main.lua

103 linhas · 3307 bytes · retorna `Library`

**Propósito:** Ponto de entrada (v0.2.0): carrega core/memoria/jogo/ui/apis/utils/neural/framework via require("src.<nome>"), inicializa o core primeiro, registra os comandos de utils no core e expõe executarComando, getMemoria, setMemoria, adicionarEvento, redeNeural e obterModulo.

Cabeçalho do arquivo:

```lua
--[[
Vessie Script Executor - Ponto de Entrada
Versão: 0.2.0
Desenvolvido para executores: Xeno, Delta, Mobile Executors
Funciona no client local sem emuladores

Arquitetura: main.lua (raiz) carrega módulos de src/ via require("src.<nome>").
<nome> resolve para src/<nome>.lua ou src/<nome>/init.lua.
--]]
```

Funções:

- `function Library:carregarModulo(nome)` (linha 18)
- `function Library:inicializar()` (linha 31)
- `function Library:executarComando(comando, ...)` (linha 68)
- `function Library:getMemoria(endereco)` (linha 77)
- `function Library:setMemoria(endereco, valor)` (linha 83)
- `function Library:adicionarEvento(nome, callback)` (linha 89)
- `function Library:redeNeural()` (linha 95)
- `function Library:obterModulo(nome)` (linha 99)

## `src/apis.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/apis.lua

137 linhas · 4799 bytes · retorna `API`

**Propósito:** Integração externa: detecta o HTTP do executor (request/syn.request/http_request), webhook/GET/POST/baixarArquivo, conversão JSON via HttpService e informações de executor/jogador/jogo.

Cabeçalho do arquivo:

```lua
--[[
Módulo de APIs - Vessie Script Executor
Integração externa (HTTP/webhooks) e informações do executor/jogador/jogo.
HTTP real é usado quando o executor expõe request; caso contrário, placeholder.
--]]
```

Funções:

- `local function obterRequest()` (linha 12, local)
- `local function temHttp()` (linha 20, local)
- `function API:enviarWebhook(url, dados, metodo)` (linha 24)
- `function API:requisicaoGET(url)` (linha 45)
- `function API:requisicaoPOST(url, dados)` (linha 53)
- `function API:baixarArquivo(url, caminhoLocal)` (linha 58)
- `function API:obterInfoExecutor()` (linha 71)
- `function API:obterInfoJogador(jogador)` (linha 81)
- `function API:obterInfoJogo()` (linha 93)
- `function API:registrarCallback(evento, callback)` (linha 108)
- `function API:dispararCallback(evento, ...)` (linha 115)
- `function API:tabelaParaJSON(tabela)` (linha 124)
- `function API:JSONParaTabela(jsonString)` (linha 128)

## `src/core/command_dispatcher.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/core/command_dispatcher.lua

59 linhas · 1848 bytes · retorna `M`

**Propósito:** Registro e despacho de handlers de comando da Public API, com execução protegida (pcall) e modo seguro.

Cabeçalho do arquivo:

```lua
-- Command Dispatcher for Public API
-- Despacho de comandos recebidos via remote events
-- Compatibilidade: Lua 5.1/5.2/5.3/5.4
```

Funções:

- `local function function_list()` (linha 9, local)
- `function M.register_handler(command_name, handler_func)` (linha 18)
- `function M.get_handler(command_name)` (linha 29)
- `function M.dispatch(command_name, args)` (linha 34)
- `function M.list_commands()` (linha 50)
- `function M.set_secure(secure)` (linha 54)

## `src/core/init.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/core/init.lua

53 linhas · 1764 bytes · retorna `Core`

**Propósito:** Faixada do núcleo Public API: agrega os 6 submódulos, inicializar prepara estado/bridge/canal, registrarComando aplica segurança+allowlist+dispatch, executar valida allowlist/rate-limit/processa/histórico e listarComandos.

Cabeçalho do arquivo:

```lua
-- Core da Public API — agrega o sistema de comandos não-visual
-- Ponto único de acesso: registro, execução segura, estado, bridge e canal.
```

Funções:

- `function Core:inicializar()` (linha 20)
- `function Core:registrarComando(nome, funcao)` (linha 29)
- `function Core:executar(comando, args)` (linha 36)
- `function Core:listarComandos()` (linha 49)

## `src/core/nonvisual_channel.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/core/nonvisual_channel.lua

86 linhas · 2481 bytes · retorna `M`

**Propósito:** Canal de comunicação não-visual: define canal ativo, prepara/valida payloads para remote events e gera IDs de mensagem.

Cabeçalho do arquivo:

```lua
-- NonVisual Channel for Public API
-- Canal de comunicacao nao-visual para enviar/receber informacoes
-- Sem interfaces graficas, apenas troca de dados por remote events
```

Funções:

- `function M.set_channel(channel_data)` (linha 11)
- `function M.get_channel()` (linha 26)
- `function M.send(data, target)` (linha 31)
- `function M.receive(event_name, payload)` (linha 61)
- `function M.is_channel_active()` (linha 77)
- `function M.generate_message_id()` (linha 82)

## `src/core/public_api.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/core/public_api.lua

125 linhas · 4794 bytes · retorna `M`

**Propósito:** API pública de comandos via remote events: registro com allowlist, processamento protegido (pcall), trigger e respostas; init registra comandos padrão.

Cabeçalho do arquivo:

```lua
-- Public API System for Executor Lua
-- Sistema de API pública usando remote events do jogo (não-visual)
-- Compatível: Lua 5.1/5.2/5.3/5.4 | Executores: Xeno, Delta, Mobile
```

Funções:

- `local function function_list()` (linha 17, local)
- `local function is_allowed(name)` (linha 26, local)
- `function M.register_command(name, func)` (linha 34)
- `function M.unregister_command(name)` (linha 44)
- `function M.process_command(command, args)` (linha 52)
- `function M.list_commands()` (linha 67)
- `function M.allow_command(name)` (linha 71)
- `function M.setup_remote_event(remote_event_name, callback)` (linha 81)
- `function M.trigger_remote(command, args)` (linha 89)
- `function M.on_response(event_name, callback)` (linha 104)
- `function M.send_response(request_id, success, data)` (linha 113)
- `function M.init()` (linha 121)

Tabelas/registros de topo:

- `M.config` (linha 7)

## `src/core/remote_event_bridge.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/core/remote_event_bridge.lua

141 linhas · 5136 bytes · retorna `M`

**Propósito:** Bridge para remote events do jogo: fila de comandos, listeners de resposta e processador injetado via set_processor; disparo real é simulado.

Cabeçalho do arquivo:

```lua
-- Remote Event Bridge for Public API
-- Conecta o sistema Public API aos remote events do jogo (execução não-visual)
```

Funções:

- `function M.set_processor(func)` (linha 10)
- `function M.create_bridge(remote_event_name)` (linha 16)
- `function bridge:on_response(callback)` (linha 34)
- `function bridge:trigger(command, args)` (linha 42)
- `function bridge:process_next()` (linha 56)
- `function bridge:_fire_remote(payload)` (linha 66)
- `function M.get_bridge(remote_event_name)` (linha 86)
- `function M.remove_bridge(remote_event_name)` (linha 90)
- `function M.list_bridges()` (linha 98)
- `function M.process_remote_event(event_name, payload)` (linha 106)
- `function M.setup(remote_event_name)` (linha 130)

## `src/core/security_wrapper.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/core/security_wrapper.lua

112 linhas · 4061 bytes · retorna `M`

**Propósito:** Wrapper de segurança da Public API: allowlist/blocklist de comandos, rate limit por minuto e histórico das últimas 100 execuções.

Cabeçalho do arquivo:

```lua
-- Security Wrapper for Public API
-- Wrapper de seguranca para comandos remotos: allowlist/blocklist, rate limit e historico
```

Funções:

- `local function contains(list, value)` (linha 17, local)
- `function M.is_command_allowed(command_name)` (linha 24)
- `function M.block_command(command_name)` (linha 38)
- `function M.allow_command(command_name)` (linha 48)
- `function M.check_rate_limit(command_name)` (linha 58)
- `function M.record_execution(command_name, success, args)` (linha 79)
- `function M.get_execution_history()` (linha 93)
- `function M.get_config()` (linha 97)
- `function M.set_config(new_config)` (linha 101)

## `src/core/state_manager.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/core/state_manager.lua

93 linhas · 2566 bytes · retorna `M`

**Propósito:** Estado não-visual entre requisições: inicialização, dados chave/valor, contador de comandos e sessões.

Cabeçalho do arquivo:

```lua
-- State Manager for Public API
-- Gerencia estado nao-visual entre requisicoes via remote events
-- Mantem estado em memoria sem interfaces graficas
```

Funções:

- `function M.init()` (linha 17)
- `function M.get_state()` (linha 29)
- `function M.update_state(key, value)` (linha 34)
- `function M.increment_command_count()` (linha 45)
- `function M.register_session(session_id, session_data)` (linha 52)
- `function M.get_session(session_id)` (linha 60)
- `function M.remove_session(session_id)` (linha 66)
- `function M.reset()` (linha 77)
- `function M.is_initialized()` (linha 89)

## `src/framework/Client/NotificationManager.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/Client/NotificationManager.lua

191 linhas · 6190 bytes · retorna `NotificationManager`

**Propósito:** Notificações UI animadas com fila e máximo visível, integradas ao ThemeManager; auto-dismiss, Clear e Destroy.

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - NotificationManager
-- Sistema de notificações com fila, duração configurável e tema integrado
```

Funções:

- `function NotificationManager._EnsureContainer()` (linha 24)
- `local function buildNotification(title: string, text: string, ntype: string)` (linha 57, local)
- `function NotificationManager._Display(request: any)` (linha 127)
- `function NotificationManager._ProcessQueue()` (linha 157)
- `function NotificationManager.Show(title: string, text: string, duration: number?, ntype: string?)` (linha 164)
- `function NotificationManager.Clear()` (linha 174)
- `function NotificationManager.Destroy()` (linha 182)

Tabelas/registros de topo:

- `NotificationManager._queue` (linha 12)
- `NotificationManager._active` (linha 13)

## `src/framework/Client/PlayerManager.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/Client/PlayerManager.lua

191 linhas · 5362 bytes · retorna `PlayerManager`

**Propósito:** Rastreia jogadores e personagens com dados por jogador e BindableEvents (PlayerAdded/Removing, CharacterAdded/Removing, PlayerRespawned); Init conecta eventos de Players e limpeza por jogador.

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - PlayerManager
-- Gerencia jogadores, entrada/saída, personagens e respawns
```

Funções:

- `local function fire(eventName: string, ...)` (linha 21, local)
- `function PlayerManager.Init()` (linha 28)
- `function PlayerManager.OnPlayerAdded(player: Player)` (linha 48)
- `function PlayerManager.OnPlayerRemoving(player: Player)` (linha 95)
- `function PlayerManager.GetCharacter(player: Player)` (linha 106)
- `function PlayerManager.GetData(player: Player, key: string?)` (linha 119)
- `function PlayerManager.SetData(player: Player, key: string, value: any)` (linha 126)
- `function PlayerManager.HasCharacter(player: Player)` (linha 135)
- `function PlayerManager.GetLastPosition(player: Player)` (linha 139)
- `function PlayerManager.SetLastPosition(player: Player, position: Vector3)` (linha 153)
- `function PlayerManager.On(eventName: string, callback: (...any) -> ())` (linha 157)
- `function PlayerManager.Cleanup(player: Player)` (linha 166)
- `function PlayerManager.Destroy()` (linha 176)

Tabelas/registros de topo:

- `PlayerManager._playerData` (linha 9)
- `PlayerManager._connections` (linha 10)
- `PlayerManager.Events` (linha 13)

## `src/framework/Client/ThemeManager.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/Client/ThemeManager.lua

110 linhas · 2871 bytes · retorna `ThemeManager`

**Propósito:** Temas Light/Dark/Custom com cores, fonte, espaçamento e border radius; GetColor/SetTheme/GetFont/GetSpacing/ApplyCustomTheme (sem mutar o tema Light).

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - ThemeManager
-- Gerenciamento de tema: cores, tipografia, espaçamento
```

Funções:

- `local function currentTheme()` (linha 46, local)
- `function ThemeManager.GetColor(key: string)` (linha 50)
- `function ThemeManager.SetTheme(themeName: string)` (linha 59)
- `function ThemeManager.GetFont()` (linha 67)
- `function ThemeManager.GetFontSize()` (linha 72)
- `function ThemeManager.GetSpacing(size: string)` (linha 76)
- `function ThemeManager.GetBorderRadius()` (linha 86)
- `function ThemeManager.Get(key: string)` (linha 90)
- `function ThemeManager.ApplyCustomTheme(customTheme: {[string]: any}?)` (linha 94)

Tabelas/registros de topo:

- `ThemeManager.Themes` (linha 7)

## `src/framework/init.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/init.lua

117 linhas · 3090 bytes · retorna `Framework`

**Propósito:** Núcleo do framework: registro de módulos (Register/Get), ciclo de vida Init → Start → Cleanup (Start/Stop) e Maid para limpeza de tarefas/conexões/instances; IsInitialized/GetModules.

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - Core (init)
-- Registro de modulos e ciclo de vida Init -> Start -> Cleanup, com Maid p/ limpeza.
```

Funções:

- `function Maid.new()` (linha 14)
- `function Maid:GiveTask(task, name)` (linha 18)
- `function Maid:GiveConnection(connection)` (linha 22)
- `function Maid:GiveInstance(instance)` (linha 27)
- `function Maid:DoCleaning()` (linha 32)
- `function Maid:Destroy()` (linha 53)
- `function Framework.Register(name: string, module: any)` (linha 60)
- `function Framework.Get(name: string)` (linha 68)
- `function Framework.Start()` (linha 73)
- `function Framework.Stop()` (linha 92)
- `function Framework.IsInitialized()` (linha 106)
- `function Framework.GetModules()` (linha 110)

Tabelas/registros de topo:

- `Framework._modules` (linha 7)

## `src/framework/runtime/ConfigManager.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/runtime/ConfigManager.lua

121 linhas · 3680 bytes · retorna `ConfigManager`

**Propósito:** Classe de configurações com defaults, overrides, campos readonly e níveis de acesso (bloqueia ServerOnly no cliente via RunService); Get trata false e GetKeys deduplica.

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - ConfigManager
-- Configuracoes com defaults, overrides, readonly e niveis de acesso
```

Funções:

- `function ConfigManager.new(configTable: {[string]: any}?)` (linha 14)
- `function ConfigManager:Set(key: string, value: any, access: string?, readonly: boolean?)` (linha 23)
- `function ConfigManager:Get(key: string, default: any)` (linha 39)
- `function ConfigManager:SetDefault(key: string, default: any, access: string?)` (linha 46)
- `function ConfigManager:SetReadOnly(key: string, value: any)` (linha 53)
- `function ConfigManager:Exists(key: string)` (linha 60)
- `function ConfigManager:Remove(key: string)` (linha 65)
- `function ConfigManager:Override(key: string, value: any)` (linha 73)
- `function ConfigManager:GetKeys()` (linha 79)
- `function ConfigManager:GetReadWriteKeys()` (linha 90)
- `function ConfigManager:ValidateRequired(required: {string})` (linha 98)
- `function ConfigManager:Export()` (linha 107)
- `function ConfigManager:Import(importedTable: {[string]: any})` (linha 114)

Tabelas/registros de topo:

- `ConfigManager.Access` (linha 8)

## `src/framework/runtime/EventBus.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/runtime/EventBus.lua

97 linhas · 2542 bytes · retorna `EventBus`

**Propósito:** Pub/sub por nome (On/Once/Off/Emit); conexões com Disconnect e Emit protegido por pcall com limpeza de listeners Once.

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - EventBus
-- Pub/sub por nome (puro, sem RBXScriptSignal). On/Once retornam conexao com Disconnect.
```

Funções:

- `function EventBus.new()` (linha 10)
- `local function addListener(self, eventName, callback, once)` (linha 16, local)
- `function connection:Disconnect()` (linha 22)
- `function EventBus:On(eventName: string, callback: any)` (linha 28)
- `function EventBus:Once(eventName: string, callback: any)` (linha 32)
- `function EventBus:Off(eventName: string?, connection: any?)` (linha 36)
- `function EventBus:Clear(eventName: string)` (linha 47)
- `function EventBus:Emit(eventName: string, ...)` (linha 55)
- `function EventBus:HasListeners(eventName: string)` (linha 72)
- `function EventBus:Count()` (linha 81)
- `function EventBus:Destroy()` (linha 91)

## `src/framework/runtime/LifecycleManager.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/runtime/LifecycleManager.lua

53 linhas · 1863 bytes · retorna `LifecycleManager`

**Propósito:** Máquina de estados de componente (Registered → Running → Stopped/Failed) com validação de transições.

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - LifecycleManager (6.11)
-- Gerencia ciclos de vida dos componentes com estados previsíveis
```

Funções:

- `function LifecycleManager.new(name)` (linha 19)
- `function LifecycleManager:SetState(newState, errorMessage)` (linha 29)
- `function LifecycleManager:GetState()` (linha 41)
- `function LifecycleManager:GetPreviousState()` (linha 42)
- `function LifecycleManager:GetError()` (linha 43)
- `function LifecycleManager:IsState(state)` (linha 44)
- `function LifecycleManager:Destroy()` (linha 46)

Tabelas/registros de topo:

- `LifecycleManager.States` (linha 8)

## `src/framework/runtime/Logger.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/runtime/Logger.lua

113 linhas · 3091 bytes · retorna `Logger`

**Propósito:** Logging com níveis DEBUG/INFO/WARN/ERROR e contexto de módulo; API de instância e estática, SetLevelMax e listeners On.

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - Logger
-- Logging com niveis DEBUG/INFO/WARN/ERROR e contexto de modulo.
-- levelMax = severidade MINIMA exibida (INFO oculta DEBUG). ERROR sempre aparece.
```

Funções:

- `function Logger.LevelName(level: number)` (linha 14)
- `function Logger.SetLevelMax(level: any)` (linha 21)
- `function Logger.RegisterModule(moduleName: string)` (linha 33)
- `function Logger.new(moduleName: string?)` (linha 40)
- `function Logger.On(callback: any)` (linha 46)
- `function Logger.WithTags(tags: any)` (linha 52)
- `local function formatMessage(message, ...)` (linha 56, local)
- `local function emit(level: number, module: string, msg: string)` (linha 61, local)
- `function Logger:Debug(message: string, ...)` (linha 70)
- `function Logger:Info(message: string, ...)` (linha 75)
- `function Logger:Warn(message: string, ...)` (linha 80)
- `function Logger:Error(message: string, ...)` (linha 85)
- `function Logger.LogError(err: any, context: string?)` (linha 91)
- `function Logger:Catch(err: any, context: string?)` (linha 98)
- `function Logger.ClearModules()` (linha 103)
- `function Logger:GetLevelMax()` (linha 108)

Tabelas/registros de topo:

- `Logger.Level` (linha 9)
- `Logger._modules` (linha 11)
- `Logger._listeners` (linha 12)

## `src/framework/runtime/ModuleRegistry.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/runtime/ModuleRegistry.lua

109 linhas · 3143 bytes · retorna `ModuleRegistry`

**Propósito:** Registro de módulos com dependências, detecção de ciclos (pilha de recursão), ordem topológica (GetInitOrder) e remoção em cascata.

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - ModuleRegistry
-- Registro de modulos com dependencias, detecao de ciclos e ordem topologica
```

Funções:

- `function ModuleRegistry.new()` (linha 8)
- `function ModuleRegistry:Register(name: string, module: any, dependencies: {string}?)` (linha 15)
- `function ModuleRegistry:Get(name: string)` (linha 27)
- `function ModuleRegistry:IsRegistered(name: string)` (linha 31)
- `function ModuleRegistry:ValidateDependencies(name: string)` (linha 35)
- `local function hasCycle(node)` (linha 45, local)
- `function ModuleRegistry:GetInitOrder()` (linha 62)
- `local function visit(moduleName)` (linha 65, local)
- `function ModuleRegistry:Remove(name: string)` (linha 77)
- `function ModuleRegistry:GetNames()` (linha 92)
- `function ModuleRegistry:CheckAllDependencies()` (linha 98)

## `src/framework/Server/CharacterManager.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/Server/CharacterManager.lua

133 linhas · 3911 bytes · retorna `CharacterManager`

**Propósito:** Helpers de personagem: tipo de rig, root part, vivo/morto, no chão (FloorMaterial), posição, direção de movimento, pulo, respawn (teleport) e pontos de interação; registro em _data.

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - CharacterManager
-- Registro e consulta de personagens (rig, root, estado, movimento)
```

Funções:

- `local function getHumanoid(character: Model)` (linha 9, local)
- `function CharacterManager.Init()` (linha 14)
- `function CharacterManager.Register(character: Model, config: any?)` (linha 16)
- `function CharacterManager._Setup(character: Model)` (linha 32)
- `function CharacterManager.Unregister(character: Model)` (linha 48)
- `function CharacterManager.GetData(character: Model)` (linha 52)
- `function CharacterManager.GetHumanoid(character: Model)` (linha 56)
- `function CharacterManager.DetectRigType(character: Model)` (linha 60)
- `function CharacterManager.GetRootPart(character: Model)` (linha 65)
- `function CharacterManager.IsAlive(character: Model)` (linha 70)
- `function CharacterManager.IsDead(character: Model)` (linha 75)
- `function CharacterManager.IsOnGround(character: Model)` (linha 80)
- `function CharacterManager.GetPosition(character: Model)` (linha 86)
- `function CharacterManager.GetMoveDirection(character: Model)` (linha 95)
- `function CharacterManager.Jump(character: Model)` (linha 104)
- `function CharacterManager.Respawn(character: Model, location: CFrame?)` (linha 111)
- `function CharacterManager.RegisterInteractionPoint(character: Model, point: BasePart, itype: string)` (linha 118)
- `function CharacterManager.GetInteractionPoints(character: Model, itype: string)` (linha 126)

Tabelas/registros de topo:

- `CharacterManager._data` (linha 7)

## `src/framework/Server/PermissionManager.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/Server/PermissionManager.lua

125 linhas · 3974 bytes · retorna `PermissionManager`

**Propósito:** Papéis e permissões por jogador (DefineRole/AssignRole/GrantPermission/HasPermission com wildcard '*'), CanExecuteOn, IsOwner (CreatorId/configurável); sem vazamento entre jogadores.

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - PermissionManager
-- Papéis (roles) e permissões por jogador, sem vazamento entre jogadores
```

Funções:

- `function PermissionManager.DefineRole(roleName: string, permissions: {string})` (linha 12)
- `function PermissionManager.AssignRole(player: Player, roleName: string)` (linha 18)
- `function PermissionManager.RemoveRole(player: Player, roleName: string)` (linha 34)
- `function PermissionManager.GrantPermission(player: Player, permission: string)` (linha 41)
- `function PermissionManager.RevokePermission(player: Player, permission: string)` (linha 50)
- `function PermissionManager.HasPermission(player: Player, permission: string)` (linha 55)
- `function PermissionManager.CanExecuteOn(executor: Player, target: Player, permission: string)` (linha 70)
- `function PermissionManager.GetPermissions(player: Player)` (linha 77)
- `function PermissionManager.GetRoles(player: Player)` (linha 94)
- `function PermissionManager.ListRoles()` (linha 102)
- `function PermissionManager.SetOwner(player: Player)` (linha 106)
- `function PermissionManager.IsOwner(player: Player)` (linha 110)
- `function PermissionManager.GetLevel(player: Player)` (linha 115)
- `function PermissionManager.Cleanup(player: Player)` (linha 119)

Tabelas/registros de topo:

- `PermissionManager._roles` (linha 7)
- `PermissionManager._playerRoles` (linha 8)
- `PermissionManager._playerPermissions` (linha 9)
- `PermissionManager._owners` (linha 10)

## `src/framework/Server/SecurityManager.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/Server/SecurityManager.lua

125 linhas · 3760 bytes · retorna `SecurityManager`

**Propósito:** Validação de operações do cliente, lista de admins configurável, validação de destino de teleport e rate limiting token-bucket (capacidade/refill configuráveis); log de auditoria.

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - SecurityManager
-- Validação de entrada, permissões de admin e rate limiting (token bucket)
```

Funções:

- `function RateLimiter.Configure(capacity: number, refillPerSecond: number)` (linha 12)
- `local function getBucket(player: Player)` (linha 17, local)
- `function RateLimiter.CanExecute(player: Player, cost: number?)` (linha 31)
- `function RateLimiter.Reset(player: Player)` (linha 41)
- `function SecurityManager.AllowOperation(operation: string, allowed: boolean?)` (linha 55)
- `function SecurityManager.SetAdmins(userIds: {number})` (linha 59)
- `function SecurityManager.AddAdmin(userId: number)` (linha 66)
- `function SecurityManager.HasAdminPermission(player: Player)` (linha 70)
- `function SecurityManager.SetTeleportBound(bound: number)` (linha 75)
- `function SecurityManager.ValidateClientOperation(player: Player, operation: string, args: any?)` (linha 79)
- `function SecurityManager.ValidateTeleport(player: Player, cframe: CFrame?)` (linha 99)
- `function SecurityManager.LogSuspiciousActivity(player: Player, operation: string, details: string?)` (linha 109)
- `function SecurityManager.ResetRateLimit(player: Player)` (linha 116)
- `function SecurityManager.Cleanup(player: Player)` (linha 120)

Tabelas/registros de topo:

- `RateLimiter._buckets` (linha 8)
- `SecurityManager._admins` (linha 46)
- `SecurityManager._allowedOperations` (linha 47)

## `src/framework/Shared/DataManager.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/Shared/DataManager.lua

126 linhas · 3678 bytes · retorna `DataManager`

**Propósito:** Persistência via DataStoreService com cache de sessão, chave estável por UserId, cache de stores e autosave (PlayerRemoving/BindToClose); Save/Load/Update/Remove e versionamento.

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - DataManager
-- Persistência via DataStore com cache de sessão, chave estável por UserId e autosave
```

Funções:

- `function DataManager.GetStore(name: string)` (linha 17)
- `local function playerStore()` (linha 25, local)
- `local function keyFor(player: Player, key: string?)` (linha 29, local)
- `function DataManager.Init()` (linha 33)
- `function DataManager.Load(player: Player, key: string?, default: any?)` (linha 49)
- `function DataManager.Save(player: Player, data: {[string]: any}, key: string?)` (linha 67)
- `function DataManager.Update(player: Player, transform: (any) -> any, key: string?)` (linha 85)
- `function DataManager.Remove(player: Player, key: string?)` (linha 96)
- `function DataManager.Flush(player: Player)` (linha 105)
- `function DataManager.GetVersion(player: Player, key: string?)` (linha 112)
- `function DataManager.SetVersion(player: Player, version: any, key: string?)` (linha 117)
- `function DataManager.ClearCache(player: Player)` (linha 121)

Tabelas/registros de topo:

- `DataManager._stores` (linha 11)
- `DataManager._cache` (linha 12)
- `DataManager._connections` (linha 14)

## `src/framework/Shared/NetworkingManager.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/Shared/NetworkingManager.lua

134 linhas · 4107 bytes · retorna `NetworkingManager`

**Propósito:** Wrapper de RemoteEvent/RemoteFunction com criação automática em ReplicatedStorage.VessieNetwork; servidor (OnServerEvent/SetCallback/FireClient/FireAllClients) e cliente (OnClientEvent/FireServer/InvokeServer) com limpeza de conexões.

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - NetworkingManager
-- Wrapper de RemoteEvent/RemoteFunction com criação automática e limpeza de conexões
```

Funções:

- `local function getFolder()` (linha 14, local)
- `local function getRemote(name: string, className: string)` (linha 28, local)
- `function NetworkingManager.GetEvent(name: string)` (linha 49)
- `function NetworkingManager.GetFunction(name: string)` (linha 55)
- `local function track(connection: RBXScriptConnection)` (linha 61, local)
- `function NetworkingManager.OnServerEvent(name: string, callback: (Player, ...any) -> ())` (linha 67)
- `function NetworkingManager.SetCallback(name: string, callback: (Player, ...any) -> ...any)` (linha 73)
- `function NetworkingManager.FireClient(name: string, player: Player, ...)` (linha 80)
- `function NetworkingManager.FireAllClients(name: string, ...)` (linha 87)
- `function NetworkingManager.OnClientEvent(name: string, callback: (...any) -> ())` (linha 95)
- `function NetworkingManager.FireServer(name: string, ...)` (linha 101)
- `function NetworkingManager.InvokeServer(name: string, ...)` (linha 108)
- `function NetworkingManager.DisconnectAll()` (linha 114)
- `function NetworkingManager.Destroy()` (linha 121)

Tabelas/registros de topo:

- `NetworkingManager._remotes` (linha 11)
- `NetworkingManager._connections` (linha 12)

## `src/framework/utils/CollectionUtils.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/utils/CollectionUtils.lua

207 linhas · 4108 bytes · retorna `CollectionUtils`

**Propósito:** Fábricas de estruturas de dados (fila, pilha, conjunto, tabela ordenada) e helpers de deduplicação/comparação em Luau válido.

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - CollectionUtils
-- Estruturas de dados: filas, pilhas, conjuntos, tabelas ordenadas
```

Funções:

- `function CollectionUtils.Queue()` (linha 8)
- `function obj:Enqueue(item: any)` (linha 13)
- `function obj:Dequeue()` (linha 19)
- `function obj:Peek()` (linha 27)
- `function obj:IsEmpty()` (linha 32)
- `function obj:Size()` (linha 36)
- `function CollectionUtils.Stack()` (linha 44)
- `function obj:Push(item: any)` (linha 49)
- `function obj:Pop()` (linha 55)
- `function obj:Peek()` (linha 63)
- `function obj:IsEmpty()` (linha 68)
- `function obj:Size()` (linha 72)
- `function CollectionUtils.Set()` (linha 80)
- `function obj:Add(value: any)` (linha 85)
- `function obj:Remove(value: any)` (linha 92)
- `function obj:Has(value: any)` (linha 101)
- `function obj:Size()` (linha 105)
- `function obj:IsEmpty()` (linha 109)
- `function obj:ToList()` (linha 113)
- `function obj:Union(other: {[any]: boolean})` (linha 119)
- `function obj:Intersect(other: {[any]: boolean})` (linha 126)
- `function CollectionUtils.SortedTable(compare: (any, any) -> boolean)` (linha 138)
- `function obj:Insert(value: any)` (linha 142)
- `function obj:Remove(value: any)` (linha 151)
- `function obj:Get(index: number)` (linha 158)
- `function obj:Size()` (linha 162)
- `function obj:IsEmpty()` (linha 166)
- `function obj:Iterator()` (linha 170)
- `function CollectionUtils.Deduplicate(list: {any})` (linha 182)
- `function CollectionUtils.SameElements(a: {any}, b: {any})` (linha 195)

## `src/framework/utils/InstanceUtils.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/utils/InstanceUtils.lua

58 linhas · 1961 bytes · retorna `InstanceUtils`

**Propósito:** Helpers seguros para instâncias Roblox: busca (IsA/filtro de classe), criação validada, propriedades, destruição segura e CFrame a partir de posição/rotação.

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - InstanceUtils
-- Utilitarios seguros para instancias do Roblox
```

Funções:

- `function InstanceUtils.FindFirstChildSafe(parent: Instance, name: string, className: string?)` (linha 7)
- `function InstanceUtils.CreateWithValidation(className: string, properties: {[string]: any})` (linha 14)
- `function InstanceUtils.SetProperties(inst: Instance, properties: {[string]: any})` (linha 25)
- `function InstanceUtils.DestroySafe(inst: Instance?)` (linha 35)
- `function InstanceUtils.IsClass(instance: Instance, className: string)` (linha 42)
- `function InstanceUtils.CFrameFromPositionRotation(position: any, euler: any)` (linha 47)

## `src/framework/utils/MathUtils.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/utils/MathUtils.lua

76 linhas · 2141 bytes · retorna `MathUtils`

**Propósito:** Matemática de vetores e CFrame: lerp, clamp, distância, projeção, lookAt, RotateVector, AngleBetween e conversões euler (fromEulerAnglesXYZ/ToEulerAnglesXYZ).

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - MathUtils
-- Utilitarios matematicos: vetores, CFrame, geometria
```

Funções:

- `function MathUtils.Lerp(a: any, b: any, t: number)` (linha 7)
- `function MathUtils.ClampVec(v: Vector3, min: Vector3, max: Vector3)` (linha 18)
- `function MathUtils.Normalize(v: Vector3)` (linha 26)
- `function MathUtils.Distance(a: Vector3, b: Vector3)` (linha 32)
- `function MathUtils.AngleBetween(a: Vector3, b: Vector3)` (linha 36)
- `function MathUtils.ProjectOnPlane(v: Vector3, planeNormal: Vector3)` (linha 43)
- `function MathUtils.LookAt(from: Vector3, to: Vector3)` (linha 48)
- `function MathUtils.EulerToCFrame(pitch: number, yaw: number, roll: number)` (linha 53)
- `function MathUtils.CFrameToEuler(cframe: CFrame)` (linha 58)
- `function MathUtils.RotateVector(v: Vector3, c: CFrame)` (linha 64)
- `function MathUtils.ProjectAOnB(a: Vector3, b: Vector3)` (linha 68)

## `src/framework/utils/NumberUtils.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/utils/NumberUtils.lua

58 linhas · 1866 bytes · retorna `NumberUtils`

**Propósito:** Utilitários numéricos puros: clamp, lerp, round, mapeamento, wrap, graus/radianos, IsFinite e random inteiro.

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - NumberUtils
-- Utilitários numéricos: clamp, lerp, arredondamento, aproximação
```

Funções:

- `function NumberUtils.Clamp(value: number, min: number, max: number)` (linha 7)
- `function NumberUtils.Lerp(a: number, b: number, t: number)` (linha 11)
- `function NumberUtils.Round(value: number, decimals: number?)` (linha 15)
- `function NumberUtils.IsFinite(value: number)` (linha 21)
- `function NumberUtils.Approximately(a: number, b: number, tolerance: number?)` (linha 25)
- `function NumberUtils.RadiansToDegrees(radians: number)` (linha 29)
- `function NumberUtils.DegreesToRadians(degrees: number)` (linha 33)
- `function NumberUtils.Random(min: number, max: number, isInteger: boolean?)` (linha 37)
- `function NumberUtils.Map(value: number, inMin: number, inMax: number, outMin: number, outMax: number)` (linha 44)
- `function NumberUtils.Wrap(value: number, min: number, max: number, cycleLength: number?)` (linha 49)

## `src/framework/utils/StringUtils.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/utils/StringUtils.lua

96 linhas · 2425 bytes · retorna `StringUtils`

**Propósito:** Manipulação e validação de strings: trim, split/join, starts/ends with, format, validações (email/número) e geração de IDs hex.

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - StringUtils
-- Utilitarios para strings: formatacao, validacao, manipulacao
```

Funções:

- `function StringUtils.Trim(s: string)` (linha 7)
- `function StringUtils.Split(s: string, delimiter: string, plain: boolean?)` (linha 11)
- `function StringUtils.Join(t: {string}, separator: string?)` (linha 31)
- `function StringUtils.StartsWith(s: string, prefix: string)` (linha 35)
- `function StringUtils.EndsWith(s: string, suffix: string)` (linha 39)
- `function StringUtils.Capitalize(s: string)` (linha 43)
- `function StringUtils.Upper(s: string)` (linha 48)
- `function StringUtils.Lower(s: string)` (linha 52)
- `function StringUtils.Format(format: string, ...)` (linha 56)
- `function StringUtils.IsEmail(email: string)` (linha 60)
- `function StringUtils.IsNumber(s: string)` (linha 64)
- `function StringUtils.Truncate(s: string, maxLen: number, suffix: string?)` (linha 68)
- `function StringUtils.Alphanumeric(s: string)` (linha 76)
- `function StringUtils.GenerateId()` (linha 80)
- `function StringUtils.EscapePattern(s: string)` (linha 91)

## `src/framework/utils/TableUtils.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/framework/utils/TableUtils.lua

87 linhas · 2050 bytes · retorna `TableUtils`

**Propósito:** Utilitários de tabelas: cópia rasa/profunda (cycle-safe), merge, filter/find, contagem, keys/values e comparação IsEqual (cycle-safe).

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - TableUtils
-- Utilitários básicos para tabelas (cópia, merge, busca, comparação profunda)
```

Funções:

- `function TableUtils.ShallowCopy(t)` (linha 7)
- `function TableUtils.DeepCopy(t, seen)` (linha 14)
- `function TableUtils.Merge(target, source)` (linha 26)
- `function TableUtils.Filter(t, keys)` (linha 32)
- `function TableUtils.Find(t, predicate)` (linha 40)
- `function TableUtils.Count(t, predicate)` (linha 47)
- `function TableUtils.IsEmpty(t)` (linha 55)
- `function TableUtils.GetKeys(t)` (linha 59)
- `function TableUtils.GetValues(t)` (linha 65)
- `function TableUtils.IsEqual(t1, t2, seen)` (linha 72)

## `src/jogo.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/jogo.lua

286 linhas · 9925 bytes · retorna `Jogo`

**Propósito:** Manipulação e modificação da base do jogo: referências de jogadores/personagem, teleport, voo (BodyVelocity), ferramentas/itens, silenciar sons com restauração, eventos; utilitários de conteúdo obterFPS, definirIluminacao (restaurável), definirTempo, modificarParte (allowlist de propriedades), limparConteudo, ancorarPartes e otimizarGraficos (snapshot restaurável).

Cabeçalho do arquivo:

```lua
--[[
Módulo de Manipulação de Jogo - Vessie Script Executor
Referências de jogadores/personagem, teleport, voo, itens, sons e eventos.
--]]
```

Funções:

- `function Jogo:inicializar()` (linha 16)
- `function Jogo:adicionarEvento(nome, callback)` (linha 48)
- `function Jogo:dispararEvento(nome, ...)` (linha 60)
- `function Jogo:obterJogador(nomeOuUsuario)` (linha 69)
- `function Jogo:teleportar(destino, tipo)` (linha 79)
- `function Jogo:criarModoVoo(ativo)` (linha 97)
- `function Jogo:obterFerramenta(nome)` (linha 121)
- `function Jogo:darItem(nomeItem, quantidade)` (linha 127)
- `function Jogo:silenciarSons(ativo)` (linha 138)
- `function Jogo:espelharPersonagem(ativo)` (linha 156)
- `function Jogo:obterFPS()` (linha 166)
- `function Jogo:definirIluminacao(props)` (linha 181)
- `function Jogo:definirTempo(hora)` (linha 194)
- `function Jogo:modificarParte(parte, props)` (linha 202)
- `function Jogo:limparConteudo(alvo)` (linha 221)
- `function Jogo:ancorarPartes(alvo, ativo)` (linha 240)
- `function Jogo:otimizarGraficos(ativo)` (linha 255)

Tabelas/registros de topo:

- `Jogo.jogadores` (linha 9)

## `src/memoria.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/memoria.lua

89 linhas · 2685 bytes · retorna `Memoria`

**Propósito:** Leitura/escrita de memória do client via API do executor (readmemory/writememory) com cache, pattern scanning (placeholder), listarEnderecos e limparCache.

Cabeçalho do arquivo:

```lua
--[[
Módulo de Memória - Vessie Script Executor
Leitura/escrita de memória do client. Usa a API do executor quando disponível
(readmemory/writememory); caso contrário, opera como cache simulado (placeholder).
--]]
```

Funções:

- `local function apiLeitura()` (linha 11, local)
- `local function apiEscrita()` (linha 15, local)
- `function Memoria:ler(endereco, tipo)` (linha 19)
- `function Memoria:escrever(endereco, valor, tipo)` (linha 38)
- `function Memoria:buscarPatron(enderecoInicio, fim, patron, mascara)` (linha 56)
- `function Memoria:proteger(endereco, tamanho, novoStatus)` (linha 66)
- `function Memoria:getEnderecoGlobal(nomeObjeto, offset)` (linha 71)
- `function Memoria:listarEnderecos()` (linha 76)
- `function Memoria:limparCache()` (linha 84)

## `src/neural/ativacoes.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/neural/ativacoes.lua

111 linhas · 3700 bytes · retorna `Ativacoes`

**Propósito:** Funções de ativação e perda: linear, sigmoid (estável), tanh, relu, leakyRelu, softmax (aplicar+derivada); perda mse/crossentropy e gradienteSaida (atalho softmax/crossentropy -> saida-alvo).

Cabeçalho do arquivo:

```lua
--[[
Rede Neural - Funcoes de ativacao e de perda (Lua 5.1+)
derivada(nome, z, a) retorna f'(z) elemento a elemento (usa a quando conveniente).
softmax nao tem derivada elementwise: o gradiente de saida e tratado em gradienteSaida.
--]]
```

Funções:

- `local function map(v, fn)` (linha 9, local)
- `local function sigmoid(x)` (linha 15, local)
- `aplicar = function(z)` (linha 25)
- `derivada = function(z)` (linha 26)
- `aplicar = function(z)` (linha 29)
- `derivada = function(z, a)` (linha 30)
- `aplicar = function(z)` (linha 33)
- `derivada = function(z, a)` (linha 34)
- `aplicar = function(z)` (linha 37)
- `derivada = function(z)` (linha 38)
- `aplicar = function(z)` (linha 41)
- `derivada = function(z)` (linha 42)
- `aplicar = function(z)` (linha 45)
- `function Ativacoes.existe(nome)` (linha 56)
- `function Ativacoes.ativar(nome, z)` (linha 60)
- `function Ativacoes.derivada(nome, z, a)` (linha 66)
- `function Ativacoes.perda(nome, saida, alvo)` (linha 73)
- `function Ativacoes.gradienteSaida(nome, ativacao, saida, alvo, z)` (linha 88)

Tabelas/registros de topo:

- `Ativacoes.funcoes` (linha 23)

## `src/neural/camadas.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/neural/camadas.lua

53 linhas · 1481 bytes · retorna `Camadas`

**Propósito:** Camada densa (dense) com init Xavier (sqrt(1/entradas)); forward guarda _x/_z/_a, backward calcula _dW=outer(dz,_x)/_db=dz e retorna dL/dx, atualizar aplica SGD in-place (W-=taxa*dW).

Cabeçalho do arquivo:

```lua
--[[
Rede Neural - Camada densa (fully connected) com forward/backward (Lua 5.1+)
W e (saidas x entradas); forward guarda _x/_z/_a; backward guarda _dW/_db.
--]]
```

Funções:

- `function Camadas.dense(entradas, saidas, ativacao)` (linha 11)
- `function Camadas.forward(camada, x)` (linha 24)
- `function Camadas.backward(camada, dz)` (linha 35)
- `function Camadas.atualizar(camada, taxa)` (linha 43)

## `src/neural/init.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/neural/init.lua

173 linhas · 5524 bytes · retorna `Neural`

**Propósito:** Rede neural MLP completa (Lua 5.1+): classe Neural com camada densa encadeável, forward/backprop, SGD (treinar com épocas/taxa/perda/embaralhar/callback), prever/classificar, avaliar (perda+acurácia), serializar/salvar/carregar e fábricas criar/deDados; expõe matriz/ativacoes/camadas/serializacao.

Cabeçalho do arquivo:

```lua
--[[
Rede Neural - Base completa (Lua 5.1+, sem dependencias externas)
MLP (perceptron multicamadas) com backpropagation e SGD.

Uso:
local Neural = require("src.neural")
local rede = Neural.nova()
rede:camada(2, 4, "tanh"):camada(4, 1, "sigmoid")
local dados = {
{ entrada = {0,0}, alvo = {0} }, { entrada = {0,1}, alvo = {1} },
{ entrada = {1,0}, alvo = {1} }, { entrada = {1,1}, alvo = {0} },
}
rede:treinar(dados, { epocas = 2000, taxaAprendizado = 0.5, perda = "mse" })
print(rede:prever({1,0})[1])
rede:salvar("modelo.json")
--]]
```

Funções:

- `function Neural.nova()` (linha 30)
- `function Neural:camada(entradas, saidas, ativacao)` (linha 34)
- `function Neural:forward(entrada)` (linha 39)
- `function Neural:prever(entrada)` (linha 50)
- `function Neural:classificar(entrada)` (linha 54)
- `function Neural:backward(alvo, perda)` (linha 58)
- `function Neural:atualizar(taxa)` (linha 77)
- `function Neural:treinar(dados, opcoes)` (linha 81)
- `function Neural:avaliar(dados, perda)` (linha 113)
- `function Neural:serializar()` (linha 125)
- `function Neural:salvar(caminho)` (linha 136)
- `function Neural.criar(config)` (linha 141)
- `function Neural.deDados(dados)` (linha 151)
- `function Neural.carregar(caminho)` (linha 166)

## `src/neural/matriz.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/neural/matriz.lua

109 linhas · 2205 bytes · retorna `Matriz`

**Propósito:** Álgebra linear pura para a rede neural: zeros/zeros2d/random2d (Xavier), copia profunda, dot, matVec, transposta, soma/sub/escala/mul (Hadamard), outer, map e argmax; vetores são arrays e matrizes são arrays de linhas.

Cabeçalho do arquivo:

```lua
--[[
Rede Neural - Algebra linear (Lua 5.1+, sem dependencias)
Vetores = arrays {1..n}; matrizes = arrays de linhas {1..l}{1..c}.
--]]
```

Funções:

- `function Matriz.zeros(n)` (linha 8)
- `function Matriz.zeros2d(linhas, colunas)` (linha 14)
- `function Matriz.random2d(linhas, colunas, escala)` (linha 20)
- `function Matriz.copia(a)` (linha 30)
- `function Matriz.dot(a, b)` (linha 37)
- `function Matriz.matVec(W, x)` (linha 44)
- `function Matriz.transposta(W)` (linha 50)
- `function Matriz.soma(a, b)` (linha 59)
- `function Matriz.sub(a, b)` (linha 65)
- `function Matriz.escala(a, s)` (linha 71)
- `function Matriz.mul(a, b)` (linha 78)
- `function Matriz.outer(a, b)` (linha 85)
- `function Matriz.map(a, fn)` (linha 94)
- `function Matriz.argmax(v)` (linha 100)

## `src/neural/serializacao.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/neural/serializacao.lua

187 linhas · 6014 bytes · retorna `Serializacao`

**Propósito:** JSON próprio (encode/decode recursivo, números %.17g, escape de strings via string.char sem literais de barra), paraJSON/deJSON e salvar/carregar via writefile/readfile do executor (pcall); round-trip fiel dos pesos.

Cabeçalho do arquivo:

```lua
--[[
Rede Neural - Serializacao JSON e persistencia (Lua 5.1+, sem dependencias)
JSON proprio para portabilidade; salvar/carregar usam writefile/readfile do executor.
--]]
```

Funções:

- `local function isArray(t)` (linha 9, local)
- `local function escapeStr(s)` (linha 18, local)
- `encode = function(v)` (linha 37)
- `local function decode(str)` (linha 59, local)
- `local function skip()` (linha 62, local)
- `local function parseString()` (linha 68, local)
- `local function parseNumero()` (linha 92, local)
- `local function parseArray()` (linha 101, local)
- `local function parseObject()` (linha 116, local)
- `parseValor = function()` (linha 136)
- `function Serializacao.paraJSON(tabela)` (linha 152)
- `function Serializacao.deJSON(texto)` (linha 156)
- `function Serializacao.salvar(tabela, caminho)` (linha 161)
- `function Serializacao.carregar(caminho)` (linha 173)

## `src/ui.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/ui.lua

146 linhas · 5075 bytes · retorna `UI`

**Propósito:** Criação de UI do executor: ScreenGui, frames arrastáveis, botões, toggles, caixas de texto, rótulos e listas roláveis (UIListLayout + AutomaticCanvasSize).

Cabeçalho do arquivo:

```lua
--[[
Módulo de Interface - Vessie Script Executor
Criação de UIs e menus para o executor (ScreenGui, frames, botões, toggles, etc.)
--]]
```

Funções:

- `function UI:criarGui(nome, pais)` (linha 8)
- `function UI:criarFrame(gui, titulo, posicao, tamanho, corFundo)` (linha 18)
- `function UI:criarBotao(frame, texto, posicao, tamanho, cor, callback)` (linha 46)
- `function UI:criarToggle(frame, texto, posicao, ligadoInicial)` (linha 64)
- `function UI:criarCaixaTexto(frame, textoPlaceholder, posicao, tamanho)` (linha 76)
- `function UI:criarRotulo(frame, texto, posicao, tamanho, corTexto)` (linha 90)
- `function UI:criarLista(frame, posicao, tamanho)` (linha 103)
- `function UI:adicionarItemLista(scrollFrame, texto, callback)` (linha 120)
- `function UI:removerGui(nome)` (linha 133)

## `src/utils.lua`

**Raw:** https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/utils.lua

548 linhas · 19468 bytes · retorna `Utils`

**Propósito:** 22 comandos prontos em Utils.comandos: fly, speed, noclip, godmode, esp, verificar, antiafk, teleport, fullbright, gravity, reset, sit, jump, hipheight, fov + otimização/modificação (otimizar, removerefeitos, notextures, nofog, daytime, antivoid, fps); toggles restauram estado original, rastreamento de conexões/desconectar, listarComandos ordenado e Utils:executar.

Cabeçalho do arquivo:

```lua
--[[
Módulo de Utilitários - Vessie Script Executor
Comandos prontos de jogo em Utils.comandos.<nome> = { nome, descricao, funcao }.
Comandos de toggle gerenciam suas conexões em Utils._conexoes (sem leaks).
--]]
```

Funções:

- `local function personagem()` (linha 11, local)
- `local function humanoid()` (linha 15, local)
- `local function root()` (linha 20, local)
- `local function desconectar(nome)` (linha 25, local)
- `funcao = function(ativo)` (linha 35)
- `funcao = function(velocidade)` (linha 60)
- `funcao = function(ativo)` (linha 72)
- `funcao = function(ativo)` (linha 96)
- `funcao = function(acao)` (linha 117)
- `funcao = function()` (linha 164)
- `funcao = function(ativo)` (linha 175)
- `funcao = function(alvo)` (linha 199)
- `funcao = function(ativo)` (linha 222)
- `funcao = function(valor)` (linha 243)
- `funcao = function()` (linha 253)
- `funcao = function(ativo)` (linha 264)
- `funcao = function(valor)` (linha 275)
- `funcao = function(valor)` (linha 288)
- `funcao = function(valor)` (linha 299)
- `local function ehEfeito(obj)` (linha 307, local)
- `local function ehTextura(obj)` (linha 312, local)
- `funcao = function(ativo)` (linha 319)
- `funcao = function(ativo)` (linha 385)
- `funcao = function(ativo)` (linha 416)
- `funcao = function(ativo)` (linha 447)
- `funcao = function(hora)` (linha 473)
- `funcao = function(ativo, limite)` (linha 486)
- `funcao = function()` (linha 515)
- `function Utils:listarComandos()` (linha 535)
- `function Utils:executar(nome, ...)` (linha 542)

Tabelas/registros de topo:

- `Utils.comandos` (linha 8)
- `Utils._conexoes` (linha 9)
- `Utils.comandos.fly` (linha 32)
- `Utils.comandos.speed` (linha 57)
- `Utils.comandos.noclip` (linha 69)
- `Utils.comandos.godmode` (linha 93)
- `Utils.comandos.esp` (linha 114)
- `Utils.comandos.verificar` (linha 161)
- `Utils.comandos.antiafk` (linha 172)
- `Utils.comandos.teleport` (linha 196)
- `Utils.comandos.fullbright` (linha 219)
- `Utils.comandos.gravity` (linha 240)
- `Utils.comandos.reset` (linha 250)
- `Utils.comandos.sit` (linha 261)
- `Utils.comandos.jump` (linha 272)
- `Utils.comandos.hipheight` (linha 285)
- `Utils.comandos.fov` (linha 296)
- `Utils.comandos.otimizar` (linha 316)
- `Utils.comandos.removerefeitos` (linha 382)
- `Utils.comandos.notextures` (linha 413)
- `Utils.comandos.nofog` (linha 444)
- `Utils.comandos.daytime` (linha 470)
- `Utils.comandos.antivoid` (linha 483)
- `Utils.comandos.fps` (linha 512)
