inventorySlot = {}
inventorySlot.mtindex = {
	__index = inventorySlot
}

function inventorySlot.new(id, amt, pref, suff)
	local slot = {}
	
	setmetatable(slot, inventorySlot.mtindex)
	slot:init(id, amt, pref, suff)
	
	return slot
end

function inventorySlot:init(id, amt, pref, suff)
	self.id = id or 0
	self.amt = amt or 0
	self.pref = pref or 0
	self.post = suff or 0
end

function inventorySlot:setItem(id, amt, prefix, suffix)
	self.id = id
	self.amt = amt or self.amt
	self.pref = prefix or self.pref
	self.post = suffix or self.post
end

function inventorySlot:setItemID(id)
	self.id = id
end

function inventorySlot:setItemAmount(amt)
	self.amt = amt
end

function inventorySlot:setPrefix(prefix)
	self.pref = prefix
end

function inventorySlot:setSuffix(suffix)
	self.post = suffix
end

function inventorySlot:setCustomVariable(name, value)
	if not self.customVariables then
		self.customVariables = {}
	end
	
	self[name] = value
	self.customVariables[name] = true
end

function inventorySlot:getCustomVariable(name)
	if not self.customVariables then
		return nil
	end
	
	return self.customVariables[name]
end

local varEnd = "\""
local slotEnd = "'"

function inventorySlot:saveToFile(stream)
	local id1, id2 = convertToBytes_2(self.id)
	local amt1, amt2 = convertToBytes_2(self.amt)
	local pref = convertToBytes_1(self.pref and self.pref or 0)
	local post = convertToBytes_1(self.post and self.post or 0)
	
	stream:write(id1, id2, amt1, amt2, pref, post)
	
	if self.customVariables then
		for varName, value in pairs(self.customVariables) do
			stream:write(varName, varEnd, convertToBytes_2(self[varName]))
		end
	end
	
	stream:write(slotEnd)
end

local readLetters = {}

function inventorySlot:loadFromFile(stream)
	self.id = stream:readTwoBytes()
	self.amt = stream:readTwoBytes()
	self.pref = stream:readByte()
	self.post = stream:readByte()
	
	table.clear(readLetters)
	
	while true do
		local sign = stream:read(1)
		
		if sign == slotEnd then
			return 
		elseif sign == varEnd then
			local varName = table.concat(readLetters)
			local value = stream:readTwoBytes()
			
			self:setCustomVariable(varName, value)
		else
			readLetters[#readLetters + 1] = sign
		end
	end
end
