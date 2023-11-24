function love.mousepressed(x, y, key)
	if not game.canHaveInput() then
		return 
	end
	
	if not gui.handleClick(x, y, key) and not inputService:handleMouseClick(key, x, y) and game.worldObject and not motivationalSpeeches:isActive() and not studio:handleClick(x, y, key, 0, 0) and not studio:passClickToObjects(x, y, key, 0, 0) and key == gui.mouseKeys.LEFT and camera:isInputAvailable() and game.cameraPanState then
		camera:setTouchPosition(x, y)
		interactionController:attemptHide()
	end
end

function love.textinput(text)
	inputService:handleTextInput(text)
end

love.nonTextKeys = {
	["return"] = true,
	backspace = true,
	escape = true
}

function love.keypressed(key, scancode)
	if key == "unknown" then
		key = scancode
	end
	
	if DEBUG_MODE and scancode == "f10" and love.keyboard.isDown("lshift") then
		require("engine/editor/init_particle_editor")
		
		return 
	end
	
	love.lastKeyPressed = scancode
	
	inputService:handleKeyPress(scancode)
end

function love.keyreleased(key, scancode)
	if key == "unknown" then
		key = scancode
	end
	
	inputService:handleKeyRelease(scancode)
end

function love.wheelmoved(x, y)
	if not game.canHaveInput() then
		return 
	end
	
	if DEBUG_MODE and officePrefabEditor:handleMouseWheel(y) then
		return 
	end
	
	if not gui.handleClick(0, 0, gui.mouseKeys.NONE, x, y) and not inputService:handleMouseWheel(y) and game.worldObject and not motivationalSpeeches:isActive() and not studio:handleClick(0, 0, gui.mouseKeys.NONE, x, y) and not studio:passClickToObjects(0, 0, gui.mouseKeys.NONE, x, y) and not frameController:preventsMouseOver() then
		camera:changeZoomLevel(y)
	end
end

function love.mousereleased(x, y, key)
	if DEBUG_MODE and officePrefabEditor:handleMouseRelease(x, y, key) then
		return 
	end
	
	if not gui.handleMouseRelease(x, y, key) and not inputService:handleMouseRelease(key, x, y) then
		studio:handleClickRelease(x, y, key)
		
		if key == gui.mouseKeys.LEFT then
			camera:removeTouch(x, y)
		end
	end
end

function love.mousemoved(x, y, dx, dy)
	if not game.canHaveInput() then
		return 
	end
	
	if not inputService:handleMouseMove(x, y, dx, dy) then
		local x, y = camera:getTouchPosition()
		
		if x then
			local camX, camY = camera:getPosition()
			
			camera:scroll(-dx, -dy)
		else
			studio:handleMouseDrag(dx, dy)
		end
	end
end
