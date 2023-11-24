local timeLimitFailState = {}

timeLimitFailState.id = "time_limit"
timeLimitFailState.iconColor = color(255, 121, 76, 255)
timeLimitFailState.description = {
	{
		font = "pix20",
		text = _T("TIME_LIMIT_FAILSTATE_DESCRIPTION_1", "This objective can only be completed within a limited amount of time.")
	}
}

function timeLimitFailState:handleEvent(event)
	if event == timeline.EVENTS.NEW_WEEK and self:checkTimeLimit() then
		self.objective:fail()
		
		if self.config.dialogueOnFail then
			dialogueHandler:addDialogue(self.config.dialogueOnFail, game.getInvestorName())
		elseif self.config.gameOverOnFail then
			game.gameOver(self.config.gameOverText or _T("TIME_LIMIT_GAME_OVER", "You've run out of time to complete the specified task."))
		end
	end
end

function timeLimitFailState:getProgressData(targetTable)
	table.insert(targetTable, {
		icon = "objectives",
		text = _format(_T("TIME_LIMIT_FAILSTATE_TEXT", "TIME left to finish"), "TIME", timeline:getTimePeriodText(self.objective:getStartTime() + self.config.timeLimit - timeline.curTime)),
		iconColor = self.iconColor,
		description = self.description
	})
end

function timeLimitFailState:checkTimeLimit()
	local time = self.objective:getStartTime()
	
	return timeline.curTime >= time + self.config.timeLimit
end

objectiveHandler:registerNewFailState(timeLimitFailState, "base_fail_state")
