local activeMMO = {}
local logic = logicPieces:getData(gameProject.MMO_SUBSCRIPTIONS_LOGIC_PIECE_ID)

activeMMO.CATCHABLE_EVENTS = {
	logic.EVENTS.OVER,
	logic.EVENTS.FEE_CHANGED
}

function activeMMO:init()
	self.infoBox = gui.create("GenericDescbox", self)
	
	self.infoBox:overwriteDepth(100)
	self.infoBox:setShowRectSprites(false)
	self.infoBox:setFadeInSpeed(0)
	self.infoBox:setPos(0, _S(3))
end

function activeMMO:handleEvent(event, proj)
	if event == logic.EVENTS.OVER then
		self:kill()
	elseif event == logic.EVENTS.FEE_CHANGED and self.project == proj then
		self:remakeInfoBox()
	end
end

function activeMMO:setInfoDescbox(desc)
	self.infoDescbox = desc
end

function activeMMO:setProject(proj)
	self.project = proj
	
	self:remakeInfoBox()
	self:setHeight(_US(self.infoBox.rawH))
end

function activeMMO:remakeInfoBox()
	self.infoBox:removeAllText()
	
	local wrapW = self.rawW - 20
	local lineWidth = self.w - _S(20)
	
	self.infoBox:addTextLine(lineWidth, game.UI_COLORS.IMPORTANT_1, nil, "weak_gradient_horizontal")
	self.infoBox:addText(self.project:getName(), "bh22", nil, 4, wrapW)
	
	local mmoLogic = self.project.mmoLogic
	
	self.infoBox:addTextLine(lineWidth, gui.genericGradientColor, nil, "weak_gradient_horizontal")
	self.infoBox:addText(_format(_T("MMO_SERVER_USE", "Server use: USE pts."), "USE", string.roundtobignumber(mmoLogic:getServerUse())), "pix20", nil, 2, wrapW, "server_load", 22, 22)
	self.infoBox:addTextLine(lineWidth, gui.genericGradientColor, nil, "weak_gradient_horizontal")
	self.infoBox:addText(_format(_T("MMO_SUBSCRIPTION_FEE_DISPLAY", "Subscription fee: $FEE"), "FEE", mmoLogic:getFee()), "pix20", nil, 2, wrapW, "wad_of_cash", 22, 22)
	
	local fees, serverCosts = mmoLogic:getMonthlyFees(), mmoLogic:calculateServerCosts()
	
	self.infoBox:addTextLine(lineWidth, gui.genericGradientColor, nil, "weak_gradient_horizontal")
	self.infoBox:addText(_format(_T("MMO_EARNINGS_PER_MONTH", "Earnings: $EARNINGS/month"), "EARNINGS", string.roundtobignumber(fees)), "pix20", nil, 2, wrapW, "wad_of_cash_plus", 22, 22)
	self.infoBox:addTextLine(lineWidth, gui.genericGradientColor, nil, "weak_gradient_horizontal")
	self.infoBox:addText(_format(_T("MMO_SERVER_COSTS_MONTH", "Server costs: $COSTS/month"), "COSTS", string.roundtobignumber(serverCosts)), "pix20", nil, 2, wrapW, "wad_of_cash_minus", 22, 22)
	
	local delta = fees - serverCosts
	local text = _format(_T("MMO_MONEY_MONTHLY_NET_CHANGE", "Monthly net change: CHANGE"), "CHANGE", string.roundtobigcashnumber(delta))
	
	if delta > 0 then
		self.infoBox:addTextLine(lineWidth, game.UI_COLORS.LIGHT_GREEN, nil, "weak_gradient_horizontal")
		self.infoBox:addText(text, "bh20", nil, 0, capWidth, "money_made", 24, 24)
	else
		self.infoBox:addTextLine(lineWidth, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		self.infoBox:addText(text, "bh20", nil, 0, capWidth, "money_lost", 24, 24)
	end
	
	if mmoLogic:getDDOS() then
		self.infoBox:addSpaceToNextText(4)
		self.infoBox:addTextLine(lineWidth, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		self.infoBox:addText(_T("MMO_DDOS_ATTACK", "DDoS attack"), "bh20", nil, 2, capWidth, "exclamation_point_red", 24, 24)
	end
	
	for key, data in ipairs(mmoLogic:getActiveRandomEvents()) do
		data:setupInfobox(self.infoBox, wrapW, lineWidth)
	end
end

function activeMMO:onMouseEntered()
	activeMMO.baseClass.onMouseEntered(self)
	self.infoDescbox:setupDescbox(self.project)
end

function activeMMO:onMouseLeft()
	activeMMO.baseClass.onMouseLeft(self)
	self.infoDescbox:hideVisibility()
end

function activeMMO:fillInteractionComboBox(comboBox)
	comboBox:setAutoCloseTime(0.5)
	self.project.mmoLogic:fillInteractionComboBox(comboBox)
end

function activeMMO:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		interactionController:startInteraction(self, x, y)
	end
end

gui.register("ActiveMMOElement", activeMMO, "GenericElement")
