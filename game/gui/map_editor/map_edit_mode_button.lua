local tabButton = gui.getClassTable("ExpansionModePropertySheetTabButton")
local editMode = {}

editMode.mouseOverIconColor = tabButton.iconActiveColor
editMode.regularIconColor = tabButton.iconInactiveColor
editMode.inactiveColor = tabButton.backgroundActiveColor
editMode.activeColor = tabButton.backgroundInActiveColor

function editMode:setEditMode(mode)
	self.editMode = mode
	self.keyText = _format("[KEY]", "KEY", mode)
	self.textWidth = self.fontObject:getWidth(self.keyText)
end

function editMode:onClick(x, y, key)
	mapEditor:setEditMode(self.editMode)
end

function editMode:getColors()
	if self:isMouseOver() then
		return editMode.activeColor, editMode.mouseOverIconColor
	elseif mapEditor:getEditMode() == self.editMode then
		return editMode.activeColor, editMode.mouseOverIconColor
	else
		return editMode.inactiveColor, editMode.regularIconColor
	end
end

gui.register("MapEditModeButton", editMode, "PrefabConstructionModeButton")
