local difficultySelectionButton = {}

difficultySelectionButton.CATCHABLE_EVENTS = {
	game.EVENTS.DIFFICULTY_CHANGED
}

function difficultySelectionButton:handleEvent(event)
	self:updateText()
end

function difficultySelectionButton:updateText()
	local data = game.DIFFICULTY_SETTINGS_BY_ID[game.getDesiredDifficulty()]
	
	self:setText(data.display)
end

function difficultySelectionButton:fillInteractionComboBox(combobox)
	combobox:setOptionButtonType("DifficultySelectionOption")
	
	local w = self.rawW
	
	for key, data in ipairs(game.DIFFICULTY_SETTINGS) do
		local option = combobox:addOption(0, 0, w, 24, data.display, fonts.get("pix20"))
		
		option:setData(data)
	end
	
	local x, y = self:getPos(true)
	
	combobox:setPos(x, y - combobox.h)
end

function difficultySelectionButton:onClick(x, y, key)
	if gui.mouseKeys.LEFT then
		interactionController:startInteraction(self, x, y)
	end
end

gui.register("DifficultySelectionButton", difficultySelectionButton, "Button")
