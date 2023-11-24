local activePlatDevElem = {}

activePlatDevElem.barSpacing = 4

local designTask = task:getData("design_task")
local newPlatformTask = task:getData("new_platform_task")

activePlatDevElem.CATCHABLE_EVENTS = {
	designTask.EVENTS.REMOVE_DISPLAY,
	newPlatformTask.EVENTS.FINISHED,
	playerPlatform.EVENTS.CANCELLED_DEVELOPMENT,
	playerPlatform.EVENTS.GAME_FINISHED,
	playerPlatform.EVENTS.DEV_SEARCH_FINISHED
}

local activeProjectElement = gui.getClassTable("ActiveProjectElement")

function activePlatDevElem:init()
	activeProjectElement.init(self)
	
	self.underBarOuterSprites = {}
	self.underBarSprites = {}
	self.barSprites = {}
end

function activePlatDevElem:releasePlatformCallback()
	self.task:confirmRelease()
end

activePlatDevElem.FINISHED_GAMES_HOVER_TEXT = {
	{
		font = "bh18",
		wrapWidth = 400,
		lineSpace = 5,
		text = _T("PLATFORM_LAUNCH_DAY_GAMES_1", "The amount of launch-day games ready for this platform.")
	},
	{
		font = "bh18",
		wrapWidth = 400,
		iconHeight = 22,
		icon = "question_mark",
		iconWidth = 22,
		text = _T("PLATFORM_LAUNCH_DAY_GAMES_2", "The more ambitious a platform is, the more launch-day games it will need to have in order to not disappoint potential customers."),
		textColor = game.UI_COLORS.LIGHT_BLUE
	}
}

function activePlatDevElem:createWorkPointsDisplay()
	if not self.workPointsDisplay then
		self.workPointsDisplay = gui.create("ProjectElementInfoDisplay", self)
		
		self.workPointsDisplay:setIcon("wrench")
		self.workPointsDisplay:setSize(50, 18)
		self.workPointsDisplay:setFont("bh14")
		self.workPointsDisplay:setCanHover(false)
		self:updateWorkPoints()
		
		self.workCompletionDisplay = gui.create("ProjectElementInfoDisplay", self)
		
		self.workCompletionDisplay:setIcon("demolition_blue")
		self.workCompletionDisplay:setSize(54, 18)
		self.workCompletionDisplay:setFont("bh16")
		self.workCompletionDisplay:setCanHover(false)
		self:updateWorkCompletion()
		
		self.devGamesDisplay = gui.create("PlatformDevGamesInfoDisplay", self)
		
		self.devGamesDisplay:setIcon("platform_games_indev")
		self.devGamesDisplay:setSize(54, 18)
		self.devGamesDisplay:setFont("bh16")
		self:updateDevGameDisplay()
		
		self.finishedGamesDisplay = gui.create("ProjectElementInfoDisplay", self)
		
		self.finishedGamesDisplay:setIcon("platform_games_finished")
		self.finishedGamesDisplay:setSize(54, 18)
		self.finishedGamesDisplay:setFont("bh16")
		self.finishedGamesDisplay:setHoverText(activePlatDevElem.FINISHED_GAMES_HOVER_TEXT)
		self:updateFinishedGamesDisplay()
	end
end

function activePlatDevElem:adjustDisplayPositions()
	activePlatDevElem.baseClass.adjustDisplayPositions(self)
	
	if self.workPointsDisplay then
		local scaledFive = _S(5)
		local x = scaledFive + self.workCompletionDisplay.localX + self.workCompletionDisplay.w
		local y = self.workCompletionDisplay.localY
		
		self.devGamesDisplay:setPos(x, y)
		
		x = x + self.devGamesDisplay.w + scaledFive
		
		self.finishedGamesDisplay:setPos(x, y)
		
		self.barY = self.workPointsDisplay.localY + self.workPointsDisplay.h + _S(6)
	end
end

function activePlatDevElem:setTargetObject(taskObj)
	self.platform = taskObj:getPlatform()
	
	activePlatDevElem.baseClass.setTask(self, taskObj)
end

function activePlatDevElem:getPlatform()
	return self.platform
end

function activePlatDevElem:updateDevGameDisplay()
	self.devGamesDisplay:setText(#self.platform:getInDevGames())
end

function activePlatDevElem:updateFinishedGamesDisplay()
	self.finishedGamesDisplay:setText(#self.platform:getFinishedLaunchDayGames())
end

function activePlatDevElem:fillInteractionComboBox(comboBox)
	self.task:getPlatform():fillInteractionComboBox(comboBox)
	
	if self.task:isDone() then
		local option = comboBox:addOption(0, 0, 0, 24, _T("RELEASE_PLATFORM", "Release platform"), fonts.get("pix20"), activePlatDevElem.releasePlatformCallback)
		
		option.task = self.task
	end
end

function activePlatDevElem:handleEvent(event, object)
	if event == playerPlatform.EVENTS.GAME_FINISHED then
		self:updateDevGameDisplay()
		self:updateFinishedGamesDisplay()
	elseif event == playerPlatform.EVENTS.CANCELLED_DEVELOPMENT then
		if object == self.task:getPlatform() then
			self:kill()
		end
	elseif event == playerPlatform.EVENTS.DEV_SEARCH_FINISHED then
		if object == self.task:getPlatform() then
			self:updateDevGameDisplay()
		end
	elseif object == self.task then
		self:kill()
	end
end

function activePlatDevElem:updateUnderProgressBar()
end

activePlatDevElem.barXOffset = 4
activePlatDevElem.barSizeReduce = 2

function activePlatDevElem:updateVisualProgressBar()
	local baseX = _S(2 + self.barXOffset)
	
	self.reqWork = self.task:getRequiredWork()
	self.finishedWork = self.task:getFinishedWork()
	
	local firstStage = self.task:getFirstStageWorkAmount()
	
	baseX = self:setBarSprites(baseX, math.min(self.finishedWork, firstStage), firstStage, gameProject.STAGE_COLORS[1], 1)
	
	self:setBarSprites(baseX, self.finishedWork - firstStage, self.reqWork - firstStage, gameProject.STAGE_COLORS[2], 2)
end

function activePlatDevElem:setBarSprites(baseX, finished, required, barColor, key)
	local barWidth = (self.rawW - self.barSpacing * 2 - self.barXOffset * 2) * (required / self.reqWork)
	local barY = self.barY
	local barH = self.barHeight
	
	self:setNextSpriteColor(game.UI_COLORS.NEW_HUD_OUTER:unpack())
	
	self.underBarOuterSprites[key] = self:allocateHollowRoundedRectangle(self.underBarOuterSprites[key], baseX - _S(1), barY - _S(1), barWidth + 2, barH + 2, 2, -0.31)
	
	self:setNextSpriteColor(45, 45, 45, 255)
	
	self.underBarSprites[key] = self:allocateSprite(self.underBarSprites[key], "generic_1px", baseX, barY, 0, barWidth, barH, 0, 0, -0.3)
	
	if finished > 0 then
		local barCompletion = finished / required
		
		self:setNextSpriteColor(barColor.r, barColor.g, barColor.b, barColor.a)
		
		self.barSprites[key] = self:allocateSprite(self.barSprites[key], "vertical_gradient_75", baseX, barY, 0, barWidth * barCompletion, barH, 0, 0, -0.25)
	end
	
	baseX = baseX + _S(barWidth) + _S(self.barSpacing)
	
	return baseX
end

gui.register("ActivePlatformDevelopmentElement", activePlatDevElem, "ActiveTaskElement")
