# Contexto do repositório para IA

> Gerado automaticamente por `tools/gerar-contexto.mjs` em 2026-11-08T20:25:56.672Z.
> Não edite manualmente: altere `tools/descricoes-modulos.json` e rode `node tools/gerar-contexto.mjs`.

Total: **32 scripts Lua**. Versão machine-readable: `docs/contexto.json`.

Para entender um módulo em profundidade, leia o arquivo fonte indicado em cada seção.

## `main.lua`

95 linhas · 2704 bytes · retorna `Library`

**Propósito:** Ponto de entrada da biblioteca: carrega os módulos de src/ via require("src.<nome>"), inicializa cada um e expõe executarComando, getMemoria, setMemoria e adicionarEvento.

Cabeçalho do arquivo:

```lua
--[[
Roblox Executor Library - Core Module
Versão: 1.0.0
Desenvolvido para executores: Xeno, Delta, Mobile Executors
Funciona no client local sem emuladores
--]]
```

Funções:

- `function Library:carregarModulo(nome)` (linha 19)
- `function Library:inicializar()` (linha 36)
- `function Library:executarComando(comando, ...)` (linha 58)
- `function Library:getMemoria(endereco)` (linha 68)
- `function Library:setMemoria(endereco, valor)` (linha 77)
- `function Library:adicionarEvento(nome, callback)` (linha 86)

## `src/apis/apis.lua`

127 linhas · 3673 bytes · retorna `API`

**Propósito:** Integração externa e informações: webhooks/HTTP (placeholders), info do executor/jogador/jogo, callbacks e conversão JSON via HttpService.

Cabeçalho do arquivo:

```lua
--[[
Módulo de APIs - Roblox Executor Library
Funções de API para integração e informações externas
--]]
```

Funções:

- `function API:enviarWebhook(url, dados, metodo)` (linha 12)
- `function API:requisicaoGET(url)` (linha 26)
- `function API:requisicaoPOST(url, dados)` (linha 33)
- `function API:baixarArquivo(url, caminhoLocal)` (linha 40)
- `function API:obterInfoExecutor()` (linha 47)
- `function API:obterInfoJogador(jogador)` (linha 59)
- `function API:obterInfoJogo()` (linha 76)
- `function API:registrarCallback(evento, callback)` (linha 90)
- `function API:dispararCallback(evento, ...)` (linha 100)

## `src/command_dispatcher.lua`

73 linhas · 2024 bytes · retorna `M`

**Propósito:** Registro e despacho de handlers de comando da Public API, com execução protegida (pcall/xpcall) e modo seguro.

Cabeçalho do arquivo:

```lua
-- Command Dispatcher for Public API
-- Responsavel por dispatcher de comandos recebidos via remote events
-- Compatibilidade: Lua 5.1/5.2/5.3/5.4
```

Funções:

- `function M.register_handler(command_name, handler_func)` (linha 11)
- `function M.get_handler(command_name)` (linha 23)
- `function M.dispatch(command_name, args)` (linha 29)
- `function function_list()` (linha 59)
- `function M.set_secure(secure)` (linha 68)

## `src/framework/Client/Players/PlayerManager.lua`

176 linhas · 5807 bytes · retorna `PlayerManager`

**Propósito:** Rastreia jogadores e personagens com dados por jogador e BindableEvents internos; incompleto (erro de sintaxe e player.PlayerRemoving inexistente).

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - PlayerManager (7)
-- Gerencia jogadores, entrada, carregamento de personagens e respawns
```

Funções:

- `function PlayerManager.Init()` (linha 22)
- `function PlayerManager.OnPlayerAdded(player: Player)` (linha 32)
- `function PlayerManager.OnPlayerRemoving(player: Player)` (linha 72)
- `function PlayerManager.GetCharacter(player: Player)` (linha 80)
- `function PlayerManager.GetData(player: Player, key: string?)` (linha 98)
- `function PlayerManager.SetData(player: Player, key: string, value: any)` (linha 109)
- `function PlayerManager.HasCharacter(player: Player)` (linha 119)
- `function PlayerManager.GetLastPosition(player: Player)` (linha 127)
- `function PlayerManager.SetLastPosition(player: Player, position: Vector3)` (linha 146)
- `function PlayerManager.On(eventName: string, callback: ...)` (linha 156)
- `function PlayerManager.Cleanup(player: Player)` (linha 167)

Tabelas/registros de topo:

- `PlayerManager.Events` (linha 13)

## `src/framework/Client/UI/NotificationManager.lua`

144 linhas · 4750 bytes · retorna `NotificationManager`

**Propósito:** Notificações UI animadas com fila; incompleto (faltam end/return, _ProcessQueue indefinido, usa ThemeManager como global).

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - Notification System
-- Sistema de notificações com fila, duração configurável
```

