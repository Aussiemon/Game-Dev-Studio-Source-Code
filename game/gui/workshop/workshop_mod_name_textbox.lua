local nameTextbox = {}

nameTextbox.ghostText = _T("WORKSHOP_ENTER_MOD_NAME", "Enter mod name")

function nameTextbox:onWrite()
	local text = self:getText()
	
	workshop:getModUploadData().title = text
	
	workshop:verifyFinishClickability()
end

function nameTextbox:onDelete()
	local text = self:getText()
	
	workshop:getModUploadData().title = text
	
	workshop:verifyFinishClickability()
end

gui.register("WorkshopModNameTextbox", nameTextbox, "TextBox")
