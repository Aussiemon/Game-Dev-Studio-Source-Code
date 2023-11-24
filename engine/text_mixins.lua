local registry = debug.getregistry()

textClass = registry.Text
textClass.textLayout = {}
textClass.nextTextColor = {}
textClass.oldAdd = textClass.add

function textClass:setNextTextColor(r, g, b, a)
	table.apply(self.nextTextColor, r, g, b, a)
end

function textClass:add(text, ...)
	if type(text) ~= "table" then
		if #textClass.nextTextColor > 0 then
			textClass.textLayout[1] = textClass.nextTextColor
			textClass.textLayout[2] = text
			
			self:oldAdd(textClass.textLayout, ...)
			table.clearArray(textClass.nextTextColor)
			table.clear(textClass.textLayout)
		else
			self:oldAdd(text, ...)
		end
	else
		self:oldAdd(text, ...)
	end
end

function textClass:addShadowed(text, textColor, x, y, shadowOffset, angle, sx, sy, ox, oy, kx, ky)
	shadowOffset = math.max(1, math.floor(_S(shadowOffset or 1)))
	x, y = math.round(x), math.round(y)
	
	local clr = self.nextTextColor
	
	if #clr > 0 then
		self:setNextTextColor(clr[1], clr[2], clr[3], clr[4])
	else
		self:setNextTextColor(0, 0, 0, 255)
	end
	
	self:add(text, x + shadowOffset, y + shadowOffset, angle, sx, sy, ox, oy, kx, ky)
	
	if textColor then
		self:setNextTextColor(textColor:unpack())
	end
	
	self:add(text, x, y, angle, sx, sy, ox, oy, kx, ky)
end

function textClass:draw(x, y)
	x, y = math.round(x), math.round(y)
	
	love.graphics.draw(self, x, y)
end
