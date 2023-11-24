local inputHandler = {}

function inputHandler:handleKeyPress(key)
	if self:_handleKeyPress(key) then
		inputService:setPreventPropagation(true)
		
		return true
	end
end

function inputHandler:_handleKeyPress(key)
	if DEBUG_MODE and key == "f10" then
		game.captureScreenshot(true)
	end
	
	if love.nonTextKeys[key] and gui.handleKeyPress(key) then
		return true
	end
	
	if not interactionController:handleKeyPress(key, isrepeat) and not studio:handleKeyPress(key, isrepeat) then
		game.handleKeyPress(key, isrepeat)
	else
		return true
	end
	
	local motIsActive = motivationalSpeeches:isActive()
	
	if not mainMenu.showing and not gui.elementSelected and not motIsActive and keyBinding:checkKey(key) then
		return true
	end
	
	if key == "return" and (love.keyboard.isDown("lalt") or love.keyboard.isDown("ralt")) then
		if love.window.getFullscreen() then
			if resolutionHandler:setScreenMode(resolutionHandler.SCREEN_MODES.WINDOWED) then
				resolutionHandler:applyScreenMode()
			end
		elseif resolutionHandler:setScreenMode(resolutionHandler.SCREEN_MODES.FULLSCREEN) then
			resolutionHandler:applyScreenMode()
		end
	end
	
	if DEBUG_MODE then
		if key == "f10" then
			game.captureScreenshot(true)
		elseif key == "h" then
			game.bottomHUD.buttons[math.random(1, #game.bottomHUD.buttons)]:disableRendering()
			game.bottomHUD:adjustLayout()
		elseif key == "f7" then
		elseif key == "f6" then
			for key, obj in ipairs(rivalGameCompanies:getCompanies()) do
				obj:buyOut(0)
			end
		elseif key == "z" then
			local oldVolume = musicPlayback.curVolume
			
			musicPlayback:setPlaybackVolume(musicPlayback.curVolume == 0 and musicPlayback.oldVolume or 0)
			
			musicPlayback.oldVolume = oldVolume
		elseif key == "j" then
		elseif key == "f4" then
			for key, empl in ipairs(studio:getEmployees()) do
				local wp = empl:getWorkplace()
				
				if wp then
					wp:addCoffee()
				end
			end
			
			studio:addFunds(10000000)
		elseif key == "f5" then
			for key, obj in ipairs(rivalGameCompanies:getCompanies()) do
				obj:goDefunct()
			end
		elseif key == "r" then
			for key, dev in ipairs(studio:getEmployees()) do
				dev:setAwayUntil(nil)
			end
		elseif key == "v" then
			for key, dev in ipairs(studio:getEmployees()) do
				dev:goOnVacation()
			end
		elseif key == "l" then
			for i = 1, 2 do
				collectgarbage("collect")
			end
		elseif key == "kp0" then
			DEBUG_PANEL = not DEBUG_PANEL
		elseif key == "kp+" and not motIsActive then
			if frameController:getFrameCount() == 0 and #objectSelector:getBlockers() == 0 then
				camera:changeZoomLevel(1)
			end
		elseif key == "kp-" and not motIsActive then
			if frameController:getFrameCount() == 0 and #objectSelector:getBlockers() == 0 then
				camera:changeZoomLevel(-1)
			end
		elseif key == "h" then
		end
	end
end

function inputHandler:handleKeyRelease(key)
	gui.handleKeyRelease(key)
	studio:handleKeyRelease(key)
	
	return true
end

function inputHandler:handleTextInput(text)
	gui.handleTextEntry(text)
end

return inputHandler
