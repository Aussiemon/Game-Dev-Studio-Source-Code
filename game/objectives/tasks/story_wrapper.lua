local storyWrapper = {}

storyWrapper.id = "story_wrapper"
storyWrapper.alwaysClickableIDs = {}

function storyWrapper:initConfig(cfg)
	storyWrapper.baseClass.initConfig(self, cfg)
	
	self.config = cfg
	self.overrides = cfg.overrides
	cfg.overrides = nil
	
	local realTask = objectiveHandler:createObjectiveTask(cfg, self.objective)
	
	self.task = realTask
	cfg.overrides = self.overrides
end

function storyWrapper:setTask(task)
	self.task = task
end

function storyWrapper:getTask()
	return self.task
end

function storyWrapper:onGameLogicStarted()
	self:startTutorial()
end

function storyWrapper:onStart()
	self.task:onStart()
	self:startTutorial()
end

function storyWrapper:onFinish()
	self.task:onFinish()
	self:resetTutorial()
end

function storyWrapper:addAlwaysClickableID(id)
	table.insert(self.alwaysClickableIDs, id)
end

function storyWrapper:startTutorial()
	local overR = self.overrides
	local clickIDs
	
	if overR.getClickIDs then
		clickIDs = overR:getClickIDs(self)
	else
		clickIDs = overR.clickIDs
	end
	
	if clickIDs then
		local newIDs = {}
		
		table.insertContents(clickIDs, newIDs)
		table.insertContents(storyWrapper.alwaysClickableIDs, newIDs)
		gui:setClickIDs(newIDs)
		
		self.clickIDsSet = true
		
		keyBinding:disableKeys()
	end
	
	if overR.blacklistClickIDs then
		gui:setBlacklistedClickIDs(overR.blacklistClickIDs)
		
		self.blacklistClickIDsSet = true
		
		keyBinding:disableKeys()
	end
	
	if overR.stopTime then
		timeline:setSpeed(0)
		timeline:setCanAdjustSpeed(false)
		
		if overR.stopTime ~= 1 then
			self.stoppedTime = true
		end
	end
	
	if overR.suppressMainMenu then
		game.setCanOpenMainMenu(false)
		
		self.suppressedMainMenu = true
	end
	
	if overR.pauseTime then
		timeline:pause()
		
		self.pausedTime = true
	end
	
	if overR.resumeTime then
		timeline:resume()
		timeline:setCanAdjustSpeed(true)
	end
	
	if overR.disableBuildingPurchases then
		studio.expansion:disableBuildingPurchases()
	end
	
	if overR.enableBuildingPurchases then
		studio.expansion:enableBuildingPurchases()
	end
	
	if overR.jobAcceptChance then
		employeeCirculation:overrideAcceptChance(overR.jobAcceptChance)
		
		self.overriddenJobAcceptChance = true
	end
	
	if overR.disableSaving then
		game.disableSaving()
		
		self.disabledSaving = true
	end
	
	if overR.moveCameraToBuilding then
		local buildingObject = game.worldObject:getOfficeObject(overR.moveCameraToBuilding)
		local action = cameraApproachAction.new()
		local midX, midY = buildingObject:getMidCoordinates()
		
		action:setTargetPosition(midX, midY)
		action:setApproachRate((math.dist(camera.midX, midX) + math.dist(camera.midY, midY)) / 2000)
		camera:addCameraApproach(action)
	end
	
	if overR.hideHUD then
		game.hideHUD()
		
		self.hudHidden = true
	end
	
	if overR.disableAutoClose then
		local elem = gui:getElementByID(overR.disableAutoClose)
		
		elem:setAutoClose(false)
	end
	
	if overR.allowTimeAdjustment then
		timeline:setCanAdjustSpeed(true)
	end
	
	if overR.disableExpansion then
		studio.expansion:disableExpansion()
	elseif overR.enableExpansion then
		studio.expansion:enableExpansion()
	end
	
	if overR.updateRivalPaychecks then
		for key, rivalObj in ipairs(rivalGameCompanies:getCompanies()) do
			rivalObj:updatePaycheckTime()
		end
	end
	
	if overR.allowRivalEmployeeStealing ~= nil then
		for key, company in ipairs(rivalGameCompanies:getCompanies()) do
			company:setCanStealEmployees(overR.allowRivalEmployeeStealing)
		end
	end
	
	if overR.allowRivalSlander ~= nil then
		for key, company in ipairs(rivalGameCompanies:getCompanies()) do
			company:setCanSlander(overR.allowRivalSlander)
		end
	end
	
	if overR.playerEmployeeStealChanceMult then
		for key, company in ipairs(rivalGameCompanies:getCompanies()) do
			company:setPlayerStealChanceMultiplier(overR.playerEmployeeStealChanceMult)
		end
	end
	
	if overR.playerSlanderDiscoveryChanceMult then
		for key, company in ipairs(rivalGameCompanies:getCompanies()) do
			company:setPlayerRivalSlanderDiscoveryChanceMultiplier(overR.playerSlanderDiscoveryChanceMult)
		end
	end
	
	if overR.makeRivalBankrupt then
		rivalGameCompanies:getCompanyByID(overR.makeRivalBankrupt):goDefunct()
	end
	
	if overR.initRivals then
		rivalGameCompanies:initCompanies(overR.initRivals)
		
		for key, id in ipairs(overR.initRivals) do
			local object = rivalGameCompanies:getCompanyByID(id)
			
			object:applyStartingStats()
		end
	end
	
	if overR.setRivalOffices then
		for key, data in ipairs(overR.setRivalOffices) do
			local rivalObject = rivalGameCompanies:getCompanyByID(data.rival)
			
			for key, buildingID in ipairs(data.officeIDs) do
				rivalObject:initBuildingOwnership(buildingID)
			end
		end
	end
	
	if overR.facts then
		for factID, state in pairs(overR.facts) do
			studio:setFact(factID, state)
		end
	end
	
	if overR.preventAutosave then
		autosave:addBlocker(self)
		
		self.preventedAutosave = true
	end
	
	if overR.expansionRoomTypes then
		studio.expansion:setMandatoryRoomTypes(overR.expansionRoomTypes)
		
		self.setExpansionRoomTypes = true
	end
	
	if overR.lockUI then
		gui.lock()
		
		self.lockedUI = true
	end
	
	if overR.unlockActions then
		for key, actionID in ipairs(overR.unlockActions) do
			interactionRestrictor:unlockAction(actionID)
		end
	end
	
	if overR.lockActions then
		for key, actionID in ipairs(overR.lockActions) do
			interactionRestrictor:restrictAction(actionID)
		end
	end
	
	if overR.generateEachRole then
		employeeCirculation:generateOneOfEach()
	end
	
	if overR.quietFunds then
		studio:addFunds(overR.quietFunds, true, "misc")
	end
	
	if overR.hudVisibility then
		game.curGametype:setHUDVisibility(overR.hudVisibility)
	end
	
	if overR.funds then
		studio:addFunds(overR.funds, nil, "misc")
	end
	
	if overR.expandHUD then
		local element = gui:getElementByID(overR.expandHUD)
		local buttons = element:getNearbyButtons()
		
		if not buttons or #buttons == 0 then
			element:expandOptions()
		end
	end
	
	local arrowCfg = overR.arrow
	
	if arrowCfg then
		self.arrowConfig = arrowCfg
		
		if not arrowCfg.skipBackgroundFade then
			self:createScreenDarkener()
		end
		
		self:createArrowPointer()
	end
