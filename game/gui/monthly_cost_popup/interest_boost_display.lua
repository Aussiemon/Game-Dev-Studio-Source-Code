local interestBoostDisplay = {}

interestBoostDisplay.GRADIENT_COLOR = gui.genericOutlineColor

function interestBoostDisplay:setInterestData(interestID, boostLevel)
	self.interestID = interestID
	self.interestData = interests:getData(self.interestID)
	self.interestBoost = boostLevel
	
	self:setIcon(self.interestData.quad, 2, 2)
	self:setFont("pix22")
	self:addText(self.interestData.display, nil, nil, nil)
	self:addText(string.easyformatbykeys(_T("INTEREST_BOOST_POINT_AMOUNT", "+POINTS points"), "POINTS", self.interestBoost), interestBoostDisplay.BOOST_TEXT_COLOR, nil, nil)
end

function interestBoostDisplay:setOffice(office)
	self.office = office
end

interestBoostDisplay.workerFormatMethods = {
	ru = function(amt)
		return translation.conjugateRussianText(amt, "В офисе есть %s людей которые заинтересованы INTEREST", "В офисе есть %s человека которые заинтересованы INTEREST", "В офисе есть %s человек который заинтересован INTEREST", true)
	end
}

function interestBoostDisplay:addTextToDescbox()
	self.descBox:addText(self.interestData.description, "pix18", nil, 0, 600)
	
	local officeEmployees = self.office:getEmployees()
	local total = 0
	
	for key, employee in ipairs(officeEmployees) do
		if employee:hasInterest(self.interestID) then
			total = total + 1
		end
	end
	
	local text
	local method = interestBoostDisplay.workerFormatMethods[translation.currentLanguage]
	
	if method then
		text = method(total)
	elseif total == 0 then
		text = _format(_T("NO_EMPLOYEES_WITH_INTEREST", "There are no employees in this office interested in INTEREST"), "INTEREST", self.interestData.display)
	elseif total == 1 then
		text = _format(_T("ONE_EMPLOYEE_WITH_INTEREST", "There is 1 employee in this office interested in INTEREST"), "INTEREST", self.interestData.display)
	else
		text = _format(_T("MULTIPLE_EMPLOYEES_WITH_INTEREST", "There are EMPLOYEES employees in this office interested in INTEREST"), "EMPLOYEES", total, "INTEREST", self.interestData.display)
	end
	
	self.descBox:addSpaceToNextText(6)
	self.descBox:addText(text, "bh18", game.UI_COLORS.LIGHT_BLUE, 0, 600, "question_mark", 20, 20)
end

gui.register("InterestBoostDisplay", interestBoostDisplay, "DescboxGradientIconTextDisplay")
