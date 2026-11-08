--[[
  Rede Neural - Funcoes de ativacao e de perda (Lua 5.1+)
  derivada(nome, z, a) retorna f'(z) elemento a elemento (usa a quando conveniente).
  softmax nao tem derivada elementwise: o gradiente de saida e tratado em gradienteSaida.
--]]

local Ativacoes = {}

local function map(v, fn)
    local r = {}
    for i = 1, #v do r[i] = fn(v[i], i) end
    return r
end

local function sigmoid(x)
    if x >= 0 then
        return 1 / (1 + math.exp(-x))
    end
    local e = math.exp(x)
    return e / (1 + e)
end

Ativacoes.funcoes = {
    linear = {
        aplicar = function(z) return map(z, function(x) return x end) end,
        derivada = function(z) return map(z, function() return 1 end) end,
    },
    sigmoid = {
        aplicar = function(z) return map(z, sigmoid) end,
        derivada = function(z, a) return map(a, function(x) return x * (1 - x) end) end,
    },
    tanh = {
        aplicar = function(z) return map(z, function(x) return 2 * sigmoid(2 * x) - 1 end) end,
        derivada = function(z, a) return map(a, function(x) return 1 - x * x end) end,
    },
    relu = {
        aplicar = function(z) return map(z, function(x) return x > 0 and x or 0 end) end,
        derivada = function(z) return map(z, function(x) return x > 0 and 1 or 0 end) end,
    },
    leakyRelu = {
        aplicar = function(z) return map(z, function(x) return x > 0 and x or 0.01 * x end) end,
        derivada = function(z) return map(z, function(x) return x > 0 and 1 or 0.01 end) end,
    },
    softmax = {
        aplicar = function(z)
            local max = z[1]
            for i = 2, #z do if z[i] > max then max = z[i] end end
            local exps, soma = {}, 0
            for i = 1, #z do exps[i] = math.exp(z[i] - max); soma = soma + exps[i] end
            return map(exps, function(x) return x / soma end)
        end,
        derivada = nil,
    },
}

function Ativacoes.existe(nome)
    return Ativacoes.funcoes[nome] ~= nil
end

function Ativacoes.ativar(nome, z)
    local f = Ativacoes.funcoes[nome]
    if not f then error("[Neural] Ativacao desconhecida: " .. tostring(nome)) end
    return f.aplicar(z)
end

function Ativacoes.derivada(nome, z, a)
    local f = Ativacoes.funcoes[nome]
    if not f or not f.derivada then return nil end
    return f.derivada(z, a)
end

-- Valor da perda (mse = 0.5 * soma dos erros^2; crossentropy para alvos one-hot)
function Ativacoes.perda(nome, saida, alvo)
    nome = nome or "mse"
    local s = 0
    if nome == "mse" then
        for i = 1, #saida do local d = saida[i] - alvo[i]; s = s + d * d end
        return 0.5 * s
    elseif nome == "crossentropy" then
        for i = 1, #saida do s = s - (alvo[i] * math.log(saida[i] + 1e-15)) end
        return s
    end
    error("[Neural] Perda desconhecida: " .. tostring(nome))
end

-- Gradiente na pre-ativacao da camada de saida (dL/dz).
-- softmax/sigmoid + crossentropy simplifica para (saida - alvo).
function Ativacoes.gradienteSaida(nome, ativacao, saida, alvo, z)
    nome = nome or "mse"
    if nome == "crossentropy" and (ativacao == "softmax" or ativacao == "sigmoid") then
        local r = {}
        for i = 1, #saida do r[i] = saida[i] - alvo[i] end
        return r
    end
    local da = {}
    if nome == "mse" then
        for i = 1, #saida do da[i] = saida[i] - alvo[i] end
    elseif nome == "crossentropy" then
        for i = 1, #saida do da[i] = -(alvo[i] / (saida[i] + 1e-15)) end
    else
        error("[Neural] Perda desconhecida: " .. tostring(nome))
    end
    local der = Ativacoes.derivada(ativacao, z, saida)
    if not der then return da end
    local dz = {}
    for i = 1, #da do dz[i] = da[i] * der[i] end
    return dz
end

return Ativacoes
