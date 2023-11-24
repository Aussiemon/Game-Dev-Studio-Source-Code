local checkbox = {}

checkbox.hoverText = {
	{
		font = "bh20",
		wrapWidth = 350,
		text = _T("WORKSHOP_CONSOLE_DESC", "Open a console for debugging purposes. Will display text when printed via the 'print' method.")
	}
}

function checkbox:isOn()
	return game.showingConsole
end

function checkbox:positionHoverText()
	local x, y = self:getPos(true)
	
	self.descBox:setPos(x, y + _S(10) + self.h)
end

function checkbox:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		if not game.showingConsole then
			game.openConsole()
		else
			game.hideConsole()
		end
		
		self:queueSpriteUpdate()
	end
end

gui.register("ConsoleCheckbox", checkbox, "Checkbox")
