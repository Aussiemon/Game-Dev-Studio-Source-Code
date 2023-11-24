local gameTypeCBB = {}

function gameTypeCBB:onMouseEntered()
	gameTypeCBB.baseClass.onMouseEntered(self)
	
	if not self.canClick then
		local x, y = self:getPos(true)
		
		self.descBox = gui.create("GenericDescbox")
		
		self.descBox:addText(_T("MUST_SELECT_RELATED_GAME_FIRST", "Must select a related game before choosing this game type."), "pix20", nil, 0, 300, "question_mark", 24, 24)
		self.descBox:setPos(x + self.w + _S(5), y)
		self.descBox:overwriteDepth(110000)
		self.relatedGameButton:highlight()
	end
end

function gameTypeCBB:setRelatedGameButton(button)
	self.relatedGameButton = button
end

function gameTypeCBB:onKill()
	self.relatedGameButton:unhighlight()
end

function gameTypeCBB:onMouseLeft()
	gameTypeCBB.baseClass.onMouseEntered(self)
	self:killDescBox()
	self.relatedGameButton:unhighlight()
end

gui.register("GameTypeComboboxButton", gameTypeCBB, "ComboBoxOption")
