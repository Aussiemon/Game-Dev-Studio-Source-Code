local pageCtrlButton = {}

pageCtrlButton.icon = "previous"

function pageCtrlButton:setDirection(dir)
	self.direction = dir
end

function pageCtrlButton:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		self.parent:getScrollbar():changePage(self.direction)
	end
end

function pageCtrlButton:updateSprites()
	local x, w
	
	if self.direction > 0 then
		x = _S(self.rawW)
		w = -self.rawW
	else
		x = 0
		w = self.rawW
	end
	
	self:setNextSpriteColor(self:getSpriteColor():unpack())
	
	self.spriteSlot = self:allocateSprite(self.spriteSlot, self.icon, x, 0, 0, w, self.rawH, 0, 0, -0.4)
end

gui.register("WorkshopPageControlButton", pageCtrlButton, "IconButton")
