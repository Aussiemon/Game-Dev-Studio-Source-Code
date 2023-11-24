local expansionModeDescbox = {}

expansionModeDescbox.regularIconColor = color(150, 150, 150, 255)
expansionModeDescbox.buttonSize = 64

function expansionModeDescbox:init()
	local size = self.buttonSize
	local depth = self:getDepth()
	local otherDepth = depth + 10
	
	self.backdrop = gui.create("GenericBackdrop")
	
	self.backdrop:setScaler("new_hud")
	self.backdrop:setWidth(size + 6)
	
	self.backdrop.color = color(0, 0, 0, 150)
	
	self.backdrop:tieVisibilityTo(self)
	self.backdrop:setDepth(depth)
	
	self.fundsDisplay = gui.create("HUDFundsDisplay")
	
	self.fundsDisplay:setScaler("new_hud")
	self.fundsDisplay:setSize(64, 64)
	self.fundsDisplay:setX(_S(10))
	self.fundsDisplay:setCanClick(false)
	self.fundsDisplay:addDepth(1000)
	self.fundsDisplay:tieVisibilityTo(self)
	self.fundsDisplay:setDepth(depth)
	self.fundsDisplay.descBox:addDepth(1000)
	
	self.exitButton = gui.create("ExitExpansionModeButton")
	
	self.exitButton:setScaler("new_hud")
	self.exitButton:setSize(size, size)
	self.exitButton:addDepth(1000)
	self.exitButton:tieVisibilityTo(self)
	self.exitButton:addDepth(10)
	self.exitButton:setDepth(otherDepth)
	self.exitButton:setID(studio.expansion.EXIT_EXPANSION_BUTTON_ID)
	
	self.changeMode = gui.create("ChangeConstructionModeButton")
	
	self.changeMode:setScaler("new_hud")
	self.changeMode:setSize(size, size)
	self.changeMode:addDepth(1000)
	self.changeMode:tieVisibilityTo(self)
	self.changeMode:setDepth(otherDepth)
end

function expansionModeDescbox:bringUp()
	self:addDepth(10000)
end

function expansionModeDescbox:handleEvent(event, newState)
	if event == studio.expansion.EVENTS.CONSTRUCTION_MODE_CHANGED or event == studio.expansion.EVENTS.DEMOLITION_MODE_CHANGED or event == studio.expansion.EVENTS.BEGAN_MOVING_OBJECT or event == studio.expansion.EVENTS.FINISHED_MOVING_OBJECT or event == studio.expansion.EVENTS.SOLD_MOVED_OBJECT then
		self:updateText()
	end
	
	if event == studio.expansion.EVENTS.BEGAN_MOVING_OBJECT then
		self.changeMode:disable()
	elseif event == studio.expansion.EVENTS.FINISHED_MOVING_OBJECT or event == studio.expansion.EVENTS.SOLD_MOVED_OBJECT then
		self.changeMode:enable()
	end
end

function expansionModeDescbox:setYEdgePosition(edge)
	self.yEdge = edge
	
	self:updateElementPosition()
	self.fundsDisplay:alignToBottom(self.yEdge + _S(25))
	self.fundsDisplay:positionDescbox()
	
	local scaler = self.exitButton:getScaler()
	
	self.exitButton:setPos(self.fundsDisplay.x + self.fundsDisplay.w * 0.5 - self.exitButton.w * 0.5, self.fundsDisplay.y - _S(10, scaler) - self.exitButton.h)
	self.changeMode:setPos(self.exitButton.x, self.exitButton.y - _S(5, scaler) - self.changeMode.h)
	self:updateBackdrop()
	self.changeMode:createButtons()
	self.changeMode:updateDisplay()
	self:updateText()
end

