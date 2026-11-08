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

local Matriz = require("src.neural.matriz")
local Ativacoes = require("src.neural.ativacoes")
local Camadas = require("src.neural.camadas")
local Serializacao = require("src.neural.serializacao")

local Neural = {}
Neural.__index = Neural
Neural.matriz = Matriz
Neural.ativacoes = Ativacoes
Neural.camadas = Camadas
Neural.serializacao = Serializacao

function Neural.nova()
    return setmetatable({ camadas = {}, perda = "mse" }, Neural)
end

function Neural:camada(entradas, saidas, ativacao)
    table.insert(self.camadas, Camadas.dense(entradas, saidas, ativacao))
    return self
end

function Neural:forward(entrada)
    local saida = entrada
    for _, cam in ipairs(self.camadas) do
        if #saida ~= cam.entradas then
            error("[Neural] Dimensao de entrada invalida: esperado " .. cam.entradas .. ", recebido " .. #saida)
        end
        saida = Camadas.forward(cam, saida)
    end
    return saida
end

function Neural:prever(entrada)
    return self:forward(entrada)
end

function Neural:classificar(entrada)
    return Matriz.argmax(self:forward(entrada))
end

function Neural:backward(alvo, perda)
    perda = perda or self.perda
    local cams = self.camadas
    local n = #cams
    if n == 0 then return end
    local ultima = cams[n]
    local dz = Ativacoes.gradienteSaida(perda, ultima.ativacao, ultima._a, alvo, ultima._z)
    for i = n, 1, -1 do
        local cam = cams[i]
        if i < n then
            local der = Ativacoes.derivada(cam.ativacao, cam._z, cam._a)
            local novo = {}
            for j = 1, #dz do novo[j] = dz[j] * (der and der[j] or 1) end
            dz = novo
        end
        dz = Camadas.backward(cam, dz)
    end
end

function Neural:atualizar(taxa)
    for _, cam in ipairs(self.camadas) do Camadas.atualizar(cam, taxa) end
end

function Neural:treinar(dados, opcoes)
    opcoes = opcoes or {}
    local epocas = opcoes.epocas or 100
    local taxa = opcoes.taxaAprendizado or 0.1
    local perda = opcoes.perda or self.perda
    local embaralhar = opcoes.embaralhar ~= false
    self.perda = perda
    local historico = {}
    for epoca = 1, epocas do
        local ordem = {}
        for i = 1, #dados do ordem[i] = i end
        if embaralhar then
            for i = #ordem, 2, -1 do
                local j = math.random(i)
                ordem[i], ordem[j] = ordem[j], ordem[i]
            end
        end
        local soma = 0
        for _, idx in ipairs(ordem) do
            local amostra = dados[idx]
            local saida = self:forward(amostra.entrada)
            soma = soma + Ativacoes.perda(perda, saida, amostra.alvo)
            self:backward(amostra.alvo, perda)
            self:atualizar(taxa)
        end
        local media = soma / math.max(#dados, 1)
        historico[epoca] = media
        if opcoes.callback then pcall(opcoes.callback, epoca, media) end
    end
    return historico
end

function Neural:avaliar(dados, perda)
    perda = perda or self.perda
    local soma, acertos = 0, 0
    for _, amostra in ipairs(dados) do
        local saida = self:forward(amostra.entrada)
        soma = soma + Ativacoes.perda(perda, saida, amostra.alvo)
        if Matriz.argmax(saida) == Matriz.argmax(amostra.alvo) then acertos = acertos + 1 end
    end
    local total = math.max(#dados, 1)
    return { perda = soma / total, acuracia = acertos / total, total = #dados }
end

function Neural:serializar()
    local cams = {}
    for i, cam in ipairs(self.camadas) do
        cams[i] = {
            entradas = cam.entradas, saidas = cam.saidas, ativacao = cam.ativacao,
            W = Matriz.copia(cam.W), b = Matriz.copia(cam.b),
        }
    end
    return { versao = 1, perda = self.perda, camadas = cams }
end

function Neural:salvar(caminho)
    return Serializacao.salvar(self:serializar(), caminho)
end

-- Fabrica a partir de config: { {entradas,saidas,ativacao}, ... } ou { camadas = {...}, perda = "..." }
function Neural.criar(config)
    local rede = Neural.nova()
    local lista = config.camadas or config
    for _, def in ipairs(lista) do
        rede:camada(def[1] or def.entradas, def[2] or def.saidas, def[3] or def.ativacao)
    end
    if config.perda then rede.perda = config.perda end
    return rede
end

function Neural.deDados(dados)
    if type(dados) ~= "table" or type(dados.camadas) ~= "table" then
        return nil, "dados de modelo invalidos"
    end
    local rede = Neural.nova()
    rede.perda = dados.perda or "mse"
    for _, def in ipairs(dados.camadas) do
        local cam = Camadas.dense(def.entradas, def.saidas, def.ativacao)
        if def.W then cam.W = Matriz.copia(def.W) end
        if def.b then cam.b = Matriz.copia(def.b) end
        table.insert(rede.camadas, cam)
    end
    return rede
end

function Neural.carregar(caminho)
    local dados, err = Serializacao.carregar(caminho)
    if not dados then return nil, err end
    return Neural.deDados(dados)
end

return Neural
