local mainMenuCredits = {}

mainMenuCredits.regularSprite = "main_menu_credits"
mainMenuCredits.hoverSprite = "main_menu_credits_outlined"
mainMenuCredits.regularSize = {
	48,
	56
}
mainMenuCredits.hoverSize = {
	56,
	64
}
mainMenuCredits.hoverOffset = {
	-4,
	-4
}
mainMenuCredits.hoverText = {
	{
		font = "bh24",
		text = _T("CREDITS", "Credits")
	}
}
mainMenuCredits.onClickSound = "main_menu_credits"

function mainMenuCredits:onClicked(key)
	game.createCreditsPopup()
end

gui.register("MainMenuCredits", mainMenuCredits, "MainMenuObject")
