local platformList = {}

function platformList:init()
	events:addReceiver(self)
end

function platformList:kill()
	platformList.baseClass.kill(self)
	events:removeReceiver(self)
end

function platformList:handleEvent(event, proj)
	if event == gameProject.EVENTS.CHANGED_PRICE and proj == self.project then
		self.price = self.project:getPrice()
		
		self:updateText()
	end
end

function platformList:setPrice(price)
	self.price = price
	
	self.project:setPrice(price)
	self:updateText()
	self:updateElementHighlight()
end

function platformList:setProject(project)
	self.project = project
	
	self:updateText()
end

function platformList:getProject()
	return self.project
end

function platformList:onShow()
	self:updateText()
end

function platformList:isDisabled()
	return self.project:getContractor()
end

function platformList:updateText()
	if self.price then
		self:setText(_format(_T("PRICE_LAYOUT", "$PRICE"), "PRICE", self.price))
	else
		self:setText(_T("SELECT_PRICE", "Select price"))
	end
end

function platformList:onMouseEntered()
	platformList.baseClass.onMouseEntered(self)
	
	if self.project:getContractor() then
		self.descBox = gui.create("GenericDescbox")
		
		self.descBox:addText(_T("CANT_SELECT_GAME_PRICE_CONTRACTOR", "Contractors are in charge of the game price."), "bh20", nil, 0, 400, "question_mark", 24, 24)
		self.descBox:centerToElement(self)
	end
end

function platformList:updateElementHighlight()
	local elements = interactionController:getComboBox():getOptionElements()
	
	for key, element in ipairs(elements) do
		if element.price == self.price then
			element:highlight(true)
		else
			element:highlight(false)
		end
	end
end

function platformList:fillInteractionComboBox(comboBox)
	self.project:createPricePointComboBox(self, nil, comboBox)
end

function platformList:onClick()
	if self.project:getContractor() then
		return 
	end
	
	interactionController:startInteraction(self)
end

gui.register("PriceListComboBoxButton", platformList, "Button")
