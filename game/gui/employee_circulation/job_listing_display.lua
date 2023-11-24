local jobListingDisplay = {}

jobListingDisplay.CATCHABLE_EVENTS = {
	employeeCirculation.EVENTS.CANDIDATE_HIRED,
	employeeCirculation.EVENTS.CANDIDATE_REFUSED
}

function jobListingDisplay:confirmRemovalCallback()
	employeeCirculation:cancelEmployeeSearch(self.searchData)
end

function jobListingDisplay:removeListingCallback()
	local popup = game.createPopup(500, _T("CONFIRM_SEARCH_CANCELLATION_TITLE", "Confirm Search Cancellation"), _T("CONFIRM_SEARCH_CANCELLATION_DESCRIPTION", "Are you sure you want to remove this job offer listing?\n\nCancelling searches will not reimburse the money you've spent on them."), "pix24", "pix20", true)
	local button = popup:addButton("pix20", _T("REMOVE_JOB_OFFER_LISTING", "Remove job offer listing"), jobListingDisplay.confirmRemovalCallback)
	
	button.searchData = self.searchData
	
	local button = popup:addButton("pix20", _T("GO_BACK", "Go back"))
	
	popup:center()
	frameController:push(popup)
end

function jobListingDisplay:viewCandidatesCallback()
	employeeCirculation:viewListingCandidates(self.searchData)
end

function jobListingDisplay:init()
	self.descriptionBox = gui.create("GenericDescbox", self)
	
	self.descriptionBox:setPos(_S(1), _S(4))
	self.descriptionBox:setShowRectSprites(false)
	self.descriptionBox:overwriteDepth(5)
	self.descriptionBox:setFadeInSpeed(0)
end

function jobListingDisplay:getSearchData()
	return self.searchData
end

function jobListingDisplay:setSearchData(data)
	self.searchData = data
	
	self:updateDescBox()
end

function jobListingDisplay:fillInteractionComboBox(combobox)
	if #self.searchData.candidates > 0 then
		local option = combobox:addOption(0, 0, 0, 24, _T("VIEW_CANDIDATES", "View candidates"), fonts.get("pix20"), self.viewCandidatesCallback)
		
		option.searchData = self.searchData
	end
	
	local option = combobox:addOption(0, 0, 0, 24, _T("REMOVE_JOB_LISTING", "Remove job listing..."), fonts.get("pix20"), self.removeListingCallback)
	
	option.searchData = self.searchData
end

function jobListingDisplay:handleEvent(event, candidate, searchData)
	if self.searchData == searchData then
		self:updateDescBox()
	end
end

function jobListingDisplay:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		local localX, localY = self:getPos(true)
		
		interactionController:setInteractionObject(self, x - _S(10), y - _S(10), true)
	end
end

jobListingDisplay.gradientColor = color(83, 152, 209, 255)
jobListingDisplay.gradientColorRegular = color(0, 0, 0, 200)

function jobListingDisplay:updateDescBox()
	self.descriptionBox:removeAllText()
	
	local capWidth = self.rawW
	local roleData = attributes.profiler.rolesByID[self.searchData.role]
	local textLineWidth = self.w - _S(20)
	local textLineHeight = _S(28)
	local textLineHeightTwo = _S(26)
	
	self.descriptionBox:addTextLine(textLineWidth, self.gradientColor, textLineHeight, "weak_gradient_horizontal")
	self.descriptionBox:addText(_format(_T("JOB_LISTING_ROLE_AND_LEVEL", "ROLE - level LEVEL"), "ROLE", roleData.display, "LEVEL", self.searchData.level), "bh22", nil, 5, capWidth, {
		{
			width = 24,
			icon = "profession_backdrop",
			x = 2,
			height = 24
		},
		{
			width = 22,
			x = 3,
			height = 22,
			icon = roleData.roleIcon
		}
	})
	self.descriptionBox:addTextLine(textLineWidth, self.gradientColorRegular, textLineHeightTwo, "weak_gradient_horizontal")
	self.descriptionBox:addText(_format(_T("EMPLOYEE_SEARCH_TIME_LEFT", "Listing time left: TIME"), "TIME", timeline:getTimePeriodText(self.searchData.timeLeft)), "pix20", nil, 3, capWidth, "clock_full", 24, 24)
	self.descriptionBox:addTextLine(textLineWidth, self.gradientColorRegular, textLineHeightTwo, "weak_gradient_horizontal")
	self.descriptionBox:addText(_format(_T("EMPLOYEE_SEARCH_TOTAL_CANDIDATES", "Total candidates: CANDIDATES"), "CANDIDATES", self.searchData.totalOffers), "pix20", nil, 7, capWidth, "hud_employee_management", 24, 20)
	self.descriptionBox:addTextLine(textLineWidth, self.gradientColorRegular, textLineHeightTwo, "weak_gradient_horizontal")
	self.descriptionBox:addText(_format(_T("EMPLOYEE_SEARCH_CURRENT_CANDIDATES", "Current candidates: CANDIDATES"), "CANDIDATES", #self.searchData.candidates), "pix20", nil, 3, capWidth, "employees", 24, 24)
	
	if #self.searchData.interests > 0 then
		for key, interestID in ipairs(self.searchData.interests) do
			self.descriptionBox:addTextLine(textLineWidth, self.gradientColorRegular, textLineHeightTwo, "weak_gradient_horizontal")
			self.descriptionBox:addText(_format(_T("EMPLOYEE_SEARCH_INTEREST", "Interest COUNT: INTEREST"), "COUNT", key, "INTEREST", interests.registeredByID[interestID].display), "bh20", nil, 6, capWidth)
		end
	end
	
	self.descriptionBox:addTextLine(textLineWidth, self.gradientColorRegular, textLineHeightTwo, "weak_gradient_horizontal")
	self.descriptionBox:addText(_format(_T("EMPLOYEE_SEARCH_EXPENDITURES", "Search expenditures: $MONEY"), "MONEY", string.comma(self.searchData.budget)), "pix20", nil, 3, capWidth, "wad_of_cash_minus", 22, 22)
	self:setHeight(_US(self.descriptionBox:getRawHeight()) + 4)
end

gui.register("JobListingDisplay", jobListingDisplay, "GenericElement")
