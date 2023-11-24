function convertToBytes_4(i)
	return string.char(bit.band(bit.rshift(i, 24), 255)), string.char(bit.band(bit.rshift(i, 16), 255)), string.char(bit.band(bit.rshift(i, 8), 255)), string.char(bit.band(i, 255))
end

function convertToBytes_2(i)
	return string.char(bit.band(bit.rshift(i, 8), 255)), string.char(bit.band(i, 255))
end

function convertToBytes_1(i)
	return string.char(i)
end

function readBytes_1(str)
	return string.byte(str:read(1))
end

function readBytes_2(str)
	local s = str:read(2)
	
	if not s then
		return false
	end
	
	return bit.bor(bit.lshift(string.byte(s, 1), 8), string.byte(s, 2))
end

function readBytes_4(str)
	local s = str:read(4)
	
	if not s then
		return false
	end
	
	return bit.bor(bit.bor(bit.lshift(string.byte(s, 1), 24), bit.bor(bit.lshift(string.byte(s, 2), 16), bit.bor(bit.lshift(string.byte(s, 3), 8), string.byte(s, 4)))))
end

local cur = "cur"

function readBytes_1DM(str)
	b = str:read(1)
	
	str:seek(cur, -1)
	
	return string.byte(b)
end

function readBytes_2DM(str)
	local s = str:read(2)
	
	str:seek(cur - 2)
	
	if not s then
		return false
	end
	
	return bit.bor(bit.lshift(string.byte(s, 1), 8), string.byte(s, 2))
end

function readBytes_4DM(str)
	local s = str:read(4)
	
	str:seek(cur - 4)
	
	if not s then
		return false
	end
	
	return bit.bor(bit.bor(bit.lshift(string.byte(s, 1), 24), bit.bor(bit.lshift(string.byte(s, 2), 16), bit.bor(bit.lshift(string.byte(s, 3), 8), string.byte(s, 4)))))
end

function read_1DM(str)
	b = str:read(1)
	
	str:seek(cur, -1)
	
	return b
end

function read_2DM(str)
	b = str:read(2)
	
	str:seek(cur, -2)
	
	return b
end

function read_4DM(str)
	b = str:read(4)
	
	str:seek(cur, -4)
	
	return b
end

function writeBytes_1(stream, data)
	stream:write(convertToBytes_1(data))
end

function writeBytes_2(stream, data)
	stream:write(convertToBytes_2(data))
end

function writeBytes_4(stream, data)
	stream:write(convertToBytes_4(data))
end
