frameController = {}
frameController.lastFrameTime = 0
frameController.test = false
frameController.EVENTS = {
	CLEARED_FRAMES = events:new(),
	FRAME_PUSHED = events:new()
}

function frameController:init()
	self.allFrames = {}
end

function frameController:preventsMouseOver()
	local frameCount = #self.allFrames
	
	return frameCount > 0 and self.allFrames[frameCount]:preventsMouseOver()
end

function frameController:hide()
	local window = self.allFrames[#self.allFrames]
	
	if window then
		window:hide()
		game.setCurrentWindow(nil)
		
		return true
	end
	
	return false
end

function frameController:show()
	local window = self.allFrames[#self.allFrames]
	
	if window and not window:getVisible() then
		game.setCurrentWindow(window)
		window:show()
		
		return true
	end
	
	return false
end

function frameController:push(frame)
	if frameController.test then
		frame:kill()
		
		return 
	end
	
	local prevFrame = self.allFrames[#self.allFrames]
	
	frame:addDepth(600)
	
	if prevFrame then
		prevFrame:hide()
		prevFrame:dequeueShowSound()
		prevFrame:setAnimated(false)
	end
	
	timeline:pause()
	game.setCurrentWindow(frame)
	frame:setWasPushed(true)
	
	if #self.allFrames == 0 then
		autosave:addBlocker(self)
		timeline:breakIteration()
		
		if game.topHUD then
			game.topHUD:disableClicks()
		end
		
		if frame:preventsMouseOver() then
			objectSelector:addBlocker(self)
		end
	end
	
	if dialogueHandler:isActive() or loadingScreen:isActive() then
		frame:hide()
		frame:dequeueShowSound()
		table.insert(self.allFrames, frame)
		
		return 
	end
	
	table.insert(self.allFrames, frame)
	self:_showFrame(frame)
end

function frameController:_showFrame(frame)
	frame:show()
	objectSelector:reset(true)
	game.hideHUD()
	self:attemptPlayShowSound(frame)
	events:fire(frameController.EVENTS.FRAME_PUSHED, frame)
	interactionController:resetInteractionObject()
	game.clearActiveCameraKeys()
	camera:removeTouch()
	
	if frame.shouldBlockLightingManager then
		lightingManager:pause()
	end
end

function frameController:attemptPlayShowSound(frame)
	local showSound = frame:getShowSound()
	
	if showSound then
		frame:queueShowSound()
	end
end

function frameController:showQueuedFrames()
	local frameObj = self.allFrames[#self.allFrames]
	
	if frameObj then
		self:_showFrame(frameObj)
	end
end

function frameController:getFrameCount()
	return #self.allFrames
end

function frameController:pop()
	local curFrame = self.allFrames[#self.allFrames]
	local canShowNextFrame = not dialogueHandler:isInProgress()
	
	if curFrame then
		table.remove(self.allFrames, #self.allFrames)
		
		if curFrame:isValid() then
			curFrame:kill()
		end
		
		local prevFrame = self.allFrames[#self.allFrames]
		
		if canShowNextFrame then
			if prevFrame then
				prevFrame:show()
				prevFrame:update()
				game.setCurrentWindow(prevFrame)
				self:attemptPlayShowSound(prevFrame)
				
				if prevFrame:preventsMouseOver() then
					objectSelector:addBlocker(self)
				else
					objectSelector:removeBlocker(self)
				end
				
				if prevFrame.shouldBlockLightingManager then
					lightingManager:pause()
				else
					lightingManager:unpause()
				end
			else
				game.setCurrentWindow(nil)
			end
		end
	end
	
	if #self.allFrames <= 0 then
		autosave:removeBlocker(self)
		objectSelector:removeBlocker(self)
		
		if game.topHUD then
			game.topHUD:enableClicks()
		end
	end
	
	if #self.allFrames <= 0 then
		if canShowNextFrame then
			timeline:resume()
			game.showHUD()
			game.setCameraPanState(true)
			lightingManager:unpause()
		end
		
		game.setCurrentWindow(nil)
		events:fire(frameController.EVENTS.CLEARED_FRAMES)
	else
		game.hideHUD()
	end
	
	interactionController:verifyComboBoxValidity()
end

function frameController:verifyScreenClearance()
	if #self.allFrames == 0 then
		events:fire(frameController.EVENTS.CLEARED_FRAMES)
	end
end

function frameController:clearAll()
	while #self.allFrames > 0 do
		self.allFrames[1]:kill()
	end
	
	objectSelector:removeBlocker(self)
	autosave:removeBlocker(self)
	
	if game.topHUD then
		game.topHUD:enableClicks()
	end
end

frameController:init()