Funções:

- `function NotificationManager._EnsureContainer()` (linha 19)
- `function NotificationManager.Show(title: string, text: string, duration: number?, type: string?)` (linha 52)

## `src/framework/Client/UI/ThemeManager.lua`

110 linhas · 3210 bytes · retorna `ThemeManager`

**Propósito:** Temas Light/Dark com cores, fontes, espaçamento e border radius; ApplyCustomTheme muta o tema Light.

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - ThemeManager
-- Gerenciamento de tema: cores, tipografia, espaçamento
```

Funções:

- `function ThemeManager.GetColor(key: string)` (linha 47)
- `function ThemeManager.SetTheme(themeName: string)` (linha 57)
- `function ThemeManager.GetFont()` (linha 67)
- `function ThemeManager.GetFontSize()` (linha 75)
- `function ThemeManager.GetSpacing(size: string)` (linha 82)
- `function ThemeManager.GetBorderRadius()` (linha 93)
- `function ThemeManager.ApplyCustomTheme(customTheme: {}?)` (linha 99)

Tabelas/registros de topo:

- `ThemeManager.Themes` (linha 8)

## `src/framework/CollectionUtils.lua`

250 linhas · 6039 bytes · retorna `CollectionUtils`

**Propósito:** Fábricas de estruturas de dados (fila, pilha, conjunto, tabela ordenada) e helpers de deduplicação/comparação. Contém sintaxe genérica <T> inválida em Luau.

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - CollectionUtils (6.6)
-- Estruturas de dados: filas, pilhas, conjuntos, tabelas ordenadas
```

Funções:

- `function _internal:Enqueue(item: T)` (linha 14)
- `function _internal:Dequeue()` (linha 20)
- `function _internal:Peek()` (linha 28)
- `function _internal:IsEmpty()` (linha 33)
- `function _internal:Size()` (linha 37)
- `function _internal:Push(item: T)` (linha 50)
- `function _internal:Pop()` (linha 56)
- `function _internal:Peek()` (linha 64)
- `function _internal:IsEmpty()` (linha 69)
- `function _internal:Size()` (linha 73)
- `function _internal:Add(value: T)` (linha 86)
- `function _internal:Remove(value: T)` (linha 95)
- `function _internal:Has(value: T)` (linha 110)
- `function _internal:Size()` (linha 114)
- `function _internal:IsEmpty()` (linha 118)
- `function _internal:Union(other: {[T]: boolean})` (linha 122)
- `function _internal:Intersect(other: {[T]: boolean])` (linha 130)
- `function _internal:Insert(value: T)` (linha 150)
- `function _internal:Remove(value: T)` (linha 169)
- `function _internal:Get(index: number)` (linha 182)
- `function _internal:Size()` (linha 187)
- `function _internal:IsEmpty()` (linha 191)
- `function _internal:Iterator()` (linha 195)

## `src/framework/ConfigManager.lua`

180 linhas · 5709 bytes · retorna `ConfigManager`