function expansionModeDescbox:updateBackdrop(heightOffset)
	heightOffset = heightOffset or 0
	
	local x, y = self.changeMode:getPos(true)
	local scaler = self.exitButton:getScaler()
	
	self.backdrop:setHeight(_US(math.dist(self.exitButton:getBottom(), y), self.exitButton:getScaler()) + 6 + heightOffset)
	self.backdrop:setPos(self.changeMode.x - _S(3, scaler), self.changeMode.y - _S(3, scaler) - _S(heightOffset, scaler))
end

function expansionModeDescbox:updateElementPosition()
	local scaledOffset = _S(10)
	
	self:alignToRight(scaledOffset)
	self:alignToBottom(self.yEdge)
end

function expansionModeDescbox:updateText()
	self:removeAllText()
	
	local modeText, modeIcon = self:getModeText()
	
	self:addSpaceToNextText(4)
	self:addText(modeText, "bh22", nil, 0, 500, modeIcon, 24, 24)
	self:addText(self:getKeyBindText(), "pix18", nil, 0, 500)
	self:updateElementPosition()
end

function expansionModeDescbox:getModeText()
	if studio.expansion:getMovedObject() then
		return _T("MOVING_MODE", "Moving mode"), "objects_active"
	end
	
	if studio.expansion:isDemolishing() then
		if studio.expansion:getDemolitionMode() == studio.expansion.CONSTRUCTION_MODE.WALLS then
			return _T("DEMOLITION_MODE_WALLS", "Demolition mode - walls"), "demolition"
		else
			return _T("DEMOLITION_MODE_OBJECTS", "Demolition mode - objects"), "demolition"
		end
	end
	
	return _T("CONSTRUCTION_MODE", "Construction mode"), "wrench"
end

function expansionModeDescbox:getKeyBindText()
	if studio.expansion:canPerformModeAction(studio.expansion.CONSTRUCTION_MODE.FLOORS) then
		return _format(_T("FLOOR_PLACEMENT_MODE_CONTROLS", "Left mouse - place floor\nLeft control - demolition/sell mode"))
	end
	
	if studio.expansion:getMovedObject() then
		return _format(_T("MOVING_MODE_CONTROLS", "Left mouse - place object\nRight mouse - rotate object\nMouse wheel - rotate object\nSELL_KEY - sell object\nCANCEL_MOVING_KEY - cancel moving"), "SELL_KEY", keyBinding:getKeyDisplay(studio.expansion.SELL_MOVING_OBJECT_KEY), "CANCEL_MOVING_KEY", keyBinding:getKeyDisplay(studio.expansion.CANCEL_MOVING_OBJECT_KEY))
	end
	
	if not studio.expansion:isDemolishing() then
		if studio.expansion:canPerformModeAction(studio.expansion.CONSTRUCTION_MODE.WALLS) then
			return string.easyformatbykeys(_T("WALL_PLACEMENT_CONTROLS", "KEY - demolition/sell mode\nLeft mouse - confirm\nMouse wheel - rotate side"), "KEY", keyBinding:getKeyDisplay("lctrl"))
		else
			return string.easyformatbykeys(_T("OBJECT_PLACEMENT_CONTROLS", "KEY - demolition/sell mode\nLeft mouse - confirm\nRight mouse - rotate object\nMouse wheel - rotate object"), "KEY", keyBinding:getKeyDisplay("lctrl"))
		end
	end
	
	local demoMode = studio.expansion:getDemolitionMode()
	
	if demoMode == studio.expansion.CONSTRUCTION_MODE.WALLS then
		return string.easyformatbykeys(_T("DEMOLITION_MODE_WALLS_KEY_BINDS", "KEY - construction mode\nLeft mouse - destroy wall\nMouse wheel - rotate side"), "KEY", keyBinding:getKeyDisplay("lctrl"))
	end
	
	return string.easyformatbykeys(_T("DEMOLITION_MODE_OBJECTS_KEY_BINDS", "KEY - construction mode\nLeft mouse - move object\nRight mouse - sell object"), "KEY", keyBinding:getKeyDisplay("lctrl"))
end

gui.register("ExpansionModeDescbox", expansionModeDescbox, "GenericDescbox")
