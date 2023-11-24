local setupInfo = {}

setupInfo.CATCHABLE_EVENTS = {
	playerPlatform.EVENTS.PART_SET,
	playerPlatform.EVENTS.SPECIALIST_SET,
	playerPlatform.EVENTS.COST_SET,
	playerPlatform.EVENTS.LICENSE_COST_SET
}

function setupInfo:handleEvent(event)
	self:updateDisplay()
end

function setupInfo:setPlatform(obj)
	self.platformObj = obj
end

function setupInfo:bringUp()
	self:addDepth(5000)
end

function setupInfo:updateDisplay()
	self:removeAllText()
	
	local obj = self.platformObj
	
	self:setWidth(250)
	
	local wrapWidth = 300
	
	self:addText(_format(_T("PLATFORM_BASE_ATTRACTIVENESS", "Attractiveness: ATTRACT pts."), "ATTRACT", obj:getDefaultAttractiveness()), "bh20", game.UI_COLORS.CATEGORY_SEPARATOR_COLOR, 4, wrapWidth, "platform_attractiveness", 23, 21)
	
	local manufac = obj:getManufacturingCost()
	local cost = obj:getRealCost()
	
	self:addText(_format(_T("PLATFORM_MANUFACTURING_COST", "Manufacturing cost: $COST"), "COST", manufac), "bh18", nil, 4, wrapWidth, "platform_manufacture_cost", 22, 22)
	
	local clr, icon
	
	if manufac < cost then
		clr = game.UI_COLORS.GREEN
		icon = "wad_of_cash_plus"
	elseif cost < manufac then
		clr = game.UI_COLORS.RED
		icon = "wad_of_cash_minus"
	end
	
	if clr then
		self:addTextLine(_S(200), clr, _S(22), "weak_gradient_horizontal")
		self:addText(_format(_T("PLATFORM_NET_CHANGE", "Net change: CHANGE"), "CHANGE", string.roundtobigcashnumber(cost - manufac)), "bh18", clr, 4, wrapWidth, icon, 22, 22)
	end
	
	self:addText(_format(_T("PLATFORM_DEVELOPMENT_DIFFICULTY", "Development difficulty: DIFF%"), "DIFF", math.round(obj:getDevelopmentDifficulty() * 100, 1)), "bh18", nil, 4, 300, "platform_dev_difficulty", 22, 22)
	self:addText(_format(_T("PLATFORM_MAX_GAME_SCALE", "Max. game scale: xSCALE"), "SCALE", obj:getMaxProjectScale()), "bh18", nil, 10, wrapWidth, "platform_max_game_scale", 22, 22)
	self:addText(_format(_T("PLATFORM_DEVELOPER_ATTRACTIVENESS", "Developer attractiveness: ATTR pts."), "ATTR", math.round(obj:getDeveloperAttractiveness(), 1)), "bh18", nil, 4, 300, "platform_dev_attractiveness", 22, 22)
	
	local specialist = obj:getSpecialist()
	
	if specialist then
		self:addTextLine(_S(200), game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
		self:addText(_T("PLATFORM_SPECIALIST_SELECTED", "Specialist selected!"), "bh18", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth, "exclamation_point", 22, 22)
		
		local data = platformParts.registeredSpecialistsByID[specialist]
		
		data:setupSpecialistText(self, wrapWidth)
	else
		self:addTextLine(_S(200), game.UI_COLORS.IMPORTANT_1, nil, "weak_gradient_horizontal")
		self:addText(_T("PLATFORM_NO_SPECIALIST_SELECTED", "No specialist selected"), "bh18", game.UI_COLORS.IMPORTANT_1, 0, wrapWidth, "question_mark_yellow", 22, 22)
	end
end

gui.register("PlatformSetupInfo", setupInfo, "GenericDescbox")
