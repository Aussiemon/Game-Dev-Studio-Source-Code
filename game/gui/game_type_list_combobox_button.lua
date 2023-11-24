local function onClicked(self)
	self.baseButton:onSelected(self)
end

local gameTypeList = {}

gameTypeList.CATCHABLE_EVENTS = {
	gameProject.EVENTS.DEVELOPMENT_TYPE_CHANGED
}

function gameTypeList:init()
end

function gameTypeList:handleEvent(event, obj)
	if obj == self.project then
		self:updateText()
	end
end

function gameTypeList:onSelected(obj)
	local gametype = obj.gameType
	local verification = gameProject.SELECT_VERIFY_CALLBACK[gametype]
	
	if verification and not verification(self.project) then
		return 
	end
	
	if self.project:getGameType() ~= gametype then
		self.project:setGameType(gametype)
	end
end

function gameTypeList:setProject(project)
	self.project = project
	
	self:updateText()
end

function gameTypeList:getProject()
	return self.project
end

function gameTypeList:setRelatedGameButton(button)
	self.relatedGameButton = button
end

function gameTypeList:onMouseEntered()
	gameTypeList.baseClass.onMouseEntered(self)
	
	if self.project:getContractor() then
		self.descBox = gui.create("GenericDescbox")
		
		self.descBox:addText(_T("CANT_SELECT_GAME_TYPE_CONTRACTOR", "Contractors are only interested in full games."), "bh20", nil, 0, 400, "question_mark", 24, 24)
		self.descBox:centerToElement(self)
	end
end

function gameTypeList:isDisabled()
	return self.project:getContractor()
end

function gameTypeList:onShow()
	self:updateText()
end

function gameTypeList:updateText()
	if self.project:getGameType() then
		self:setText(self.project:getGameTypeText())
	else
		self:setText(_T("SELECT_TYPE", "Select type"))
	end
end

function gameTypeList:getListTable()
	return studio:getTeams()
end

function gameTypeList:fillInteractionComboBox(comboBox)
	local x, y = self:getPos(true)
	
	comboBox:setOptionButtonType("GameTypeComboboxButton")
	comboBox:setPos(x, y + self.h)
	
	for key, devType in ipairs(gameProject.DEVELOPMENT_TYPE_ORDER) do
		if self.project:canHaveGametype(devType) then
			local optionObject = comboBox:addOption(0, 0, self.rawW, 18, self.project:getGameTypeText(devType), fonts.get("pix20"), onClicked)
			
			if not gameProject.SEQUEL_DEV_TYPES[devType] then
				optionObject:setCanClick(self.project:getSequelTo() ~= nil)
			end
			
			optionObject:setRelatedGameButton(self.relatedGameButton)
			
			optionObject.gameType = devType
			optionObject.baseButton = self
		end
	end
	
	comboBox:centerToElement(self)
end

function gameTypeList:onClick()
	if self.project:getContractor() then
		return 
	end
	
	interactionController:startInteraction(self)
end

gui.register("GameTypeListComboBoxButton", gameTypeList, "Button")
require("game/gui/game_type_combobox_button")
