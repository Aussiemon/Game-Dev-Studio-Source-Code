local dialogueBox = {}

dialogueBox.HORIZONTAL_TEXT_SPACING = 5
dialogueBox.VERTICAL_TEXT_SPACING = 5
dialogueBox.TEXT_SPOOL_PER_SECOND = 40
dialogueBox.FLY_IN_SPEED = 0.5
dialogueBox.FLY_OUT_SPEED = 0.45
dialogueBox.HIDDEN_PORTRAIT_COLOR = color(50, 50, 50, 255)

dialogueBox.HIDDEN_PORTRAIT_COLOR:normalize()

dialogueBox.HIDDEN_PORTRAIT_COLOR_SHADER = {
	dialogueBox.HIDDEN_PORTRAIT_COLOR:unpack()
}
dialogueBox.TEXT_BORDER = 100
dialogueBox.underNameExtraWidth = 5
dialogueBox.BOX_COLOR = color(7, 9, 12, 150)
dialogueBox.GRADIENT_COLOR = color(52, 91, 142, 200)
dialogueBox.EVENTS = {
	FLEW_AWAY = events:new()
}
dialogueBox.flyInDistance = 0
dialogueBox._scaleVert = false
dialogueBox._scaleHor = false

function dialogueBox:init()
	self.flash = 0
	self.flashDelay = 0
	self.font = fonts.get("pix22")
	self.characterNameFont = fonts.get("bh22")
	self.characterNameFontHeight = self.characterNameFont:getHeight()
	self.hintFont = fonts.get("bh20")
	self.textSpoolProgress = 1
	
	self:setCharacterName("unassigned name")
	
	self.hiddenPortraitQuad = quadLoader:getQuadStructure("big_question_mark")
	self.portraitW = _S(256)
	self.portraitH = _S(256)
end

function dialogueBox:setFlyInDistance(distance)
	self.flyInDistance = distance
	self.initialFlyInDistance = distance
end

function dialogueBox:getFlyInDistance()
	return self.flyInDistance
end

function dialogueBox:setFlyAway(state)
	self.flyAway = state
	
	self.questionData:stopSound()
	self:queueSpriteUpdate()
end

function dialogueBox:hidePortrait()
	self.hiddenPortrait = true
end

function dialogueBox:revealPortrait()
	local wasHidden = self.hiddenPortrait
	
	self.hiddenPortrait = false
	
	if wasHidden and not self.image then
		self.portraitImage = self:allocateSprite(self.portraitImage, "generic_1px", 0, 0, 0, 0, 0, 0, 0, -0.1)
		self.portraitImage = nil
	end
	
	self:updateNameText()
end

function dialogueBox:updateNameText()
	local characterNameText
	
	if self.hiddenPortrait then
		characterNameText = _T("DIALOGUE_UNKNOWN", "Unknown")
	else
		characterNameText = self.characterName
	end
	
	self.characterNameText = characterNameText
	self.nameTextW = self.characterNameFont:getWidth(characterNameText)
	self.nameTextX = self.w - self.nameTextW * 0.5 + _S(20)
	self.nameTextY = _S(65 + dialogueBox.VERTICAL_TEXT_SPACING) + self.characterNameFontHeight
end

function dialogueBox:setBasePoint(x, y)
	self.baseX = x
	self.baseY = y
end

function dialogueBox:createAnswers()
	self.dialogue:createAnswerOptions()
end

function dialogueBox:onClick()
	self:advanceSpool(true)
end

function dialogueBox:setDialogue(dialogue)
	self.image = nil
	self.dialogue = dialogue
	self.employee = dialogue:getEmployee()
	
	if self.employee then
		self:setPortrait(self.employee:getPortrait())
	end
end

function dialogueBox:setPortrait(portrait)
	self.portrait = portrait
	
	self.portrait:setupSpritebatch()
	self:updateNameText()
end

function dialogueBox:adjustPosition()
	self:setPos(self.baseX - self.w - self.portraitW * 0.5, math.round(self.baseY - self.h * 0.5))
end

local utf8 = require("utf8")

