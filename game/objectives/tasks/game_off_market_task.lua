local gameOffMarketTask = {}

gameOffMarketTask.id = "game_off_market"

function gameOffMarketTask:initConfig(cfg)
	gameOffMarketTask.baseClass.initConfig(self, cfg)
	
	self.completed = false
end

function gameOffMarketTask:handleEvent(event, gameProj)
	if event == gameProject.EVENTS.GAME_OFF_MARKET and gameProj:getOwner() == studio then
		self.completed = true
	end
end

objectiveHandler:registerNewTask(gameOffMarketTask, "wait_for_event")
