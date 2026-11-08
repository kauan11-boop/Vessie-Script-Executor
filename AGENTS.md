# AGENTS.md — Guia para agents de coding e IA

Este arquivo é o ponto de entrada para qualquer agent de IA que trabalha neste repositório.
Leia-o antes de explorar ou modificar código.

## O que é este projeto

**Vessie Script Executor** (0.2.0): biblioteca Lua para executores Roblox (Xeno, Delta, Mobile Executors).
Fornece comandos de jogo (fly, speed, godmode, noclip, ESP, teleport, antiafk, fullbright, gravity, otimizar,
antivoid e outros), leitura/escrita de memória, criação de UI, integração HTTP, modificação da base/conteúdo
do jogo e um sistema de comandos remoto **não-visual** (Public API via remote events). Inclui um framework
Luau de managers/utilitários para Roblox e uma base completa de **rede neural** (MLP) em Lua puro (`src/neural/`).

Alvo de compatibilidade: Lua 5.1/5.2/5.3/5.4 (núcleo e domínio) e Luau (framework). Todo o texto de
documentação e identificadores de domínio é em **português (pt-BR)**.

## Estrutura do repositório

```
main.lua                  # ÚNICO script Lua na raiz — ponto de entrada (v0.2.0)
src/                      # Todo o código restante vive aqui
  core/                   # Núcleo Public API (snake_case)
    init.lua              # Faixada: agrega os submódulos e expõe registrarComando/executar
    public_api.lua
    command_dispatcher.lua
    security_wrapper.lua
    state_manager.lua
    remote_event_bridge.lua
    nonvisual_channel.lua
  apis.lua                # Módulos de domínio (métodos em pt-BR, arquivos planos)
  jogo.lua
  memoria.lua
  ui.lua
  utils.lua               # Utils.comandos: 22 comandos prontos (jogo + otimização/modificação)
  neural/                 # Rede neural MLP em Lua puro (Lua 5.1+)
    init.lua              # Classe Neural: forward/backprop/SGD, treinar/avaliar, serializar
    matriz.lua            # Álgebra linear (vetores/matrizes, dot, outer, transposta)
    ativacoes.lua         # sigmoid/tanh/relu/leakyRelu/softmax/linear + perdas mse/crossentropy
    camadas.lua           # Camada densa (init Xavier, forward/backward/atualizar)
    serializacao.lua      # JSON próprio + salvar/carregar (writefile/readfile)
  framework/              # Framework Luau (PascalCase, --!strict)
    init.lua              # Registro + ciclo de vida Init/Start/Cleanup + Maid
    utils/                # Utilitários puros (*Utils.lua)
    runtime/              # ConfigManager, EventBus, LifecycleManager, Logger, ModuleRegistry
    Client/               # PlayerManager, NotificationManager, ThemeManager
    Server/               # CharacterManager, PermissionManager, SecurityManager
    Shared/               # DataManager, NetworkingManager
docs/
  CONTEXTO_IA.md          # Índice gerado de TODOS os scripts (ler primeiro)
  contexto.json           # Mesma informação em formato machine-readable
tools/
  gerar-contexto.mjs      # Gerador do índice (Node.js, sem dependências)
  descricoes-modulos.json # Propósito curado de cada arquivo
```

## Leitura dos scripts via raw do GitHub (preferido para IA)

Em vez de navegar pela arquitetura de diretórios, **leia o conteúdo integral de cada script pela URL raw
do GitHub**. Isso facilita a leitura por agents/IA (sem clonar o repositório) e é o formato recomendado
para entender cada módulo.

