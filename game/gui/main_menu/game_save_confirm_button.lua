local button = {}

function button:setQuitToMenuAfterSaving(should)
	self.quitToMenuAfterSaving = should
end

function button:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		game.beginSaving(game.getSaveFileName(game.desiredSaveName), nil, self.quitToMenuAfterSaving)
		frameController:pop()
		mainMenu:closeInGameMenu()
	end
end

gui.register("GameSaveConfirmButton", button, "Button")
