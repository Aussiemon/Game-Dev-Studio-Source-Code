local function onClicked(self)
	self.baseButton:setEngine(self.engine)
	self.tree:close()
end

local engineList = {}

engineList.CATCHABLE_EVENTS = {
	gameProject.EVENTS.DEVELOPMENT_TYPE_CHANGED,
	gameProject.EVENTS.ENGINE_CHANGED
}

function engineList:init()
	self.allowPurchasedEngines = true
end

function engineList:setEngine(engineObj)
	local lastEngine = self.engine
	
	self.engine = engineObj
	
	self.project:setEngine(engineObj:getUniqueID(), engineObj)
	
	if lastEngine ~= engineObj then
		self.listDisplayOwner:updateGameFeatureList()
	end
end

function engineList:setListDisplayOwner(owner)
	self.listDisplayOwner = owner
end

function engineList:setProject(project)
	self.project = project
	
	self:updateText()
end

function engineList:getProject()
	return self.project
end

function engineList:onShow()
	self:updateText()
end

function engineList:isDisabled()
	return not self.project:isNewGame()
end

function engineList:updateText()
	if self.project:getEngine() then
		self:setText(self.project:getEngine():getName())
	else
		self:setText(_T("SELECT_ENGINE", "Select engine"))
	end
end

function engineList:setAllowPurchasedEngines(state)
	self.allowPurchasedEngines = state
end

function engineList:onMouseEntered()
	engineList.baseClass.onMouseEntered(self)
	
	if not self.project:isNewGame() then
		self.descBox = gui.create("GenericDescbox")
		
		self.descBox:addText(_T("CANT_SELECT_ENGINE_CONTENT_PACK", "Game engine can not be changed on content-pack type game projects."), "bh20", nil, 4, 400, "question_mark", 24, 24)
		self.descBox:addText(_T("THIS_GAME_WILL_USE_RELATED_GAME_ENGINE", "This game will use the same engine that the related game used."), "pix20", nil, 0, 400)
		self.descBox:centerToElement(self)
		self.descBox:overwriteDepth(110000)
	end
end

function engineList:onMouseLeft()
	engineList.baseClass.onMouseLeft(self)
	self:killDescBox()
end

function engineList:handleEvent(event)
	if event == gameProject.EVENTS.DEVELOPMENT_TYPE_CHANGED then
		self:queueSpriteUpdate()
		self:updateText()
	elseif event == gameProject.EVENTS.ENGINE_CHANGED then
		self:queueSpriteUpdate()
		self:updateText()
	end
end

function engineList:fillInteractionComboBox(comboBox)
	local x, y = self:getPos(true)
	
	comboBox:setPos(x, y + self.h)
	comboBox:setOptionButtonType("EngineListComboBoxOption")
	
	for key, engineObj in ipairs(studio:getEngines()) do
		local optionObject = comboBox:addOption(0, 0, self.rawW, 18, engineObj:getName(), fonts.get("pix20"), onClicked)
		
		optionObject:setEngine(engineObj)
		
		optionObject.baseButton = self
	end
	
	if self.allowPurchasedEngines then
		for key, engineObj in ipairs(studio:getPurchasedEngines()) do
			local optionObject = comboBox:addOption(0, 0, self.rawW, 18, engineObj:getName(), fonts.get("pix20"), onClicked)
			
			optionObject:setEngine(engineObj)
			
			optionObject.baseButton = self
		end
	end
	
	comboBox:centerToElement(self)
end

engineList.ENGINES_FOR_POPUP = 7

function engineList:onClick()
	if not self.project:isNewGame() then
		return 
	end
	
	local engineCount = #studio:getEngines() + (self.allowPurchasedEngines and #studio:getPurchasedEngines() or 0)
	
	if engineCount > 0 then
		if engineCount >= engineList.ENGINES_FOR_POPUP then
			self.project:createEngineSelectionPopup()
		else
			interactionController:startInteraction(self)
		end
	else
		local popup = gui.create("Popup")
		
		popup:setWidth(500)
		popup:centerX()
		popup:setTextFont(fonts.get("pix20"))
		popup:setFont(fonts.get("pix24"))
		popup:setTitle(_T("NO_ENGINES_AVAILABLE_TITLE", "No Engines Available"))
		popup:setText(_T("NO_ENGINES_AVAILABLE_DESC", "You currently have no engines developed.\nPlease develop at least one engine to use for game development before attempting to create a game."))
		popup:addDepth(100)
		popup:addButton(fonts.get("pix20"), "OK")
		popup:performLayout()
		popup:centerY()
		frameController:push(popup)
	end
end

gui.register("EngineListComboBoxButton", engineList, "Button")