**Propósito:** Classe de configurações com defaults, overrides, campos readonly e níveis de acesso (bloqueia ServerOnly no cliente via RunService).

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - ConfigManager (6.12)
-- Gerencia configurações com valores padrão, validação e persistência
```

Funções:

- `function ConfigManager.new(configTable: table)` (linha 18)
- `function ConfigManager:Set(key: string, value: any, access: string?, readonly: boolean?)` (linha 32)
- `function ConfigManager:Get(key: string, default: any)` (linha 57)
- `function ConfigManager:SetDefault(key: string, default: any, access: string?)` (linha 72)
- `function ConfigManager:SetReadOnly(key: string, value: any)` (linha 82)
- `function ConfigManager:Exists(key: string)` (linha 92)
- `function ConfigManager:Remove(key: string)` (linha 100)
- `function ConfigManager:Override(key: string, value: any)` (linha 111)
- `function ConfigManager:GetKeys()` (linha 119)
- `function ConfigManager:GetReadWriteKeys()` (linha 132)
- `function ConfigManager:ValidateRequired(required: {string})` (linha 146)
- `function ConfigManager:Export()` (linha 159)
- `function ConfigManager:Import(importedTable: table)` (linha 172)

Tabelas/registros de topo:

- `ConfigManager.Access` (linha 9)

## `src/framework/EventBus.lua`

133 linhas · 4488 bytes · retorna `EventBus`

**Propósito:** Pub/sub por nome (On/Once/Off/Emit), mas incompleto/não funcional: usa RBXScriptSignal.new() inexistente e Emit não invoca callbacks.

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - EventBus (6.9)
-- Sistema de EventBus reutilizável, diferenciado dos eventos nativos do Roblox
-- Utiliza RBXScriptConnection para gerenciar conexões
```

Funções:

- `function EventBus.new()` (linha 11)
- `function EventBus:On(eventName: string, callback: any)` (linha 21)
- `function EventBus:Once(eventName: string, callback: any)` (linha 41)
- `local function onceFunc(...: any)` (linha 42, local)
- `function EventBus:Off(eventName: string?, connection: RBXScriptConnection?)` (linha 53)
- `function EventBus:Clear(eventName: string)` (linha 78)
- `function EventBus:Emit(eventName: string, ...: any)` (linha 88)
- `function EventBus:HasListeners(eventName: string)` (linha 100)
- `function EventBus:Destroy()` (linha 105)
- `function EventBus:Count()` (linha 118)

## `src/framework/Framework.lua`

139 linhas · 3108 bytes · retorna `Framework`

**Propósito:** Núcleo do framework: registro de módulos (Register/Get), ciclo de vida Init → Start → Cleanup e Maid para limpeza de conexões/instances.

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - Core Module
-- Módulo núcleo responsável pela inicialização, registro e gerenciamento do framework
```

Funções:

- `function Maid.new()` (linha 14)
- `function Maid:GiveTask(task: () -> (), name: string?)` (linha 18)
- `function Maid:DoCleaning()` (linha 22)
- `function Maid:Destroy()` (linha 47)
- `function Framework.Register(name: string, module: any)` (linha 53)
- `function Framework.Get(name: string)` (linha 75)
- `function Framework.Start()` (linha 79)
- `function Framework.Stop()` (linha 108)
- `function Framework.IsInitialized()` (linha 127)
- `function Framework.GetModules()` (linha 131)

## `src/framework/InstanceUtils.lua`

55 linhas · 1932 bytes · retorna `InstanceUtils`

**Propósito:** Helpers seguros para instâncias Roblox: busca, criação validada, propriedades, destruição segura e CFrame a partir de posição/rotação.

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - InstanceUtils (6.4)
-- Utilitários básicos para instâncias do Roblox
```

Funções:

- `function InstanceUtils.FindFirstChildSafe(parent: Instance, name: string, className: string?)` (linha 7)
- `function InstanceUtils.CreateWithValidation(className: string, properties: table)` (linha 11)
- `function InstanceUtils.SetProperties(inst: Instance, properties: table)` (linha 20)
- `function InstanceUtils.DestroySafe(inst: Instance?)` (linha 29)
- `function InstanceUtils.IsClass(instance: Instance, className: string)` (linha 33)
- `function InstanceUtils.CFrameFromPositionRotation(position: Vector3 | table, euler: Vector3 | table)` (linha 45)

## `src/framework/LifecycleManager.lua`