function dialogueBox:setQuestionData(data, pickedAnswer)
	if self.questionData then
		self.questionData:stopSound()
	end
	
	self.questionData = data
	self.spoolCooldown = self.questionData.spoolCooldown
	self.currentSpoolCooldown = 0
	self.startedSpooling = false
	
	if self.questionData.image then
		self.image = self.questionData.image
	end
	
	local returnText
	
	if pickedAnswer then
		returnText = dialogueHandler.registeredAnswersByID[pickedAnswer]:getReturnText(self.dialogue)
	end
	
	local text = returnText or self.questionData:getText(self.dialogue)
	local wrappedText, lineCount, height = string.wrap(text, self.font, self.w - _S(self.TEXT_BORDER + 10))
	
	self.flash = 0
	self.flashDelay = 1
	self.flashValue = 0
	self.displayText = wrappedText
	self.displayTextLength = #self.displayText
	self.charLayout = {
		utf8.codepoint(self.displayText, 1, self.displayTextLength)
	}
	self.charLayoutSymbols = #self.charLayout
	
	if self.builtString then
		table.clearArray(self.builtString)
	else
		self.builtString = {}
	end
	
	local building = ""
	
	for key, symbol in ipairs(self.charLayout) do
		building = building .. utf8.char(symbol)
		self.builtString[key] = building
	end
	
	self:setHeight(height + _S(self.VERTICAL_TEXT_SPACING) * 2)
	
	self.spoolDone = false
	self.textSpoolProgress = 1
	self.spooledText = ""
	self.firstTimeUpdate = false
	self.canPlaySpool = data:canPlaySpool()
	
	self:adjustPosition()
	
	if data.nameID then
		self:setCharacterName(game.getDialogueName(data.nameID))
	end
	
	if self.portrait then
		local eye = self.portrait:rollRandomAppearance(portrait.APPEARANCE_PARTS.EYE, self.employee:isFemale())
		
		self.portrait:setEye(eye)
		self.portrait:setupSpritebatch()
	end
end

function dialogueBox:setCharacterName(name)
	self.characterName = name
	
	self:updateNameText()
end

function dialogueBox:isSpoolDone()
	return self.spoolDone
end

function dialogueBox:isSpooling()
	return self.startedSpooling and not self.spoolDone
end

function dialogueBox:advanceSpool(forceFinish)
	if self.spoolDone then
		return 
	end
	
	if self.currentSpoolCooldown > 0 and not forceFinish then
		self.currentSpoolCooldown = self.currentSpoolCooldown - frameTime
		
		return 
	end
	
	local oldSpool = math.floor(self.textSpoolProgress)
	
	if forceFinish then
		self.textSpoolProgress = self.charLayoutSymbols
	else
		self.textSpoolProgress = math.approach(self.textSpoolProgress, self.charLayoutSymbols, frameTime * self.TEXT_SPOOL_PER_SECOND)
	end
	
	local actualSpool = math.floor(self.textSpoolProgress)
	
	if oldSpool ~= actualSpool then
		if not self.startedSpooling then
			self.questionData:onStartSpooling(self.dialogue)
			self.questionData:playSound()
			
			self.startedSpooling = true
		end
		
		self.spooledText = self.builtString[actualSpool] or ""
		
		if self.canPlaySpool and not sound.manager:isPlaying("dialogue_spool") then
			sound:play("dialogue_spool", nil, nil, nil)
		end
		
		if self.spoolCooldown and actualSpool < self.charLayoutSymbols then
			local currentSymbol = self.charLayout[self.actualSpool]
			
			if currentSymbol == "." then
				self.currentSpoolCooldown = self.spoolCooldown
			end
		end
		
		if self.textSpoolProgress == self.charLayoutSymbols then
			self:createAnswers()
			
			self.spoolDone = true
		end
	end
end

function dialogueBox:think()
	if self.flyAway then
		local oldDist = self.flyInDistance
		
		self.flyInDistance = math.approach(self.flyInDistance, self.initialFlyInDistance, scrW * dialogueBox.FLY_OUT_SPEED * frameTime)
		
		if self.flyInDistance == self.initialFlyInDistance and oldDist ~= self.flyInDistance then
			events:fire(dialogueBox.EVENTS.FLEW_AWAY, self)
		end
	elseif self.flyInDistance ~= 0 then
		self.flyInDistance = math.approach(self.flyInDistance, 0, scrW * dialogueBox.FLY_IN_SPEED * frameTime)
	end
	
	if self.flyInDistance == 0 then
		self:advanceSpool()
		
		if not self.firstTimeUpdate then
			self:queueSpriteUpdate()
			
			self.firstTimeUpdate = true
		end
		
		if self.flashDelay <= 0 then
			self.flash = self.flash + frameTime * 2
			
			if self.flash >= math.pi then
				self.flash = self.flash - math.pi
			end
			
			self.flashValue = 255 * math.sin(self.flash)
		else
			self.flashDelay = self.flashDelay - frameTime
		end
	else
		self:queueSpriteUpdate()
	end
	
	if not self.portrait and (self.hiddenPortrait or self.image) then
		self:queueSpriteUpdate()
	end
end

function dialogueBox:getPortraitPosition()
	return self.w + self.flyInDistance, -_S(30)
end

