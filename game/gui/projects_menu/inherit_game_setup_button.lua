local inherit = {}

inherit.icon = "related_games"
inherit.hoverText = {
	{
		font = "bh20",
		icon = "question_mark",
		iconHeight = 22,
		iconWidth = 22,
		text = _T("INHERIT_RELATED_GAME_SETUP", "Inherit related game setup")
	}
}

function inherit:setProject(proj)
	self.project = proj
end

function inherit:positionDescbox()
	local x, y = self:getPos(true)
	
	self.descBox:setPos(x + self.w + _S(5), y - self.h - _S(5))
end

function inherit:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		self.project:inheritSetup(self.project:getSequelTo())
	end
end

gui.register("InheritGameSetupButton", inherit, "IconButton")
