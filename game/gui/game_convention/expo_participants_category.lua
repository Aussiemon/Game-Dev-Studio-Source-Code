local expoEmployees = {}

expoEmployees.changeSizeOnTextUpdate = false

function expoEmployees:initVisual()
	self.selectBest = gui.create("SelectBestEmployeesButton", self)
	
	self.selectBest:setPos(_S(3), _S(3))
end

function expoEmployees:handleEvent(event)
	if event == gameConventions.EVENTS.BOOTH_CHANGED or event == gameConventions.EVENTS.PARTICIPANT_ADDED or event == gameConventions.EVENTS.PARTICIPANT_REMOVED then
		self:updateText()
	end
end

function expoEmployees:setConventionData(data)
	self.conventionData = data
	
	self.selectBest:setConvention(data)
end

function expoEmployees:onSizeChanged()
	self.selectBest:setSize(self.rawH - 6, self.rawH - 6)
	self:updateTextX()
end

function expoEmployees:updateTextX()
	expoEmployees.baseClass.updateTextX(self)
	
	self.textX = self.textX + self.selectBest:getWidth()
end

function expoEmployees:updateText()
	local boothID = self.conventionData:getDesiredBooth()
	
	if boothID then
		self:setText(string.easyformatbykeys(_T("CONVENTION_EMPLOYEE_PARTICIPANTS_COUNTER", "Employee participants (CURRENT/REQUIRED)"), "CURRENT", #self.conventionData:getDesiredEmployees(), "REQUIRED", self.conventionData:getRequiredParticipants(boothID)))
		self:setHoverText(gameProject.employeeParticipantsExplanationHoverText)
	else
		self:setText(_T("CONVENTION_EMPLOYEE_PARTICIPANTS", "Employee participants - unavailable"))
		self:setHoverText(gameProject.employeeParticipantsNoBoothExplanationHoverText)
	end
end

gui.register("ExpoParticipantsCategory", expoEmployees, "Category")
