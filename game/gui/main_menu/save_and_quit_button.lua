local saveGame = {}

saveGame.text = _T("SAVE_AND_QUIT", "Save&Quit")

function saveGame:init()
	self:setFont(fonts.get("pix24"))
end

function saveGame:onClick(x, y, key)
	mainMenu:closeInGameMenu()
	mainMenu:createSavegameNamingPopup(true)
end

gui.register("SaveAndQuitButton", saveGame, "Button")
