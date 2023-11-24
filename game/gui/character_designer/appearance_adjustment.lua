local appearanceAdjustment = {}

gui.skinTextFillColor = color(200, 200, 200, 255)
gui.skinTextHoverColor = color(255, 255, 255, 255)
gui.skinTextDisableColor = color(140, 140, 140, 255)
appearanceAdjustment.CATCHABLE_EVENTS = {
	portrait.EVENTS.APPEARANCE_CHANGED
}

function appearanceAdjustment:init()
	self.font = fonts.get("pix20")
	self.currentIndex = 0
	self.currentColorIndex = 0
end

function appearanceAdjustment:setFemale(female)
	self.female = female
end

function appearanceAdjustment:initializeAdjustmentButtons(buttonClass)
	buttonClass = buttonClass or "AppearanceAdjustmentButton"
	self.nextButton = gui.create(buttonClass, self)
	
	self.nextButton:setFemale(self.female)
	self.nextButton:setDirection(1)
	self.nextButton:setSize(24, 24)
	
	self.previousButton = gui.create(buttonClass, self)
	
	self.previousButton:setFemale(self.female)
	self.previousButton:setDirection(-1)
	self.previousButton:setSize(24, 24)
	self:positionAdjustmentButtons()
end

function appearanceAdjustment:getPartList()
	if self.female then
		return portrait.registeredDataByPart.female
	end
	
	return portrait.registeredDataByPart.male
end

function appearanceAdjustment:disableClicks()
	self.nextButton:setCanClick(false)
	self.nextButton:queueSpriteUpdate()
	self.previousButton:setCanClick(false)
	self.previousButton:queueSpriteUpdate()
	
	if self.colorAdjustment then
		self.colorAdjustment:setCanClick(false)
		self.colorAdjustment:queueSpriteUpdate()
	end
end

function appearanceAdjustment:verifyValidity()
	local currentIndex = self.currentIndex
	local partType = self.nextButton:getPartType()
	local partList = self:getPartList()[partType]
	
	if not partList then
		self.nextButton:setCanClick(false)
		self:disableClicks()
		
		return 
	end
	
	local portraitObj = self.employee:getPortrait()
	
	if currentIndex ~= 0 and not portraitObj:isValidForFace(partList[currentIndex]) then
		self.nextButton:clickedCallback(portraitObj)
	end
	
	local atLeastOneValid = false
	
	for key, data in ipairs(partList) do
		if portraitObj:isValidForFace(data) then
			atLeastOneValid = true
			
			break
		end
	end
	
	self.atLeastOneValid = atLeastOneValid
	
	if not atLeastOneValid then
		self.nextButton:setCanClick(false)
		self.nextButton:queueSpriteUpdate()
		self.previousButton:setCanClick(false)
		self.previousButton:queueSpriteUpdate()
		
		if self.colorAdjustment then
			self.colorAdjustment:setCanClick(false)
			self.colorAdjustment:queueSpriteUpdate()
		end
	else
		self.nextButton:setCanClick(true)
		self.nextButton:queueSpriteUpdate()
		self.previousButton:setCanClick(true)
		self.previousButton:queueSpriteUpdate()
		
		if self.colorAdjustment then
			self.colorAdjustment:setCanClick(true)
			self.colorAdjustment:queueSpriteUpdate()
		end
	end
end

function appearanceAdjustment:handleEvent(event, object, value)
	self:verifyValidity()
end

function appearanceAdjustment:setPartType(type)
	self.nextButton:setPartType(type)
	self.previousButton:setPartType(type)
end

function appearanceAdjustment:initializeColorAdjustmentButton(buttonClass)
	self.colorAdjustment = gui.create(buttonClass, self)
	
	self.colorAdjustment:setFemale(self.female)
	self.colorAdjustment:setDirection(1)
	self.colorAdjustment:setColorAdjustment(true)
	self.colorAdjustment:setSize(24, 24)
	self.colorAdjustment:setIconOverride("color_button")
end

function appearanceAdjustment:onSizeChanged()
	self:positionAdjustmentButtons()
	
	if self.text then
		self:updateTextDrawPosition()
	end
end

function appearanceAdjustment:positionAdjustmentButtons()
	if self.nextButton then
		self.nextButton:setPos(self.w - self.nextButton.w - _S(2), _S(2))
		self.previousButton:setPos(_S(2), _S(2))
	end
	
	if self.colorAdjustment then
		self.colorAdjustment:setPos(self.nextButton.x - _S(4) - self.colorAdjustment.w, _S(2))
	end
end

function appearanceAdjustment:setCurrentColorIndex(index)
	self.currentColorIndex = index
end

function appearanceAdjustment:getCurrentColorIndex()
	return self.currentColorIndex
end

function appearanceAdjustment:setCurrentPartIndex(index)
	self.currentIndex = index
end

function appearanceAdjustment:getCurrentPartIndex()
	return self.currentIndex
end

function appearanceAdjustment:setText(text)
	self.text = text
	self.textWidth = self.font:getWidth(text)
	
	self:updateTextDrawPosition()
end

function appearanceAdjustment:updateTextDrawPosition()
	self.textDrawX = self.w * 0.5 - self.textWidth * 0.5
	self.textDrawY = (self.h - self.font:getHeight()) * 0.5
end

function appearanceAdjustment:setEmployee(employee)
	self.employee = employee
	self.female = employee:isFemale()
end

function appearanceAdjustment:getEmployee()
	return self.employee
end

function appearanceAdjustment:updateSprites()
	self:setNextSpriteColor(0, 0, 0, 255)
	
	self.backgroundSprite = self:allocateSprite(self.backgroundSprite, "weak_gradient_horizontal", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
end

function appearanceAdjustment:isDisabled()
	return not self.atLeastOneValid
end

function appearanceAdjustment:draw(w, h)
	local pcol, tcol = self:getStateColor()
	
	love.graphics.setFont(self.font)
	love.graphics.printST(self.text, self.textDrawX, self.textDrawY, tcol.r, tcol.g, tcol.b, tcol.a, 0, 0, 0, 255)
end

gui.register("AppearanceAdjustment", appearanceAdjustment)
