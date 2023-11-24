serverRenting = {}
serverRenting.serverRackClass = "server_rack"
serverRenting.baseEventName = "server_cap_inc_"
serverRenting.registeredLevels = {}
serverRenting.MONTHLY_FEE = 20000
serverRenting.CUSTOMER_SUPPORT_FEE = 20000
serverRenting.CUSTOMER_SUPPORT_INCREMENT = 25000
serverRenting.RENT_HEADSUP_FACT = "server_rent_headsup"
serverRenting.EVENTS = {
	CHANGED_RENTED_SERVERS = events:new(),
	CHANGED_CUSTOMER_SUPPORT = events:new()
}

function serverRenting:init()
	self.capacity = 0
	self.activeMMOs = {}
end

function serverRenting:remove()
	self.capacity = 0
	
	table.clearArray(self.activeMMOs)
end

function serverRenting:getMonthlyRentFee()
	return self.MONTHLY_FEE
end

function serverRenting:getCustomerSupportCost()
	return studio:getCustomerSupport() * self:getMonthlyCustomerSupportFee()
end

function serverRenting:getMonthlyCustomerSupportFee()
	return self.CUSTOMER_SUPPORT_FEE
end

function serverRenting:getCustomerSupportValue()
	return self.CUSTOMER_SUPPORT_INCREMENT
end

function serverRenting:getPlayerFee()
	return self.MONTHLY_FEE * studio:getRentedServers()
end

function serverRenting:getActiveMMOFee()
	local fee = 0
	
	for key, mmo in ipairs(self.activeMMOs) do
		fee = fee + mmo.mmoLogic:calculateServerCosts()
	end
	
	return fee
end

function serverRenting:getActiveMMOSubFees()
	local fee = 0
	
	for key, mmo in ipairs(self.activeMMOs) do
		fee = fee + mmo.mmoLogic:getMonthlyFees()
	end
	
	return fee
end

function serverRenting:getCapacity()
	return self.capacity
end

function serverRenting:setCapacity(capacity)
	self.capacity = capacity
	
	studio:onServerCapacityChanged()
end

function serverRenting:registerLevel(availabilityDate, capacity)
	local id = serverRenting.baseEventName .. #self.registeredLevels + 1
	
	scheduledEvents:registerNew({
		id = id,
		factToSet = id,
		date = availabilityDate,
		capacity = capacity
	}, "server_capacity_increase")
	table.insert(self.registeredLevels, {
		date = availabilityDate,
		capacity = capacity
	})
end

function serverRenting:findLatestCapacity()
	local valid, latest = nil, 0
	local time = timeline:getDateTime(timeline:getYear(), timeline:getMonth())
	
	for key, data in ipairs(self.registeredLevels) do
		local date = data.date
		local avTime = timeline:getDateTime(date.year, date.month)
		
		if latest < avTime and avTime <= time then
			valid = data
			latest = avTime
		end
	end
	
	if valid then
		self.capacity = valid.capacity
	end
end

function serverRenting:manageServersCallback()
	serverRenting:createMenu()
end

function serverRenting:addMenuOption(comboBox, font)
	if not self.menuFrame or not self.menuFrame:isValid() then
		comboBox:addOption(0, 0, 0, 24, _T("MANAGE_SERVERS_OPTION", "Manage servers..."), font, serverRenting.manageServersCallback)
	end
end

function serverRenting:changeCustomerSupport(change)
	if change > 0 and not studio:hasFunds(self:getMonthlyCustomerSupportFee() * change) then
		return 
	end
	
	local customerSupport = studio:getCustomerSupport()
	
	if change < 0 and customerSupport == 0 then
		return 
	end
	
	local abs = math.abs(change)
	
	if change < 0 then
		change = -math.min(customerSupport, abs)
	end
	
	if change > 0 then
		studio:deductFunds(self:getMonthlyCustomerSupportFee() * change)
	else
		local pending = studio:getPendingCustomerSupport()
		local returnFee = math.max(0, math.min(pending, math.abs(change)))
		
		studio:addFunds(self:getMonthlyCustomerSupportFee() * returnFee)
	end
	
	studio:changeCustomerSupport(change)
	events:fire(serverRenting.EVENTS.CHANGED_RENTED_SERVERS)
