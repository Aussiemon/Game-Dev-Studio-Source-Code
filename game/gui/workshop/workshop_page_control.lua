local ctrl = {}

function ctrl:setScrollbar(scrl)
	self.scrollbar = scrl
end

function ctrl:getScrollbar()
	return self.scrollbar
end

function ctrl:initButtons(font)
	self.pageLabel = gui.create("Label", self)
	
	self.pageLabel:setFont(font)
	self:updatePageLabel()
	
	local buttonSize = self.rawH
	
	self.prevPage = gui.create("WorkshopPageControlButton", self)
	
	self.prevPage:setSize(buttonSize, buttonSize)
	self.prevPage:setPos(0, 0)
	self.prevPage:setIcon("previous")
	self.prevPage:setDirection(-1)
	
	self.nextPage = gui.create("WorkshopPageControlButton", self)
	
	self.nextPage:setSize(buttonSize, buttonSize)
	self.nextPage:setPos(self.w - _S(buttonSize), 0)
	self.nextPage:setIcon("previous")
	self.nextPage:setDirection(1)
end

function ctrl:getButtons()
	return self.prevPage, self.nextPage
end

function ctrl:updateSprites()
	self:setNextSpriteColor(0, 0, 0, 125)
	
	self.backSprite = self:allocateSprite(self.backSprite, "generic_1px", self.h * 0.5, 0, 0, self.rawW - self.h * 0.5, self.rawH, 0, 0, -0.1)
end

function ctrl:updatePageLabel()
	self.pageLabel:wrapText(self.w - self.h * 2, self.scrollbar:getPageText())
	self.pageLabel:setWidth(self.pageLabel:getTextWidth())
	self:updateLabelPosition()
end

function ctrl:updateLabelPosition()
	self.pageLabel:setPos(self.w * 0.5 - _US(self.pageLabel.w) * 0.5, self.h * 0.5 - self.pageLabel.h * 0.5)
end

gui.register("WorkshopPageControl", ctrl)
