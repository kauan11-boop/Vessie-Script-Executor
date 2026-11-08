--[[
  Módulo de APIs - Vessie Script Executor
  Integração externa (HTTP/webhooks) e informações do executor/jogador/jogo.
  HTTP real é usado quando o executor expõe request; caso contrário, placeholder.
--]]

local API = {}

API.callbacks = API.callbacks or {}

-- Detecta a função de HTTP request exposta pelo executor
local function obterRequest()
    return (syn and syn.request)
        or (http and http.request)
        or (fluxus and fluxus.request)
        or http_request
        or request
end

local function temHttp()
    return obterRequest() ~= nil
end

function API:enviarWebhook(url, dados, metodo)
    metodo = metodo or "POST"
    local req = obterRequest()
    if not req then
        warn("[API] Webhook placeholder - executor sem função request")
        return { sucesso = false, mensagem = "Funcionalidade requer executor específico" }
    end
    local ok, resposta = pcall(function()
        local body = dados
        if game and game:GetService("HttpService") and type(dados) == "table" then
            body = game:GetService("HttpService"):JSONEncode(dados)
        end
        return req({ Url = url, Method = metodo, Body = body, Headers = { ["Content-Type"] = "application/json" } })
    end)
    if not ok then
        warn("[API] Falha no webhook: " .. tostring(resposta))
        return { sucesso = false, mensagem = tostring(resposta) }
    end
    return { sucesso = true, resposta = resposta }
end

function API:requisicaoGET(url)
    local req = obterRequest()
    if not req then warn("[API] GET placeholder") return nil end
    local ok, resposta = pcall(function() return req({ Url = url, Method = "GET" }) end)
    if not ok then warn("[API] GET falhou: " .. tostring(resposta)) return nil end
    return resposta and resposta.Body or resposta
end

function API:requisicaoPOST(url, dados)
    local resultado = self:enviarWebhook(url, dados, "POST")
    return resultado.sucesso and resultado.resposta or nil
end

function API:baixarArquivo(url, caminhoLocal)
    local corpo = self:requisicaoGET(url)
    if not corpo then return false end
    -- writefile é exposto pela maioria dos executores
    if writefile and caminhoLocal then
        local ok, err = pcall(writefile, caminhoLocal, corpo)
        if not ok then warn("[API] Falha ao salvar arquivo: " .. tostring(err)) return false end
        return true
    end
    warn("[API] Download requer writefile do executor")
    return false
end

function API:obterInfoExecutor()
    return {
        nomeExecutor = (identifyexecutor and identifyexecutor()) or "Executor Desconhecido",
        versao = "Desconhecido",
        arquitectura = "32/64 bits",
        rodandoNo = "Roblox Client Local",
        httpDisponivel = temHttp(),
    }
end

function API:obterInfoJogador(jogador)
    jogador = jogador or (game and game.Players and game.Players.LocalPlayer)
    if not jogador then return nil end
    return {
        nome = jogador.Name,
        userId = jogador.UserId,
        health = jogador.Character and jogador.Character:FindFirstChildOfClass("Humanoid") and jogador.Character:FindFirstChildOfClass("Humanoid").Health or nil,
        personagem = jogador.Character,
        equipe = jogador.Team,
    }
end

function API:obterInfoJogo()
    if not game then return nil end
    local nomeLugar = "Desconhecido"
    pcall(function()
        nomeLugar = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    end)
    return {
        placeId = game.PlaceId,
        lugar = nomeLugar,
        maxPlayers = game.Players.MaxPlayers,
        jogadoresAtuais = #game.Players:GetPlayers(),
        servidorAtual = game:GetService("RunService"):IsStudio() and "Studio" or "Online",
    }
end

function API:registrarCallback(evento, callback)
    if type(callback) ~= "function" then return false end
    API.callbacks[evento] = API.callbacks[evento] or {}
    table.insert(API.callbacks[evento], callback)
    return true
end

function API:dispararCallback(evento, ...)
    if API.callbacks[evento] then
        for _, callback in ipairs(API.callbacks[evento]) do
            local ok, err = pcall(callback, ...)
            if not ok then warn("[API] Callback erro: " .. tostring(err)) end
        end
    end
end

function API:tabelaParaJSON(tabela)
    return game:GetService("HttpService"):JSONEncode(tabela)
end

function API:JSONParaTabela(jsonString)
    local sucesso, resultado = pcall(function()
        return game:GetService("HttpService"):JSONDecode(jsonString)
    end)
    if sucesso then return resultado end
    warn("[API] Falha ao decodificar JSON: " .. tostring(resultado))
    return nil
end

return API