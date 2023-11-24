local interestSelectionButton = {}

interestSelectionButton.iconSize = 40

function interestSelectionButton:init()
	self.descriptionBox = gui.create("GenericDescbox", self)
	
	self.descriptionBox:setPos(0, _S(3))
	self.descriptionBox:setFadeInSpeed(0)
	self.descriptionBox:setShowRectSprites(false)
	self.descriptionBox:overwriteDepth(10)
end

function interestSelectionButton:setSelectionElement(element)
	self.selectionElement = element
end

function interestSelectionButton:onMouseEntered()
	interestSelectionButton.baseClass.onMouseEntered(self)
	
	local box = gui:getElementByID(interests.INTEREST_INFO_DESCBOX_ID)
	
	box:removeAllText()
	box:show()
	knowledge:setupContributionDisplay(self.interestData.knowledgeContributions, box, 350)
	self.interestData:setupContributionDisplay(box, 350)
	
	if #box:getTextEntries() == 0 then
		box:hide()
	end
end

function interestSelectionButton:onMouseLeft()
	interestSelectionButton.baseClass.onMouseLeft(self)
	
	local box = gui:getElementByID(interests.INTEREST_INFO_DESCBOX_ID)
	
	box:removeAllText()
	box:hide()
end

function interestSelectionButton:setInterest(data)
	self.interestData = data
	
	local wrapWidth = self.rawW - (self.iconSize + 10)
	
	self.descriptionBox:addTextLine(_S(wrapWidth), gui.genericMainGradientColor, nil, "weak_gradient_horizontal")
	self.descriptionBox:addText(data.display, "bh22", nil, 3, wrapWidth)
	self.descriptionBox:addTextLine(_S(wrapWidth), gui.genericGradientColor, nil, "weak_gradient_horizontal")
	self.descriptionBox:addText(data.description, "pix18", nil, 0, wrapWidth)
	self:setHeight(math.max(self.rawH, _US(self.descriptionBox.rawH) + 6))
end

function interestSelectionButton:updateSprites()
	interestSelectionButton.baseClass.updateSprites(self)
	
	local iconSize = self.iconSize
	local scaledIcon = _S(iconSize)
	
	self:setNextSpriteColor(0, 0, 0, 100)
	
	self.underIconSprite = self:allocateSprite(self.underIconSprite, "generic_1px", self.w - scaledIcon - _S(4), _S(2), 0, iconSize + 2, iconSize + 2, 0, 0, -0.05)
	self.iconSprite = self:allocateSprite(self.iconSprite, self.interestData.quad, self.w - scaledIcon - _S(3), _S(3), 0, iconSize, iconSize, 0, 0, -0.04)
end

function interestSelectionButton:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		self.selectionElement:onSelectInterest(self.interestData)
		self.basePanel:kill()
	end
end

gui.register("InterestSelectionButton", interestSelectionButton, "GenericElement")
