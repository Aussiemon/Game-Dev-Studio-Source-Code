loadingScreen = {}
loadingScreen.INTER_LOAD_DELAY = 0.1
loadingScreen.INSTANT = false

function loadingScreen:start(totalProgress, loadFunc)
	if self.INSTANT then
		loadFunc()
		game.showHUD()
	else
		self.finished = false
		self.active = true
		
		layerRenderer:addLayer(self)
		inputService:addHandler(self)
		
		self.progressValue = 0
		self.progressText = ""
		self.loadWait = 0
		self.loadFunc = loadFunc
		self.loadingBar = gui.create("LoadingProgressBar")
		
		self.loadingBar:setSize(400, 20)
		self.loadingBar:setupTip()
		self.loadingBar:updateDisplay()
		self.loadingBar:center()
		
		self.loadingCoroutine = coroutine.create(function()
			self.loadFunc()
		end)
	end
end

function loadingScreen:handleMouseClick(key)
	self:attemptGoToGame()
	
	return true
end

function loadingScreen:handleKeyPress(key)
	self:attemptGoToGame()
	
	return true
end

function loadingScreen:handleKeyRelease(key)
end

function loadingScreen:handleTextInput(text)
end

function loadingScreen:attemptGoToGame()
	if self.finished then
		game.startGameLogic()
		loadingScreen:hide()
		
		return true
	end
	
	return false
end

function loadingScreen:isActive()
	return self.active
end

function loadingScreen:getProgress()
	return self.progressValue
end

function loadingScreen:getText()
	return self.progressText
end

function loadingScreen:finish()
	events:fire(game.EVENTS.ENTER_GAMEPLAY)
	
	if self.INSTANT then
		game.startGameLogic()
		
		return 
	end
	
	self.active = false
	self.finished = true
	
	self:updateProgress(1, _T("PRESS_ANY_KEY_TO_CONTINUE", "Press any key to continue"))
end

function loadingScreen:hide()
	self.loadingBar:kill()
	
	self.loadingBar = nil
	self.loadFunc = nil
	self.loadingCoroutine = nil
	
	game.showHUD(true)
	layerRenderer:removeLayer(self)
	inputService:removeHandler(self)
	self:showInteractables()
	
	local fader = gui.create("ScreenFader")
	
	fader:setTargetAlpha(1)
	fader:setAlpha(1)
	fader:setFadeState(fader.STATES.OUT)
	fader:bringUp()
	fader:setSize(scrW, scrH)
	fader:setFadeColor(mainMenu.backgroundColor)
end

function loadingScreen:showInteractables()
	if not dialogueHandler:attemptStartDialogue() then
		frameController:showQueuedFrames()
	end
end

function loadingScreen:isFinished()
	return self.finished
end

function loadingScreen:updateProgress(progressValue, progressText)
	if self.INSTANT then
		return 
	end
	
	self.loadWait = curTime + self.INTER_LOAD_DELAY
	self.progressValue = progressValue
	self.progressText = progressText
	
	if self.loadingBar then
		self.loadingBar:updateDisplay()
	end
	
	if self.loadingCoroutine then
		coroutine.yield()
	end
end

function loadingScreen:draw()
	gui.performDrawing()
	
	local status = coroutine.status(self.loadingCoroutine)
	
	if status == "suspended" and curTime > self.loadWait then
		local success, error = coroutine.resume(self.loadingCoroutine)
		
		if error then
			love.errhand(error)
		end
	end
end

return loadingScreen
