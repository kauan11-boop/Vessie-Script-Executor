--[[
  Vessie Script Executor - Ponto de Entrada
  Versão: 0.2.0
  Desenvolvido para executores: Xeno, Delta, Mobile Executors
  Funciona no client local sem emuladores

  Arquitetura: main.lua (raiz) carrega módulos de src/ via require("src.<nome>").
  <nome> resolve para src/<nome>.lua ou src/<nome>/init.lua.
--]]

local Library = {
    _VERSION = "0.2.0",
    _DESCRIPTION = "Biblioteca completa para executores Roblox",
}

local modules = {}

function Library:carregarModulo(nome)
    if modules[nome] then return modules[nome] end
    local sucesso, modulo = pcall(function()
        return require("src." .. nome)
    end)
    if sucesso and modulo then
        modules[nome] = modulo
        return modulo
    end
    warn("[Library] Falha ao carregar módulo '" .. nome .. "': " .. tostring(modulo))
    return nil
end

function Library:inicializar()
    local ordem = { "core", "memoria", "jogo", "ui", "apis", "utils", "framework" }
    for _, nome in ipairs(ordem) do
        self:carregarModulo(nome)
    end

    -- Core primeiro: prepara estado, bridge e canal
    local core = modules["core"]
    if core and core.inicializar then
        core:inicializar()
    end

    -- Demais módulos (protegido: um módulo com erro não derruba os outros)
    for nome, modulo in pairs(modules) do
        if nome ~= "core" and modulo.inicializar then
            local ok, err = pcall(function() modulo:inicializar() end)
            if not ok then warn("[Library] Erro ao inicializar '" .. nome .. "': " .. tostring(err)) end
        end
    end

    -- Registra os comandos reais de utils no core (Public API)
    local utils = modules["utils"]
    if core and utils and utils.comandos then
        for nome, cmd in pairs(utils.comandos) do
            if type(cmd) == "table" and type(cmd.funcao) == "function" then
                core:registrarComando(nome, cmd.funcao)
            end
        end
    end

    local total = 0
    for _ in pairs(modules) do total = total + 1 end
    print("[Library] Biblioteca carregada com sucesso! Módulos: " .. total)
    return self
end

-- Executa um comando pelo core (segurança + rate limit + histórico)
function Library:executarComando(comando, ...)
    local core = self:carregarModulo("core")
    if core and core.executar then
        local args = ...
        return core:executar(comando, args)
    end
    error("[Library] Módulo core não disponível")
end

function Library:getMemoria(endereco)
    local memoria = self:carregarModulo("memoria")
    if memoria and memoria.ler then return memoria:ler(endereco) end
    return nil
end

function Library:setMemoria(endereco, valor)
    local memoria = self:carregarModulo("memoria")
    if memoria and memoria.escrever then return memoria:escrever(endereco, valor) end
    return false
end

function Library:adicionarEvento(nome, callback)
    local jogo = self:carregarModulo("jogo")
    if jogo and jogo.adicionarEvento then return jogo:adicionarEvento(nome, callback) end
    return false
end

function Library:obterModulo(nome)
    return self:carregarModulo(nome)
end

return Library:inicializar()