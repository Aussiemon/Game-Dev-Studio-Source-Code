local rivalStopsExistingTask = {}

rivalStopsExistingTask.id = "rival_stops_existing"

function rivalStopsExistingTask:initConfig(cfg)
	rivalStopsExistingTask.baseClass.initConfig(self, cfg)
	
	self.rivalID = cfg.rivalID
end

function rivalStopsExistingTask:handleEvent(event, company)
	local evs = rivalGameCompany.EVENTS
	
	if (event == evs.RIVAL_DEFUNCT_POPUP_CLOSED or event == evs.RIVAL_BUYOUT_POPUP_CLOSED) and self.rivalID == company:getID() then
		self.completed = true
	end
end

objectiveHandler:registerNewTask(rivalStopsExistingTask, "base_task")
