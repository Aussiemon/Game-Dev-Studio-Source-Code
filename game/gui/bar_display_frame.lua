local barFrame = {}

barFrame.skinPanelFillColor = color(86, 104, 135, 200)
barFrame.barDisplayClass = "BarDisplay"

function barFrame:init()
	self:initSubElements()
end

function barFrame:initSubElements()
	self.leftInfo = gui.create("GenericDescbox", self)
	
	self.leftInfo:setShowRectSprites(false)
	self.leftInfo:overwriteDepth(10)
	self.leftInfo:setY(5)
	self.leftInfo:setFadeInSpeed(0)
	
	self.rightInfo = gui.create("GenericDescbox", self)
	
	self.rightInfo:setShowRectSprites(false)
	
	self.rightInfo.alignedToRight = true
	
	self.rightInfo:overwriteDepth(10)
	self.rightInfo:setFadeInSpeed(0)
	self:createBarDisplay()
end

function barFrame:saveData(saved)
	return saved
end

function barFrame:loadData(data)
end

function barFrame:createBarDisplay()
	self.barDisplay = gui.create(self.barDisplayClass, self)
end

function barFrame:cycleLineColor(descBox, wrapWidth)
	self.otherColor = not self.otherColor
	
	descBox:addTextLine(wrapWidth, self.otherColor and game.UI_COLORS.LINE_COLOR_ONE or game.UI_COLORS.LINE_COLOR_TWO)
end

function barFrame:updateDisplay()
	self.barDisplay:updateBars()
	
	if self:shouldRemoveRightText() then
		self.rightInfo:removeAllText()
	end
	
	self:_updateDisplay()
	self:updateRightDescboxPosition()
end

function barFrame:updateRightDescboxPosition()
	self.rightInfo:setX(self.w - self.rightInfo.w - _S(2))
end

function barFrame:_updateDisplay()
end

function barFrame:shouldRemoveRightText()
	return true
end

function barFrame:postUpdateDisplay()
	self.rightInfo:setX(self.w - self.rightInfo.w - _S(2))
end

function barFrame:getFillColor()
	return self.skinPanelFillColor:unpack()
end

function barFrame:updateSprites()
	local color = self:getStateColor()
	
	self:setNextSpriteColor(gui.genericOutlineColor:unpack())
	
	self.backSprite = self:allocateSprite(self.backSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
	
	self:setNextSpriteColor(self:getFillColor())
	
	self.foreSprite = self:allocateSprite(self.foreSprite, "vertical_gradient_75", _S(1), _S(1), 0, self.rawW - 2, self.rawH - 2, 0, 0, -0.1)
end

function barFrame:draw(w, h)
end

gui.register("BarDisplayFrame", barFrame)
