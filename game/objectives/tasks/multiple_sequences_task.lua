local multipleSequenceTask = {}

multipleSequenceTask.id = "multiple_sequences"

function multipleSequenceTask:initConfig(cfg)
	multipleSequenceTask.baseClass.initConfig(self, cfg)
	
	self.sequences = {}
	self.mainSequences = cfg.mainSequences or {
		1
	}
	
	for key, sequenceData in ipairs(cfg.sequences) do
		sequenceData.id = "sequence"
		
		local sequenceTaskObject = objectiveHandler:createObjectiveTask(sequenceData, self.objective)
		
		table.insert(self.sequences, sequenceTaskObject)
	end
end

function multipleSequenceTask:getSequences()
	return self.sequences
end

function multipleSequenceTask:onGameLogicStarted()
	for key, sequence in ipairs(self.sequences) do
		sequence:onGameLogicStarted()
	end
end

function multipleSequenceTask:onStart()
	for key, sequenceTaskObject in ipairs(self.sequences) do
		sequenceTaskObject:onStart()
	end
end

function multipleSequenceTask:onFinish()
	for key, sequenceTaskObject in ipairs(self.sequences) do
		sequenceTaskObject:onFinish()
	end
end

function multipleSequenceTask:remove()
	for key, taskObject in ipairs(self.sequences) do
		taskObject:remove()
	end
end

function multipleSequenceTask:getProgressData(targetList)
	for key, sequenceTaskObject in ipairs(self.sequences) do
		sequenceTaskObject:getProgressData(targetList)
	end
end

function multipleSequenceTask:getProgressValues()
	return 1, 1
end

function multipleSequenceTask:isFinished()
	for key, sequenceID in ipairs(self.mainSequences) do
		if not self.sequences[sequenceID]:isFinished() then
			return false
		end
	end
	
	return true
end

function multipleSequenceTask:handleEvent(...)
	for key, sequenceTaskObject in ipairs(self.sequences) do
		if not sequenceTaskObject:isFinished() then
			sequenceTaskObject:handleEvent(...)
		end
	end
end

function multipleSequenceTask:save()
	local saved = multipleSequenceTask.baseClass.save(self)
	
	saved.sequences = {}
	
	for key, taskObject in ipairs(self.sequences) do
		table.insert(saved.sequences, taskObject:save())
	end
	
	return saved
end

function multipleSequenceTask:load(data)
	multipleSequenceTask.baseClass.load(self, data)
	
	for key, sequenceData in ipairs(data.sequences) do
		self.sequences[key]:load(sequenceData)
	end
end

objectiveHandler:registerNewTask(multipleSequenceTask, "base_task")
