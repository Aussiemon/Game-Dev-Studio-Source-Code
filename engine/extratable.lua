table.sortl = require("engine/qsort")

function table.count(t)
	local amt = 0
	
	for k, v in pairs(t) do
		amt = amt + 1
	end
	
	return amt
end

function table.hasValue(t, val)
	for k, v in pairs(t) do
		if v == val then
			return true
		end
	end
	
	return false
end

function table.average(list)
	local total = 0
	
	for key, value in pairs(list) do
		total = total + value
	end
	
	return total / #list
end

function table.removeObject(list, object)
	for key, otherObject in ipairs(list) do
		if otherObject == object then
			table.remove(list, key)
			
			return true, key
		end
	end
	
	return false, nil
end

function table.reuse(desiredTable)
	return desiredTable or {}
end

function table.find(list, object)
	for key, otherObject in ipairs(list) do
		if otherObject == object then
			return key
		end
	end
	
	return nil
end

function table.removeDuplicates(list, targetObject)
	local curIndex = 1
	local duplicatesRemoved = 0
	local original
	
	for key, object in ipairs(list) do
		if targetObject == object then
			if not original then
				original = targetObject
				curIndex = curIndex + 1
			else
				table.remove(list, curIndex)
				
				duplicatesRemoved = duplicatesRemoved + 1
			end
		else
			curIndex = curIndex + 1
		end
	end
	
	return duplicatesRemoved
end

table.removeduplicates = table.removeDuplicates

function table.copyOver(from, to)
	for a, b in pairs(from) do
		to[a] = b
	end
	
	return to
end

table.copyover = table.copyOver

function table.insertContents(from, to)
	for a, b in pairs(from) do
		table.insert(to, b)
	end
	
	return to
end

table.insertcontents = table.insertContents

function table.apply(list, ...)
	for i = 1, select("#", ...) do
		local cur = select(i, ...)
		
		list[i] = cur
	end
end

function table.getTableWithMostIndexes(...)
	local highest = 0
	local object
	
	for i = 1, select("#", ...) do
		local cur = select(i, ...)
		
		if highest < #cur then
			highest = #cur
			object = cur
		end
	end
	
	return object, highest
end

function table.reverse(list)
	local newList = {}
	local position = 1
	
	for i = #list, 1, -1 do
		newList[i] = list[position]
		position = position + 1
	end
	
	return newList
end

function table.initialize(object)
	if not object then
		return {}
	end
	
	return table.clear(object)
end

local concatTable = {}

function table.concatEasy(concatenator, ...)
	concatenator = concatenator or ""
	
	table.clear(concatTable)
	
	for iter = 1, select("#", ...) do
		local cur = select(iter, ...)
		
		concatTable[#concatTable + 1] = cur
	end
	
	return table.concat(concatTable, concatenator)
end

local longConcatTable = {}

function table.concatlongstring(spacingConcat, firstConcat, nthConcat, lastConcat, getProperArticle, ...)
	table.clear(longConcatTable)
	
	local amount = select("#", ...)
	
	table.inserti(longConcatTable, firstConcat)
	
	local cur = select(1, ...)
	
	if getProperArticle then
		table.inserti(longConcatTable, string.article(cur))
		table.inserti(longConcatTable, " ")
	end
	
	table.inserti(longConcatTable, cur)
	
	if amount > 2 then
		for iter = 2, amount - 1 do
			table.inserti(longConcatTable, nthConcat)
			
			local cur = select(iter, ...)
			
			table.inserti(longConcatTable, cur)
		end
	end
	
	if amount > 1 then
		table.inserti(longConcatTable, lastConcat)
		
		local cur = select(amount, ...)
		
		if getProperArticle then
			table.inserti(longConcatTable, string.article(cur))
			table.inserti(longConcatTable, " ")
		end
		
		table.inserti(longConcatTable, cur)
	end
	
	return table.concat(longConcatTable, spacingConcat)
end

table.concatLongString = table.concatlongstring

function table.random(t, count)
	count = count or table.count(t)
	
	local rand = math.random(1, count)
	local num = 0
	
	for k, v in pairs(t) do
		num = num + 1
		
		if num == rand then
			return v, k
		end
	end
end

function table.inserti(t, c)
	local total = #t
	local position = total + 1
	
	t[position] = c
	
	return position
end

function table.randomi(list)
	local randomPos = math.random(1, #list)
	
	return list[randomPos], randomPos
end

function table.incrementValue(t, i)
	if t[i] then
		t[i] = t[i] + 1
	else
		t[i] = 1
	end
end

local grab

function table.grab(t)
	grab = nil
	
	if t[1] then
		grab = t[1]
		
		table.remove(t, 1)
	end
	
	return grab
end

function table.clear(tbl)
	for k, v in pairs(tbl) do
		tbl[k] = nil
	end
	
	return tbl
end

function table.clearArray(tbl)
	for i = 1, #tbl do
		tbl[i] = nil
	end
end

function table.copy(list)
	local new = {}
	
	for key, value in pairs(list) do
		local data = value
		
		if type(data) == "table" then
			data = table.copy(data)
		end
		
		new[key] = data
	end
	
	return new
end

function table.print(list, tabs)
	if tabs == 0 then
		print(list)
	end
	
	for key, value in pairs(list) do
		local myTabs = tabs or 1
		
		if type(value) == "table" then
			print(string.rep("\t", myTabs) .. key .. " (" .. tostring(value) .. ") :")
			
			myTabs = myTabs + 1
			
			table.print(value, myTabs)
		else
			print(string.rep("\t", myTabs) .. key .. " = " .. tostring(value))
		end
	end
end
