dialogueHandler = {}
dialogueHandler.registeredQuestions = {}
dialogueHandler.registeredQuestionsByID = {}
dialogueHandler.registeredAnswers = {}
dialogueHandler.registeredAnswersByID = {}
dialogueHandler.currentDialogueObjects = {}
dialogueHandler.currentIndex = nil
dialogueHandler.currentDialogueData = nil
dialogueHandler.uiElements = {}
dialogueHandler.baseDarkenerDepth = 100
dialogueHandler.baseConversationDepth = 20000
dialogueHandler.EVENTS = {
	FINISHED = "dialogue_finished",
	CLOSED = "dialogue_closed"
}

local baseQuestionFuncs = {}

function baseQuestionFuncs:getText(dialogueObject)
	if type(self.text) == "string" then
		return self.text
	end
	
	return self.text[math.random(1, #self.text)]
end

function baseQuestionFuncs:canPlaySpool()
	return true
end

function baseQuestionFuncs:canPlaySound()
	return self.sound and sound.getSoundData(self.sound)
end

function baseQuestionFuncs:playSound()
	if self:canPlaySound() then
		self.playedSound = sound:play(self.sound)
	end
end

function baseQuestionFuncs:stopSound()
	if self.playedSound then
		sound.manager:removeSound(self.playedSound)
	end
end

function baseQuestionFuncs:getAnswers(dialogueObject)
	return self.answers
end

function baseQuestionFuncs:getNextQuestion()
	return self.nextQuestion
end

function baseQuestionFuncs:onStart(answerID)
end

function baseQuestionFuncs:onStartSpooling(dialogueObject)
end

function baseQuestionFuncs:onFinish(dialogueObject)
end

baseQuestionFuncs.mtindex = {
	__index = baseQuestionFuncs
}

function dialogueHandler.registerQuestion(data)
	table.insert(dialogueHandler.registeredQuestions, data)
	
	dialogueHandler.registeredQuestionsByID[data.id] = data
	
	setmetatable(data, baseQuestionFuncs.mtindex)
end

local baseAnswerFuncs = {}

function baseAnswerFuncs:getText(dialogueObject)
	if type(self.text) == "string" then
		return self.text
	end
	
	return self.text[math.random(1, #self.text)]
end

function baseAnswerFuncs:canEndDialogue(dialogueObject)
	return self.endDialogue
end

function baseAnswerFuncs:getNextQuestion(dialogueObject)
	return self.question
end

function baseAnswerFuncs:getReturnText(dialogueObject)
	return self.returnText
end

function baseAnswerFuncs:onPick(questionID, answerKey)
end

function baseAnswerFuncs:postPickAnswer()
end

baseAnswerFuncs.mtindex = {
	__index = baseAnswerFuncs
}

function dialogueHandler.registerAnswer(data)
	table.insert(dialogueHandler.registeredAnswers, data)
	
	dialogueHandler.registeredAnswersByID[data.id] = data
	
	setmetatable(data, baseAnswerFuncs.mtindex)
end

function dialogueHandler:init()
	events:addDirectReceiver(self, dialogueHandler.CATCHABLE_EVENTS)
end

function dialogueHandler:remove()
	self:resetDialogueData()
	events:removeDirectReceiver(self, dialogueHandler.CATCHABLE_EVENTS)
end

function dialogueHandler:handleKeyPress(key, isrepeat)
	if self.currentDialogue and not self.hidden then
		self.currentDialogue:handleKeyPress(key, isrepeat)
		
		return true
	end
end

function dialogueHandler:resetDialogueData()
	table.clear(self.currentDialogueObjects)
end

function dialogueHandler:handleEvent(event)
	if self.currentDialogue then
		local screenDarkener = gui.getClassTable("ScreenDarkener")
		local dialogueBox = gui.getClassTable("DialogueBox")
		
		if event == screenDarkener.EVENTS.REACHED_FULL_ALPHA and not self.finishedDialogue then
			self.currentDialogue:createUI()
		elseif event == dialogueBox.EVENTS.FLEW_AWAY and self:attemptAdvanceDialogue() then
			self.currentDialogue:getDialogueBox():setFlyAway(false)
		end
	end
end

function dialogueHandler:pickAnswer(answerID)
	local answerData = dialogueHandler.registeredAnswersByID[answerID]
	
	answerData:onPick()
end

function dialogueHandler:setQuestion(questionObject)
	timeline:pause()
	
	self.currentDialogue = questionObject
	
	self.currentDialogue:begin()
	
	if self.currentDialogue:getSkippedUI() then
		self.screenDarkener = gui.create("DialogueScreenDarkener")
		
		self.screenDarkener:setPos(0, 0)
		self.screenDarkener:setSize(scrW, scrH)
		self.screenDarkener:setDepth(dialogueHandler.baseDarkenerDepth)
	end
end

function dialogueHandler:getScreenDarkener()
	return self.screenDarkener
end

function dialogueHandler:hide()
	self.currentDialogue:hide()
	self.screenDarkener:hide()
	
	self.hidden = true
	
	autosave:removeBlocker(self)
	objectSelector:removeBlocker(self)
end

function dialogueHandler:show()
	self.currentDialogue:show()
	self.screenDarkener:show()
	
	self.hidden = false
	
	autosave:addBlocker(self)
	objectSelector:addBlocker(self)
	game.hideHUD()
	timeline:pause()
end

function dialogueHandler:attemptStartDialogue()
	if not self.currentIndex then
		local object = self.currentDialogueObjects[1]
		
		if object then
			frameController:hide()
			
			self.currentIndex = 1
			
			self:setQuestion(object, true)
			autosave:addBlocker(self)
			objectSelector:addBlocker(self)
			
			self.finishedDialogue = false
			
			game.hideHUD()
			game.clearActiveCameraKeys()
			interactionController:resetInteractionObject()
			
			return true
		end
		
		return false
	elseif not self.currentDialogue then
		if self.currentIndex < #self.currentDialogueObjects then
			self.currentIndex = self.currentIndex + 1
			
			self:setQuestion(self.currentDialogueObjects[self.currentIndex])
			
			return true
		else
			self:finishDialogue()
			
			return false
		end
	end
	
	return false
end

function dialogueHandler:onFinishDialogue(answerID)
	self.currentDialogue:getDialogueBox():setFlyAway(true)
	self:killEmployeeInfoDisplay(self.currentDialogue)
	events:fire(dialogueHandler.EVENTS.FINISHED, self.currentDialogue)
	
	if self.currentIndex == #self.currentDialogueObjects then
		self.screenDarkener:setTargetAlpha(0)
		
		self.finishedDialogue = true
	end
end

function dialogueHandler:attemptAdvanceDialogue()
	self.currentDialogue:onFinish(answerID)
	
	self.currentDialogue = nil
	
	return self:attemptStartDialogue()
end

function dialogueHandler:isActive()
	return self.currentDialogue ~= nil and not self.hidden
end

function dialogueHandler:isInProgress()
	return self.currentDialogue ~= nil
end

dialogueHandler.EMPLOYEE_INFO_DISPLAY_FACT = "employeeInfoDisplay"

function dialogueHandler:updateSkillChangePosition(dialogueObject)
	local display = dialogueObject:getFact(dialogueHandler.EMPLOYEE_INFO_DISPLAY_FACT)
	
	if display then
		local elements = dialogueObject:getAnswerElements()
		local element = elements[1]
		
		display:setPos(element.x, element.y - display.h - _S(10))
	end
end

function dialogueHandler:createSkillChangeDisplay(dialogueObject, overview)
	local employee = dialogueObject:getEmployee()
	local display = gui.create("ChangedSkillsDisplay")
	
	if overview then
		display:setShowOverview(true)
	end
	
	display:setEmployee(employee)
	
	local elements = dialogueObject:getAnswerElements()
	local element = elements[1]
	local xPos, yPos = dialogueObject:getAnswerBasePosition()
	
	display:setPos(xPos, yPos - display.h - _S(10))
	dialogueObject:setFact(dialogueHandler.EMPLOYEE_INFO_DISPLAY_FACT, display)
end

function dialogueHandler:killEmployeeInfoDisplay(dialogueObject)
	local display = dialogueObject:getFact(dialogueHandler.EMPLOYEE_INFO_DISPLAY_FACT)
	
	if display then
		display:kill()
		dialogueObject:setFact(dialogueHandler.EMPLOYEE_INFO_DISPLAY_FACT, nil)
	end
end

function dialogueHandler:addDialogue(questionID, characterName, employee, preStartCallback)
	if not characterName and employee then
		characterName = employee:getFullName(true)
	end
	
	local data = {
		questionID = questionID,
		characterName = characterName,
		employee = employee
	}
	local dialogueObject = dialogue.new(dialogueHandler.registeredQuestionsByID[questionID], data, #self.currentDialogueObjects == 0)
	
	dialogueObject:setCharacterName(characterName)
	table.insert(self.currentDialogueObjects, dialogueObject)
	
	if preStartCallback then
		preStartCallback(dialogueObject)
	end
	
	if not self.currentDialogue and not loadingScreen:isActive() then
		self:attemptStartDialogue()
	end
	
	return dialogueObject
end

function dialogueHandler:finishDialogue()
	local finishedDialogue = self.currentDialogue
	
	if self.currentDialogue then
		self.currentDialogue:onFinish()
	end
	
	self:resetDialogueData()
	
	self.currentIndex = nil
	self.currentDialogue = nil
	
	if self.screenDarkener then
		self.screenDarkener:kill()
		
		self.screenDarkener = nil
	end
	
	if not frameController:show() then
		timeline:resume()
		game.showHUD()
	end
	
	autosave:removeBlocker(self)
	objectSelector:removeBlocker(self)
	events:fire(dialogueHandler.EVENTS.CLOSED)
	frameController:verifyScreenClearance()
end

dialogueHandler.registerAnswer({
	id = "end_conversation",
	text = _T("END_CONVERSATION", "[END CONVERSATION]")
})
dialogueHandler.registerAnswer({
	id = "end_conversation_ok",
	endDialogue = true,
	text = _T("END_CONVERSATION_OK", "OK.")
})
dialogueHandler.registerAnswer({
	id = "end_conversation_got_it",
	endDialogue = true,
	text = _T("END_CONVERSATION_GOT_IT", "I got it.")
})
dialogueHandler.registerAnswer({
	id = "generic_continue",
	text = _T("GENERIC_CONVERSATION_CONTINUE", "[...]")
})
dialogueHandler.registerAnswer({
	id = "generic_hang_up",
	endDialogue = true,
	text = _T("HANG_UP", "[HANG UP]")
})
dialogueHandler.registerAnswer({
	id = "generic_nevermind",
	question = "talk_to_employee",
	text = _T("GENERIC_NEVERMIND", "Nevermind."),
	returnText = _T("GENERIC_NEVERMIND_RETURN", "Alright, was there something else you wanted?")
})
dialogueHandler.registerAnswer({
	id = "generic_thanks_for_info",
	question = "talk_to_employee",
	text = _T("GENERIC_THANKS_FOR_INFO", "Thanks for the info."),
	returnText = _T("GENERIC_THANKS_FOR_INFO_RETURN", "No problem, was there something else you wanted?")
})
dialogueHandler.registerAnswer({
	id = "generic_thanks_for_info_2",
	question = "talk_to_employee",
	text = _T("GENERIC_THANKS_FOR_INFO", "Thanks for the info."),
	returnText = _T("GENERIC_THANKS_FOR_INFO_RETURN_2", "No problem, is there anything else you'd like me to do?")
})
dialogueHandler.registerAnswer({
	id = "generic_return_to_conversation",
	question = "talk_to_employee",
	text = _T("GENERIC_CONVERSATION_CONTINUE", "[...]"),
	returnText = _T("GENERIC_RETURN_TO_CONVERSATION_RETURN", "Anything else?")
})
require("game/dialogue/dialogue")
require("game/dialogue/test_dialogue")
require("game/dialogue/developer/developer")
require("game/dialogue/story_mode/story_mode")
require("game/dialogue/scenarios/back_in_the_game")
require("game/dialogue/scenarios/pay_denbts")
require("game/dialogue/tutorial/construction")
require("game/dialogue/tutorial/employees")
require("game/dialogue/tutorial/projects")
