--!strict
-- Vessie Roblox Framework - CollectionUtils
-- Estruturas de dados: filas, pilhas, conjuntos, tabelas ordenadas

local CollectionUtils = {}

-- Fila (FIFO)
function CollectionUtils.Queue()
	local items: {any} = {}
	local head, tail = 1, 0
	local obj = {}

	function obj:Enqueue(item: any): boolean
		tail = tail + 1
		items[tail] = item
		return true
	end

	function obj:Dequeue(): any
		if head > tail then return nil end
		local item = items[head]
		items[head] = nil
		head = head + 1
		return item
	end

	function obj:Peek(): any
		if head > tail then return nil end
		return items[head]
	end

	function obj:IsEmpty(): boolean
		return head > tail
	end

	function obj:Size(): number
		return tail - head + 1
	end

	return obj
end

-- Pilha (LIFO)
function CollectionUtils.Stack()
	local items: {any} = {}
	local top = 0
	local obj = {}

	function obj:Push(item: any): boolean
		top = top + 1
		items[top] = item
		return true
	end

	function obj:Pop(): any
		if top < 1 then return nil end
		local item = items[top]
		items[top] = nil
		top = top - 1
		return item
	end

	function obj:Peek(): any
		if top < 1 then return nil end
		return items[top]
	end

	function obj:IsEmpty(): boolean
		return top < 1
	end

	function obj:Size(): number
		return top
	end

	return obj
end

-- Conjunto (Set) - retorna um unico objeto
function CollectionUtils.Set()
	local hash: {[any]: boolean} = {}
	local list: {any} = {}
	local obj = {}

	function obj:Add(value: any): boolean
		if hash[value] then return false end
		hash[value] = true
		table.insert(list, value)
		return true
	end

	function obj:Remove(value: any): boolean
		if not hash[value] then return false end
		hash[value] = nil
		for i, v in ipairs(list) do
			if v == value then table.remove(list, i) break end
		end
		return true
	end

	function obj:Has(value: any): boolean
		return hash[value] == true
	end

	function obj:Size(): number
		return #list
	end

	function obj:IsEmpty(): boolean
		return #list == 0
	end

	function obj:ToList(): {any}
		local copy = {}
		for _, v in ipairs(list) do table.insert(copy, v) end
		return copy
	end

	function obj:Union(other: {[any]: boolean}): {[any]: boolean}
		local result: {[any]: boolean} = {}
		for v in pairs(hash) do result[v] = true end
		for v in pairs(other) do result[v] = true end
		return result
	end

	function obj:Intersect(other: {[any]: boolean}): {[any]: boolean}
		local result: {[any]: boolean} = {}
		for v in pairs(hash) do
			if other[v] then result[v] = true end
		end
		return result
	end

	return obj
end

-- Tabela ordenada por insercao (compare(a,b) = true se a vem antes de b)
function CollectionUtils.SortedTable(compare: (any, any) -> boolean)
	local items: {any} = {}
	local obj = {}

	function obj:Insert(value: any): number
		local index = #items + 1
		for i = 1, #items do
			if compare(value, items[i]) then index = i break end
		end
		table.insert(items, index, value)
		return index
	end

	function obj:Remove(value: any): boolean
		for i, v in ipairs(items) do
			if v == value then table.remove(items, i) return true end
		end
		return false
	end

	function obj:Get(index: number): any
		return items[index]
	end

	function obj:Size(): number
		return #items
	end

	function obj:IsEmpty(): boolean
		return #items == 0
	end

	function obj:Iterator()
		local i = 0
		return function()
			i = i + 1
			return items[i]
		end
	end

	return obj
end

-- Remover duplicatas mantendo ordem
function CollectionUtils.Deduplicate(list: {any}): {any}
	local seen: {[any]: boolean} = {}
	local result: {any} = {}
	for _, value in ipairs(list) do
		if not seen[value] then
			seen[value] = true
			table.insert(result, value)
		end
	end
	return result
end

-- Mesmos elementos ignorando ordem (com multiplicidade)
function CollectionUtils.SameElements(a: {any}, b: {any}): boolean
	if #a ~= #b then return false end
	local count: {[any]: number} = {}
	for _, v in ipairs(a) do count[v] = (count[v] or 0) + 1 end
	for _, v in ipairs(b) do
		if not count[v] or count[v] == 0 then return false end
		count[v] = count[v] - 1
	end
	return true
end

return CollectionUtils
