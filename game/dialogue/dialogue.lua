dialogue = {}
dialogue.mtindex = {
	__index = dialogue
}
dialogue.currentQuestion = nil
dialogue.HORIZONTAL_SPACING = 50
dialogue.BOTTOM_SPACING = 0
dialogue.ANSWER_SPACING = 5
dialogue.ANSWER_ELEMENT_WIDTH = 600
dialogue.BASE_ELEMENT_OFFSET = 50
dialogue.ANSWER_ELEMENT_OFFSET = -50
dialogue.MIN_GAP_BETWEEN_TEXTBOX_AND_ANSWERS = 20

function dialogue.new(registeredQuestionData, questionData, skipUI)
	local new = {}
	
	setmetatable(new, dialogue.mtindex)
	new:init(registeredQuestionData, questionData, skipUI)
	
	return new
end

function dialogue:init(registeredQuestionData, questionData, skipUI)
	self.facts = {}
	self.shownQuestions = {}
	self.pickedAnswers = {}
	self.uiElements = {}
	self.answerElements = {}
	self.employee = questionData.employee
	self.initialQuestionData = registeredQuestionData
	self.id = registeredQuestionData.uniqueDialogueID
	self.skippedUI = skipUI
end

function dialogue:setID(id)
	self.id = id
end

function dialogue:getID()
	return self.id
end

function dialogue:getQuestionData()
	return self.initialQuestionData
end

function dialogue:getSkippedUI()
	return self.skippedUI
end

function dialogue:begin()
	self.isActive = true
	
	self:setQuestionData(self.initialQuestionData, nil, self.skippedUI)
end

function dialogue:hide()
	for key, element in ipairs(self.uiElements) do
		element:hide()
	end
end

function dialogue:show()
	for key, element in ipairs(self.uiElements) do
		element:show()
	end
end

function dialogue:clearUI()
	for key, element in ipairs(self.uiElements) do
		element:kill()
		
		self.uiElements[key] = nil
	end
	
	self:clearAnswers()
end

function dialogue:clearAnswers()
	for key, element in ipairs(self.answerElements) do
		element:kill()
		
		self.answerElements[key] = nil
	end
end

function dialogue:setEmployee(emp)
	self.employee = emp
end

function dialogue:getEmployee()
	return self.employee
end

function dialogue:createUI()
	self:clearUI()
	self:createMainTextBox()
	self.textBox:setQuestionData(self.questionData)
	
	if self.isActive and (self.questionData.hidePortrait or self.shouldHidePortrait) then
		self:_hidePortrait()
	end
	
	if self.portrait then
		self.textBox:setPortrait(self.portrait)
	end
end

function dialogue:getDialogueBox()
	return self.textBox
end

function dialogue:createMainTextBox()
	local dialogueBox = gui.create("DialogueBox")
	
	dialogueBox:setBasePoint(scrW - _S(dialogue.HORIZONTAL_SPACING), scrH - _S(300) + _S(dialogue.BASE_ELEMENT_OFFSET))
	dialogueBox:setSize(scrW * 0.6, 0)
	dialogueBox:setDepth(dialogueHandler.baseConversationDepth)
	dialogueBox:setFlyInDistance(_S(300))
	
	if self.characterName then
		dialogueBox:setCharacterName(self.characterName)
		
		self.characterName = nil
	end
	
	dialogueBox:setDialogue(self)
	dialogueHandler:getScreenDarkener():setDialogueBox(dialogueBox)
	
	self.textBox = dialogueBox
	
	table.insert(self.uiElements, dialogueBox)
end

function dialogue:getAnswerBasePosition()
	return _S(dialogue.HORIZONTAL_SPACING), scrH + _S(dialogue.ANSWER_ELEMENT_OFFSET)
end

function dialogue:createAnswerOptions()
	if self.questionData == self.createdAnswers then
		return 
	end
	
	self.createdAnswers = self.questionData
	
	local totalHeight = dialogue.BOTTOM_SPACING
	
	for key, answerID in ipairs(self.questionData:getAnswers(self)) do
		local answerElement = gui.create("DialogueAnswer")
		
		answerElement:setSize(_S(dialogue.ANSWER_ELEMENT_WIDTH), 0)
		answerElement:setDialogue(self)
		answerElement:setAnswerID(answerID, key)
		answerElement:setDepth(dialogueHandler.baseConversationDepth)
		
		totalHeight = totalHeight + dialogue.ANSWER_SPACING + answerElement:getHeight()
		
		table.insert(self.uiElements, answerElement)
		table.insert(self.answerElements, answerElement)
	end
	
	local xPos, yPos = self:getAnswerBasePosition()
	
	for key, answerElement in ipairs(self.answerElements) do
		answerElement:setPos(xPos, yPos - totalHeight)
		
		totalHeight = totalHeight - dialogue.ANSWER_SPACING - answerElement:getHeight()
	end
	
	local firstAnswer = self.answerElements[1]
	local answerX, answerY = firstAnswer:getPos(true)
	local textBoxX, textBoxY = self.textBox:getPos(true)
	local textBoxBottom = textBoxY + self.textBox.h
	local scaledGap = _S(dialogue.MIN_GAP_BETWEEN_TEXTBOX_AND_ANSWERS)
	
	if scaledGap > answerY - textBoxBottom then
		self.textBox:setPos(nil, answerY - scaledGap - self.textBox.h)
	end
	
	dialogueHandler:updateSkillChangePosition(self)
