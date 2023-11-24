local removeEdit = {}

removeEdit.regularIconColor = color(220, 220, 220, 255)
removeEdit.icon = "decrease_red"
removeEdit.hoverText = {
	{
		font = "bh20",
		icon = "question_mark",
		iconHeight = 22,
		iconWidth = 22,
		text = _T("REMOVE_GAME_EDITION", "Remove edition")
	}
}

function removeEdit:setEdition(edit)
	self.edition = edit
end

function removeEdit:onClick(x, y, key)
	local par = self:getParent()
	
	self.edition:getProject():removeEdition(self.edition)
end

function removeEdit:positionDescbox()
	local x, y = self:getPos(true)
	
	self.descBox:setPos(x + self.w + _S(5), y + self.h + _S(5))
end

gui.register("RemoveGameEditionButton", removeEdit, "IconButton")