end

function storyWrapper:createScreenDarkener()
	local darkener = gui.create("TutorialScreenDarkener")
	
	darkener:setTargetAlpha(0.5)
	darkener:setAlpha(0.5)
	darkener:setSize(scrW, scrH)
	darkener:setDepth(0)
	
	self.screenDarkener = darkener
end

function storyWrapper:createArrowPointer()
	local arrowCfg = self.arrowConfig
	local targetElement
	
	if type(arrowCfg.elementID) == "function" then
		targetElement = arrowCfg:elementID(self)
	else
		targetElement = gui:getElementByID(arrowCfg.elementID)
	end
	
	local targetX, targetY
	
	if arrowCfg.align then
		targetX, targetY = targetElement:getSide(arrowCfg.align)
	else
		targetX, targetY = targetElement:getPos(true)
	end
	
	if arrowCfg.offset then
		targetX = targetX + _S(arrowCfg.offset[1])
		targetY = targetY + _S(arrowCfg.offset[2])
	end
	
	if arrowCfg.heightOffset then
		targetY = targetY + targetElement.h * arrowCfg.heightOffset
	end
	
	if arrowCfg.widthOffset then
		targetX = targetX + targetElement.w * arrowCfg.widthOffset
	end
	
	local size = arrowCfg.size or 50
	local arrow = gui.create("ArrowPointer")
	
	arrow:setAngle(arrowCfg.angle or 0)
	arrow:setSize(size, size)
	arrow:setPos(targetX, targetY)
	arrow:setTrackElement(targetElement)
	
	if arrowCfg.followElement then
		arrow:setFollowElement(targetElement)
	end
	
	if targetElement then
		local x, y = targetElement:getPos(true)
		
		arrow:setFollowOffset(targetX - x, targetY - y)
	end
	
	if arrowCfg.moveAmount then
		arrow:setMoveAmount(arrowCfg.moveAmount)
	end
	
	if arrowCfg.moveSpeed then
		arrow:setMoveSpeed(arrowCfg.moveSpeed)
	end
	
	self.arrow = arrow
	
	arrow:bringUp(50)
	
	if arrowCfg.onAttach then
		arrowCfg:onAttach(targetElement, self)
	end
