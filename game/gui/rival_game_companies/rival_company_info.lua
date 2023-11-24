local rivalCompanyInfo = {}

rivalCompanyInfo.extraInfoColor = color(140, 180, 206, 255)
rivalCompanyInfo.saleInfoColor = color(184, 206, 171, 255)
rivalCompanyInfo.categoryColor = color(201, 206, 171, 255)

function rivalCompanyInfo:showDisplay(companyObject)
	companyObject = companyObject or self.lastCompanyObject
	self.lastCompanyObject = companyObject
	
	self:addText(_T("RIVAL_INFO", "Rival info"), "pix24", self.categoryColor, 5, 320)
	self:addText(_format(_T("RIVAL_INFO_REPUTATION", "Reputation: REP"), "REP", string.roundtobignumber(companyObject:getReputation())), "pix20", nil, 4, 320, "star", 20, 20)
	self:addText(_format(_T("RIVAL_INFO_RELEASED_GAMES", "Released games: GAMES"), "GAMES", #companyObject:getReleasedGames()), "pix20", nil, 4, 320, "checkmark", 20, 20)
	self:addSpaceToNextText(8)
	self:addText(_T("RIVAL_EMPLOYEES", "Employees"), "pix24", self.categoryColor, 4, 320)
	self:addText(_format(_T("RIVAL_INFO_TOTAL_EMPLOYEES", "Current employees: EMPLOYEES"), "EMPLOYEES", #companyObject:getEmployees()), "pix20", nil, 4, 320, "employees", 20, 20)
	self:addText(_format(_T("RIVAL_INFO_EMPLOYEES_STOLEN", "Employees stolen: AMOUNT"), "AMOUNT", companyObject:getPlayerStolenEmployees()), "pix20", nil, 4, 320, "hud_employee_management", 20, 17)
	self:addText(_format(_T("RIVAL_INFO_EMPLOYEES_STOLEN_FROM_US", "Employees stolen from you: AMOUNT"), "AMOUNT", companyObject:getStolenEmployees()), "pix20", nil, 4, 320, "hud_employee", 20, 25)
	
	local time = companyObject:getLastPlayerStealAttempt()
	
	if time then
		self:addText(_format(_T("RIVAL_INFO_LAST_PERSUASION_ATTEMPT", "Last persuasion attempt: YEAR/MONTH"), "YEAR", timeline:getYear(time), "MONTH", timeline:getMonth(time)), "pix20", nil, 4, 320, "clock_full", 20, 20)
	else
		self:addText(_T("RIVAL_INFO_LAST_PERSUASION_ATTEMPT_NEVER", "Last persuasion attempt: never"), "pix20", nil, 4, 320, "clock_full", 20, 20)
	end
	
	self:addSpaceToNextText(8)
	self:addText(_T("RIVAL_SLANDER", "Slander"), "pix24", self.categoryColor, 4, 320)
	self:addText(_format(_T("RIVAL_SUCCESFUL_SLANDER", "Successful slander: SLANDER"), "SLANDER", companyObject:getSuccessfulSlander()), "pix20", self.categoryColor, 4, 320, "checkmark", 20, 20)
	self:addText(_format(_T("RIVAL_FAILED_SLANDER", "Failed slander: SLANDER"), "SLANDER", companyObject:getFailedSlander()), "pix20", self.categoryColor, 4, 320, "close_button", 20, 20)
	
	local scheduledSlander = companyObject:getScheduledPlayerSlander()
	
	if scheduledSlander then
		self:addText(_format(_T("SCHEDULED_SLANDER", "SLANDER in progress"), "SLANDER", rivalGameCompanies.registeredSlanderByID[scheduledSlander]:getName()), "pix20", nil, 4, v, "question_mark", 20, 20)
	end
	
	if studio:knowsOfRivalSlander(companyObject:getID()) then
		self:addText(_T("LEGAL_ACTION_AVAILABLE", "Legal action available."), "pix20", game.UI_COLORS.LIGHT_BLUE, 4, 320, "attention", 20, 20)
		self:addText(_T("LEGAL_ACTION_AVAILABLE_DETAILED", "You have evidence of this rival running defamatory campaigns against your studio."), "pix18", nil, 4, 320)
	end
	
	self:show()
end

function rivalCompanyInfo:hideDisplay()
	self:removeAllText()
	self:hide()
end

gui.register("RivalCompanyInfo", rivalCompanyInfo, "GenericDescbox")
