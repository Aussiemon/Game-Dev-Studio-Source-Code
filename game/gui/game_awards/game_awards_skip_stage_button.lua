local skipButton = {}

skipButton.icon = "skip_stage"
skipButton.hoverText = {
	{
		font = "bh20",
		text = _T("GAME_AWARDS_SKIP_STAGE", "Skip stage")
	}
}

function skipButton:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		self.parent:forceSkipStage()
	end
end

gui.register("GameAwardsSkipStageButton", skipButton, "IconButton")
