local mapEditorInputHandler = {}

function mapEditorInputHandler:handleKeyPress(key)
	if self:_handleKeyPress(key) then
		inputService:setPreventPropagation(true)
		
		return true
	end
end

function mapEditorInputHandler:_handleKeyPress(key)
	if key == "f10" then
		game.captureScreenshot(true)
	end
	
	if love.nonTextKeys[key] and gui.handleKeyPress(key) then
		return true
	end
	
	game.handleKeyPress(key)
	game.attemptSetCameraKey(key, true)
	
	if frameController:getFrameCount() == 0 and mapEditor:handleKeyPress(key) then
		return true
	end
end

function mapEditorInputHandler:handleMouseClick(key, x, y)
	return mapEditor:handleMouseClick(key, x, y)
end

function mapEditorInputHandler:handleMouseWheel(direction)
	return mapEditor:handleMouseWheel(direction)
end

function mapEditorInputHandler:handleMouseRelease(key, x, y)
	return mapEditor:handleMouseRelease(key, x, y)
end

function mapEditorInputHandler:handleKeyRelease(key)
	gui.handleKeyRelease(key)
	game.attemptSetCameraKey(key, false)
	
	return true
end

function mapEditorInputHandler:handleTextInput(text)
	gui.handleTextEntry(text)
end

return mapEditorInputHandler