53 linhas · 1863 bytes · retorna `LifecycleManager`

**Propósito:** Máquina de estados de componente (Registered → Running → Stopped/Failed) com validação de estados.

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

## `src/framework/Logger.lua`

161 linhas · 4800 bytes · retorna `Logger`

**Propósito:** Logging com níveis DEBUG/INFO/WARN/ERROR e contexto de módulo; mistura API estática e de instância, com stubs e bugs conhecidos.

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - Logger (6.8)
-- Sistema de logging com níveis: DEBUG, INFO, WARN, ERROR
```

Funções:

- `function Logger.SetLevelMax(level: number)` (linha 32)
- `function Logger.RegisterModule(moduleName: string)` (linha 42)
- `function Logger.new(moduleName: string)` (linha 53)
- `function Logger.On(callback: function)` (linha 62)
- `function Logger.WithTags(tags: table)` (linha 69)
- `function Logger.Error(err: any, context: string?)` (linha 77)
- `function Logger:Debug(message: string, ...: any)` (linha 90)
- `function Logger:Info(message: string, ...: any)` (linha 101)
- `function Logger:Warn(message: string, ...: any)` (linha 112)
- `function Logger:Error(message: string, ...: any)` (linha 123)
- `function Logger:Catch(err: error, context: string)` (linha 132)
- `function Logger.ClearModules()` (linha 143)
- `function Logger:GetLevelMax()` (linha 149)
- `function Logger.LevelName(level: number)` (linha 154)

Tabelas/registros de topo:

- `Logger.Level` (linha 9)

## `src/framework/MathUtils.lua`

140 linhas · 4455 bytes · retorna `MathUtils`

**Propósito:** Matemática de vetores e CFrame (lerp, clamp, distância, projeção, lookAt, conversões euler); contém bugs conhecidos de runtime.

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - MathUtils (6.5)
-- Utilitários matemáticos: vetores, CFrame, geometria
```

Funções:

- `function MathUtils.Lerp(a: number | Vector3 | CFrame, b: number | Vector3 | CFrame, t: number)` (linha 12)
- `function MathUtils.ClampVec(v: Vector3, min: Vector3, max: Vector3)` (linha 28)
- `function MathUtils.Normalize(v: Vector3)` (linha 39)
- `function MathUtils.Distance(a: Vector3, b: Vector3)` (linha 49)
- `function MathUtils.AngleBetween(a: Vector3, b: Vector3)` (linha 57)
- `function MathUtils.ProjectOnPlane(v: Vector3, planeNormal: Vector3)` (linha 68)
- `function MathUtils.LookAt(from: Vector3, to: Vector3)` (linha 77)
- `function MathUtils.EulerToCFrame(pitch: number, yaw: number, roll: number)` (linha 87)
- `function MathUtils.CFrameToEuler(cframe: CFrame)` (linha 106)
- `function MathUtils.RotateVector(v: Vector3, c: CFrame)` (linha 126)
- `function MathUtils.ProjectAOnB(a: Vector3, b: Vector3)` (linha 134)

## `src/framework/ModuleRegistry.lua`

196 linhas · 5844 bytes · retorna `ModuleRegistry`

**Propósito:** Registro de módulos com dependências, detecção de ciclos e ordem topológica de inicialização (GetInitOrder).

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - ModuleRegistry (6.10)
-- Registro de módulos com validação de nomes, dependências e detecção de ciclos
```

Funções:

- `function ModuleRegistry.new()` (linha 10)
- `function ModuleRegistry:Register(name: string, module: any, dependencies: {string}?)` (linha 24)
- `function ModuleRegistry:Get(name: string)` (linha 54)
- `function ModuleRegistry:IsRegistered(name: string)` (linha 61)
- `function ModuleRegistry:ValidateDependencies(name: string)` (linha 69)
- `local function checkCycle(current: string, path: {string})` (linha 81, local)
- `function ModuleRegistry:GetInitOrder()` (linha 102)
- `local function visit(moduleName: string)` (linha 114, local)
- `function ModuleRegistry:Remove(name: string)` (linha 141)
- `function ModuleRegistry:GetNames()` (linha 171)
- `function ModuleRegistry:CheckAllDependencies()` (linha 182)

## `src/framework/NumberUtils.lua`

104 linhas · 3839 bytes · retorna `NumberUtils`

**Propósito:** Utilitários numéricos puros: clamp, lerp, round, mapeamento, wrap, conversão graus/radianos e random.

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - NumberUtils (6.7)
-- Utilitários numéricos: clamp, lerp, arredondamento, aproximação
```

