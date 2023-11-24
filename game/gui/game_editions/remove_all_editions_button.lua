local remEdits = {}

remEdits.icon = "decrease_red"
remEdits.regularIconColor = color(220, 220, 220, 255)
remEdits.hoverText = {
	{
		font = "bh20",
		icon = "question_mark",
		iconHeight = 22,
		iconWidth = 22,
		text = _T("GAME_EDITIONS_REMOVE_ALL", "Remove all game editions")
	}
}

function remEdits:setProject(proj)
	self.project = proj
end

function remEdits:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		local edits = self.project:getEditions()
		local rIdx = 1
		
		for i = 1, #edits do
			local edit = edits[rIdx]
			
			if edit:getDeletable() then
				self.project:removeEdition(edit)
			else
				rIdx = rIdx + 1
			end
		end
	end
end

gui.register("RemoveAllEditionsButton", remEdits, "IconButton")
