local standard = {}

standard.id = "standard"
standard.invisible = true
standard.display = _T("FREEPLAY_STANDARD", "Freeplay - Standard")
standard.description = _T("STANDARD_GAMETYPE_DESCRIPTION", "Start out in the same circumstances on the selected map, but without any objective.\n\nWhen your player character retires you will be shown a recap of what you've achieved in those YEARS game-time years, with the ability to keep playing after that point.\n\nEnjoy freeplay with no hand-holding, supervision and set objective!")
standard.playerCharacterStartAge = 20
standard.playerCharacterFinishAge = 60
standard.playerCharacterLearnSpeedMultiplier = 3
standard.startMoney = 50000
standard.usersPerYear = 125000
standard.startingGenres = {
	"action",
	"adventure",
	"strategy"
}
standard.startingThemes = {
	"scifi",
	"fantasy"
}
standard.orderWeight = 2
standard.map = "story_mode"
standard.rivals = {
	"rival_company_1",
	"rival_company_2",
	"rival_company_3"
}
standard.rivalBuildings = {
	rival_company_1 = "office_medium_6",
	rival_company_3 = "office_medium_8",
	rival_company_2 = "office_medium_7"
}

function standard:formatDescription()
	return string.easyformatbykeys(self.description, "YEARS", self.playerCharacterFinishAge - self.playerCharacterStartAge)
end

function standard:begin()
	self:setupStartingTime()
	characterDesigner:begin()
end

function standard:startCallback()
	self:unlockStartingTech()
	
	local employee = characterDesigner:getEmployee()
	
	employee:setOverallSkillProgressionMultiplier(self.playerCharacterLearnSpeedMultiplier)
	characterDesigner:finish()
	self:giveStartingThemesGenres()
	self:setupStartingRivals()
	
	self.playerCharacter = employee
	
	studio:setFunds(self:getStartingMoney())
end

function standard:load()
	for key, employee in ipairs(studio:getEmployees()) do
		if employee:isPlayerCharacter() then
			self.playerCharacter = employee
			
			break
		end
	end
end

game.registerGameType(standard)
