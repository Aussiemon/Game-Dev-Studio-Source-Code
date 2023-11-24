local mainRenderer = {}
local nextRequest = 0
local perfStats

function mainRenderer:draw()
	love.graphics.setColor(255, 255, 255, 255)
	cullingTester:updateCameraPosition()
	camera:set()
	love.graphics.setCanvas(game.mainFrameBufferObject)
	particleSystem.manager:update(dt)
	studio:preDraw()
	game.worldObject:draw()
	studio:postWorldDraw()
	pedestrianController:draw()
	priorityRenderer:draw()
	studio:draw()
	game.worldObject:postDraw()
	camera:unset()
	love.graphics.setCanvas()
	love.graphics.setColor(255, 255, 255, 255)
	game.mainFrameBuffer:draw()
	
	if game.savingGame then
		game.finishSaving()
	end
	
	gui.performDrawing()
	
	if not gui.elementHovered then
		local comboBox = interactionController:getComboBox()
		
		if not comboBox or comboBox and not comboBox:isValid() then
			local object = game.getMouseOverObject()
			
			if object then
				object:drawMouseOver()
			end
		end
	end
	
	love.graphics.setColor(255, 255, 255, 255)
	
	if game.worldObject and DEBUG_PANEL then
		love.graphics.setFont(fonts.createdFonts.pix16)
		
		local grid = game.worldObject:getFloorTileGrid()
		local x, y = grid:getMouseTileCoordinates()
		local mx, my = camera:mousePosition()
		local index = grid:getTileIndex(x, y)
		local threadText = ""
		
		if curTime > nextRequest then
			perfStats = love.graphics.getStats()
			nextRequest = curTime + 1
		end
		
		local floor = camera:getViewFloor()
		local mouseRoom = studio.roomMap[floor][index]
		local finalText = table.concatEasy("", "DCALLS ", perfStats.drawcalls, "\nFPS ", love.timer.getFPS(), "\nRAM/VRAM ", tostring(math.round(collectgarbage("count") / 1024, 3)) .. "/" .. math.round(perfStats.texturememory / 1024 / 1024), "MB\nTIME PAUSED, SPEED: ", tostring(timeline.paused), ", x", timeline.speed, "\nCAMERA TOPLEFT: ", camera.x, "/", camera.y, "\nMOUSE COORDS ", mx, "/", my, "\nMOUSE GRID X/Y: ", x, "/", y, "\nOBJECTS AT MOUSE: ", game.worldObject:getObjectGrid():getObjects(x, y, floor) and #game.worldObject:getObjectGrid():getObjects(x, y, floor) or 0, "\nROOM AT MOUSE: ", tostring(mouseRoom) .. " " .. tostring(mouseRoom and #mouseRoom:getAssignedEmployees() or 0) .. " " .. tostring(mouseRoom and #mouseRoom:getObjects() or 0), "\nBUILDING AT MOUSE: " .. tostring(studio:getOfficeBuildingMap():getTileBuilding(index) or "none"), "\nBRIGHTNESS AT MOUSE: ", studio:getBrightnessMap():getTileBrightness(index, floor), "\n", threadText, "CACHED PATHS: ", pathCaching.totalPaths)
		local height = fonts.createdFonts.pix16:getTextHeight(finalText)
		local size = _S(15)
		local y = height + _S(20)
		local spacing = _S(5)
		local x = scrW - _S(5) - size
		
		love.graphics.printST(finalText, scrW - fonts.createdFonts.pix16:getWidth(finalText) - _S(5), _S(10))
	end
end

return mainRenderer
