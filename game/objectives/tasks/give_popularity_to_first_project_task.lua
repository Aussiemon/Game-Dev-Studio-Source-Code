local givePop = {}

givePop.id = "give_popularity_to_first_project"

function givePop:initConfig(cfg)
	givePop.baseClass.initConfig(self, cfg)
	
	self.popularity = cfg.popularity
end

function givePop:onStart()
	for key, projectObj in ipairs(studio:getGames()) do
		projectObj:increasePopularity(self.popularity)
		
		break
	end
	
	self.finished = true
end

function givePop:isFinished()
	return self.finished
end

function givePop:handleEvent(event, change, newAmount, quiet)
end

objectiveHandler:registerNewTask(givePop, "base_task")
