# Biblioteca Executor Lua - Referência e Guia de Uso

## Sobre esta Biblioteca

Esta biblioteca foi desenvolvida em **Lua 5.1/5.2/5.3/5.4** (núcleo e domínio) e **Luau** (framework). Este documento serve como referência da linguagem e guia de integração para executores de jogos.

---
---
## 1. Tabelas - A Base de Tudo

Em Lua, tabelas são a estrutura de dados fundamental - usadas como arrays, dicionários, objetos, listas, sets.

```lua
local player = {}                              -- tabela vazia
local config = { enabled = true, max = 16 }    -- inicialização literal
player.name = "Exemplo"
local v = config.max                           -- leitura de valor
```

**Para executores:** dados dinâmicos, estados de configuração, organização de módulos. Todos os módulos desta biblioteca usam tabelas como base.

---
---
## 2. Funções como Valores de Primeira Classe

Funções em Lua são cidadãos de primeira classe - podem ser passadas como argumento, retornadas por outras funções e armazenadas em tabelas.

```lua
local function saudar(nome) return "Olá, " .. nome end

local comandos = { fly = function() print("Voando") end, stop = function() print("Parado") end }

function criarModo(ativo) return function() return ativo end end
```

**Para executores:** system commands, hooks/callbacks, eventos de framework. Padrão usado para registrar comandos dinamicamente em Xeno, Delta e executores similares.

---
---
## 3. Módulos e `require`

Cada arquivo `.lua` é um módulo independente. `require()` carrega e retorna sua tabela pública.

```lua
-- src/memoria.lua
local M = {}
function M:ler(addr) return valor end
function M:escrever(addr, val) return true end
return M
```

```lua
-- main.lua
local memoria = require("src.memoria")
local result = memoria:ler(0x12345678)
```

**Para executores:** módulos independentes, escopo isolado, `main.lua` carrega todos. Arquitetura desta biblioteca: `main.lua` (raiz) + `src/` contendo os módulos de domínio planos (`apis.lua`, `jogo.lua`, `memoria.lua`, `ui.lua`, `utils.lua`), o núcleo `src/core/`, a rede neural `src/neural/` e o framework `src/framework/`. `require("src.<nome>")` resolve `src/<nome>.lua` ou `src/<nome>/init.lua`.

---
---
## 4. Controle de Erros com `pcall`/`xpcall`

Lua protege chamadas que podem falhar em ambientes de execução.

```lua
local ok, err = pcall(function() error("test") end)
-- ou
local ok = xpcall(f, handler)  -- handler processa o erro
```

**Para executores:** proteger chamadas de memória, hooks, APIs. Impedir que um erro quebre todo o executor. Logs de erro em vez de crashes. Padrão essencial para Xeno, Delta, Mobile executors. (Em Lua 5.1, `xpcall` não aceita argumentos extras — use uma closure com `pcall`.)

---
---
## 5. Manipulação de Strings

Funções nativas de Lua para strings.

```lua
local t = "Fly:Enabled:true"
string.upper(t)    -- "FLY:ENABLED:TRUE"
string.lower(t)    -- "fly:enabled:true"
string.sub(t, 1, 3) -- "Fly"
string.gsub(t, "Enable", "Disabled") -- substituir
```

**Para executores:** parsing de comandos inseridos pelo usuário, formatação de mensagens de saída, processamento de nomes, webhooks e URLs. Commands como `fly`, `speed`, `godmode` são parseados usando estas funções.

---
---
## 6. Operações sobre Tabelas

Biblioteca `table` com métodos úteis para manipulação de coleções.

```lua
local fruits = {"fly", "speed"}
table.concat(fruits, ", ")  -- "fly, speed"
table.insert(comandos, "godmode")
local N = #comandos          -- tamanho
```

**Para executores:** listar comandos disponíveis, adicionar comandos dinamicamente durante a execução, contar itens, organizar dados de memória ou estado do jogo. `table.concat()` usado para gerar listas de comandos registrados.

---
---
## 7. Metatables e Metamethods

Sobrecarregar operações em tabelas (`__index`, `__newindex`, `__add`, `__tostring`).

```lua
local vetor = {x=10, y=20}
setmetatable(vetor, { __add = function(a,b) return {x=a.x+b.x, y=a.y+b.y} end, __tostring = function() return "Vetor("..vetor.x..","..vetor.y..")" end })
```

**Para executores:** controlar acesso a campos de memória (`__newindex`), criar propriedades inteligentes para configurações, sobrecarregar operadores para tipos customizados em scripts de executor.

---
---
## 8. Closures (Funções Anônimas)

Funções que capturam variáveis do escopo onde foram definidas.

```lua
function criarContador(inicio)
    local contador = inicio or 0
    return function() contador = contador + 1; return contador end
end
local c = criarContador(); print(c()) -- 1, print(c()) -- 2, print(c()) -- 3
```

**Para executores:** eventos/hooks `Connect()`, callbacks configuráveis, funções que mantêm estado interno. Padrão para sistemas de toggle (fly on/off, godmode ativo/desativado).

