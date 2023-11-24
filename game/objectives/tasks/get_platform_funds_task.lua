local getFundsTask = {}

getFundsTask.id = "get_platform_funds"

function getFundsTask:handleEvent(event, change, newAmount)
	if event == playerPlatform.EVENTS.FUNDS_CHANGED and change > 0 then
		self.accumulatedFunds = self.accumulatedFunds + change
	end
end

objectiveHandler:registerNewTask(getFundsTask, "get_funds")
