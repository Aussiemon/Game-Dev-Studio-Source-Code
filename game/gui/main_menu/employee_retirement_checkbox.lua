local checkbox = {}

checkbox.hoverText = {
	{
		font = "pix18",
		wrapWidth = 350,
		text = _T("EMPLOYEES_RETIRE_DESCRIPTION", "Employees retire when they grow old. Unchecking this box will disable that, allowing your employees to work at your company forever, with some funny side-effects such as employees becoming 200 years old or older.")
	}
}

function checkbox:setGametypeData(data)
	self.gametypeData = data
end

function checkbox:isOn()
	if game.worldObject then
		return game.getCanRetire()
	end
	
	return self.gametypeData:getRetirement()
end

function checkbox:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		if game.worldObject then
			game.setCanRetire(not game.getCanRetire())
		else
			self.gametypeData:setRetirement(not self.gametypeData:getRetirement())
		end
		
		self:queueSpriteUpdate()
	end
end

gui.register("EmployeeRetirementCheckbox", checkbox, "Checkbox")
