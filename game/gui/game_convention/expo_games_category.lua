local expoGames = {}

expoGames.changeSizeOnTextUpdate = false

function expoGames:handleEvent(event)
	if event == gameConventions.EVENTS.BOOTH_CHANGED or event == gameConventions.EVENTS.GAME_TO_PRESENT_ADDED or event == gameConventions.EVENTS.GAME_TO_PRESENT_REMOVED then
		self:updateText()
	end
end

function expoGames:setConventionData(data)
	self.conventionData = data
end

function expoGames:updateText()
	local boothID = self.conventionData:getDesiredBooth()
	
	if boothID then
		self:setText(string.easyformatbykeys(_T("CONVENTION_GAMES_TO_PRESENT_COUNTER", "Games to present (CURRENT/MAX)"), "CURRENT", #self.conventionData:getDesiredGames(), "MAX", self.conventionData.booths[boothID].maxPresentedGames))
		self:setHoverText(gameProject.expoPresentedGamesHoverText)
	else
		self:setText(_T("CONVENTION_GAMES_TO_PRESENT", "Games to present - unavailable"))
		self:setHoverText(gameProject.expoPresentedGamesNoBoothHoverText)
	end
end

gui.register("ExpoGamesCategory", expoGames, "Category")