- Base raw: `https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/`
- URL de um script = base + caminho relativo. Exemplos:
  - `main.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/main.lua
  - `src/neural/init.lua` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/src/neural/init.lua
  - `AGENTS.md` -> https://raw.githubusercontent.com/kauan11-boop/Vessie-Script-Executor/refs/heads/main/AGENTS.md
- **`docs/CONTEXTO_IA.md`** traz a lista completa (caminho -> URL raw) e um link `**Raw:**` em cada seção.
- **`docs/contexto.json`** expõe `rawBase` e o campo `rawUrl` por arquivo (machine-readable).
- O gerador (`tools/gerar-contexto.mjs`) detecta a base via `git remote`/branch, com fallback fixo acima;
  as URLs apontam para `refs/heads/main` e só resolvem depois que o script estiver commitado/pushado.

> Para IA: comece pelo raw de `AGENTS.md` e `docs/CONTEXTO_IA.md`, depois busque o raw de cada script
> relevante listado lá. O índice é um mapa; o raw entrega o código-fonte completo.

## Fluxo de trabalho para agents

1. **Leia `docs/CONTEXTO_IA.md`** (ou `docs/contexto.json`) para obter o mapa de todos os scripts,
   seus propósitos, assinaturas de funções com números de linha e a **URL raw** de cada um.
   Prefira buscar o conteúdo integral pelo raw (ver seção acima) antes de editar.
2. **Leia integralmente os scripts relevantes** antes de editá-los. O índice é um mapa, não substitui o código.
3. Código novo vai sempre em `src/`. **Nunca** crie outros scripts Lua na raiz; `main.lua` é a única exceção.
4. Ao criar, mover ou renomear scripts:
   - adicione/atualize a entrada em `tools/descricoes-modulos.json` (chave = caminho relativo com `/`);
   - rode `node tools/gerar-contexto.mjs` para regenerar `docs/CONTEXTO_IA.md` e `docs/contexto.json`;
   - commite os documentos gerados junto com a mudança.
5. `main.lua` carrega módulos com `require("src.<nome>")`. `<nome>` resolve para `src/<nome>.lua`
   **ou** `src/<nome>/init.lua`. Nomes usados: `core`, `memoria`, `jogo`, `ui`, `apis`, `utils`, `neural`, `framework`.
   Dentro de `src/core/init.lua`, os submódulos são carregados como `require("src.core.<arquivo>")`;
   dentro de `src/neural/init.lua`, como `require("src.neural.<modulo>")`. `Library:redeNeural()` expõe a rede neural.

## As quatro famílias de módulos (siga o padrão da família que está editando)

### 1. Núcleo Public API (`src/core/`)
Comunicação não-visual por remote events. Identificadores em **snake_case**, mensagens em pt-BR.
- Padrão: `local M = {} ... return M`. `init.lua` é a faixada que agrega os submódulos.
- Funções retornam tuplas `true/false, "mensagem"` ou tabelas `{ success, result, command }`.
- Nomes de comando são sempre normalizados com `:lower()`.
- Execução de handlers é protegida com `pcall` (Lua 5.1: `xpcall` não aceita argumentos extras — use closure).
- Fluxo: `core/init` → `public_api` (registro/allowlist) → `command_dispatcher` (handlers) →
  `security_wrapper` (allowlist/rate-limit/histórico) → `remote_event_bridge` (fila + listeners, processador
  injetado via `set_processor`) → `nonvisual_channel` (payloads) + `state_manager` (estado/sessões).

### 2. Módulos de domínio (`src/apis|jogo|memoria|ui|utils.lua`)
Tabelas nomeadas (`local API = {}`, `local Jogo = {}`...), métodos com `:` e nomes em pt-BR
(`API:enviarWebhook`, `Jogo:teleportar`, `Memoria:ler`). Retornam a tabela no final.
`utils.lua` registra comandos como `Utils.comandos.<nome> = { nome, descricao, funcao }`; `main.lua`
os conecta ao core via `core:registrarComando`. Funcionalidades que dependem do executor real
(memória bruta, pattern scan, disparo real de remote events) são **placeholders** que emitem `warn(...)`
ou simulam a resposta — mantenha esse padrão ao estender.

### 3. Framework (`src/framework/`)
Luau com `--!strict`, **PascalCase**, tipagem explícita. O núcleo (`init.lua`) registra módulos via
`Framework.Register(name, module)` e segue o ciclo de vida `Init` → `Start` → `Cleanup`
(executado por `Framework.Start()` / `Framework.Stop()`), com padrão Maid para limpeza.
- `utils/`: utilitários puros (NumberUtils, StringUtils, TableUtils, MathUtils, InstanceUtils, CollectionUtils).
- `runtime/`: infraestrutura (ConfigManager, EventBus, LifecycleManager, Logger, ModuleRegistry).
- `Client/`, `Server/`, `Shared/`: managers Roblox. Entre si, usam `require("src.framework.<Pasta>/<Modulo>")`.
- Evite anotações inválidas: não use genéricos `<T>`, dupla anotação (`x: T: any`) nem anotação de campo
  em atribuição (`M._x: {...} = {}`); declare `M._x = {}` e tipifique parâmetros/retornos nas funções.

### 4. Rede neural (`src/neural/`)
Lua puro (5.1+), **sem dependência do Roblox** — roda em qualquer executor ou fora dele. MLP com
forward/backprop e SGD. Identificadores em pt-BR, padrão `local M = {} ... return M`.
- `init.lua`: classe `Neural` (`nova`, `camada` encadeável, `forward`, `prever`, `classificar`, `backward`,
  `atualizar`, `treinar`, `avaliar`, `serializar`, `salvar`, `carregar`, fábricas `criar`/`deDados`).
- `matriz.lua` (álgebra linear), `ativacoes.lua` (ativações + perdas), `camadas.lua` (densa/Xavier),
  `serializacao.lua` (JSON próprio + `writefile`/`readfile`). Submódulos: `require("src.neural.<modulo>")`.
- Serialização usa `string.char` para escapes (sem literais de barra) — válido em Lua 5.1–5.4 e Luau.
- Acesso pela biblioteca: `Library:redeNeural()` ou `require("src.neural")`. Persistência de pesos via
  `salvar`/`carregar` depende de `writefile`/`readfile` do executor (placeholder/`warn` onde não existir).

## Convenções gerais

- Proteção de erro: chamadas que podem falhar usam `pcall`; erros viram `warn`/retorno, nunca crash.
- Logs: `print("[Modulo] mensagem")` / `warn("[Modulo] mensagem")`.
- Estado privado em `local` no topo do módulo; exponha apenas o necessário na tabela retornada.
- Conexões RBXScriptConnection devem ser rastreadas e desconectadas em Cleanup/Destroy (sem leaks).
- Sem dependências externas além das APIs do ambiente Roblox/executor.

## Estado atual e limites conhecidos (não assuma que tudo funciona no mundo real)

- Recursos simulados/placeholder por dependerem do executor ou do jogo alvo: memória bruta e pattern scan
  (`memoria`), disparo real de remote events (`remote_event_bridge` simula a resposta). HTTP (`apis`) detecta
  a função de request do executor, mas só funciona onde ela existir.
- O framework foi refinado para Luau válido e funcional, mas **não há testes automatizados nem build**;
  a validação é leitura/revisão e execução no executor/Studio alvo. Managers de Server/Shared usam APIs
  server-only (DataStore, RemoteEvent creation) — respeite o lado correto ao usá-los.
- `SecurityManager` e `PermissionManager` exigem configuração (lista de admins, papéis, donos) para
  conceder acesso; por padrão ninguém é admin.
