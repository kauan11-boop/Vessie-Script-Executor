--!strict
-- Vessie Roblox Framework - TableUtils (6.13)
-- Utilitários básicos para tabelas

local TableUtils = {}

-- Cópia rasa
function TableUtils.ShallowCopy(t)
	local copy = {}
	for k, v in pairs(t) do copy[k] = v end
	return copy
end

-- Cópia profunda (nível único)
function TableUtils.DeepCopy(t)
	local copy = {}
	for k, v in pairs(t) do
		if type(v) == "table" then
			copy[k] = TableUtils.DeepCopy(v)
		else
			copy[k] = v
		end
	end
	return copy
end

-- Mesclar source into target (shallow)
function TableUtils.Merge(target, source)
	local result = TableUtils.ShallowCopy(target)
	for k, v in pairs(source) do result[k] = v end
	return result
end

-- Filtrar por chaves
function TableUtils.Filter(t, keys)
	local filtered = {}
	for _, k in ipairs(keys) do if t[k] ~= nil then filtered[k] = t[k] end end
	return filtered
end

-- Encontrar valor com predicate
function TableUtils.Find(t, predicate)
	for k, v in pairs(t) do if predicate(v, k) then return v end end
	return nil
end

-- Contar itens
function TableUtils.Count(t, predicate)
	local n = 0
	for _, v in pairs(t) do if predicate then if predicate(v) then n = n + 1 end else n = n + 1 end end end
	return n
end

-- Verificar se vazia
function TableUtils.IsEmpty(t) return next(t) == nil end

-- Obter chaves
function TableUtils.GetKeys(t)
	local keys = {}
	for k in pairs(t) do table.insert(keys, k) end
	return keys
end

-- Obter valores
function TableUtils.GetValues(t)
	local vals = {}
	for _, v in pairs(t) do table.insert(vals, v) end
	return vals
end

-- Comparar profundo (simplificado)
function TableUtils.IsEqual(t1, t2)
	if type(t1) ~= type(t2) then return false end
	if next(t1) == nil and next(t2) == nil then return true end
	for k, v in pairs(t1) do
		if t2[k] == nil then return false end
		if type(v) ~= type(t2[k]) then return false end
		if type(v) == "table" and not TableUtils.IsEqual(v, t2[k]) then return false end
		if v ~= t2[k] then return false end
	end
	return true
end

return TableUtils