local mmoExpand = {}

function mmoExpand:setDisplay(disp)
	self.display = disp
	
	self:tieVisibilityTo(self.display)
end

function mmoExpand:setMove(move)
	self.move = move
	self.moveOff = 0
end

function mmoExpand:think()
	if self.move then
		local x, y = self.display:getPos(true)
		
		self:setPos(x - self.w - _S(5) - self.w * math.sin(self.moveOff), y)
		
		if not self:isMouseOver() then
			self.moveOff = self.moveOff + frameTime * 2
			
			if self.moveOff >= math.pi then
				self.moveOff = self.moveOff - math.pi
			end
		end
	else
		local x, y = self.display:getPos(true)
		
		self:setPos(x - self.w - _S(5), y)
	end
end

function mmoExpand:updateSprites()
	self.iconSprite = self:allocateSprite(self.iconSprite, "generic_pointer", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.5)
end

function mmoExpand:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		self.display:startInteraction()
	end
end

gui.register("ExpandMMOOptionsButton", mmoExpand)
