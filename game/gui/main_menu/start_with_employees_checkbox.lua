local checkbox = {}

checkbox.hoverText = {
	{
		font = "pix18",
		wrapWidth = 350,
		text = _T("START_WITH_EMPLOYEES_DESCRIPTION", "Unchecking this box will make you start out with just your player character, as opposed to having extra employees, as it is in the scenario that uses the selected map.\n\nPlease note that not all maps have starting employees, so even with this setting there may not be any.")
	}
}

function checkbox:setGametypeData(data)
	self.gametypeData = data
end

function checkbox:isOn()
	return self.gametypeData:getStartWithEmployees()
end

function checkbox:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		self.gametypeData:setStartWithEmployees(not self.gametypeData:getStartWithEmployees())
		self:queueSpriteUpdate()
	end
end

gui.register("StartWithEmployeesCheckbox", checkbox, "Checkbox")