Funções:

- `function NumberUtils.Clamp(value: number, min: number, max: number)` (linha 12)
- `function NumberUtils.Lerp(a: number, b: number, t: number)` (linha 21)
- `function NumberUtils.Round(value: number, decimals: number)` (linha 29)
- `function NumberUtils.IsFinite(value: number)` (linha 37)
- `function NumberUtils.Approximately(a: number, b: number, tolerance: number)` (linha 46)
- `function NumberUtils.RadiansToDegrees(radians: number)` (linha 54)
- `function NumberUtils.DegreesToRadians(degrees: number)` (linha 61)
- `function NumberUtils.Random(min: number, max: number, isInteger: boolean)` (linha 70)
- `function NumberUtils.Map(value: number, inMin: number, inMax: number, outMin: number, outMax: number)` (linha 86)
- `function NumberUtils.Wrap(value: number, min: number, max: number, cycleLength: number)` (linha 96)

## `src/framework/Server/Characters/CharacterManager.lua`

96 linhas · 3181 bytes · retorna `CharacterManager`

**Propósito:** Helpers de personagem: tipo de rig, root part, vivo/morto, posição, direção, pulo e respawn; incompleto (_data não declarado, typos de enum).

Cabeçalho do arquivo:

```lua
-- Vessie - CharacterManager
```

Funções:

- `function CharacterManager.Init()` (linha 8)
- `function CharacterManager.Register(character: Model, config: any?)` (linha 10)
- `function CharacterManager._Setup(character: Model)` (linha 24)
- `function CharacterManager.DetectRigType(character: Model)` (linha 35)
- `function CharacterManager.GetRootPart(character: Model)` (linha 40)
- `function CharacterManager.IsAlive(character: Model)` (linha 45)
- `function CharacterManager.IsOnGround(character: Model)` (linha 50)
- `function CharacterManager.GetPosition(character: Model)` (linha 57)
- `function CharacterManager.GetMoveDirection(character: Model)` (linha 62)
- `function CharacterManager.Jump(character: Model)` (linha 70)
- `function CharacterManager.Respawn(character: Model, location: CFrame?)` (linha 75)
- `function CharacterManager.IsDead(character: Model)` (linha 84)
- `function CharacterManager.RegisterInteractionPoint(character: Model, point: BasePart, itype: string)` (linha 89)

## `src/framework/Server/Permissions/PermissionManager.lua`

153 linhas · 5439 bytes · retorna `PermissionManager`

**Propósito:** Papéis e permissões (DefineRole/AssignRole/HasPermission); bug conhecido: permissões são globais, não por jogador.

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - PermissionManager (10)
-- Gerenciamento de papéis e permissões
```

Funções:

- `function PermissionManager.DefineRole(roleName: string, permissions: {string})` (linha 19)
- `function PermissionManager.AssignRole(player: Player, roleName: string)` (linha 26)
- `function PermissionManager.RemoveRole(player: Player, roleName: string)` (linha 46)
- `function PermissionManager.HasPermission(player: Player, permission: string, targetPlayer: Player?)` (linha 62)
- `function PermissionManager.CanExecuteOn(executor: Player, target: Player, permission: string)` (linha 91)
- `function PermissionManager.GetPermissions(player: Player)` (linha 108)
- `function PermissionManager.ListRoles()` (linha 126)
- `function PermissionManager.ListPermissions()` (linha 132)
- `function PermissionManager.IsOwner(player: Player)` (linha 139)
- `function PermissionManager.GetLevel(player: Player)` (linha 148)

## `src/framework/Server/Security/SecurityManager.lua`

167 linhas · 5408 bytes · retorna `SecurityManager`

**Propósito:** Validação de operações do cliente, admin e teleport + rate limiting token-bucket; lista de admins é placeholder.

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - SecurityManager (10)
-- Camada de segurança: validação de entrada, permissões, rate limiting
```

