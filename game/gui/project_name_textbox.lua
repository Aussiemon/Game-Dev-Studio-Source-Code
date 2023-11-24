local engineName = {}

engineName.ghostText = "Enter project name"

function engineName:setProject(proj)
	self.project = proj
end

function engineName:onWrite(text)
	self.project:setName(self:getText())
end

function engineName:onDelete()
	self.project:setName(self:getText())
end

gui.register("ProjectNameTextBox", engineName, "TextBox")
