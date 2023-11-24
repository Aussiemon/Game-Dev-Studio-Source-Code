local saveGame = {}

saveGame.text = _T("SAVE_GAME", "Save game")

function saveGame:init()
	self:setFont(fonts.get("pix24"))
end

function saveGame:onClick(x, y, key)
	mainMenu:createSavegameNamingPopup()
end

gui.register("SaveGameButton", saveGame, "Button")
