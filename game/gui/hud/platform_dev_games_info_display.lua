local platformDev = {}

platformDev.hoverText = {
	{
		font = "bh18",
		wrapWidth = 400,
		lineSpace = 5,
		text = _T("PLATFORM_IN_DEV_GAMES_1", "The amount of games in-development for this platform.")
	},
	{
		iconWidth = 22,
		font = "bh18",
		wrapWidth = 400,
		iconHeight = 22,
		icon = "question_mark",
		textColor = game.UI_COLORS.LIGHT_BLUE
	}
}

function platformDev:setupHoverText()
	local plat = self.parent:getPlatform()
	
	if #plat:getInDevGames() > 0 then
		self.hoverText[2].text = plat:getLastGameDevText()
	else
		self.hoverText[2].text = _T("PLATFORM_LAUNCH_DAY_GAMES_READY", "All launch-day games are ready.")
	end
	
	platformDev.baseClass.setupHoverText(self)
end

gui.register("PlatformDevGamesInfoDisplay", platformDev, "ProjectElementInfoDisplay")
