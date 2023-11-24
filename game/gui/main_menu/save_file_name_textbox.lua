local saveFileName = {}

saveFileName.ghostText = _T("ENTER_SAVE_NAME", "Enter savefile name")

function saveFileName:onWrite(text)
	game.desiredSaveName = self:getText()
	
	self:updateConfirmState()
end

function saveFileName:setConfirmButton(confirmButton)
	self.confirmButton = confirmButton
end

function saveFileName:updateConfirmState()
	if string.withoutspaces(game.desiredSaveName) == "" then
		self.confirmButton:setCanClick(false)
	else
		self.confirmButton:setCanClick(true)
	end
	
	self.confirmButton:queueSpriteUpdate()
end

function saveFileName:onDelete()
	game.desiredSaveName = self:getText()
	
	self:updateConfirmState()
end

function saveFileName:updateSaveName()
	self:setText(game.desiredSaveName)
	self:updateConfirmState()
end

gui.register("SaveFileNameTextBox", saveFileName, "TextBox")
