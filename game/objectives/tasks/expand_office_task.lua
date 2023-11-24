local expandOffice = {}

expandOffice.id = "expand_office"

function expandOffice:initConfig(cfg)
	expandOffice.baseClass.initConfig(self, cfg)
	
	self.requiredExpansions = cfg.expansions
	self.expansions = 0
end

function expandOffice:getProgressValues()
	return math.min(self.requiredExpansions, self.expansions), self.requiredExpansions
end

function expandOffice:handleEvent(event)
	if event == studio.expansion.EVENTS.EXPANDED_OFFICE then
		self.expansions = self.expansions + 1
		
		events:fire(objectiveHandler.EVENTS.UPDATE_PROGRESS_DISPLAY, self)
		
		if self.expansions >= self.requiredExpansions then
			self.completed = true
		end
	end
end

function expandOffice:save()
	local saved = expandOffice.baseClass.save(self)
	
	saved.expansions = self.expansions
	
	return saved
end

function expandOffice:load(data)
	self.expansions = data.expansions
end

objectiveHandler:registerNewTask(expandOffice, "base_task")
