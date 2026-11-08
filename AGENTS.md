# AGENTS.md — Guia para agents de coding e IA

Este arquivo é o ponto de entrada para qualquer agent de IA que trabalha neste repositório.
Leia-o antes de explorar ou modificar código.

## O que é este projeto

**Vessie Script Executor** (0.1 ALPHA): biblioteca Lua para executores Roblox (Xeno, Delta, Mobile Executors).
Fornece comandos de jogo (fly, speed, godmode, noclip, ESP, teleport, antiafk), leitura/escrita de memória,
criação de UI, integração HTTP e um sistema de comandos remoto **não-visual** (Public API via remote events).

Alvo de compatibilidade: Lua 5.1/5.2/5.3/5.4 e Luau (framework). Todo o texto de documentação e
identificadores de domínio é em **português (pt-BR)**.

## Estrutura do repositório

```
main.lua                  # ÚNICO script Lua na raiz — ponto de entrada
src/                      # Todo o código restante vive aqui
  command_dispatcher.lua  # Núcleo Public API (snake_case)
  public_api.lua
  state_manager.lua
  security_wrapper.lua
  remote_event_bridge.lua
  nonvisual_channel.lua
  apis/apis.lua           # Módulos de domínio (métodos em pt-BR)
  jogo/jogo.lua
  memoria/memoria.lua
  ui/ui.lua
  utils/utils.lua
  framework/              # Framework Luau (PascalCase, --!strict)
    Framework.lua         # Registro + ciclo de vida Init/Start/Cleanup
    Client/ Server/ Shared/
    *Utils.lua, *Manager.lua, EventBus.lua, Logger.lua, ModuleRegistry.lua
docs/
  CONTEXTO_IA.md          # Índice gerado de TODOS os scripts (ler primeiro)
  contexto.json           # Mesma informação em formato machine-readable
tools/
  gerar-contexto.mjs      # Gerador do índice (Node.js, sem dependências)
  descricoes-modulos.json # Propósito curado de cada arquivo
```

## Fluxo de trabalho para agents

1. **Leia `docs/CONTEXTO_IA.md`** (ou `docs/contexto.json`) para obter o mapa de todos os scripts,
   seus propósitos e assinaturas de funções com números de linha.
2. **Leia integralmente os scripts relevantes** antes de editá-los. O índice é um mapa, não substitui o código.
3. Código novo vai sempre em `src/`. **Nunca** crie outros scripts Lua na raiz; `main.lua` é a única exceção.
4. Ao criar, mover ou renomear scripts:
   - adicione/atualize a entrada em `tools/descricoes-modulos.json`;
   - rode `node tools/gerar-contexto.mjs` para regenerar `docs/CONTEXTO_IA.md` e `docs/contexto.json`;
   - commite os documentos gerados junto com a mudança.
5. `main.lua` carrega módulos com `require("src.<nome>")` (nomes: `memoria`, `jogo`, `ui`, `apis`,
   `utils`, `framework`; `core` é referenciado mas ainda não existe).

## As três famílias de módulos (siga o padrão da família que está editando)

### 1. Núcleo Public API (`src/*.lua`)
Comunicação não-visual por remote events. Identificadores em **snake_case**, mensagens em pt-BR.
- Padrão: `local M = {} ... return M`.
- Funções retornam tuplas `true/false, "mensagem"` ou tabelas `{ success, result, command }`.
- Nomes de comando são sempre normalizados com `:lower()`.
- Execução de handlers é protegida com `pcall`/`xpcall`.
- Fluxo: `public_api` (registro/allowlist) → `command_dispatcher` (handlers) →
  `security_wrapper` (allowlist/rate-limit/histórico) → `remote_event_bridge` (fila + listeners) →
  `nonvisual_channel` (payloads) + `state_manager` (estado/sessões).

### 2. Módulos de domínio (`src/apis|jogo|memoria|ui|utils/`)
Tabelas nomeadas (`local API = {}`, `local Jogo = {}`...), métodos com `:` e nomes em pt-BR
(`API:enviarWebhook`, `Jogo:teleportar`, `Memoria:ler`). Retornam a tabela no final.
`utils/utils.lua` registra comandos como `Utils.comandos.<nome> = { nome, descricao, funcao }`.
Funcionalidades que dependem do executor real (HTTP, memória bruta, pattern scan) são
**placeholders** que emitem `warn(...)` — mantenha esse padrão ao estender.

### 3. Framework (`src/framework/`)
Luau com `--!strict`, **PascalCase**, tipagem explícita. Módulos são registrados via
`Framework.Register(name, module)` e seguem o ciclo de vida `Init` → `Start` → `Cleanup`
(executado por `Framework.Start()` / `Framework.Stop()`). Usa padrão Maid para limpeza de
conexões/instances. Managers ficam em `Client/`, `Server/`, `Shared/`; utilitários puros na raiz do framework.

## Convenções gerais

- Proteção de erro: chamadas que podem falhar usam `pcall`/`xpcall`; erros viram `warn`/retorno, nunca crash.
- Logs: `print("[Modulo] mensagem")` / `warn("[Modulo] mensagem")`.
- Estado privado em `local` no topo do módulo; exponha apenas o necessário na tabela retornada.
- Sem dependências externas além das APIs do ambiente Roblox/executor.

## Estado atual e problemas conhecidos (não assuma que tudo funciona)

- Vários recursos são placeholders intencionais: HTTP/webhooks (`apis`), memória real e pattern scan (`memoria`),
  disparo real de remote events (`remote_event_bridge:_fire_remote` simula a resposta).
- Existem **erros de sintaxe pré-existentes** em módulos de domínio, por exemplo:
  - `src/apis/apis.lua`: `functionAPI:tabelaParaJSON` / `functionAPI:JSONParaTabela` (falta espaço após `function`);
  - `src/jogo/jogo.lua`: concatenação sem `..` na linha do print de inicialização; `:Conectar` em vez de `:Connect`;
  - `src/ui/ui.lua`: `:Conectar` em vez de `:Connect`;
  - `src/framework/Framework.lua`: anotação de tipo inválida em `Framework._modules: {[string]: any} = {}`.
  Corrija-os ao tocar nesses arquivos, mas não faça limpeza não relacionada em massa.
- `src/framework/Shared/Networking/NetworkingManager.lua` está vazio (a implementar).
- Vários módulos do framework estão incompletos ou com bugs de compilação/runtime
  (EventBus, NotificationManager, PlayerManager, CharacterManager, Logger, MathUtils, CollectionUtils).
  Os propósitos em `docs/CONTEXTO_IA.md` sinalizam quais.
- Não há testes automatizados nem build; a validação é leitura/revisão e execução no executor alvo.