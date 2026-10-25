--!strict
-- Vessie Roblox Framework - StringUtils (6.2)
-- Utilitários para strings: formatação, validação, manipulação

local StringUtils = {}

-- Remover espaços em branco das extremidades
-- @param s string string a ser limpa
-- @return string limpa
function StringUtils.Trim(s: string): string
	return s:match("^%s*(.-)%s*$")
end

-- Dividir string por delimitador
-- @param s string string a dividir
-- @param delimiter string delimitador
-- @param plain boolean se true, busca literal; se false, padrão de Lua
-- @return {string} array de pedaços
function StringUtils.Split(s: string, delimiter: string, plain: boolean?): {string}
	local result: {string} = {}
	if delimiter == "" then
		-- Retornar cada caractere
		for i = 1, #s do
			table.insert(result, s:sub(i, i))
		end
		return result
	end
	local start: number = 1
	local lim: number = #delimiter + 1
	while true do
		local found: number, last = s:find(delimiter, start, plain)
		if found == nil then
			local sub = s:sub(start)
			if sub ~= "" then table.insert(result, sub) end
			break
		end
		table.insert(result, s:sub(start, found - 1))
		start = found + lim
	end
	return result
end

-- Juntar tabela de strings com separador
-- @param t {string} tabela de strings
-- @param separator string separador (padrão ", ")
-- @return string unida
function StringUtils.Join(t: {string}, separator: string?): string
	separator = separator or ", "
	if #t == 0 then return "" end
	if #t == 1 then return t[1] end
	return table.concat(t, separator)
end

-- Verificar se string começa com prefixo
-- @param s string string a verificar
-- @param prefix string prefixo
-- @return boolean
function StringUtils.StartsWith(s: string, prefix: string): boolean
	return s:sub(1, #prefix) == prefix
end

-- Verificar se string termina com sufixo
-- @param s string string a verificar
-- @param suffix string sufixo
-- @return boolean
function StringUtils.EndsWith(s: string, suffix: string): boolean
	return #suffix > 0 and s:sub(-#suffix) == suffix
end

-- Capitalizar primeira letra
-- @param s string string a capitalizar
-- @return string primeira letra maiúscula
function StringUtils.Capitalize(s: string): string
	if #s == 0 then return s end
	return s:sub(1, 1):upper() .. s:sub(2)
end

-- Converter para maiúsculas
-- @param s string
-- @return string maiúsculas
function StringUtils.Upper(s: string): string
	return s:upper()
end

-- Converter para minúsculas
-- @param s string
-- @return string minúsculas
function StringUtils.Lower(s: string): string
	return s:lower()
end

-- Format string typeado (similar a printf)
-- @param format string padrão de formatação
-- @param ... any argumentos
-- @return string formatada
function StringUtils.Format(format: string, ...): string
	return string.format(format, ...)
end

-- Validar e-mail (padrão simples)
-- @param email string
-- @return boolean válido
function StringUtils.IsEmail(email: string): boolean
	local pattern: string = "^[%w%.-]+@[%w%.-]+%.%w+$"
	return email:match(pattern) ~= nil
end

-- Validar número (inteiro ou decimal)
-- @param s string string a validar
-- @return boolean válido
function StringUtils.IsNumber(s: string): boolean
	local tonumber_result = tonumber(s)
	return tonumber_result ~= nil
end

-- Truncar string com sufixo
-- @param s string string original
-- @param maxLen number comprimento máximo
-- @param suffix string sufixo a adicionar quando truncado (padrão "...")
-- @return string truncada
function StringUtils.Truncate(s: string, maxLen: number, suffix: string?): string
	suffix = suffix or "..."
	if #s <= maxLen then return s end
	local available: number = maxLen - #suffix
	if available < 1 then return suffix:sub(1, maxLen) end
	return s:sub(1, available) .. suffix
end

-- Remover caracteres não alfanuméricos
-- @param s string string limpa
-- @return string apenas alfanumérico
function StringUtils.Alphanumeric(s: string): string
	return s:gsub("[^%w]", "")
end

-- Gerar identificador único (UUID simplificado baseado em timestamp)
-- @return string identificador único
function StringUtils.GenerateId(): string
	local template = "xxxxxxxx-xxxx-4xxx-Yxxx-xxxxxxxxxxxx"
	local map: {[string]: string} = {x = function() return math.random(0, 0xF) end, 
		Y = function() return math.random(8, 0xB) end}
	local id: string = template:gsub("[xY]", map)
	return id
end

-- Escape mágico para padrões de string
-- @param s string string com padrões
-- @return string padrão escapeado
function StringUtils.EscapePattern(s: string): string
	return s:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
end

return StringUtils