--!strict
-- Vessie Roblox Framework - CollectionUtils (6.6)
-- Estruturas de dados: filas, pilhas, conjuntos, tabelas ordenadas

local CollectionUtils = {}

-- Fila (FIFO) usando tabela
-- @return {enqueue: function, dequeue: function, peek: function, isEmpty: function}
function CollectionUtils.Queue<T>()
	local _internal: {T} = {}
	local _head: number = 1
	local _tail: number = 0

	function _internal:Enqueue(item: T): boolean
		_tail = _tail + 1
		self[_tail] = item
		return true
	end

	function _internal:Dequeue(): T?
		if _head > _tail then return nil end
		local item: T = self[_head]
		_head = _head + 1
		self[_head - 1] = nil -- limpar referência
		return item
	end

	function _internal:Peek(): T?
		if _head > _tail then return nil end
		return self[_head]
	end

	function _internal:IsEmpty(): boolean
		return _head > _tail
	end

	function _internal:Size(): number
		return _tail - _head + 1
	end

	return _internal
end

-- Pilha (LIFO) usando tabela
-- @return {push: function, pop: function, peek: function, isEmpty: function}
function CollectionUtils.Stack<T>()
	local _internal: {T} = {}
	local _top: number = 0

	function _internal:Push(item: T): boolean
		_top = _top + 1
		self[_top] = item
		return true
	end

	function _internal:Pop(): T?
		if _top < 1 then return nil end
		local item: T = self[_top]
		self[_top] = nil
		_top = _top - 1
		return item
	end

	function _internal:Peek(): T?
		if _top < 1 then return nil end
		return self[_top]
	end

	function _internal:IsEmpty(): boolean
		return _top < 1
	end

	function _internal:Size(): number
		return _top
	end

	return _internal
end

-- Conjuntos (Set) usando tabela como hash
-- @return {add: function, remove: function, has: function, size: function, union: function, intersect: function}
function CollectionUtils.Set<T>()
	local _internal: {[T]: boolean} = {}
	local _internal2: {T} = {}

	function _internal:Add(value: T): boolean
		if not _internal[value] then
			_internal[value] = true
			table.insert(_internal2, value)
			return true
		end
		return false -- já existe
	end

	function _internal:Remove(value: T): boolean
		if _internal[value] then
			_internal[value] = nil
			-- Remover da lista também
			for i, v: T: any in ipairs(_internal2) do
				if v == value then
					table.remove(_internal2, i)
					break
				end
			end
			return true
		end
		return false -- não existia
	end

	function _internal:Has(value: T): boolean
		return _internal[value] == true
	end

	function _internal:Size(): number
		return #_internal2
	end

	function _internal:IsEmpty(): boolean
		return #_internal2 == 0
	end

	function _internal:Union(other: {[T]: boolean}): {[T]: boolean}
		local result: {[T]: boolean} = table.clone(_internal)
		for value: T: any in pairs(other) do
			result[value] = (result[value] or false) or true
		end
		return result
	end

	function _internal:Intersect(other: {[T]: boolean]): {[T]: boolean}
		local result: {[T]: boolean} = {}
		for value: T: any in pairs(_internal) do
			if other[value] then
				result[value] = true
			end
		end
		return result
	end

	return _internal, _internal2
end

-- Tabela ordenada (SortedTable) baseada em inserção ordenada
-- @param compare function função de comparação (a, b -> boolean, onde true significa a vem antes de b)
-- @return {insert: function, remove: function, get: function, iterator: function}
function CollectionUtils.SortedTable<T>(compare: function): {any}
	local _internal: {T} = {}
	local _index: {[T]: number} = {}

	function _internal:Insert(value: T): number
		local index: number = #_internal + 1
		-- Encontrar posição correta
		for i = #_internal, 1, -1 do
			if compare(value, _internal[i]) then
				index = i
				break
			end
		end
		-- Inserir deslocando elementos
		for i = #_internal, index, -1 do
			_internal[i + 1] = _internal[i]
			_index[_internal[i]] = i + 1
		end
		_internal[index] = value
		_index[value] = index
		return index
	end

	function _internal:Remove(value: T): boolean
		local index: number = _index[value]
		if not index then return false end
		-- Remover e deslocar
		for i = index, #_internal - 1 do
			_internal[i] = _internal[i + 1]
			_index[_internal[i + 1]] = i
		end
		_internal[_internal[0] or #_internal] = nil -- limpar
		_index[value] = nil
		return true
	end

	function _internal:Get(index: number): T?
		if index < 1 or index > #_internal then return nil end
		return _internal[index]
	end

	function _internal:Size(): number
		return #_internal
	end

	function _internal:IsEmpty(): boolean
		return #_internal == 0
	end

	function _internal:Iterator(): iterator
		local i: number = 0
		return function()
			i = i + 1
			if i <= #_internal then
				return _internal[i]
			end
			return nil
		end
	end

	return _internal
end

-- Deduplicar tabela (remover valores repetidos mantendo ordem)
-- @param table {any} tabela
-- @return {any} tabela sem duplicatas
function CollectionUtils.Deduplicate<T>(table: {T}): {T}
	local seen: {[T]: boolean} = {}
	local result: {T} = {}

	for _, value: T: any in ipairs(table) do
		if not seen[value] then
			seen[value] = true
			table.insert(result, value)
		end
	end

	return result
end

-- Verificar se duas tabelas têm os mesmos elementos (ignorando ordem)
-- @param table1 {any}
-- @param table2 {any}
-- @return boolean sameElements
function CollectionUtils.SameElements<T>(table1: {T}, table2: {T}): boolean
	if #table1 ~= #table2 then return false end

	local count1: {[T]: number} = {}
	local count2: {[T]: number} = {}

	for _, v: T: any in ipairs(table1) do
		count1[v] = (count1[v] or 0) + 1
	end
	for _, v: T: any in ipairs(table2) do
		count2[v] = (count2[v] or 0) + 1
	end

	for k: T: any, c: number: any in pairs(count1) do
		if (count2[k] or 0) ~= c then return false end
	end

	return true
end

return CollectionUtils