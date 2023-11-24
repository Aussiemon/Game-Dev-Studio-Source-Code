local mainMenuExitGame = {}

mainMenuExitGame.regularSprite = "main_menu_quit_game"
mainMenuExitGame.hoverSprite = "main_menu_quit_game_outlined"
mainMenuExitGame.regularSize = {
	196,
	356
}
mainMenuExitGame.hoverSize = {
	204,
	364
}
mainMenuExitGame.hoverOffset = {
	-4,
	-4
}
mainMenuExitGame.hoverText = {
	{
		font = "bh24",
		text = _T("EXIT_GAME", "Exit game")
	}
}
mainMenuExitGame.onClickSound = "main_menu_exit"

function mainMenuExitGame:onClicked(key)
	local fader = gui.create("ScreenFader")
	
	fader:setTargetAlpha(1)
	fader:setAlpha(0)
	fader:setFadeState(fader.STATES.IN)
	fader:addDepth(100)
	fader:setSize(scrW, scrH)
	fader:setFadeColor(mainMenu.backgroundColor)
	fader:setCanFadeOut(false)
	gui.lock()
	timer.simple(1, function()
		love.event.quit()
	end)
end

gui.register("MainMenuExitGame", mainMenuExitGame, "MainMenuObject")
