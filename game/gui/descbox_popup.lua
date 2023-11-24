local descboxPopup = {}

descboxPopup.extraInfoClass = "GenericDescbox"

function descboxPopup:init()
	gui.getClassTable("Frame").init(self)
	
	self.descboxOffset = 0
	self.extraInfo = gui.create(self.extraInfoClass, self)
	
	self.extraInfo:setShowRectSprites(false)
	self.extraInfo:setFadeInSpeed(0)
	
	self.leftDescbox = gui.create("GenericDescbox", self)
	
	self.leftDescbox:setShowRectSprites(false)
	self.leftDescbox:setFadeInSpeed(0)
	
	self.rightDescbox = gui.create("GenericDescbox", self)
	
	self.rightDescbox:setShowRectSprites(false)
	self.rightDescbox:setFadeInSpeed(0)
end

function descboxPopup:setDescboxOffset(off)
	self.descboxOffset = off
end

function descboxPopup:getExtraHeight()
	return self.descboxOffset
end

function descboxPopup:onSizeChanged()
	local boxWidth = (self.w - _S(10)) / 2
	
	self.leftDescbox:setWidth(boxWidth)
	self.rightDescbox:setWidth(boxWidth)
	self.extraInfo:setWidth(self.w - _S(10))
	
	self.descboxWidth = boxWidth
end

function descboxPopup:getDescboxes()
	return self.leftDescbox, self.rightDescbox, self.extraInfo
end

function descboxPopup:getExtraInfoDescbox()
	return self.extraInfo
end

function descboxPopup:updateButtonPositions(skipResize)
	self.leftDescbox:setPos(_S(4), self.h - _S(5) + _S(self.descboxOffset))
	self.rightDescbox:setPos(self.w * 0.5, self.leftDescbox.y)
	
	local maxHeight = math.max(self.rightDescbox:getHeight(), self.leftDescbox:getHeight())
	
	self.extraInfo:setPos(_S(5), self.leftDescbox.y + maxHeight)
	self.extraInfo:setWidth(self.rawW - _S(10))
	self:setHeight(self:getHeight() + math.dist(self.leftDescbox.y, self.extraInfo.y + self.extraInfo.h))
	descboxPopup.baseClass.updateButtonPositions(self, skipResize)
end

gui.register("DescboxPopup", descboxPopup, "Popup")
