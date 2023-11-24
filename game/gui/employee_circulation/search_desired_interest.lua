local desiredInterestButton = {}

function desiredInterestButton.selectInterestCallback(option)
	option.mainElement:setSelectedInterest(option.interestID)
end

function desiredInterestButton.unassignInterestCallback(option)
	option.mainElement:setSelectedInterest(nil)
end

function desiredInterestButton:setSearchData(data)
	self.searchData = data
end

function desiredInterestButton:setSelectedInterest(id)
	if self.selectedInterest then
		table.removeObject(self.searchData.interests, self.selectedInterest)
	end
	
	self.selectedInterest = id
	
	if id then
		table.insert(self.searchData.interests, id)
	end
	
	self:updateText()
	self:queueSpriteUpdate()
	events:fire(employeeCirculation.EVENTS.ADJUSTED_SEARCH_PARAMETER, self.searchData)
end

function desiredInterestButton:setUnassignedText(text)
	self.unassignedText = text
end

function desiredInterestButton:updateText()
	if self.selectedInterest then
		self:setText(interests.registeredByID[self.selectedInterest].display)
	else
		self:setText(self.unassignedText)
	end
end

function desiredInterestButton:updateTextPosition()
	self.textX = self.h + _S(3)
end

function desiredInterestButton:removeInterest(id)
	table.removeObject(self.searchData.interests, id)
end

function desiredInterestButton:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		return 
	end
	
	local localX, localY = self:getPos(true)
	
	interactionController:setInteractionObject(self, localX, localY + self.h, true)
	
	local comboBox = interactionController:getComboBox()
	
	comboBox:setWidth(self.w)
	comboBox:scaleToWidestOption(true)
end

function desiredInterestButton:updateSprites()
	desiredInterestButton.baseClass.updateSprites(self)
	
	if self.selectedInterest then
		self.interestSprite = self:allocateSprite(self.interestSprite, interests.registeredByID[self.selectedInterest].quad, _S(3), _S(3), 0, self.rawH - 6, self.rawH - 6, 0, 0, -0.1)
	else
		self.interestSprite = self:allocateSprite(self.interestSprite, "question_mark", _S(3), _S(3), 0, self.rawH - 6, self.rawH - 6, 0, 0, -0.1)
	end
end

function desiredInterestButton:fillInteractionComboBox(combobox)
	local option = combobox:addOption(0, 0, 0, 24, _T("UNASSIGN_TRAIT", "None"), fonts.get("pix20"), self.unassignInterestCallback)
	
	option.mainElement = self
	
	for key, interestData in ipairs(interests.registered) do
		if interestData.selectableForSearch and not table.find(self.searchData.interests, interestData.id) then
			local option = combobox:addOption(0, 0, 0, 24, interestData.display, fonts.get("pix20"), self.selectInterestCallback)
			
			option.interestID = interestData.id
			option.mainElement = self
			
			option:setHoverText(interestData.hoverText)
		end
	end
end

gui.register("SearchDesiredInterest", desiredInterestButton, "Button")

desiredInterestButton.alignment = desiredInterestButton.RIGHT
