local platformComboboxOption = {}

platformComboboxOption.CATCHABLE_EVENTS = {
	gameProject.EVENTS.PLATFORM_STATE_CHANGED
}
platformComboboxOption.RED = color(255, 150, 150, 255)

function platformComboboxOption:onMouseLeft()
	platformComboboxOption.baseClass.onMouseLeft(self)
	self:killDescBox()
	self:killGenreDescBox()
end

function platformComboboxOption:killGenreDescBox()
	if self.genreDescBox then
		self.genreDescBox:kill()
		
		self.genreDescBox = nil
	end
end

function platformComboboxOption:setProject(project)
	self.project = project
	
	self:updateSelectabilityState()
end

function platformComboboxOption:updateSelectabilityState()
	self:setCanClick(self.platform:canSelect(self.project))
end

function platformComboboxOption:handleEvent()
	self:updateSelectabilityState()
	self:queueSpriteUpdate()
end

local concatTable = {}

function platformComboboxOption:onMouseEntered()
	platformComboboxOption.baseClass.onMouseEntered(self)
	
	local x, y = self:getPos(true)
	
	self.descBox = gui.create("GenericDescbox")
	
	self.descBox:setDepth(200)
	self.descBox:setPos(self.w + x + _S(5), y)
	
	local state, missingFeatures = self.platform:getSelectabilityState(self.project)
	local states = platform.SELECTABILITY_STATE
	
	if state == states.INCOMPLETE_PLATFORM then
		self.descBox:addText(_T("PLATFORM_INCOMPLETE", "This platform does not yet have a proper hardware spec, and is therefore not developable for."), "bh18", nil, 0, 320, "exclamation_point_yellow", 24, 24)
	elseif state == states.NO_ENGINE_SELECTED then
		self.descBox:addText(_T("MUST_SELECT_ENGINE_FIRST_PLATFORM", "You must select an engine before selecting platforms."), "bh20", game.UI_COLORS.RED, 0, 320, "exclamation_point_red", 24, 24)
	elseif state == states.CROSS_PLATFORM_MISSING then
		self.descBox:addText(_format(_T("CROSS_PLATFORM_SUPPORT_MISSING", "The selected engine supports developing for only PLATFORMS platforms."), "PLATFORMS", platform.MAX_PLATFORMS_BEFORE_CROSS_PLATFORM), "bh20", game.UI_COLORS.RED, 0, 320, "exclamation_point_red", 24, 24)
		
		if not taskTypes.registeredByID[platform.CROSS_PLATFORM_FEATURE_ID]:wasReleased() then
			self.descBox:addText(_format(_T("NO_CROSS_PLATFORM_TECH_YET", "There is currently no cross-platform tech available for integration into game engines."), "PLATFORMS", platform.MAX_PLATFORMS_BEFORE_CROSS_PLATFORM), "pix20", nil, 0, 320)
		elseif not studio:isFeatureResearched(platform.CROSS_PLATFORM_FEATURE_ID) then
			self.descBox:addText(_T("RESEARCH_CROSS_PLATFORM_SUPPORT", "Research cross-platform support and implement it into your game engine."), "pix20", nil, 0, 320)
		end
	elseif state == states.MISSING_FEATURES then
		for key, featureID in ipairs(missingFeatures) do
			concatTable[#concatTable + 1] = taskTypes.registeredByID[featureID].display
		end
		
		self.descBox:addText(_format(_T("CANNOT_SELECT_PLATFORM", "Can not select PLATFORM."), "PLATFORM", self.platform:getName()), "bh20", game.UI_COLORS.RED, 4, 320, "exclamation_point_red", 24, 24)
		self.descBox:addText(_format(_T("MISSING_ENGINE_FEATURES", "Missing engine features: FEATURES"), "FEATURES", table.concat(concatTable, "\n\t")), "bh20", nil, 4, 320, "question_mark", 24, 24)
		table.clear(missingFeatures)
		table.clear(concatTable)
	elseif state == states.NOT_IN_BASE_GAME then
		self.descBox:addText(_T("BASE_GAME_NOT_MADE_FOR_PLATFORM", "The base game of this expansion pack was not made for this platform."), "bh20", game.UI_COLORS.RED, 4, 320, "exclamation_point_red", 24, 24)
	elseif state == states.SCALE_TOO_SMALL then
		self.descBox:addText(_T("PLATFORM_MAX_SCALE_TOO_LOW_FOR_CONTRACT", "The platform's maximum game scale is too low for this contract game project."), "bh20", game.UI_COLORS.RED, 4, 320, "exclamation_point_red", 24, 24)
	elseif state == states.MMO_TOO_MANY_PLATFORMS then
		self.descBox:addText(_format(_T("PLATFORM_TOO_MANY_PLATFORMS_SELECTED_MMO", "You can only select up to MAX platforms for a MMO game project."), "MAX", gameProject.MMO_MAX_PLATFORMS), "bh20", game.UI_COLORS.RED, 4, 320, "exclamation_point_red", 24, 24)
	else
		self.platform:setupDescbox(self.descBox, 320, self.project, true)
	end
	
	self.genreDescBox = gui.create("GenericDescbox")
	
	self.platform:fillMatchingDescbox(self.genreDescBox)
	self.genreDescBox:setPos(x - self.genreDescBox.w - _S(5), y)
end

function platformComboboxOption:updateSprites()
	platformComboboxOption.baseClass.updateSprites(self)
	
	local checkboxSprite
	
	checkboxSprite = self.project:getPlatformState(self.platformID) and "checkbox_on_test" or "checkbox_off"
	
	local spriteSize = self.rawH - _S(4)
	
	self.checkboxSprite = self:allocateSprite(self.checkboxSprite, checkboxSprite, _S(2), _S(2), 0, spriteSize, spriteSize, 0, 0, -0.1)
end

function platformComboboxOption:getTextWidth()
	return self.font:getWidth(self.text) + self.rawH
end

function platformComboboxOption:onClick(x, y, key)
	platformComboboxOption.baseClass.onClick(self, x, y, key)
	self:highlight(self.project:getPlatformState(self.platformID))
	self:queueSpriteUpdate()
end

function platformComboboxOption:onHide()
	self:killDescBox()
	self:killGenreDescBox()
end

function platformComboboxOption:kill()
	platformComboboxOption.baseClass.kill(self)
	self:killDescBox()
	self:killGenreDescBox()
end

function platformComboboxOption:getTextOffset()
	return self.rawH + _S(12), 0
end

function platformComboboxOption:setPlatformID(platformID)
	self.platformID = platformID
	self.platform = platformShare:getPlatformByID(platformID)
end

function platformComboboxOption:setPlatform(obj)
	self.platformID = obj:getID()
	self.platform = obj
end

gui.register("PlatformComboBoxOption", platformComboboxOption, "ComboBoxOption")
