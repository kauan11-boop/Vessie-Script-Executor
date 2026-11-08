--!strict
-- Vessie Roblox Framework - TableUtils
-- Utilitários básicos para tabelas (cópia, merge, busca, comparação profunda)

local TableUtils = {}

function TableUtils.ShallowCopy(t)
	local copy = {}
	for k, v in pairs(t) do copy[k] = v end
	return copy
end

-- Cópia profunda com proteção contra ciclos
function TableUtils.DeepCopy(t, seen)
	if type(t) ~= "table" then return t end
	seen = seen or {}
	if seen[t] then return seen[t] end
	local copy = {}
	seen[t] = copy
	for k, v in pairs(t) do
		copy[TableUtils.DeepCopy(k, seen)] = TableUtils.DeepCopy(v, seen)
	end
	return copy
end

function TableUtils.Merge(target, source)
	local result = TableUtils.ShallowCopy(target)
	for k, v in pairs(source) do result[k] = v end
	return result
end

function TableUtils.Filter(t, keys)
	local filtered = {}
	for _, k in ipairs(keys) do
		if t[k] ~= nil then filtered[k] = t[k] end
	end
	return filtered
end

function TableUtils.Find(t, predicate)
	for k, v in pairs(t) do
		if predicate(v, k) then return v end
	end
	return nil
end

function TableUtils.Count(t, predicate)
	local n = 0
	for _, v in pairs(t) do
		if not predicate or predicate(v) then n = n + 1 end
	end
	return n
end

function TableUtils.IsEmpty(t)
	return next(t) == nil
end

function TableUtils.GetKeys(t)
	local keys = {}
	for k in pairs(t) do table.insert(keys, k) end
	return keys
end

function TableUtils.GetValues(t)
	local vals = {}
	for _, v in pairs(t) do table.insert(vals, v) end
	return vals
end

-- Comparação profunda (ciclo-segura, verifica ambos os lados)
function TableUtils.IsEqual(t1, t2, seen)
	if t1 == t2 then return true end
	if type(t1) ~= "table" or type(t2) ~= "table" then return false end
	seen = seen or {}
	if seen[t1] then return true end
	seen[t1] = true
	for k, v in pairs(t1) do
		if not TableUtils.IsEqual(v, t2[k], seen) then return false end
	end
	for k in pairs(t2) do
		if t1[k] == nil then return false end
	end
	return true
end

return TableUtils