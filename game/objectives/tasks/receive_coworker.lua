local receiveCoworkerTask = {}

receiveCoworkerTask.id = "receive_coworker"

function receiveCoworkerTask:initConfig(cfg)
	receiveCoworkerTask.baseClass.initConfig(self, cfg)
	
	self.targetReputation = cfg.reputation
	self.employeeConfig = cfg.employeeConfig
	self.dialogueID = cfg.dialogueID
	self.refuseQuestionID = cfg.refuseQuestionID
end

function receiveCoworkerTask:handleEvent(event, change, company)
	if event == studio.EVENTS.REPUTATION_CHANGED and company:isPlayer() and company:getReputation() >= self.targetReputation then
		local employee = employeeCirculation:generateEmployeeFromConfig(self.employeeConfig)
		
		employee:setFact(employeeCirculation.ALWAYS_ACCEPT_JOB_OFFER_FACT, true)
		
		local obj = dialogueHandler:addDialogue(self.dialogueID, nil, employee)
		
		obj:setFact("question_id", self.refuseQuestionID)
		
		self.firstPart = true
	elseif event == dialogueHandler.EVENTS.CLOSED and self.firstPart then
		self.completed = true
	end
end

objectiveHandler:registerNewTask(receiveCoworkerTask, "base_task")
