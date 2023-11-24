local bankruptRival = {}

bankruptRival.id = "bankrupt_rival"

function bankruptRival:initConfig(cfg)
	bankruptRival.baseClass.initConfig(self, cfg)
	
	self.rivalID = cfg.rivalID
end

function bankruptRival:handleEvent(event, company)
	if event == rivalGameCompany.EVENTS.FILED_FOR_BANKRUPTCY and company:getID() == self.rivalID then
		self.completed = true
	end
end

objectiveHandler:registerNewTask(bankruptRival, "base_task")
