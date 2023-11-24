local button = {}

button.CATCHABLE_EVENTS = {
	studio.expansion.EVENTS.DEMOLITION_MODE_CHANGED
}
button.regularIconColor = color(200, 200, 200, 255)

function button:init()
	self._canShow = true
end

function button:setIcons(active, inactive, hover)
	self.activeIcon = active
	self.inactiveIcon = inactive
	self.hoverIcon = hover
end

function button:getIcon()
	if self:isMouseOver() then
		return self.hoverIcon
	end
	
	if studio.expansion:getDemolitionMode() == self.mode then
		return self.activeIcon
	end
	
	return self.inactiveIcon
end

function button:setCanShow(state)
	self._canShow = state
end

function button:canShow()
	return self._canShow
end

function button:handleEvent(event)
	self:queueSpriteUpdate()
end

function button:setMode(mode)
	self.mode = mode
end

function button:setDescboxPosition(x, y)
	self.descX = x
	self.descY = y
end

function button:getDescboxPosition()
	return self.descX, self.descY
end

function button:positionDescbox()
	local x, y = self:getPos(true)
	
	self.descBox:setPos(self.descX, self.descY - self.descBox.h * 0.5)
end

function button:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		studio.expansion:setDemolitionMode(self.mode)
	end
end

gui.register("DemolitionModeButton", button, "IconButton")