function dialogueBox:updateSprites()
	if self.image or self.hiddenPortrait then
		local imageName
		local w, h = 0, 0
		
		if self.hiddenPortrait then
			w, h = 128, 128
			imageName = "big_question_mark"
		else
			local quadData = quadLoader:getQuadStructure(self.image)
			
			w, h = quadData.w, quadData.h
			
			local scale = quadData.quad:getScaleToSize(300)
			
			w, h = w * scale, h * scale
			imageName = self.image
		end
		
		w, h = _S(w) * 0.75, _S(h) * 0.75
		
		local x, y = self:getPortraitPosition()
		
		self.portraitImage = self:allocateSprite(self.portraitImage, imageName, x + w * 0.5 + _S(20), y - h * 0.5, 0, -w, h, 0, 0, -0.1)
	end
	
	if not self.flyAway then
		if self.flyInDistance == 0 then
			self:setNextSpriteColor(dialogueBox.BOX_COLOR:unpack())
			
			self.rectSprites = self:allocateRoundedRectangle(self.rectSprites, 0, 0, self.rawW - _S(dialogueBox.TEXT_BORDER), self.rawH, 4, -0.1)
		end
	else
		self:setNextSpriteColor(0, 0, 0, 0)
		
		self.rectSprites = self:allocateRoundedRectangle(self.rectSprites, 0, 0, self.rawW - _S(dialogueBox.TEXT_BORDER), self.rawH, 4, -0.1)
	end
	
	local border = _S(self.underNameExtraWidth)
	local portX, portY = self:getPortraitPosition()
	local bgPortW, bgPortH = 208, 279 + _US(self.characterNameFontHeight)
	
	portX = portX - _S(84)
	portY = portY - _S(150)
	
	self:setNextSpriteColor(game.UI_COLORS.NEW_HUD_OUTER:unpack())
	
	self.bgSpriteUnder = self:allocateRoundedRectangle(self.bgSpriteUnder, portX, portY, _S(bgPortW), _S(bgPortH), 4, -0.9)
	
	self:setNextSpriteColor(game.UI_COLORS.NEW_HUD_FILL:unpack())
	
	self.bgSprite = self:allocateSprite(self.bgSprite, "vertical_gradient_60", portX + _S(2), portY + _S(2), 0, _S(bgPortW - 4), _S(bgPortH - 4), 0, 0, -0.89)
	
	self:setNextSpriteColor(0, 0, 0, 75)
	
	self.underNameSprite = self:allocateSprite(self.underNameSprite, "generic_1px", portX + _S(4), self.nameTextY - _S(1), 0, _S(bgPortW - 8), self.characterNameFontHeight + _S(4), 0, 0, -0.05)
	
	self:setNextSpriteColor(dialogueBox.GRADIENT_COLOR:unpack())
	
	self.underNameGradient = self:allocateSprite(self.underNameGradient, "vertical_gradient_75", portX + _S(6), self.nameTextY + _S(1), 0, _S(bgPortW - 12), self.characterNameFontHeight, 0, 0, -0.05)
end

function dialogueBox:draw(w, h)
	if not self.flyAway and self.flyInDistance == 0 then
		love.graphics.setFont(self.font)
		love.graphics.printST(self.spooledText, _S(dialogueBox.HORIZONTAL_TEXT_SPACING), dialogueBox.VERTICAL_TEXT_SPACING, 255, 255, 255, 255, 0, 0, 0, 255)
		
		if not self.spoolDone and self.flashDelay <= 0 then
			love.graphics.setFont(self.hintFont)
			love.graphics.printST(_T("CLICK_TO_REVEAL_TEXT", "Click to reveal text"), _S(dialogueBox.HORIZONTAL_TEXT_SPACING), dialogueBox.VERTICAL_TEXT_SPACING + h, 255, 255, 255, self.flashValue, 0, 0, 0, self.flashValue)
		end
	end
	
	local x, y = self:getPortraitPosition()
	
	if self.portrait then
		if self.hiddenPortrait then
			love.graphics.setShader(shaders.colorReplacer)
			shaders.colorReplacer:send("replacement", dialogueBox.HIDDEN_PORTRAIT_COLOR_SHADER)
			self.portrait:draw(x + _S(80), y - _S(100), 0, nil, nil)
			love.graphics.setShader(nil)
		else
			self.portrait:draw(x + _S(80), y - _S(100), 0, nil, nil)
		end
	end
	
	if self.hiddenPortrait then
		local w, h = self.hiddenPortraitQuad.quad:getSpriteScale(128, 128)
		
		w, h = _S(w), _S(h)
		
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(self.hiddenPortraitQuad.texture, self.hiddenPortraitQuad.quad, x - _S(50), y - _S(64), 0, w, h)
	end
	
	love.graphics.setFont(self.characterNameFont)
	love.graphics.printST(self.characterNameText, self.nameTextX + self.flyInDistance, self.nameTextY, 255, 255, 255, 255, 0, 0, 0, 255)
end

gui.register("DialogueBox", dialogueBox)