Funções:

- `function RateLimiter.AddTokens(player: Player, amount: number)` (linha 17)
- `function RateLimiter.CanExecute(player: Player, cost: number?)` (linha 33)
- `function SecurityManager.ValidateClientOperation(player: Player, operation: string, args: any?)` (linha 67)
- `function SecurityManager.HasAdminPermission(player: Player, targetPlayer: Player?)` (linha 107)
- `function SecurityManager.ValidateTeleport(player: Player, cframe: CFrame?)` (linha 129)
- `function SecurityManager.LogSuspiciousActivity(player: Player, operation: string, details: string?)` (linha 153)
- `function SecurityManager.ResetRateLimit(player: Player)` (linha 163)

## `src/framework/Shared/Data/DataManager.lua`

53 linhas · 1566 bytes · retorna `DataManager`

**Propósito:** Persistência via DataStoreService com merge e versionamento; store por jogador + PlaceId; Init vazio.

Cabeçalho do arquivo:

```lua
-- Vessie - DataManager
```

Funções:

- `function DataManager.Init()` (linha 10)
- `function DataManager.GetStore(name)` (linha 12)
- `function DataManager.Save(player, data, key)` (linha 16)
- `function DataManager.Load(player, key, default)` (linha 29)
- `function DataManager.Remove(player, key)` (linha 37)
- `function DataManager.GetVersion(player, key)` (linha 44)
- `function DataManager.SetVersion(player, version, key)` (linha 49)

Tabelas/registros de topo:

- `DataManager._stores` (linha 7)

## `src/framework/Shared/Networking/NetworkingManager.lua`

1 linhas · 0 bytes

**Propósito:** Arquivo vazio (0 bytes) — módulo de networking a implementar.

## `src/framework/StringUtils.lua`

153 linhas · 4754 bytes · retorna `StringUtils`

