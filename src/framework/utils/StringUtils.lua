--!strict
-- Vessie Roblox Framework - StringUtils
-- Utilitarios para strings: formatacao, validacao, manipulacao

local StringUtils = {}

function StringUtils.Trim(s: string): string
	return (s:match("^%s*(.-)%s*$"))
end

function StringUtils.Split(s: string, delimiter: string, plain: boolean?): {string}
	local result: {string} = {}
	if delimiter == "" then
		for i = 1, #s do table.insert(result, s:sub(i, i)) end
		return result
	end
	local start = 1
	while true do
		local found, last = s:find(delimiter, start, plain)
		if not found then
			local sub = s:sub(start)
			if sub ~= "" then table.insert(result, sub) end
			break
		end
		table.insert(result, s:sub(start, found - 1))
		start = last + 1
	end
	return result
end

function StringUtils.Join(t: {string}, separator: string?): string
	return table.concat(t, separator or ", ")
end

function StringUtils.StartsWith(s: string, prefix: string): boolean
	return s:sub(1, #prefix) == prefix
end

function StringUtils.EndsWith(s: string, suffix: string): boolean
	return suffix == "" or s:sub(-#suffix) == suffix
end

function StringUtils.Capitalize(s: string): string
	if #s == 0 then return s end
	return s:sub(1, 1):upper() .. s:sub(2)
end

function StringUtils.Upper(s: string): string
	return s:upper()
end

function StringUtils.Lower(s: string): string
	return s:lower()
end

function StringUtils.Format(format: string, ...): string
	return string.format(format, ...)
end

function StringUtils.IsEmail(email: string): boolean
	return email:match("^[%w%.-]+@[%w%.-]+%.%w+$") ~= nil
end

function StringUtils.IsNumber(s: string): boolean
	return tonumber(s) ~= nil
end

function StringUtils.Truncate(s: string, maxLen: number, suffix: string?): string
	suffix = suffix or "..."
	if #s <= maxLen then return s end
	local available = maxLen - #suffix
	if available < 1 then return suffix:sub(1, maxLen) end
	return s:sub(1, available) .. suffix
end

function StringUtils.Alphanumeric(s: string): string
	return (s:gsub("[^%w]", ""))
end

function StringUtils.GenerateId(): string
	local template = "xxxxxxxx-xxxx-4xxx-Yxxx-xxxxxxxxxxxx"
	local id = template:gsub("[xY]", function(c)
		if c == "x" then
			return string.format("%x", math.random(0, 15))
		end
		return string.format("%x", math.random(8, 11))
	end)
	return id
end

function StringUtils.EscapePattern(s: string): string
	return (s:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1"))
end

return StringUtils