end

function storyWrapper:addClickID(id)
	gui:addClickID(id)
	
	self.clickIDsSet = true
end

function storyWrapper:resetTutorial()
	if self.clickIDsSet then
		gui:clearClickIDs()
		keyBinding:enableKeys()
	end
	
	if self.blacklistClickIDsSet then
		gui:clearBlacklistedClickIDs()
		keyBinding:enableKeys()
	end
	
	if self.preventedAutosave then
		autosave:removeBlocker(self)
	end
	
	if self.stoppedTime then
		timeline:setSpeed(1)
		timeline:setCanAdjustSpeed(true)
	end
	
	if self.overriddenJobAcceptChance then
		employeeCirculation:overrideAcceptChance(nil)
	end
	
	if self.lockedUI then
		gui.unlock()
	end
	
	if self.hudHidden then
		game.showHUD()
	end
	
	if self.disableSaving then
		game.enableSaving()
	end
	
	if self.pausedTime then
		timeline:resume()
		timeline:setCanAdjustSpeed(true)
	end
	
	if self.suppressedMainMenu then
		game.setCanOpenMainMenu(true)
	end
	
	if self.setExpansionRoomTypes then
		studio.expansion:setMandatoryRoomTypes(nil)
	end
	
	if self.screenDarkener and self.screenDarkener:isValid() then
		self.screenDarkener:kill()
		
		self.screenDarkener = nil
	end
	
	if self.arrow then
		self.arrow:kill()
		
		self.arrow = nil
	end
end

function storyWrapper:handleEvent(event, ...)
	if event == game.EVENTS.RESOLUTION_CHANGED then
		if self.arrowConfig then
			self:createArrowPointer()
		end
		
		if self.screenDarkener and not self.skipBackgroundFade then
			self:createScreenDarkener()
		end
	else
		self.task:handleEvent(event, ...)
	end
end

function storyWrapper:getProgress()
	return self.task:getProgress()
end

function storyWrapper:getProgressValues()
	return self.task:getProgressValues()
end

function storyWrapper:getProgressPercentage()
	return self.task:getProgressPercentage()
end

function storyWrapper:hasStarted()
	return self.task:hasStarted()
end

function storyWrapper:setHasStarted(state)
	self.task:setHasStarted(state)
end

function storyWrapper:isFinished()
	return self.task:isFinished()
end

function storyWrapper:remove()
	self.task:remove()
	self:resetTutorial()
end

function storyWrapper:save()
	local saved = storyWrapper.baseClass.save(self)
	
	saved.task = self.task:save()
	
	return saved
end

function storyWrapper:load(data)
	storyWrapper.baseClass.load(self, data)
	self.task:load(data.task)
end

objectiveHandler:registerNewTask(storyWrapper, "base_task")
