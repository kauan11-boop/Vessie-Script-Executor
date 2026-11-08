--[[
  Rede Neural - Serializacao JSON e persistencia (Lua 5.1+, sem dependencias)
  JSON proprio para portabilidade; salvar/carregar usam writefile/readfile do executor.
--]]

local Serializacao = {}
local aviso = warn or print

local function isArray(t)
    local n = 0
    for k in pairs(t) do
        if type(k) ~= "number" then return false end
        n = n + 1
    end
    return n == #t
end

local function escapeStr(s)
    local out = { string.char(34) }
    for i = 1, #s do
        local b = string.byte(s, i)
        if b == 34 then
            out[#out + 1] = string.char(92, 34)
        elseif b == 92 then
            out[#out + 1] = string.char(92, 92)
        elseif b < 32 then
            out[#out + 1] = string.format(string.char(92) .. "u%04x", b)
        else
            out[#out + 1] = string.char(b)
        end
    end
    out[#out + 1] = string.char(34)
    return table.concat(out)
end

local encode
encode = function(v)
    local t = type(v)
    if t == "number" then
        if v ~= v or v == math.huge or v == -math.huge then return "0" end
        return string.format("%.17g", v)
    elseif t == "boolean" then
        return v and "true" or "false"
    elseif t == "string" then
        return escapeStr(v)
    elseif t == "table" then
        if isArray(v) then
            local parts = {}
            for i = 1, #v do parts[i] = encode(v[i]) end
            return "[" .. table.concat(parts, ",") .. "]"
        end
        local parts = {}
        for k, val in pairs(v) do parts[#parts + 1] = escapeStr(tostring(k)) .. ":" .. encode(val) end
        return "{" .. table.concat(parts, ",") .. "}"
    end
    return "null"
end

local function decode(str)
    local pos, len = 1, #str
    local parseValor
    local function skip()
        while pos <= len do
            local c = str:sub(pos, pos)
            if c == " " or c == "\t" or c == "\n" or c == "\r" then pos = pos + 1 else break end
        end
    end
    local function parseString()
        pos = pos + 1
        local buf = {}
        while pos <= len do
            local c = str:sub(pos, pos)
            if c == '"' then pos = pos + 1; return table.concat(buf) end
            if c == "\\" then
                pos = pos + 1
                local e = str:sub(pos, pos)
                if e == "n" then buf[#buf + 1] = "\n"
                elseif e == "t" then buf[#buf + 1] = "\t"
                elseif e == "r" then buf[#buf + 1] = "\r"
                elseif e == "u" then
                    buf[#buf + 1] = string.char(tonumber(str:sub(pos + 1, pos + 4), 16) or 63)
                    pos = pos + 4
                else buf[#buf + 1] = e end
                pos = pos + 1
            else
                buf[#buf + 1] = c
                pos = pos + 1
            end
        end
        error("string nao terminada")
    end
    local function parseNumero()
        local inicio = pos
        while pos <= len do
            if str:sub(pos, pos):match("[%d%+%-%.eE]") then pos = pos + 1 else break end
        end
        local num = tonumber(str:sub(inicio, pos - 1))
        if not num then error("numero invalido") end
        return num
    end
    local function parseArray()
        pos = pos + 1
        local arr = {}
        skip()
        if str:sub(pos, pos) == "]" then pos = pos + 1; return arr end
        while true do
            skip()
            arr[#arr + 1] = parseValor()
            skip()
            local c = str:sub(pos, pos)
            if c == "," then pos = pos + 1
            elseif c == "]" then pos = pos + 1; return arr
            else error("array invalido") end
        end
    end
    local function parseObject()
        pos = pos + 1
        local obj = {}
        skip()
        if str:sub(pos, pos) == "}" then pos = pos + 1; return obj end
        while true do
            skip()
            local key = parseString()
            skip()
            if str:sub(pos, pos) ~= ":" then error("objeto invalido") end
            pos = pos + 1
            skip()
            obj[key] = parseValor()
            skip()
            local c = str:sub(pos, pos)
            if c == "," then pos = pos + 1
            elseif c == "}" then pos = pos + 1; return obj
            else error("objeto invalido") end
        end
    end
    parseValor = function()
        skip()
        local c = str:sub(pos, pos)
        if c == '"' then return parseString() end
        if c == "[" then return parseArray() end
        if c == "{" then return parseObject() end
        if str:sub(pos, pos + 3) == "true" then pos = pos + 4; return true end
        if str:sub(pos, pos + 4) == "false" then pos = pos + 5; return false end
        if str:sub(pos, pos + 3) == "null" then pos = pos + 4; return nil end
        return parseNumero()
    end
    local ok, res = pcall(function() skip(); return parseValor() end)
    if ok then return res end
    return nil, res
end

function Serializacao.paraJSON(tabela)
    return encode(tabela)
end

function Serializacao.deJSON(texto)
    return decode(texto)
end

-- Persistencia em arquivo via APIs do executor (placeholder quando indisponivel)
function Serializacao.salvar(tabela, caminho)
    if type(caminho) ~= "string" then return false, "caminho invalido" end
    local json = encode(tabela)
    if writefile then
        local ok, err = pcall(writefile, caminho, json)
        if ok then return true end
        return false, err
    end
    aviso("[Neural] salvar requer writefile do executor")
    return false, "writefile indisponivel"
end

function Serializacao.carregar(caminho)
    if type(caminho) ~= "string" then return nil, "caminho invalido" end
    if readfile then
        local ok, conteudo = pcall(readfile, caminho)
        if not ok then return nil, conteudo end
        local dados, err = decode(conteudo)
        if dados ~= nil then return dados end
        return nil, err
    end
    aviso("[Neural] carregar requer readfile do executor")
    return nil, "readfile indisponivel"
end

return Serializacao
