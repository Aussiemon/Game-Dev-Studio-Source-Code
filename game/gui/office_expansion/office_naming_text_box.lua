local officeName = {}

officeName.ghostText = _T("ENTER_OFFICE_NAME", "Enter office name")

function officeName:setOffice(office)
	self.office = office
end

function officeName:onWrite(text)
	self.office:setName(self:getText())
end

function officeName:onDelete()
	self.office:setName(self:getText())
end

gui.register("OfficeNamingTextBox", officeName, "TextBox")
