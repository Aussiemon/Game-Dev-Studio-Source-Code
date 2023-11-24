local jobListingCandidate = {}

jobListingCandidate.CATCHABLE_EVENTS = {
	employeeCirculation.EVENTS.CANDIDATE_HIRED,
	employeeCirculation.EVENTS.CANDIDATE_REFUSED
}

function jobListingCandidate:moreInfoCallback()
	self.employee:createEmployeeMenu()
end

function jobListingCandidate:acceptCandidateCallback()
	if self.searchData then
		employeeCirculation:acceptListingCandidate(self.searchData, self.employee)
	else
		employeeCirculation:acceptCandidate(self.employee)
	end
end

function jobListingCandidate:refuseCandidateCallback()
	employeeCirculation:refuseListingCandidate(self.searchData, self.employee)
end

function jobListingCandidate:handleEvent(event, candidate)
	if candidate == self.employee then
		self:kill()
	end
end

function jobListingCandidate:setSearchData(data)
	self.searchData = data
end

function jobListingCandidate:fillInteractionComboBox(comboBox)
	comboBox:addOption(0, 0, 200, 18, _T("MORE_INFO", "More info"), fonts.get("pix20"), jobListingCandidate.moreInfoCallback).employee = self.employee
	
	local option = comboBox:addOption(0, 0, 200, 18, _T("ACCEPT_CANDIDATE", "Accept candidate"), fonts.get("pix20"), jobListingCandidate.acceptCandidateCallback)
	
	option.searchData = self.searchData
	option.employee = self.employee
	
	if self.searchData then
		local option = comboBox:addOption(0, 0, 200, 18, _T("REFUSE_CANDIDATE", "Refuse candidate"), fonts.get("pix20"), jobListingCandidate.refuseCandidateCallback)
		
		option.searchData = self.searchData
		option.employee = self.employee
	end
end

function jobListingCandidate:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		return 
	end
	
	interactionController:setInteractionObject(self, x - 20, y - 10, true)
	self:killDescBox()
end

gui.register("JobListingCandidate", jobListingCandidate, "EmployeeTeamAssignmentButton")
