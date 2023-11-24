local teamComboboxButton = {}

function teamComboboxButton:onMouseLeft()
	teamComboboxButton.baseClass.onMouseLeft(self)
	self:killDescBox()
end

function teamComboboxButton:setTeam(teamObj)
	self.team = teamObj
end

local sortedByLevel = {}

teamComboboxButton.teamSkillList = nil

function teamComboboxButton.sortByLevel(a, b)
	return teamComboboxButton.teamSkillList[a] > teamComboboxButton.teamSkillList[b]
end

function teamComboboxButton:onMouseEntered()
	teamComboboxButton.baseClass.onMouseEntered(self)
	
	local x, y = self:getPos(true)
	
	self.descBox = gui.create("TeamInfoDescbox")
	
	self.descBox:setTeam(self.team)
	self.descBox:overwriteDepth(100500)
	self.descBox:setPos(x + self.w + _S(5), y)
end

function teamComboboxButton:onHide()
	self:killDescBox()
end

gui.register("TeamComboboxButton", teamComboboxButton, "ComboBoxOption")