end

function dialogue:getText()
	return self.questionData:getText()
end

function dialogue:getAnswers()
	return self.questionData:getAnswers()
end

function dialogue:setFact(fact, value)
	self.facts[fact] = value
end

function dialogue:getFact(fact)
	return self.facts[fact]
end

function dialogue:setQuestionData(data, answerID, skipUI)
	self.questionData = data
	
	self.questionData:onStart(self, answerID)
	
	self.shownQuestions[data.id] = true
	self.createdAnswers = nil
	
	for key, element in ipairs(self.answerElements) do
		element:kill()
		
		self.answerElements[key] = nil
	end
	
	if not skipUI then
		if not self.textBox then
			self:createUI()
		end
		
		self.textBox:setQuestionData(self.questionData, answerID)
	end
	
	if self.questionData.hidePortrait or self.shouldHidePortrait then
		self:_hidePortrait()
	elseif self.questionData.revealPortrait then
		self.textBox:revealPortrait()
	end
end

function dialogue:hidePortrait()
	self.shouldHidePortrait = true
	
	if self.isActive and self.textBox then
		self.textBox:hidePortrait()
	end
end

function dialogue:_hidePortrait()
	if self.isActive and self.textBox then
		self.textBox:hidePortrait()
		
		self.shouldHidePortrait = false
	end
end

function dialogue:setPortrait(portraitObj)
	self.portrait = portraitObj
	
	if self.textBox then
		self.textBox:setPortrait(self.portrait)
	end
end

function dialogue:getAnswerElements()
	return self.answerElements
end

dialogue.FORCEFINISH_KEYS = {
	["return"] = true,
	space = true
}

function dialogue:handleKeyPress(key, isrepeat)
	if self.textBox and self.textBox:isSpooling() and dialogue.FORCEFINISH_KEYS[key] then
		self.textBox:advanceSpool(true)
		
		return true
	end
	
	local number = tonumber(key)
	
	if number then
		local element = self.answerElements[number]
		
		if element then
			element:pickAnswer()
			
			local answerID = element:getAnswerID()
			
			for key, otherAnswer in ipairs(self.answerElements) do
				if otherAnswer:getAnswerID() ~= answerID then
					otherAnswer:unconfirm()
				end
			end
		end
	end
	
	return true
end

function dialogue:setCharacterName(name)
	if self.textBox then
		self.textBox:setCharacterName(name)
	else
		self.characterName = name
	end
end

function dialogue:returnToBeginning()
	self:setQuestionData(self.initialQuestionData)
end

function dialogue:finish(answerID)
	self.finished = true
	
	dialogueHandler:onFinishDialogue(answerID)
	self:clearAnswers()
end

function dialogue:onPickAnswer(answerID, nextQuestion, answerKey)
	if self.finished then
		return 
	end
	
	local answerData = dialogueHandler.registeredAnswersByID[answerID]
	local previousQuestionID = self.questionData.id
	
	answerData:onPick(self, previousQuestionID, answerKey)
	
	local nextQuestion = answerData:getNextQuestion(self) or self.questionData:getNextQuestion(self)
	local canEndDialogue = false
	
	if answerData then
		canEndDialogue = answerData:canEndDialogue(self)
	end
	
	if nextQuestion and not canEndDialogue then
		self:setQuestionData(dialogueHandler.registeredQuestionsByID[nextQuestion], answerID)
	elseif canEndDialogue then
		self:finish(answerID)
	elseif answerData.returnToBeginning then
		self:returnToBeginning()
	else
		self:finish(answerID)
	end
	
	dialogueHandler.registeredAnswersByID[answerID]:postPickAnswer(previousQuestionID)
	
	self.pickedAnswers[answerID] = true
end

function dialogue:postPickAnswer(answerElement, questionID)
end

function dialogue:onFinish()
	self:clearUI()
	self.questionData:onFinish()
end
