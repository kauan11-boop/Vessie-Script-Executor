--[[
  Rede Neural - Algebra linear (Lua 5.1+, sem dependencias)
  Vetores = arrays {1..n}; matrizes = arrays de linhas {1..l}{1..c}.
--]]

local Matriz = {}

function Matriz.zeros(n)
    local v = {}
    for i = 1, n do v[i] = 0 end
    return v
end

function Matriz.zeros2d(linhas, colunas)
    local m = {}
    for i = 1, linhas do m[i] = Matriz.zeros(colunas) end
    return m
end

function Matriz.random2d(linhas, colunas, escala)
    escala = escala or 1
    local m = {}
    for i = 1, linhas do
        m[i] = {}
        for j = 1, colunas do m[i][j] = (math.random() * 2 - 1) * escala end
    end
    return m
end

function Matriz.copia(a)
    if type(a) ~= "table" then return a end
    local c = {}
    for k, v in pairs(a) do c[k] = Matriz.copia(v) end
    return c
end

function Matriz.dot(a, b)
    local s = 0
    for i = 1, #a do s = s + a[i] * b[i] end
    return s
end

-- W (saidas x entradas) multiplicado por vetor x (entradas) -> vetor (saidas)
function Matriz.matVec(W, x)
    local r = {}
    for i = 1, #W do r[i] = Matriz.dot(W[i], x) end
    return r
end

function Matriz.transposta(W)
    local t = {}
    for j = 1, #W[1] do
        t[j] = {}
        for i = 1, #W do t[j][i] = W[i][j] end
    end
    return t
end

function Matriz.soma(a, b)
    local r = {}
    for i = 1, #a do r[i] = a[i] + b[i] end
    return r
end

function Matriz.sub(a, b)
    local r = {}
    for i = 1, #a do r[i] = a[i] - b[i] end
    return r
end

function Matriz.escala(a, s)
    local r = {}
    for i = 1, #a do r[i] = a[i] * s end
    return r
end

-- Produto elemento a elemento (Hadamard) de vetores
function Matriz.mul(a, b)
    local r = {}
    for i = 1, #a do r[i] = a[i] * b[i] end
    return r
end

-- Produto externo: a (m) x b (n) -> matriz m x n
function Matriz.outer(a, b)
    local m = {}
    for i = 1, #a do
        m[i] = {}
        for j = 1, #b do m[i][j] = a[i] * b[j] end
    end
    return m
end

function Matriz.map(a, fn)
    local r = {}
    for i = 1, #a do r[i] = fn(a[i], i) end
    return r
end

function Matriz.argmax(v)
    local idx, max = 1, v[1]
    for i = 2, #v do
        if v[i] > max then max = v[i]; idx = i end
    end
    return idx
end

return Matriz
