local function onClicked(self)
	local themeData = themes.registeredByID[self.themeID]
	
	self.baseButton:setTheme(self.themeID)
	self.tree:close()
end

local function researchNewThemeCallback(self)
	if studio:getEmployeeCountByRole("designer") == 0 then
		local popup = game.createPopup(600, _T("NO_DESIGNERS_AVAILABLE_TITLE", "No Designers Available"), _T("MUST_HIRE_DESIGNERS_TO_DESIGN", "You must first hire a Designer to design new game genres and themes."), "pix24", "pix20", nil)
		
		frameController:push(popup)
	else
		game.createDesignSelectionMenu()
	end
end

local themeList = {}

themeList.CATCHABLE_EVENTS = {
	gameProject.EVENTS.DEVELOPMENT_TYPE_CHANGED,
	gameProject.EVENTS.CHANGED_THEME
}

function themeList:init()
end

function themeList:setTheme(themeID)
	self.project:setTheme(themeID)
	self:updateText()
end

function themeList:setProject(project)
	self.project = project
	
	self:updateText()
end

function themeList:getProject()
	return self.project
end

function themeList:onShow()
	self:updateText()
end

function themeList:isDisabled()
	return not self.project:isNewGame()
end

function themeList:onMouseEntered()
	themeList.baseClass.onMouseEntered(self)
	
	if not self.project:isNewGame() then
		self.descBox = gui.create("GenericDescbox")
		
		self.descBox:addText(_T("CANT_SELECT_THEME_CONTENT_PACK", "Game theme can not be changed on content-pack type game projects."), "bh20", nil, 0, 400, "question_mark", 24, 24)
	end
	
	if not self.descBox then
		self.descBox = gui.create("GenericDescbox")
	else
		self.descBox:addSpaceToNextText(10)
	end
	
	if not trends:showAllThemeTrends(self.descBox, wrapWidth) then
		self.descBox:addText(_T("NO_THEMES_TRENDING_CURRENTLY", "No themes are currently trending"), "bh20", game.UI_COLORS.LIGHT_BLUE, 0, 400, "question_mark", 22, 22)
	end
	
	if self.descBox then
		self.descBox:centerToElement(self)
	end
end

function themeList:onMouseLeft()
	themeList.baseClass.onMouseLeft(self)
	self:killDescBox()
end

function themeList:handleEvent(event, project)
	if project == self.project then
		self:queueSpriteUpdate()
		self:updateText()
	end
end

function themeList:updateText()
	local themeID = self.project:getTheme()
	
	if themeID then
		local themeData = themes.registeredByID[themeID]
		
		self:setText(themeData.display)
	else
		self:setText(_T("SELECT_THEME", "Select theme"))
	end
end

function themeList:fillInteractionComboBox(comboBox)
	local x, y = self:getPos(true)
	
	comboBox:setPos(x, y + self.h)
	comboBox:setOptionButtonType("ThemeComboBoxOption")
	
	for key, data in ipairs(self.themeList) do
		local optionObject = comboBox:addOption(0, 0, self.rawW, 18, data.display, fonts.get("pix20"), onClicked)
		
		optionObject:setTheme(data.id)
		
		optionObject.baseButton = self
	end
	
	if not themes:areAllThemesResearched() then
		comboBox:setOptionButtonType("ComboBoxOption")
		
		local option = comboBox:addOption(0, 0, self.rawW, 18, _T("DESIGN_NEW", "Design new"), fonts.get("pix20"), researchNewThemeCallback)
	end
	
	self.themeList = nil
	
	comboBox:centerToElement(self)
end

themeList.MENU_THEME_COUNT = 6

function themeList:onClick()
	if not self.project:isNewGame() then
		return 
	end
	
	if interactionController:attemptHide(self) then
		return 
	end
	
	self:killDescBox()
	
	local resThemes = themes:getResearchedThemes()
	
	if #resThemes > 0 then
		if #resThemes > themeList.MENU_THEME_COUNT then
			self.project:createThemeSelectionMenu(resThemes)
		else
			self.themeList = resThemes
			
			interactionController:startInteraction(self)
		end
	else
		local popup = gui.create("Popup")
		
		popup:setWidth(600)
		popup:setFont(fonts.get("pix24"))
		popup:setTitle(_T("NO_THEMES_AVAILABLE_TITLE", "No Themes Available"))
		popup:setTextFont(fonts.get("pix20"))
		popup:setText(_T("NO_THEMES_AVAILABLE_DESCRIPTION", "You have no themes researched. You should hire a Designer and have him research themes to make games with."))
		popup:createOKButton(fonts.get("pix20"))
		popup:center()
		frameController:push(popup)
	end
end

gui.register("ThemeListComboBoxButton", themeList, "Button")
require("game/gui/projects_menu/theme_combobox_option")
