local projectRenameConfirm = {}

function projectRenameConfirm:setProject(proj)
	self.project = proj
	
	self:reevaluateState(self.project:getName())
end

function projectRenameConfirm:setTextbox(textbox)
	self.textbox = textbox
end

function projectRenameConfirm:isDisabled()
	return not self.valid
end

function projectRenameConfirm:reevaluateState(text)
	self.valid = string.withoutspaces(text) ~= ""
end

function projectRenameConfirm:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT and self.valid then
		self.project:setName(self.textbox:getText())
		frameController:pop()
	end
end

gui.register("ProjectRenamingConfirmButton", projectRenameConfirm, "Button")
