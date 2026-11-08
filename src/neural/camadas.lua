--[[
  Rede Neural - Camada densa (fully connected) com forward/backward (Lua 5.1+)
  W e (saidas x entradas); forward guarda _x/_z/_a; backward guarda _dW/_db.
--]]

local Matriz = require("src.neural.matriz")
local Ativacoes = require("src.neural.ativacoes")

local Camadas = {}

function Camadas.dense(entradas, saidas, ativacao)
    ativacao = ativacao or "sigmoid"
    local escala = math.sqrt(1 / entradas)
    return {
        tipo = "dense",
        entradas = entradas,
        saidas = saidas,
        ativacao = ativacao,
        W = Matriz.random2d(saidas, entradas, escala),
        b = Matriz.zeros(saidas),
    }
end

function Camadas.forward(camada, x)
    camada._x = x
    local z = Matriz.matVec(camada.W, x)
    for i = 1, #z do z[i] = z[i] + camada.b[i] end
    camada._z = z
    local a = Ativacoes.ativar(camada.ativacao, z)
    camada._a = a
    return a
end

-- Recebe dz (dL/dz), guarda gradientes e retorna dL/dx (entrada da camada).
function Camadas.backward(camada, dz)
    camada._dW = Matriz.outer(dz, camada._x)
    camada._db = dz
    local Wt = Matriz.transposta(camada.W)
    return Matriz.matVec(Wt, dz)
end

-- Descida de gradiente simples (SGD) in-place.
function Camadas.atualizar(camada, taxa)
    local W, dW = camada.W, camada._dW
    for i = 1, #W do
        for j = 1, #W[i] do W[i][j] = W[i][j] - taxa * dW[i][j] end
    end
    local b, db = camada.b, camada._db
    for i = 1, #b do b[i] = b[i] - taxa * db[i] end
end

return Camadas