end

function serverRenting:changeRentedServers(change)
	if change > 0 and not studio:hasFunds(self:getMonthlyRentFee() * change) then
		return 
	end
	
	local rentedServers = studio:getRentedServers()
	
	if change < 0 and rentedServers == 0 then
		return 
	end
	
	if change > 0 and not studio:getFact(serverRenting.RENT_HEADSUP_FACT) then
		local popup = game.createPopup(500, _T("RENTING_SERVERS_TITLE", "Renting Servers"), _T("RENTING_SERVERS_DESCRIPTION", "Renting out a new server requires you pay the fee for it up-front, rather than paying next month."), "pix24", "pix20", nil)
		
		popup:hideCloseButton()
		frameController:push(popup)
		studio:setFact(serverRenting.RENT_HEADSUP_FACT, true)
		
		return 
	end
	
	local abs = math.abs(change)
	
	if change < 0 then
		change = -math.min(rentedServers, abs)
	end
	
	if change > 0 then
		studio:deductFunds(self:getMonthlyRentFee() * change)
	else
		local pending = studio:getPendingRentedServers()
		local returnFee = math.max(0, math.min(pending, math.abs(change)))
		
		studio:addFunds(self:getMonthlyRentFee() * returnFee)
	end
	
	studio:changeRentedServers(change)
	events:fire(serverRenting.EVENTS.CHANGED_RENTED_SERVERS)
end

function serverRenting:getActiveMMOs()
	return self.activeMMOs
end

