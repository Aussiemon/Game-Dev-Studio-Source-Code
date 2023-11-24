local engineList = {}

engineList.popupTitle = _T("NO_ENGINES_AVAILABLE", "No Engines Available")
engineList.popupText = _T("NO_ENGINES_AVAILABLE_DESCRIPTION", "You currently have no engines developed.\nPlease develop at least one engine before proceeding.")

local function onClicked(self)
	self.baseButton:setTeam(self.engine)
	self.baseButton:onSelected(self)
	self.tree:onSelected(self)
	self.tree:close()
end

engineList.handleEvent = false

function engineList:init()
	self:setFont(fonts.get("pix14"))
	self:updateText()
	
	self.allowPurchasedEngines = true
end

function engineList:setTeam(teamObj)
	self.engine = teamObj
	
	self:updateText()
end

function engineList:setProject(project)
end

function engineList:getProject()
end

function engineList:getListTable()
	return studio:getEngines()
end

function engineList:onSelected(option)
	self.engine = option.engine
	
	if self.displayIDToUpdate then
		local element = gui:getElementByID(self.displayIDToUpdate)
		
		element:setProject(self.engine)
		element:showDisplay(self.engine)
	end
	
	if self.featureList then
		self.featureList:updateList(option.engine)
	end
end

function engineList:setAllowPurchasedEngines(state)
	self.allowPurchasedEngines = state
end

function engineList:setDisplayToUpdate(displayID)
	self.displayIDToUpdate = displayID
end

function engineList:fillInteractionComboBox(comboBox)
	local x, y = self:getPos(true)
	
	comboBox:setPos(x, y + self.h)
	comboBox:setOptionButtonType("EngineListComboBoxOption")
	
	local engines = studio:getEngines()
	
	for key, engineObj in ipairs(engines) do
		if not engineObj:getTeam() and not engineObj:getDevType() then
			local optionObject = comboBox:addOption(0, 0, self.rawW, 18, engineObj:getName(), fonts.get("pix20"), onClicked)
			
			optionObject:setEngine(engineObj)
			
			optionObject.baseButton = self
		end
	end
	
	if self.allowPurchasedEngines then
		local licensedEngines = studio:getPurchasedEngines()
		
		for key, engineObj in ipairs(licensedEngines) do
			local optionObject = comboBox:addOption(0, 0, self.rawW, 18, engineObj:getName(), fonts.get("pix20"), onClicked)
			
			optionObject:setEngine(engineObj)
			
			optionObject.baseButton = self
		end
	end
end

function engineList:onClick()
	if interactionController:attemptHide(self) then
		return 
	end
	
	local engines = studio:getEngines()
	local licensedEngines = studio:getPurchasedEngines()
	local totalEngines = #engines + (self.allowPurchasedEngines and #licensedEngines or 0)
	
	if totalEngines > 0 then
		local availableEngines = 0
		
		for key, engineObj in ipairs(engines) do
			if not engineObj:getTeam() and not engineObj:getDevType() then
				availableEngines = availableEngines + 1
			end
		end
		
		if not self.allowPurchasedEngines and availableEngines == 0 then
			local popup = game.createPopup(500, _T("ENGINES_BEING_WORKED_ON_TITLE", "Engines Worked On"), _T("ENGINES_BEING_WORKED_ON_DESC", "All in-house engines are currently being worked on.\n\nYou must wait for the work to be finished on them before selecting them for an update or revamp."), "pix24", "pix20", nil)
			
			frameController:push(popup)
			
			return 
		end
		
		interactionController:startInteraction(self)
	else
		local popup = gui.create("Popup")
		
		popup:setWidth(450)
		popup:centerX()
		popup:setTextFont(fonts.get("pix20"))
		popup:setFont(fonts.get("pix24"))
		popup:setTitle(self.popupTitle)
		popup:setText(self.popupText)
		popup:setDepth(105)
		popup:addButton(fonts.get("pix20"), "OK")
		popup:performLayout()
		popup:centerY()
		frameController:push(popup)
	end
end

function engineList:updateText()
	if self.engine then
		self:setText(self.engine:getName())
	else
		self:setText(_T("SELECT_ENGINE", "Select engine"))
	end
end

gui.register("EngineListComboBox", engineList, "EngineTeamComboBox")
