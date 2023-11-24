local bookExpoButton = {}

function bookExpoButton:setConventionData(data)
	self.conventionData = data
end

function bookExpoButton:confirmExpo()
	self.mainFrame:setBooking(true)
	self.mainFrame:kill()
	self.conventionData:book()
end

function bookExpoButton:onClick(x, y, key)
	local total, entryFee, boothCost, staffCost, realFee = self.conventionData:getDesiredFee()
	
	if studio:hasFunds(realFee) then
		if #self.conventionData:getDesiredGames() == 0 then
			local popup = game.createPopup(500, _T("NO_PRESENTED_GAMES_SELECTED_TITLE", "No Games Selected"), _T("NO_PRESENTED_GAMES_SELECTED_DESCRIPTION", "You have not selected any games to present at the expo."), "pix24", "pix20")
			
			popup:center()
			frameController:push(popup)
			
			return 
		end
		
		if #self.conventionData:getDesiredEmployees() == 0 then
			local popup = game.createPopup(500, _T("NO_EMPLOYEES_SELECTED_EXPO_TITLE", "No Employees Selected"), _T("NO_PRESENTING_STAFF_SELECTED_DESCRIPTION", "You have not selected any of your employees to participate in the expo, which means the staff will be from an outside company, and will not attract more people.\n\nAre you sure you want to book a spot in the exposition with none of your employees present?"), "pix24", "pix20", true)
			local button = popup:addButton("pix20", string.easyformatbykeys(_T("CONFIRM_EXPO", "Confirm & pay $COST"), "COST", string.roundtobignumber(realFee)), bookExpoButton.confirmExpo)
			
			button.conventionData = self.conventionData
			button.mainFrame = self:getParent()
			
			popup:addButton("pix20", _T("GO_BACK", "Go back"))
			popup:center()
			frameController:push(popup)
			
			return 
		end
		
		local mainFrame = self:getParent()
		
		mainFrame:setBooking(true)
		mainFrame:kill()
		self.conventionData:book()
	else
		local popup = game.createPopup(500, _T("NOT_ENOUGH_MONEY_TITLE", "Not Enough Money"), _T("NOT_ENOUGH_CASH_FOR_EXPO_BOOKING", "You do not have enough money to book a spot in the game expo with the current setup."), "pix24", "pix20")
		
		popup:center()
		frameController:push(popup)
	end
end

gui.register("BookExpoButton", bookExpoButton, "Button")
