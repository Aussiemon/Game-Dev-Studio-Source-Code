local function onClicked(self)
	self.baseButton:setPlatformState(self.platform, self)
end

local platformList = {}

platformList.CATCHABLE_EVENTS = {
	gameProject.EVENTS.PLATFORM_STATE_CHANGED
}

function platformList:init()
end

function platformList:setPlatformState(platObj, element)
	if not platObj:canSelect(self.project) then
		return 
	end
	
	local platformID = platObj:getID()
	local newState = not self.project:getPlatformState(platformID)
	
	self.project:setPlatformState(platformID, newState)
	self:updateText()
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

function platformList:handleEvent(event)
	self:updateText()
end

platformList.consoleCountFormatMethods = {
	ru = function(amt)
		return translation.conjugateRussianText(amt, "%s Консолей", "%s Консоли", "%s Консоль", true)
	end
}

function platformList:updateText()
	local count = self.project:getPlatformCount()
	
	if count > 0 then
		local method = platformList.consoleCountFormatMethods[translation.currentLanguage]
		
		if method then
			self:setText(method(count))
		elseif count == 1 then
			self:setText(_T("SELECTED_ONE_PLATFORM", "1 Platform"))
		else
			self:setText(_format(_T("SELECTED_PLATFORMS", "PLATFORMS Platforms"), "PLATFORMS", count))
		end
	else
		self:setText(_T("PLATFORMS", "Platforms"))
	end
end

function platformList:fillInteractionComboBox(comboBox)
	local x, y = self:getPos(true)
	
	comboBox:setPos(x, y + self.h)
	comboBox:setOptionButtonType("PlatformComboBoxOption")
	self:addPlayerPlatforms(comboBox, studio:getActivePlayerPlatforms())
	self:addPlayerPlatforms(comboBox, studio:getDevPlayerPlatforms())
	
	for key, data in ipairs(platforms.registered) do
		if studio:hasPlatformLicense(data.id) and platforms:reachedReleaseTime(data) and platformShare:getOnMarketPlatformByID(data.id) and platforms:isPlatformManufacturerAlive(data.id) then
			local optionObject = comboBox:addOption(0, 0, self.rawW, 18, data.display, fonts.get("pix20"), onClicked)
			
			optionObject:setPlatformID(data.id)
			optionObject:setProject(self.project)
			
			optionObject.baseButton = self
			
			optionObject:highlight(self.project:getPlatformState(data.id))
			optionObject:setCloseOnClick(false)
		end
	end
	
	comboBox:centerToElement(self)
end

function platformList:addPlayerPlatforms(comboBox, list)
	for key, obj in ipairs(list) do
		local optionObject = comboBox:addOption(0, 0, self.rawW, 18, obj:getName(), fonts.get("pix20"), onClicked)
		
		optionObject:setPlatform(obj)
		optionObject:setProject(self.project)
		
		optionObject.baseButton = self
		
		optionObject:highlight(self.project:getPlatformState(obj:getID()))
		optionObject:setCloseOnClick(false)
	end
end

function platformList:onClick()
	interactionController:startInteraction(self)
end

gui.register("PlatformListComboBoxButton", platformList, "Button")
