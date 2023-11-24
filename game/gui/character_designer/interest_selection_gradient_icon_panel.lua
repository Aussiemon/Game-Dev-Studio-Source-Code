local interestSelectionGradient = {}

interestSelectionGradient.availableAttributePointsTextColor = color(228, 255, 201, 255)
interestSelectionGradient.unavailableAttributePointsTextColor = color(255, 255, 255, 255)
interestSelectionGradient.backdropSize = 24
interestSelectionGradient.iconSize = 24
interestSelectionGradient.backdropVisible = false
interestSelectionGradient.textPad = 0
interestSelectionGradient.DEFAULT_HOVER_TEXT = _T("CLICK_TO_SELECT_INTEREST", "Click to open list of selectable interests.\n\nInterests are optional and provide knowledge in various aspects, which is passively used to increase game quality.\nIf interests aren't filled up, then the player character will gain interests over time depending on what team building activities are being organized.")
interestSelectionGradient.hoverText = interestSelectionGradient.DEFAULT_HOVER_TEXT

function interestSelectionGradient:init(employee)
	self.employee = employee
end

function interestSelectionGradient:handleEvent(event, employee)
	if event == developer.EVENTS.INTEREST_ADDED or event == developer.EVENTS.INTEREST_REMOVED then
		self:updateText()
	end
end

function interestSelectionGradient:onSelectInterest(interestData)
	local employee = self.employee
	local prevInterest = self.selectedInterest
	
	if prevInterest then
		employee:removeInterest(prevInterest)
	end
	
	employee:addInterest(interestData.id)
	self:setSelectedInterest(interestData.id)
end

function interestSelectionGradient:onDeselectInterest()
	local employee = self.employee
	local prevInterest = self.selectedInterest
	
	if prevInterest then
		employee:removeInterest(prevInterest)
	end
	
	self:setSelectedInterest(nil)
end

function interestSelectionGradient:setSelectedInterest(interest)
	self.selectedInterest = interest
	
	self:updateText()
	
	if interest then
		local interestData = interests:getData(interest)
		
		self:setHoverText(interestData.description)
	else
		self:setHoverText(interestSelectionGradient.DEFAULT_HOVER_TEXT)
	end
end

function interestSelectionGradient:getSelectedInterest()
	return self.selectedInterest
end

function interestSelectionGradient:setEmployee(employee)
	self.employee = employee
end

function interestSelectionGradient:getEmployee()
	return self.employee
end

function interestSelectionGradient:updateSprites()
	self.iconBackdropSprite = self.iconBackdropSprite or self:pureAllocateSprite("profession_backdrop", -0.1)
	
	interestSelectionGradient.baseClass.updateSprites(self)
end

function interestSelectionGradient:updateText()
	if self.selectedInterest then
		local interestData = interests:getData(self.selectedInterest)
		
		self.text = interestData.display
		
		self:setIcon(interestData.quad)
		
		self.backdropVisible = true
	else
		self.text = _T("INTEREST_AVAILABLE", "Unassigned")
		
		self:setIcon("no_task")
		
		self.backdropVisible = false
	end
	
	self:updateTextDimensions()
end

function interestSelectionGradient:onClick(x, y, key)
	local localX, localY = self:getPos(true)
	
	interests:createInterestSelectionPopup(self.employee, self)
	self:killDescBox()
	self:queueSpriteUpdate()
end

gui.register("InterestSelectionGradientIconPanel", interestSelectionGradient, "GradientIconPanel")
