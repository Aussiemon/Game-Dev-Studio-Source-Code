local gameConventionPopup = {}

gameConventionPopup._scaleVert = false
gameConventionPopup.extraHeight = 0

function gameConventionPopup:setBaseHeight(h)
	self.baseHeight = _S(h)
end

function gameConventionPopup:getExtraHeight()
	return 0
end

local popupClass = gui.getClassTable("Popup")

function gameConventionPopup:updateButtonPositions(skipResize)
	self.leftDescbox:setPos(_S(4), self.baseHeight)
	self.rightDescbox:setPos(self.w * 0.5, self.leftDescbox.y)
	
	local maxHeight = math.max(self.rightDescbox:getHeight(), self.leftDescbox:getHeight())
	
	self.extraInfo:setPos(_S(5), self.leftDescbox.y + maxHeight)
	self.extraInfo:setWidth(self.rawW - _S(10))
	self:setHeight(self.extraInfo.y + self.extraInfo.h)
	popupClass.updateButtonPositions(self, skipResize)
end

gui.register("GameConventionResultPopup", gameConventionPopup, "DescboxPopup")
