local bookInventory = {}

function bookInventory:positionButtons()
	local w, h = self:getButtonSize()
	local startX = self:getGradientStartPosition()
	local buttonY = self:getButtonY() - _S(self.buttonPadVertical)
	
	self.bookBuy:setPos(startX, buttonY)
	self.bookBuy:setSize(w, h)
end

function bookInventory:createButtons()
	self.bookBuy = gui.create("BookAllocateButton", self)
	
	self.bookBuy:setFont(fonts.get("pix16"))
end

function bookInventory:updateButtons()
	if self.bookBuy then
		self.bookBuy:updateText()
	end
end

gui.register("BookInventoryElement", bookInventory, "BookPurchaseElement")
