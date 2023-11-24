local AddJobListingButton = {}

AddJobListingButton.text = _T("BEGIN_EMPLOYEE_SEARCH_BUTTON", "List job offer")
AddJobListingButton.CATCHABLE_EVENTS = {
	employeeCirculation.EVENTS.ADJUSTED_SEARCH_PARAMETER
}

function AddJobListingButton:init()
	self.invalidFactors = {}
end

function AddJobListingButton:handleEvent()
	self:evaluateClickabilityState()
end

function AddJobListingButton:evaluateClickabilityState()
	table.clearArray(self.invalidFactors)
	
	local funds = studio:getFunds()
	local valid = true
	
	if funds < self.searchData.budget then
		valid = false
		
		table.insert(self.invalidFactors, _format(_T("SEARCH_NOT_ENOUGH_MONEY", "You are lacking $MISSING"), "MISSING", self.searchData.budget - funds))
	end
	
	if not self.searchData.role then
		valid = false
		
		table.insert(self.invalidFactors, _T("SEARCH_NO_ROLE_SELECTED", "You have not selected a role"))
	elseif employeeCirculation:isSearchingForRole(self.searchData.role) then
		valid = false
		
		table.insert(self.invalidFactors, _format(_T("SEARCH_OF_ROLE_ALREADY_IN_PROGRESS", "You already have a job offer listing for ROLE"), "ROLE", attributes.profiler.rolesByID[self.searchData.role].personDisplay))
	end
	
	self.valid = valid
end

function AddJobListingButton:setSearchData(data)
	self.searchData = data
	
	self:evaluateClickabilityState()
	self:queueSpriteUpdate()
end

function AddJobListingButton:isDisabled()
	return not self.valid
end

function AddJobListingButton:onMouseEntered()
	self:queueSpriteUpdate()
	
	if #self.invalidFactors == 0 then
		return 
	end
	
	self.descBox = gui.create("GenericDescbox")
	
	for key, data in ipairs(self.invalidFactors) do
		self.descBox:addText(data, "bh20", nil, 0, 500)
	end
	
	self.descBox:positionToMouse(_S(10), _S(10))
end

function AddJobListingButton:onMouseLeft()
	self:queueSpriteUpdate()
	self:killDescBox()
end

function AddJobListingButton:confirmJobListingCallback()
	employeeCirculation:addEmployeeSearch(self.searchData)
end

function AddJobListingButton:onClick()
	if not self.valid then
		return 
	end
	
	local warningText = employeeCirculation:verifyJobSearchAvailability()
	
	if warningText then
		local popup = game.createPopup(500, _T("CONFIRM_JOB_LISTING_TITLE", "Confirm Job Listing"), warningText, "pix24", "pix20", true, nil)
		local button = popup:addButton("pix20", _T("GENERIC_CONFIRM", "Confirm job listing"), AddJobListingButton.confirmJobListingCallback)
		
		button.searchData = self.searchData
		
		popup:addButton("pix20", _T("GENERIC_CANCEL", "Cancel"))
		popup:center()
		frameController:push(popup)
		
		return 
	end
	
	employeeCirculation:addEmployeeSearch(self.searchData)
end

gui.register("AddJobListingButton", AddJobListingButton, "Button")
