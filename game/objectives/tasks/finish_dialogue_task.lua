local finishDialogueTask = {}

finishDialogueTask.id = "finish_dialogue"

function finishDialogueTask:initConfig(cfg)
	finishDialogueTask.baseClass.initConfig(self, cfg)
	
	self.completed = false
	self.dialogueID = cfg.dialogueID
	self.startDialogue = cfg.startDialogue
	self.portraitName = cfg.portraitName
	self.rival = cfg.rival
end

function finishDialogueTask:onStart()
	if self.startDialogue then
		local dialogueObject
		
		if self.rival then
			dialogueObject = rivalGameCompanies:getCompanyByID(self.rival):startDialogue(self.startDialogue)
		else
			dialogueObject = dialogueHandler:addDialogue(self.startDialogue, game.getDialogueName("investor"), nil, nil)
		end
		
		dialogueObject:setID(self.dialogueID)
	end
end

function finishDialogueTask:isFinished()
	return self.completed
end

function finishDialogueTask:getProgressValues()
	return self.completed and 1 or 0, 1
end

function finishDialogueTask:handleEvent(event, finishedDialogueObject)
	if event == dialogueHandler.EVENTS.FINISHED then
		if self.dialogueID then
			if finishedDialogueObject:getID() == self.dialogueID then
				self.completed = true
			end
		else
			self.completed = true
		end
	end
end

function finishDialogueTask:save()
	local saved = finishDialogueTask.baseClass.save(self)
	
	saved.completed = self.completed
	
	return saved
end

function finishDialogueTask:load(data)
	finishDialogueTask.baseClass.load(self, data)
	
	self.completed = data.completed
end

objectiveHandler:registerNewTask(finishDialogueTask, "base_task")
