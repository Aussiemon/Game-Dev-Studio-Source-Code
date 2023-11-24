local officeNaming = {}

function officeNaming:onWrite()
	studio:setName(self:getText())
end

gui.register("OfficeNamingTextBox", officeNaming, "TextBox")
