local function onClicked(self)
	local genreData = audience.registeredByID[self.themeID]
	
	self.baseButton:setAudience(self.audienceID)
	self.tree:close()
end

local audienceList = {}

audienceList.CATCHABLE_EVENTS = {
	gameProject.EVENTS.AUDIENCE_CHANGED
}

function audienceList:init()
end

function audienceList:handleEvent(event)
	self:updateText()
end

function audienceList:setAudience(audienceID)
	self.project:setAudience(audienceID)
end

function audienceList:setProject(project)
	self.project = project
	
	self:updateText()
end

function audienceList:getProject()
	return self.project
end

function audienceList:onShow()
	self:updateText()
end

function audienceList:updateText()
	local audID = self.project:getAudience()
	
	if audID then
		local audienceData = audience.registeredByID[audID]
		
		self:setText(audienceData.display)
	else
		self:setText(_T("SELECT_AUDIENCE", "Audience"))
	end
end

function audienceList:fillInteractionComboBox(comboBox)
	local x, y = self:getPos(true)
	
	comboBox:setOptionButtonType("AudienceComboboxButton")
	comboBox:setPos(x, y + self.h)
	
	for key, data in ipairs(audience.registered) do
		local optionObject = comboBox:addOption(0, 0, self.rawW, 18, data.display, fonts.get("pix20"), onClicked)
		
		optionObject:setProject(self.project)
		optionObject:setAudienceID(data.id)
		
		optionObject.baseButton = self
	end
end

function audienceList:onClick()
	interactionController:startInteraction(self)
end

gui.register("AudienceListComboBoxButton", audienceList, "Button")
