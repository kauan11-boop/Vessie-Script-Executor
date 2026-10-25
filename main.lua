--[[
  Roblox Executor Library - Core Module
  Versão: 1.0.0
  Desenvolvido para executores: Xeno, Delta, Mobile Executors
  Funciona no client local sem emuladores
--]]

-- Tabela principal da biblioteca
local Library = {
    _VERSION = "1.0.0",
    _DESCRIPTION = "Biblioteca completa para executores Roblox",
    _AUTHOR = "Sistema Automatizado"
}

-- Módulos carregados
local modules = {}

-- Função para carregar um módulo
function Library:carregarModulo(nome)
    if modules[nome] then return modules[nome] end
    
    local sucesso, modulo = pcall(function()
        return require(self._NAME .. "." .. nome)
    end)
    
    if sucesso then
        modules[nome] = modulo
        return modulo
    else
        warn("[Library] Falha ao carregar módulo '" .. nome .. "': " .. tostring(modulo))
        return nil
    end
end

-- Função para inicializar todos os módulos
function Library:inicializar()
    -- Carregar módulos em ordem dependente
    self:carregarModulo("core")
    self:carregarModulo("memoria")
    self:carregarModulo("jogo")
    self:carregarModulo("ui")
    self:carregarModulo("apis")
    self:carregarModulo("utils")
    self:carregarModulo("framework")
    
    -- Executar inicialização de cada módulo
    for nome, modulo in pairs(modules) do
        if modulo.inicializar then
            modulo:inicializar()
        end
    end
    
    print("[Library] Biblioteca carregada com sucesso! Módulos: " .. #modules)
    return self
end

-- Função para executar um comando pelo framework
function Library:executarComando(comando, ...)
    local framework = self:carregarModulo("framework")
    if framework and framework.executar then
        return framework:executar(comando, ...)
    else
        error("[Framework] Módulo framework não disponível ou função executar não encontrada")
    end
end

-- Função para obter memória
function Library:getMemoria(endereco)
    local memoria = self:carregarModulo("memoria")
    if memoria and memoria.ler then
        return memoria:ler(endereco)
    end
    return nil
end

-- Função para definir memória
function Library:setMemoria(endereco, valor)
    local memoria = self:carregarModulo("memoria")
    if memoria and memoria.escrever then
        return memoria:escrever(endereco, valor)
    end
    return false
end

-- Função para evento
function Library:adicionarEvento(nome, callback)
    local jogo = self:carregarModulo("jogo")
    if jogo and jogo.adicionarEvento then
        return jogo:adicionarEvento(nome, callback)
    end
    return false
end

-- Retornar a biblioteca
return Library:inicializar()