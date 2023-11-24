local renamingTextbox = {}

function renamingTextbox:setProject(proj)
	self.project = proj
	
	self:setText(proj:getName())
	self:setMaxText(gameProject.MAX_NAME_SYMBOLS)
	self:setShouldCenter(true)
end

function renamingTextbox:setConfirmButton(butt)
	self.confirmButton = butt
end

function renamingTextbox:onWrite()
	self.confirmButton:reevaluateState(self.curText)
end

function renamingTextbox:onDelete()
	self.confirmButton:reevaluateState(self.curText)
end

gui.register("ProjectRenamingTextbox", renamingTextbox, "TextBox")
