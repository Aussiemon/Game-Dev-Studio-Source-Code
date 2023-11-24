local mmoInfo = {}

function mmoInfo:setupDescbox(mmo)
	local logic = mmo.mmoLogic
	
	self.logic = logic
	
	self:show()
	self:removeAllText()
	
	local wrapW = 300
	
	self:addText(_format(_T("MMO_CURRENT_SUBSCRIPTIONS_FULL", "Current subscriptions: SUBS"), "SUBS", string.roundtobignumber(logic:getSubscribers())), "bh18", nil, 4, wrapW, "mmo_subscriptions", 22, 22)
	self:addText(_format(_T("MMO_SUBSCRIPTION_CHANGE_THIS_MONTH", "Sub change this month: SUBS"), "SUBS", string.roundtobignumber(logic:getSubChange())), "bh18", nil, 4, wrapW, "subscription_change", 22, 22)
	self:addText(_format(_T("PROJECT_SERVER_COMPLEXITY", "Server complexity: COMPLEX pts."), "COMPLEX", logic:getServerComplexity()), "bh18", nil, 4, wrapW, "projects_finished", 24, 24)
	self:addText(_format(_T("FINAL_SERVER_USE", "Final server use: USE pts."), "USE", string.roundtobignumber(logic:getServerUse())), "bh18", nil, 4, wrapW, "server_load_full", 24, 24)
	self:addText(_format(_T("MMO_SUBSCRIPTION_PLAYER_HAPPINESS_FULL", "Player happiness: HAPPINESS%"), "HAPPINESS", math.round(logic:getHappiness() * 100, 1)), "bh18", nil, 0, wrapW, "trait_asocial", 22, 22)
	
	local serverUseAffector = logic:getServerUseAffector()
	
	if serverUseAffector > 0 then
		self:addSpaceToNextText(4)
		self:addTextLine(wrapW - 30, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		self:addText(_format(_T("MMO_EXTRA_SERVER_LOAD", "Extra server load: POINTS pts"), "POINTS", string.roundtobignumber(logic:getServerUseAffector(), 1)), "bh18", nil, 0, wrapW, "exclamation_point_red", 22, 22)
	end
end

function mmoInfo:canShow()
	return self.logic
end

function mmoInfo:hideVisibility()
	self.logic = nil
	
	self:removeAllText()
	self:hide()
end

gui.register("MMOInfoDescbox", mmoInfo, "GenericDescbox")
