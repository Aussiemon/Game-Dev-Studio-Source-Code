multiText = {}
multiText.mtindex = {
	__index = multiText
}

function multiText.new(font)
	local new = {}
	
	setmetatable(new, multiText.mtindex)
	new:init(font)
	
	return new
end

function multiText:init(font)
	self.entries = {}
	self.text = love.graphics.newText(font)
end

local textSetup = {
	{}
}

function multiText:addText(text, drawColor, x, y, angle, sx, sy, ox, oy, kx, ky)
	local realText
	
	if type(text) == "table" then
		for key, data in ipairs(text) do
			self:addText(data[1], data[2])
		end
	else
		realText = text
	end
	
	self.totalText = self.totalText .. realText
	
	local colorTable = textSetup[1]
	
	colorTable[1], colorTable[2], colorTable[3], colorTable[4] = drawColor:unpack()
	textSetup[2] = text
	
	table.clearArray(textSetup)
end

function multiText:rebuildText()
	self.text:clear()
end
