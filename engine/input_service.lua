inputService = {}
inputService.handlers = {}
inputService.mouseHandlers = {}
inputService.mouseReleaseHandlers = {}
inputService.wheelHandlers = {}
inputService.mouseMoveHandlers = {}

function inputService:addHandler(handler)
	if table.find(self.handlers, handler) then
		error("attempt to insert the same handler")
	end
	
	table.insert(self.handlers, handler)
	
	if handler.handleMouseClick then
		table.insert(self.mouseHandlers, handler)
	end
	
	if handler.handleMouseRelease then
		table.insert(self.mouseReleaseHandlers, handler)
	end
	
	if handler.handleMouseWheel then
		table.insert(self.wheelHandlers, handler)
	end
	
	if handler.mouseMoved then
		table.insert(self.mouseMoveHandlers, handler)
	end
end

function inputService:removeHandler(handler)
	table.removeObject(self.handlers, handler)
	
	if handler.handleMouseClick then
		table.removeObject(self.mouseHandlers, handler)
	end
	
	if handler.handleMouseRelease then
		table.removeObject(self.mouseReleaseHandlers, handler)
	end
	
	if handler.handleMouseWheel then
		table.removeObject(self.wheelHandlers, handler)
	end
	
	if handler.handleMouseMoved then
		table.removeObject(self.moveHandlers, handler)
	end
end

function inputService:lock()
	self.locked = true
end

function inputService:unlock()
	self.locked = false
end

function inputService:setPreventPropagation(state)
	self.preventPropagation = state
end

function inputService:handleMouseClick(key, x, y)
	if self.locked then
		return 
	end
	
	for index, handler in ipairs(self.mouseHandlers) do
		if handler:handleMouseClick(key, x, y) then
			return true
		end
	end
	
	return false
end

function inputService:handleMouseWheel(direction)
	for key, handler in ipairs(self.wheelHandlers) do
		if handler:handleMouseWheel(direction) then
			return true
		end
	end
	
	return false
end

function inputService:handleMouseRelease(key, x, y)
	if self.locked then
		return 
	end
	
	for index, handler in ipairs(self.mouseReleaseHandlers) do
		if handler:handleMouseRelease(key, x, y) then
			return true
		end
	end
	
	return false
end

function inputService:handleKeyPress(key)
	if self.locked then
		return 
	end
	
	self.preventPropagation = false
	
	for index, handler in ipairs(self.handlers) do
		if handler:handleKeyPress(key) then
			return true
		end
	end
	
	return false
end

function inputService:handleKeyRelease(key)
	if self.locked then
		return 
	end
	
	for index, handler in ipairs(self.handlers) do
		if handler:handleKeyRelease(key) then
			return true
		end
	end
	
	return false
end

function inputService:handleTextInput(text)
	if self.locked or self.preventPropagation then
		return 
	end
	
	for key, handler in ipairs(self.handlers) do
		if handler:handleTextInput(text) then
			break
		end
	end
end

function inputService:handleMouseMove(x, y, dx, dy)
	if self.locked then
		return 
	end
	
	for index, handler in ipairs(self.mouseMoveHandlers) do
		if handler:mouseMoved(x, y, dx, dy) then
			return true
		end
	end
end