**Propósito:** Manipulação e validação de strings: trim, split/join, starts/ends with, format, validações (email/número) e geração de IDs.

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - StringUtils (6.2)
-- Utilitários para strings: formatação, validação, manipulação
```

Funções:

- `function StringUtils.Trim(s: string)` (linha 10)
- `function StringUtils.Split(s: string, delimiter: string, plain: boolean?)` (linha 19)
- `function StringUtils.Join(t: {string}, separator: string?)` (linha 47)
- `function StringUtils.StartsWith(s: string, prefix: string)` (linha 58)
- `function StringUtils.EndsWith(s: string, suffix: string)` (linha 66)
- `function StringUtils.Capitalize(s: string)` (linha 73)
- `function StringUtils.Upper(s: string)` (linha 81)
- `function StringUtils.Lower(s: string)` (linha 88)
- `function StringUtils.Format(format: string, ...)` (linha 96)
- `function StringUtils.IsEmail(email: string)` (linha 103)
- `function StringUtils.IsNumber(s: string)` (linha 111)
- `function StringUtils.Truncate(s: string, maxLen: number, suffix: string?)` (linha 121)
- `function StringUtils.Alphanumeric(s: string)` (linha 132)
- `function StringUtils.GenerateId()` (linha 138)
- `Y = function()` (linha 141)
- `function StringUtils.EscapePattern(s: string)` (linha 149)

## `src/framework/TableUtils.lua`

84 linhas · 2074 bytes · retorna `TableUtils`

**Propósito:** Utilitários de tabelas: cópia rasa/profunda, merge, filter/find, contagem, keys/values e comparação.

Cabeçalho do arquivo:

```lua
-- Vessie Roblox Framework - TableUtils (6.13)
-- Utilitários básicos para tabelas
```

Funções:

- `function TableUtils.ShallowCopy(t)` (linha 8)
- `function TableUtils.DeepCopy(t)` (linha 15)
- `function TableUtils.Merge(target, source)` (linha 28)
- `function TableUtils.Filter(t, keys)` (linha 35)
- `function TableUtils.Find(t, predicate)` (linha 42)
- `function TableUtils.Count(t, predicate)` (linha 48)
- `function TableUtils.IsEmpty(t)` (linha 55)
- `function TableUtils.GetKeys(t)` (linha 58)
- `function TableUtils.GetValues(t)` (linha 65)
- `function TableUtils.IsEqual(t1, t2)` (linha 72)

## `src/jogo/jogo.lua`

188 linhas · 5665 bytes · retorna `Jogo`

**Propósito:** Manipulação do jogo: referências de jogadores/personagem, teleport, modo voo (BodyVelocity), ferramentas/itens e silenciar sons.

Cabeçalho do arquivo:

```lua
--[[
Módulo de Manipulação de Jogo - Roblox Executor Library
Funções para interagir com o jogo Roblox
--]]
```

Funções:

- `function Jogo:inicializar()` (linha 15)
- `function Jogo:obterJogador(nomeOuUsuario)` (linha 46)
- `function Jogo:teleportar(destino, tipo)` (linha 61)
- `function Jogo:criarModoVoo(ativo)` (linha 92)
- `function Jogo:obterFerramenta(nome)` (linha 131)
- `function Jogo:darItem(nomeItem, quantidade)` (linha 139)
- `function Jogo:silenciarSons(ativo)` (linha 159)
- `function Jogo:espelharPersonagem(ativo)` (linha 178)

Tabelas/registros de topo:

- `Jogo.jogadores` (linha 10)

## `src/memoria/memoria.lua`

80 linhas · 2804 bytes · retorna `Memoria`

**Propósito:** Leitura/escrita de memória do client (placeholders do executor), pattern scanning, proteção de memória e endereço global.

Cabeçalho do arquivo:

```lua
--[[
Módulo de Memória - Roblox Executor Library
Funções para ler/escrever memória do client Roblox
--]]
```

Funções:

- `function Memoria:ler(endereco, tipo)` (linha 12)
- `function Memoria:escrever(endereco, valor, tipo)` (linha 37)
- `function Memoria:buscarPatron(enderecoInicio, fim, patron, mascara)` (linha 57)
- `function Memoria:proteger(endereco, tamanho, novoStatus)` (linha 66)
- `function Memoria:getEnderecoGlobal(nomeObjeto, offset)` (linha 73)

## `src/nonvisual_channel.lua`

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

## `src/public_api.lua`

95 linhas · 4790 bytes · retorna `M`

**Propósito:** API pública de comandos via remote events: registro com allowlist, processamento protegido, trigger e respostas; init registra 9 comandos padrão.

Cabeçalho do arquivo:

```lua
-- Public API System for Executor Lua
-- Versão: 1.0.0
-- Descrição: Sistema de API pública usando remote events do jogo
-- Compatível: Lua 5.1/5.2/5.3/5.4
-- Executores: Xeno, Delta, Mobile
```

Funções:

- `function M.register_command(name, func)` (linha 19)
- `function M.process_command(command, args)` (linha 32)
- `function function_list()` (linha 42)
- `function M.setup_remote_event(remote_event_name, callback)` (linha 48)
- `M._trigger_remote_event = function(...)` (linha 52)
- `function M.trigger_remote(command, args)` (linha 56)
- `function M.on_response(event_name, callback)` (linha 65)
- `function M.send_response(request_id, success, data)` (linha 73)
- `function M.init()` (linha 79)

Tabelas/registros de topo:

- `M.config` (linha 9)
- `remote_connections` (linha 16)
- `registered_commands` (linha 17)

## `src/remote_event_bridge.lua`

184 linhas · 5994 bytes · retorna `M`

**Propósito:** Bridges para remote events do jogo: fila de comandos, listeners de resposta e processamento de eventos recebidos; disparo real é simulado.

Cabeçalho do arquivo:

```lua
-- Remote Event Bridge for Public API
-- Conecta o sistema Public API aos remote events do jogo
-- Permite execucao de comandos de forma nao-visual
```

Funções:

- `function M.create_bridge(remote_event_name)` (linha 9)
- `function bridge:on_response(callback)` (linha 27)
- `function bridge:trigger(command, args)` (linha 36)
- `function bridge:process_next()` (linha 61)
- `function bridge:_fire_remote(payload)` (linha 87)
- `function M.get_bridge(remote_event_name)` (linha 108)
- `function M.remove_bridge(remote_event_name)` (linha 113)
- `function M.list_bridges()` (linha 122)
- `function M.process_remote_event(event_name, payload)` (linha 132)
- `function M.setup(remote_event_name)` (linha 165)

## `src/security_wrapper.lua`

163 linhas · 4598 bytes · retorna `M`

**Propósito:** Wrapper de segurança da Public API: allowlist/blocklist de comandos, rate limit por minuto e histórico das últimas 100 execuções.

Cabeçalho do arquivo:

```lua
-- Security Wrapper for Public API
-- Wrapper de seguranca para comandos remotos
-- Evita execucao de comandos nao autorizados e protege o executor
```

Funções:

- `function M.is_command_allowed(command_name)` (linha 31)
- `function M.block_command(command_name)` (linha 62)
- `function M.allow_command(command_name)` (linha 72)
- `function M.check_rate_limit(command_name)` (linha 82)
- `function M.record_execution(command_name, success, args)` (linha 114)
- `function M.get_execution_history()` (linha 132)
- `function M.get_config()` (linha 137)
- `function M.set_config(new_config)` (linha 142)

## `src/state_manager.lua`

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

## `src/ui/ui.lua`

165 linhas · 5049 bytes · retorna `UI`

**Propósito:** Criação de UI do executor: ScreenGui, frames arrastáveis, botões, toggles, caixas de texto, rótulos e listas roláveis.

Cabeçalho do arquivo:

```lua
--[[
Módulo de Interface - Roblox Executor Library
Criação de UIs e menus para o executor
--]]
```

Funções:

- `function UI:criarGui(nome, pais)` (linha 9)
- `function UI:criarFrame(gui, titulo, posicao, tamanho, corFundo)` (linha 22)
- `function UI:criarBotao(frame, texto, posicao, tamanho, cor, callback)` (linha 54)
- `function UI:criarToggle(frame, texto, posicao, ligadoInicial)` (linha 75)
- `function UI:criarCaixaTexto(frame, textoPlaceholder, posicao, tamanho)` (linha 96)
- `function UI:criarRotulo(frame, texto, posicao, tamanho, corTexto)` (linha 111)
- `function UI:criarLista(frame, posicao, tamanho)` (linha 126)
- `function UI:adicionarItemLista(scrollFrame, texto, callback)` (linha 138)
- `function UI:removerGui(nome)` (linha 156)

## `src/utils/utils.lua`

227 linhas · 8092 bytes · retorna `Utils`

**Propósito:** Comandos prontos de jogo em Utils.comandos: fly, speed, noclip, godmode, esp, verificar e antiafk, com listarComandos.

Cabeçalho do arquivo:

```lua
--[[
Módulo de Utilitários - Roblox Executor Library
Comandos pré-definidos comprimidos para uso único
--]]
```

Funções:

- `funcao = function(...)` (linha 13)
- `funcao = function(velocidade)` (linha 38)
- `funcao = function(ativo)` (linha 53)
- `funcao = function(ativo)` (linha 74)
- `function Utils:listarComandos()` (linha 96)
- `funcao = function(acao)` (linha 109)
- `funcao = function()` (linha 169)
- `funcao = function(ativo)` (linha 184)
- `function Utils:listarComandos()` (linha 208)

Tabelas/registros de topo:

- `Utils.comandos.fly` (linha 10)
- `Utils.comandos.speed` (linha 35)
- `Utils.comandos.noclip` (linha 50)
- `Utils.comandos.godmode` (linha 71)
- `Utils.comandos.esp` (linha 106)
- `Utils.comandos.verificar` (linha 166)
- `Utils.comandos.antiafk` (linha 181)
