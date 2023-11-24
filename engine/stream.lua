stream = {}
stream.mtindex = {
	__index = stream
}

function stream.open(file, mode)
	local object = {}
	
	setmetatable(object, stream.mtindex)
	
	object.io = io.open(file, mode)
	object.readData = object.io:read("*all")
	object.pos = 1
	
	return object
end

function stream:close()
	self.io:close()
	
	self.io = nil
	self.readData = nil
end

function stream:write(...)
	self.io:write(...)
end

function stream:flush()
	self.io:flush()
end

function stream:seek(offset)
	self.pos = self.pos + offset
end

function stream:read(amount)
	self.io:seek("set", self.pos - 1)
	
	self.pos = self.pos + amount
	
	return self.io:read(amount)
end

function stream:readByte()
	self.pos = self.pos + 1
	
	return self.readData:byte(self.pos - 1)
end

function stream:readTwoBytes()
	self.pos = self.pos + 2
	
	return bit.bor(bit.lshift(string.byte(self.readData, self.pos - 2), 8), string.byte(self.readData, self.pos - 1))
end

function stream:readFourBytes()
	self.pos = self.pos + 4
	
	return bit.bor(bit.lshift(string.byte(self.readData, self.pos - 4), 24), bit.lshift(string.byte(self.readData, self.pos - 3), 16), bit.lshift(string.byte(self.readData, self.pos - 2), 8), string.byte(self.readData, self.pos - 1))
end

function stream:readFloat32()
	local raw = self:readFourBytes()
	local fr, exp = bit.band(raw, 8388607), bit.band(bit.rshift(raw, 23), 255)
	
	if exp ~= 0 then
		fr = fr + 8388608
	else
		exp = 1
	end
	
	exp = exp - 128 + 1
	exp = exp - 23
	
	return math.ldexp(fr, exp) * (bit.band(raw, 2147483648) ~= 0 and -1 or 1)
end

function stream:readBlockData()
	self.pos = self.pos + 4
	
	return self.readData:byte(self.pos - 4), self.readData:byte(self.pos - 3), self.readData:byte(self.pos - 2), self.readData:byte(self.pos - 1)
end

function stream:readEntityData()
	return self:readTwoBytes(), self:readTwoBytes(), self:readTwoBytes()
end

function stream:convertToByte(i)
	return string.char(i)
end

function stream:convertToTwoBytes(i)
	return string.char(bit.band(bit.rshift(i, 8), 255)), string.char(bit.band(i, 255))
end

function stream:convertToFourBytes(i)
	return string.char(bit.band(bit.rshift(i, 24), 255)), string.char(bit.band(bit.rshift(i, 16), 255)), string.char(bit.band(bit.rshift(i, 8), 255)), string.char(bit.band(i, 255))
end

function stream:writeByte(i)
	self.io:write(string.char(i))
end

function stream:writeTwoBytes(i)
	self.io:write(string.char(bit.band(bit.rshift(i, 8), 255)), string.char(bit.band(i, 255)))
end

function stream:writeFourBytes(i)
	self.io:write(string.char(bit.band(bit.rshift(i, 24), 255)), string.char(bit.band(bit.rshift(i, 16), 255)), string.char(bit.band(bit.rshift(i, 8), 255)), string.char(bit.band(i, 255)))
end

function stream:writeFloat32(f)
	local sign = f < 0 or 1 / f == -math.huge
	local fr, exp = math.frexp(math.abs(f))
	local bias = 127
	
	if f == 0 then
		fr = 0
		exp = 0
	else
		if exp + bias <= 1 then
			fr = fr * 2^(23 + exp + bias - 1)
			exp = -bias
		else
			fr = fr - 0.5
			exp = exp - 1
			fr = fr * 16777216
		end
		
		exp = exp + bias
	end
	
	self:writeFourBytes(bit.bor(sign and 2147483648 or 0, bit.lshift(exp, 23), fr))
end
