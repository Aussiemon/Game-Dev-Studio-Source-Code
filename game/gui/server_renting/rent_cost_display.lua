local rentCostDisplay = {}
local data = logicPieces:getData(gameProject.MMO_SUBSCRIPTIONS_LOGIC_PIECE_ID)

rentCostDisplay.CATCHABLE_EVENTS = {
	serverRenting.EVENTS.CHANGED_RENTED_SERVERS,
	serverRenting.EVENTS.CHANGED_CUSTOMER_SUPPORT,
	studio.EVENTS.FUNDS_CHANGED,
	data.EVENTS.FEE_CHANGED
}

function rentCostDisplay:init()
	self:updateMMOFee()
	self:updateSubFees()
end

function rentCostDisplay:hasEnoughFunds()
	return studio:getFunds() >= serverRenting:getMonthlyRentFee()
end

function rentCostDisplay:handleEvent()
	if event == data.EVENTS.FEE_CHANGED then
		self:updateSubFees()
	else
		self:updateMMOFee()
		self:setCost(self:getRentFee())
		self:updateText()
	end
end

function rentCostDisplay:getRentFee()
	if serverRenting:isSleeping() then
		return 0
	end
	
	return serverRenting:getPlayerFee()
end

function rentCostDisplay:getRealCost()
	return self:getRentFee() + self.activeMMOFee + self.customerSupportCost
end

function rentCostDisplay:updateSubFees()
	self.subFees = serverRenting:getActiveMMOSubFees()
end

function rentCostDisplay:updateMMOFee()
	self.activeMMOFee = serverRenting:getActiveMMOFee()
	
	if serverRenting:isSleeping() then
		self.customerSupportCost = 0
	else
		self.customerSupportCost = serverRenting:getCustomerSupportCost()
	end
end

function rentCostDisplay:setupDescBox()
end

gui.register("RentCostDisplay", rentCostDisplay, "CostDisplay")
