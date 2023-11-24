local exitExpansionButton = {}

exitExpansionButton.regularIconColor = color(200, 200, 200, 255)
exitExpansionButton.hoverIcon = "new_demolition_mode_hover"
exitExpansionButton.hoverTextDemolition = {
	{
		font = "bh24",
		text = _T("SWITCH_TO_CONSTRUCTION_MODE", "Switch to construction mode")
	}
}
exitExpansionButton.hoverTextConstruction = {
	{
		font = "bh24",
		text = _T("SWITCH_TO_DEMOLITION_MODE", "Switch to demolition mode")
	}
}
exitExpansionButton.CATCHABLE_EVENTS = {
	studio.expansion.EVENTS.DEMOLITION_MODE_CHANGED
}

function exitExpansionButton:init()
	self.buttons = {}
end

function exitExpansionButton:handleEvent(event)
	self:updateDisplay()
end

function exitExpansionButton:disable()
	self:setCanClick(false)
	self.walls:setCanClick(false)
	self.objects:setCanClick(false)
end

function exitExpansionButton:enable()
	self:setCanClick(true)
	self.walls:setCanClick(true)
	self.objects:setCanClick(true)
end

function exitExpansionButton:updateDisplay()
	if studio.expansion:isDemolishing() then
		self:setIcon("new_demolition_mode_active")
		self:setHoverIcon("new_tab_general_hover")
		self:queueSpriteUpdate()
		self:setHoverText(self.hoverTextDemolition)
		
		if self:isMouseOver() then
			self:updateDescbox()
		end
		
		self.walls:setCanShow(true)
		self.objects:setCanShow(true)
		self.walls:show()
		self.objects:show()
		self.tiedVisibilityTo:updateBackdrop(self.walls.rawH + 2)
	else
		self:setIcon("new_tab_general")
		self:setHoverIcon("new_demolition_mode_hover")
		self:queueSpriteUpdate()
		self:setHoverText(self.hoverTextConstruction)
		
		if self:isMouseOver() then
			self:updateDescbox()
		end
		
		self.walls:hide()
		self.objects:hide()
		self.walls:setCanShow(false)
		self.objects:setCanShow(false)
		self.tiedVisibilityTo:updateBackdrop(0)
	end
end

exitExpansionButton.hoverTextWalls = {
	{
		font = "bh20",
		text = _T("WALL_DEMOTION_MODE", "Wall demolition")
	}
}
exitExpansionButton.hoverTextObjects = {
	{
		font = "bh20",
		text = _T("OBJECT_DEMOLITION_MODE", "Object demolition")
	}
}

function exitExpansionButton:createButtons()
	local x, y = self:getPos(true)
	local size = self.rawW / 2 - 1
	local scaler = "new_hud"
	local yPos = y - _S(2, scaler) - _S(size, scaler)
	local obj = gui.create("DemolitionModeButton")
	
	obj:setScaler(scaler)
	obj:setSize(size, size)
	obj:setPos(x, yPos)
	obj:setIcons("new_tab_walls_active", "new_tab_walls_inactive", "new_tab_walls_hover")
	obj:setMode(studio.expansion.CONSTRUCTION_MODE.WALLS)
	obj:setHoverText()
	obj:tieVisibilityTo(self)
	obj:setHoverText(exitExpansionButton.hoverTextWalls)
	obj:setDepth(self.depth + 5)
	obj:hide()
	
	self.walls = obj
	
	local obj = gui.create("DemolitionModeButton")
	
	obj:setScaler(scaler)
	obj:setSize(size, size)
	obj:setPos(x + self.w - _S(size, scaler), yPos)
	obj:setIcons("new_tab_general_active", "new_tab_general_inactive", "new_tab_general_hover")
	obj:setMode(studio.expansion.CONSTRUCTION_MODE.OBJECTS)
	obj:tieVisibilityTo(self)
	obj:setHoverText(exitExpansionButton.hoverTextObjects)
	obj:setDepth(self.depth + 5)
	obj:hide()
	
	self.objects = obj
	
	local descX, descY = x + self.w + _S(5, scaler), yPos + self.objects.h * 0.5
	
	self.walls:setDescboxPosition(descX, descY)
	self.objects:setDescboxPosition(descX, descY)
end

function exitExpansionButton:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		local demolishing = not studio.expansion:isDemolishing()
		
		studio.expansion:setDemolishing(demolishing)
		self:updateDisplay()
	end
end

gui.register("ChangeConstructionModeButton", exitExpansionButton, "ExitExpansionModeButton")