---
---
## 9. Controle de Escopo

Lua tem escopo de função (não de bloco). `local` limita variável à função.

```lua
function foo() local secreto = "interno" end -- fora dá erro
globalVar = "visível em todo lugar"          -- sem local
function bar() _G.meuVar = "global" end      -- via _G
```

**Para executores:** `local` para variáveis de módulo/helpers/temporárias, `_G` para compartilhar, evitar poluição global, configurações acessíveis quando necessário.

---
---
## Padrões Usados na Biblioteca

```lua
-- Padrão módulo
local M = {}
function M.comando(opts) ... end
return M

-- Padrão opções
function novoComando(opts) opts = opts or {}; local ativo = opts.ativo or false; ... end

-- Padrão proteção
local ok, err = pcall(funcaoArrojada)
if not ok then warn("Erro: " .. err) end
```

---
---
## Rede Neural (`src/neural/`)

Base completa de rede neural (MLP) em **Lua puro 5.1+**, sem dependência do Roblox — roda em qualquer
executor ou fora dele. Forward/backpropagation com SGD, ativações `linear/sigmoid/tanh/relu/leakyRelu/softmax`
e perdas `mse/crossentropy`.

```lua
local Neural = require("src.neural")           -- ou Library:redeNeural()
local rede = Neural.nova()
rede:camada(2, 4, "tanh"):camada(4, 1, "sigmoid")

local dados = {
  { entrada = {0,0}, alvo = {0} }, { entrada = {0,1}, alvo = {1} },
  { entrada = {1,0}, alvo = {1} }, { entrada = {1,1}, alvo = {0} },
}
rede:treinar(dados, { epocas = 2000, taxaAprendizado = 0.5, perda = "mse" })
print(rede:prever({1,0})[1])                    -- ~1
print(rede:avaliar(dados).acuracia)             -- fração de acertos
rede:salvar("modelo.json")                      -- requer writefile do executor
local copia = Neural.carregar("modelo.json")    -- requer readfile do executor
```

- Camadas encadeáveis: `rede:camada(entradas, saidas, ativacao)`; init Xavier automático.
- `treinar(dados, { epocas, taxaAprendizado, perda, embaralhar, callback })` retorna o histórico de perda.
- `classificar(entrada)` retorna o índice de maior saída (argmax); útil com `softmax` + `crossentropy`.
- Fábricas: `Neural.criar({ {2,4,"tanh"}, {4,1,"sigmoid"} })` e `Neural.deDados(modelo)`.
- Serialização JSON própria (`serializacao.lua`); `salvar`/`carregar` usam `writefile`/`readfile` do executor
  (emitem `warn` onde não existirem). Módulo machine-readable: raw em `docs/CONTEXTO_IA.md`.

---
---
## Arquivos da Biblioteca

- `main.lua` - carregamento e inicialização de todos os módulos (único arquivo Lua na raiz, v0.2.0)
- `src/apis.lua` - funções de HTTP, webhooks, requisições externas e conversão JSON
- `src/jogo.lua` - teleport, fly, ferramentas, silenciar sons e modificação da base (iluminação, tempo, partes, limpeza, ancoragem, otimização gráfica)
- `src/memoria.lua` - leitura/escrita de memória, pattern scanning e cache
- `src/ui.lua` - interface gráfica: frames, botões, toggles, textboxes e listas
- `src/utils.lua` - 22 comandos (fly, speed, noclip, godmode, esp, teleport, antiafk, fullbright, gravity, otimizar, removerefeitos, notextures, nofog, daytime, antivoid, fps, etc.)
- `src/neural/` - rede neural MLP em Lua puro: `init.lua` (classe Neural), `matriz.lua`, `ativacoes.lua`, `camadas.lua`, `serializacao.lua`
- `src/core/` - núcleo Public API: `init.lua` (faixada), `public_api.lua`, `command_dispatcher.lua`, `security_wrapper.lua`, `state_manager.lua`, `remote_event_bridge.lua`, `nonvisual_channel.lua`
- `src/framework/init.lua` - registro de módulos, ciclo de vida Init/Start/Cleanup e Maid
- `src/framework/utils/` - utilitários puros (Number, String, Table, Math, Instance, Collection)
- `src/framework/runtime/` - ConfigManager, EventBus, LifecycleManager, Logger, ModuleRegistry
- `src/framework/Client/` - PlayerManager, NotificationManager, ThemeManager
- `src/framework/Server/` - CharacterManager, PermissionManager, SecurityManager
- `src/framework/Shared/` - DataManager, NetworkingManager

Para documentação voltada a agents de IA, consulte `AGENTS.md` e `docs/CONTEXTO_IA.md`. Cada script tem
uma **URL raw do GitHub** para leitura direta (sem clonar o repositório): base
`https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/` + caminho relativo.
A lista completa (caminho -> raw) está em `docs/CONTEXTO_IA.md` e em `docs/contexto.json` (campo `rawUrl`).
