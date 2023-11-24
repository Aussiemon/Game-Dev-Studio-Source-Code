local traitSelectionGradient = {}

traitSelectionGradient.availableAttributePointsTextColor = color(228, 255, 201, 255)
traitSelectionGradient.unavailableAttributePointsTextColor = color(255, 255, 255, 255)
traitSelectionGradient.backdropSize = 24
traitSelectionGradient.iconSize = 24
traitSelectionGradient.backdropVisible = false
traitSelectionGradient.textPad = 0
traitSelectionGradient.DEFAULT_HOVER_TEXT = _T("CLICK_TO_SELECT_TRAIT", "Click to open list of selectable traits.\n\nTraits are optional and provide a boost or trade-off in employee abilities.")
traitSelectionGradient.hoverText = traitSelectionGradient.DEFAULT_HOVER_TEXT

function traitSelectionGradient.selectTraitCallback(option)
	local employee = option.mainElement:getEmployee()
	local prevTrait = employee:getTraits()[option.mainElement:getTraitIndex()]
	
	if prevTrait then
		employee:removeTrait(prevTrait)
	end
	
	employee:addTrait(option:getTraitData().id)
end

function traitSelectionGradient.unassignCallback(option)
	local employee = option.mainElement:getEmployee()
	local prevTrait = employee:getTraits()[option.mainElement:getTraitIndex()]
	
	if prevTrait then
		employee:removeTrait(prevTrait)
	end
end

function traitSelectionGradient:init(employee)
	self.employee = employee
end

function traitSelectionGradient:handleEvent(event, employee)
	if event == developer.EVENTS.TRAIT_ADDED or event == developer.EVENTS.TRAIT_REMOVED then
		self:updateText()
	end
end

function traitSelectionGradient:setEmployee(employee)
	self.employee = employee
end

function traitSelectionGradient:getEmployee()
	return self.employee
end

function traitSelectionGradient:setTraitIndex(index)
	self.traitIndex = index
	
	self:updateText()
end

function traitSelectionGradient:getTraitIndex()
	return self.traitIndex
end

function traitSelectionGradient:updateSprites()
	self.iconBackdropSprite = self.iconBackdropSprite or self:pureAllocateSprite("profession_backdrop", -0.1)
	
	traitSelectionGradient.baseClass.updateSprites(self)
end

function traitSelectionGradient:onMouseEntered()
	traitSelectionGradient.baseClass.onMouseEntered(self)
	
	local traitID = self.employee:getTraits()[self.traitIndex]
	
	if traitID then
		local traitData = traits:getData(traitID)
		
		traitData:formatDescriptionText(self.descBox, self.employee, self.descBoxWrapWidth, "bh18")
	end
end

function traitSelectionGradient:updateText()
	local employeeTraits = self.employee:getTraits()
	local trait = employeeTraits[self.traitIndex]
	
	if trait then
		local traitData = traits:getData(trait)
		
		self.text = traitData.display
		
		self:setIcon(traitData.quad)
		
		self.backdropVisible = true
		
		self:setHoverText(traitData.description)
	else
		self.text = _T("TRAIT_AVAILABLE", "Unassigned")
		
		self:setIcon("no_task")
		
		self.backdropVisible = false
		
		self:setHoverText(traitSelectionGradient.DEFAULT_HOVER_TEXT)
	end
	
	local oldW, oldH = self.rawW, self.rawH
	
	self:setIconSize(24, nil, 26)
	self:setSize(oldW, oldH)
	self:updateTextDimensions()
end

function traitSelectionGradient:fillInteractionComboBox(combobox)
	local option = combobox:addOption(0, 0, 0, 24, _T("UNASSIGN_TRAIT", "None"), fonts.get("pix20"), traitSelectionGradient.unassignCallback)
	
	option.mainElement = self
	
	local employeeTraits = self.employee:getTraits()
	local trait = employeeTraits[self.traitIndex]
	
	combobox:setOptionButtonType("TraitSelectionComboBoxOption")
	
	for key, traitData in ipairs(traits.registered) do
		if traits:canPlayerSelectTrait(traitData, self.employee, trait) then
			local option = combobox:addOption(0, 0, 0, 24, traitData.display, fonts.get("pix20"), traitSelectionGradient.selectTraitCallback)
			
			option.mainElement = self
			
			option:setTraitData(traitData)
			option:setEmployee(self.employee)
		end
	end
end

function traitSelectionGradient:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		return 
	end
	
	local localX, localY = self:getPos(true)
	
	interactionController:setInteractionObject(self, localX, localY + self.h, true)
	
	local comboBox = interactionController:getComboBox()
	
	comboBox:setWidth(self.w)
	comboBox:scaleToWidestOption(true)
	self:killDescBox()
	self:queueSpriteUpdate()
end

gui.register("TraitSelectionGradientIconPanel", traitSelectionGradient, "GradientIconPanel")
