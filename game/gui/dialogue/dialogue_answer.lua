local dialogueAnswer = {}

dialogueAnswer.HORIZONTAL_TEXT_SPACING = 5
dialogueAnswer.VERTICAL_TEXT_SPACING = 3
dialogueAnswer.skinPanelFillColor = color(0, 0, 0, 150)
dialogueAnswer.skinPanelHoverColor = color(144, 167, 204, 150)
dialogueAnswer.skinPanelSelectColor = color(114, 148, 204, 200)
dialogueAnswer.skinTextFillColor = color(237, 242, 255, 255)
dialogueAnswer.skinTextHoverColor = color(255, 231, 209, 255)
dialogueAnswer.skinTextSelectColor = color(239, 255, 209, 255)
dialogueAnswer._scaleVert = false
dialogueAnswer._scaleHor = false

function dialogueAnswer:init()
	self.confirmation = 0
	self.font = fonts.get("pix22")
end

function dialogueAnswer:isDisabled()
	return false
end

function dialogueAnswer:isOn()
	return self.confirmation == 1
end

function dialogueAnswer:onMouseEntered()
	self:queueSpriteUpdate()
end

function dialogueAnswer:onMouseLeft()
	self.confirmation = 0
	
	self:queueSpriteUpdate()
end

function dialogueAnswer:setAnswerID(answerID, answerKey)
	self.answerKey = answerKey
	self.answerID = answerID
	self.answerData = dialogueHandler.registeredAnswersByID[answerID]
	
	local text = self.answerData:getText(self.dialogue, self.answerKey)
	
	if self.answerData.endDialogue then
		text = text .. " " .. _T("END_CONVERSATION", "[END CONVERSATION]")
	end
	
	local realText = answerKey .. ". " .. text
	
	self.wrapw = self.w - _S(dialogueAnswer.HORIZONTAL_TEXT_SPACING * 2)
	
	local text, lines, height = string.wrap(realText, self.font, self.w - _S(dialogueAnswer.HORIZONTAL_TEXT_SPACING * 2))
	
	self.displayText = text
	
	self:setHeight(height + _S(self.VERTICAL_TEXT_SPACING) * 2)
end

function dialogueAnswer:getAnswerID()
	return self.answerID
end

function dialogueAnswer:setDialogue(dialogue)
	self.dialogue = dialogue
end

function dialogueAnswer:unconfirm()
	self.confirmation = 0
end

function dialogueAnswer:pickAnswer(skipConfirmation)
	if not skipConfirmation and self.answerData.requiresConfirmation and self.confirmation < 1 then
		self:queueSpriteUpdate()
		
		self.confirmation = self.confirmation + 1
		
		return 
	end
	
	self.dialogue:onPickAnswer(self.answerID, nil, self.answerKey)
end

function dialogueAnswer:onClick()
	self:pickAnswer(true)
end

function dialogueAnswer:updateSprites()
	local pcol, tcol = self:getStateColor()
	
	self:setNextSpriteColor(pcol:unpack())
	
	self.rectSprites = self:allocateRoundedRectangle(self.rectSprites, 0, 0, self.rawW, self.rawH, 4, -0.1)
end

function dialogueAnswer:draw(w, h)
	local pcol, tcol = self:getStateColor()
	
	love.graphics.setFont(self.font)
	love.graphics.printST(self.displayText, dialogueAnswer.HORIZONTAL_TEXT_SPACING, dialogueAnswer.VERTICAL_TEXT_SPACING, tcol.r, tcol.g, tcol.b, tcol.a, 0, 0, 0, 255)
end

gui.register("DialogueAnswer", dialogueAnswer)
