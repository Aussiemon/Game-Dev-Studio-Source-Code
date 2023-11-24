local quitToMainMenu = {}

quitToMainMenu.text = _T("QUIT_TO_MENU", "Quit to menu")

function quitToMainMenu:init()
	self:setFont(fonts.get("pix24"))
end

function quitToMainMenu:onClick(x, y, key)
	game.returnToMainMenu()
end

gui.register("QuitToMainMenuButton", quitToMainMenu, "Button")
