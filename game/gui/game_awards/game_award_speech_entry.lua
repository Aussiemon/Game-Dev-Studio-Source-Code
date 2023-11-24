local entry = {}

entry.displayText = ""
entry.CATCHABLE_EVENTS = {
	gameAwards.EVENTS.DEFAULT_SPEECH,
	gameAwards.EVENTS.LAST_SPEECH
}

function entry:updateDisplayText()
	local text, lineCount, textHeight, textList = string.wrap(self.curText, self.font, self.w - _S(10))
	
	self.displayText = text
	
	local lastLine = textList[#textList]
	
	self.pointerX = _S(5)
	self.pointerY = _S(2)
	
	if lastLine then
		self.pointerX = self.font:getWidth(lastLine) + self.pointerX
		self.pointerY = self.pointerY + textHeight - self.fontHeight
	end
end

function entry:handleEvent(event)
	if event == gameAwards.EVENTS.DEFAULT_SPEECH then
		self:setText(gameAwards.DEFAULT_TEXT[self.speechStage])
	elseif event == gameAwards.EVENTS.LAST_SPEECH then
		self:setText(gameAwards:getSpeechText(self.speechStage))
	end
end

function entry:setText(text)
	entry.baseClass.setText(self, text)
	self:updateDisplayText()
end

function entry:onDelete()
	self:updateDisplayText()
	gameAwards:setSpeechText(self.speechStage, self.curText)
end

function entry:onWrite()
	self:updateDisplayText()
	gameAwards:setSpeechText(self.speechStage, self.curText)
end

function entry:getDisplayText()
	return self.displayText
end

function entry:getTextY()
	return _S(2)
end

function entry:adjustPointerPosition()
	return self.pointerX
end

function entry:getPointerY()
	return self.pointerY
end

function entry:adjustPointerSize()
	self.pointerHeight = self.font:getHeight()
end

function entry:setSpeechStage(stage)
	self.speechStage = stage
	
	self:setMaxText(gameAwards.SPEECH_LIMITS[stage])
end

gui.register("GameAwardSpeechEntry", entry, "TextBox")
