--[[
  Módulo de Memória - Vessie Script Executor
  Leitura/escrita de memória do client. Usa a API do executor quando disponível
  (readmemory/writememory); caso contrário, opera como cache simulado (placeholder).
--]]

local Memoria = {}

Memoria.enderecos = Memoria.enderecos or {}

local function apiLeitura()
    return readmemory or (syn and syn.readmemory) or (debug and debug.readmemory)
end

local function apiEscrita()
    return writememory or (syn and syn.writememory) or (debug and debug.writememory)
end

function Memoria:ler(endereco, tipo)
    tipo = tipo or "number"
    if self.enderecos[endereco] ~= nil then
        return self.enderecos[endereco]
    end
    local ler = apiLeitura()
    if ler then
        local ok, resultado = pcall(ler, endereco, tipo)
        if ok then
            self.enderecos[endereco] = resultado
            return resultado
        end
        warn("[Memória] Falha ao ler endereço " .. tostring(endereco) .. ": " .. tostring(resultado))
        return nil
    end
    -- Placeholder: sem API do executor, retorna nil (endereço desconhecido)
    return nil
end

function Memoria:escrever(endereco, valor, tipo)
    tipo = tipo or "number"
    if type(endereco) ~= "number" then
        warn("[Memória] Endereço deve ser um número")
        return false
    end
    local escrever = apiEscrita()
    if escrever then
        local ok, err = pcall(escrever, endereco, valor, tipo)
        if not ok then
            warn("[Memória] Falha ao escrever: " .. tostring(err))
            return false
        end
    end
    self.enderecos[endereco] = valor
    return true
end

function Memoria:buscarPatron(enderecoInicio, fim, patron, mascara)
    -- Pattern scanning real requer API de memória do executor
    if not apiLeitura() then
        warn("[Memória] Pattern scanning requer executor específico - placeholder")
        return nil
    end
    warn("[Memória] Pattern scanning ainda não implementado para este executor")
    return nil
end

function Memoria:proteger(endereco, tamanho, novoStatus)
    warn("[Memória] Proteção de memória requer executor específico")
    return false
end

function Memoria:getEnderecoGlobal(nomeObjeto, offset)
    local base = game and game.PlaceId or 0
    return base + (offset or 0)
end

function Memoria:listarEnderecos()
    local lista = {}
    for endereco, valor in pairs(self.enderecos) do
        table.insert(lista, { endereco = endereco, valor = valor })
    end
    return lista
end

function Memoria:limparCache()
    self.enderecos = {}
    return true
end

return Memoria