function serverRenting:addActiveMMO(gameObj)
	self.activeMMOs[#self.activeMMOs + 1] = gameObj
	
	if self.sleeping then
		self.sleeping = false
	end
end

function serverRenting:removeActiveMMO(gameObj)
	table.removeObject(self.activeMMOs, gameObj)
	
	if #self.activeMMOs == 0 then
		self.sleeping = true
	end
end

function serverRenting:isSleeping()
	return self.sleeping
end

function serverRenting:createMenu()
	local frame = gui.create("Frame")
	
	frame:setSize(350, 500)
	frame:setFont("pix24")
	frame:setTitle(_T("SERVER_MANAGEMENT_TITLE", "Server Management"))
	
	local propSheet = gui.create("PropertySheet", frame)
	
	propSheet:setSize(340, frame.rawH - 163)
	propSheet:setFont(fonts.get("bh24"))
	propSheet:setPos(_S(5), _S(35))
	
	local sizeOffset = 193
	local serverPanel = gui.create("Panel")
	
	serverPanel:setSize(340, frame.rawH - sizeOffset)
	
	serverPanel.shouldDraw = false
	
	local scrollbar = gui.create("ServerRentingScrollbarPanel", serverPanel)
	
	scrollbar:setSize(340, serverPanel.rawH)
	scrollbar:setAdjustElementPosition(true)
	scrollbar:setSpacing(3)
	scrollbar:setPadding(3, 3)
	scrollbar:buildLevelCounters()
	
	local serversButton = propSheet:addItem(serverPanel, _T("SERVER_RENTING_TAB_SERVERS", "Servers"))
	
	serversButton:addHoverText(_T("SERVER_RENTING_TAB_DESCRIPTION", "View the server racks you have in your office."), "pix18", 0, nil, 300)
	
	local x, y = scrollbar:getPos(true)
	local gamesPanel = gui.create("Panel")
	
	gamesPanel:setSize(340, frame.rawH - sizeOffset)
	
	gamesPanel.shouldDraw = false
	
	local gamesScrollbar = gui.create("ScrollbarPanel", gamesPanel)
	
	gamesScrollbar:setSize(340, gamesPanel.rawH)
	gamesScrollbar:setAdjustElementPosition(true)
	gamesScrollbar:setSpacing(3)
	gamesScrollbar:setPadding(3, 3)
	
	local mmosButton = propSheet:addItem(gamesPanel, _T("SERVER_RENTING_TAB_MMOS", "MMOs"))
	
	mmosButton:addHoverText(_T("MMOS_TAB_DESCRIPTION", "View all on-market MMO game projects that are currently using up server capacity."), "pix18", 0, nil, 300)
	
	local capBar = gui.create("ServerCapacityBar", frame)
	
	capBar:setSize(340, 40)
	capBar:setFont("bh20")
	capBar:setPos(_S(5), y + scrollbar.h + _S(40))
	capBar:updateText()
	
	local costDisplay = gui.create("RentCostDisplay", frame)
	
	costDisplay:setSize(200, 30)
	costDisplay:setFont("bh22")
	costDisplay:setCost(self:getPlayerFee())
	costDisplay:updateText()
	costDisplay:setCanHover(false)
	costDisplay:setPos(_S(5), capBar.y - _S(5) - costDisplay.h)
	
	local incRent = gui.create("ChangeServerRentButton", frame)
	
	incRent:setSize(30, 30)
	incRent:setDirection(1)
	incRent:setPos(frame.w - _S(5) - incRent.w, capBar.y - incRent.h - _S(5))
	
	local decRent = gui.create("ChangeServerRentButton", frame)
	
	decRent:setSize(30, 30)
	decRent:setDirection(-1)
	decRent:setPos(incRent.x - incRent.w - _S(5), incRent.y)
	
	local rentCount = gui.create("RentedServerCountDisplay", frame)
	
	rentCount:setSize(65, 30)
	rentCount:setPos(decRent.x - rentCount.w - _S(5), decRent.y)
	rentCount:setFont("bh24")
	rentCount:setText(studio:getRentedServers())
	rentCount:updateText()
	
	local custBar = gui.create("CustomerSupportBar", frame)
	
	custBar:setSize(270, 30)
	custBar:setFont("bh20")
	custBar:setPos(_S(5), capBar.localY + capBar.h + _S(5))
	custBar:updateText()
	
	local incCust = gui.create("ChangeCustomerSupportButton", frame)
	
	incCust:setSize(30, 30)
	incCust:setDirection(1)
	incCust:setPos(frame.w - _S(5) - incCust.w, custBar.y)
	
	local decCust = gui.create("ChangeCustomerSupportButton", frame)
	
	decCust:setSize(30, 30)
	decCust:setDirection(-1)
	decCust:setPos(incCust.x - incCust.w - _S(5), custBar.y)
	frame:center()
	
	local funds = gui.create("ServerRentingInfoDescbox")
	
	funds:setBasePoint(frame.x - _S(5), frame.y)
	funds:tieVisibilityTo(serversButton.bar)
	funds:overwriteDepth(5000)
	funds:setup()
	
	local descbox = gui.create("MMOInfoDescbox")
	
	descbox:tieVisibilityTo(mmosButton.bar)
	descbox:setPos(frame.x + frame.w + _S(5), frame.y)
	descbox:overwriteDepth(5000)
	
	for key, mmo in ipairs(self.activeMMOs) do
		local elem = gui.create("ActiveMMOElement")
		
		elem:setWidth(gamesScrollbar.rawW - 18)
		elem:setProject(mmo)
		elem:setInfoDescbox(descbox)
		gamesScrollbar:addItem(elem)
	end
	
	frameController:push(frame)
	
	self.menuFrame = frame
end

function serverRenting:save()
	local saved = {
		capacity = self.capacity
	}
	
	return saved
end

function serverRenting:load(data)
	self.capacity = data.capacity
end

function serverRenting:postLoad()
	self:findLatestCapacity()
	
	if #self.activeMMOs == 0 then
		self.sleeping = true
	end
end
