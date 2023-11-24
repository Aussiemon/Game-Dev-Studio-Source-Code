local removePrequel = {}

removePrequel.icon = "decrease"
removePrequel.hoverText = {
	{
		font = "bh18",
		wrapWidth = 200,
		icon = "question_mark",
		iconWidth = 22,
		lineSpace = 0,
		iconHeight = 22,
		text = _T("REMOVE_PREQUEL", "Deselect related game")
	}
}

function removePrequel:setProject(proj)
	self.project = proj
end

function removePrequel:canShow()
	if not self.project then
		return false
	end
	
	return self.project:getSequelTo() ~= nil
end

function removePrequel:updateVisibility()
	if not self:canShow() then
		self:hide()
	else
		self:show()
	end
end

function removePrequel:onClick(x, y, key)
	self.project:setSequelTo(nil)
	self.parent:updateText()
	self.parent:updateInheritButtonState()
	sound:play("feature_deselected", nil, nil, nil)
end

gui.register("RemoveSelectedPrequelButton", removePrequel, "IconButton")
