playerPlatform.EVENTS.POWER_OUTAGE = "platform_power_outage"

local powerOutage = {
	addToList = true,
	id = "power_outage",
	affectorDropPerWeek = 0.03,
	occurChance = 0.2,
	cooldown = timeline.DAYS_IN_MONTH * 6,
	affectorRange = {
		0.3,
		0.7
	},
	devStage = playerPlatform.FINISHED_STAGE,
	canStart = function(self, platObj)
		if not platObj:isReleased() then
			return false
		end
		
		return platObj:isReleased() and math.random() * 100 <= self.occurChance
	end,
	setupAffectorCategory = function(self, catObj, elemW)
		local boost = gui.create("GradientIconPanel", nil)
		
		boost:setIcon("generic_electricity")
		boost:setBaseSize(elemW, 0)
		boost:setIconSize(20, nil, 22)
		boost:setFont("bh20")
		boost:setTextColor(game.UI_COLORS.RED)
		boost:setGradientColor(game.UI_COLORS.RED)
		boost:setText(_format(_T("PLATFORM_SALE_DECREASE_POWER_OUTAGE_SHORT", "-DEC% sales (power outage)"), "DEC", math.round(self.curAffector * 100, 1)))
		catObj:addItem(boost)
	end,
	onNewWeek = function(self, platObj)
		self.curAffector = math.max(0, self.curAffector - self.affectorDropPerWeek)
		
		if self.curAffector <= 0 then
			platObj:setSaleAffector(self.id, nil)
			platObj:setEventCooldown(self.id, timeline.curTime + self.cooldown)
			platObj:stopRandomEvent(self)
		else
			platObj:setSaleAffector(self.id, -self.curAffector)
		end
	end,
	occur = function(self, platObj)
		local range = self.affectorRange
		
		self.curAffector = math.randomf(range[1], range[2])
		
		platObj:setSaleAffector(self.id, -self.curAffector)
		
		local popup = gui.create("DescboxPopup")
		
		popup:setWidth(500)
		popup:setFont("pix24")
		popup:setTitle(_T("PLATFORM_POWER_OUTAGE_TITLE", "Power Outage"))
		popup:setTextFont("pix20")
		popup:setText(_format(_T("PLATFORM_POWER_OUTAGE_DESCRIPTION", "There has been a power outage at the manufacturing facility of your 'PLATFORM' game console, which has delayed the manufacturing process, resulting in reduced production capacity for sale."), "PLATFORM", platObj:getName()))
		popup:setShowSound("bad_jingle")
		popup:hideCloseButton()
		
		local left, right, extra = popup:getDescboxes()
		
		extra:addSpaceToNextText(10)
		extra:addTextLine(popup.w - _S(20), game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		extra:addText(_format(_T("PLATFORM_SALE_DECREASE", "Sales decreased by DECREASE%"), "DECREASE", math.round(self.curAffector * 100, 1)), "bh20", game.UI_COLORS.RED, 0, popup.rawW - 20, "exclamation_point_red", 22, 22)
		extra:addTextLine(popup.w - _S(20), game.UI_COLORS.IMPORTANT_1, nil, "weak_gradient_horizontal")
		extra:addText(_T("PLATFORM_POWER_OUTAGE_RESTORE", "The manufacturing speed will eventually restore back to 100%."), "bh20", nil, 0, popup.rawW - 20, "question_mark_yellow", 22, 22)
		popup:addOKButton("pix20")
		popup:center()
		frameController:push(popup)
		conversations:addTopicToTalkAbout(playerPlatform.CONVERSATION_POWER_OUTAGE, platObj:getID())
		events:fire(playerPlatform.EVENTS.POWER_OUTAGE, platObj)
	end
}

function powerOutage:save()
	local saved = powerOutage.baseClass.save(self)
	
	saved.curAffector = self.curAffector
	
	return saved
end

function powerOutage:load(data, platObj)
	powerOutage.baseClass.load(self, data)
	
	self.curAffector = data.curAffector
	
	platObj:setSaleAffector(self.id, self.curAffector)
end

playerPlatform:registerRandomEvent(powerOutage)

playerPlatform.EVENTS.FIRMWARE_CRACK = "platform_firmware_crack"

local firmwareCrack = {
	affectorRange = -0.2,
	chanceDecPerCompletionDelta = 0.025,
	chanceIncPerCompletionDelta = 1,
	addToList = true,
	minOccurChance = 0.5,
	occurChanceDec = 2,
	id = "firmware_crack",
	occurChance = 0.9,
	cooldown = timeline.DAYS_IN_MONTH * 9,
	devStage = playerPlatform.FINISHED_STAGE,
	canStart = function(self, platObj)
		if not platObj:isReleased() then
			return false
		end
		
		local chance = self.occurChance / (1 + self.occurChanceDec * platObj:getEventTimes(self.id))
		local delta = platObj:getCompletionValueDelta()
		
		if delta < 0 then
			chance = chance + math.abs(delta) / 20 * self.chanceIncPerCompletionDelta
		elseif delta > 0 then
			chance = math.max(self.minOccurChance, chance - self.chanceDecPerCompletionDelta * (delta / 20))
		end
		
		return chance >= math.random() * 100
	end,
	setupAffectorCategory = function(self, catObj, elemW)
		local boost = gui.create("GradientIconPanel", nil)
		
		boost:setIcon("generic_electricity")
		boost:setBaseSize(elemW, 0)
		boost:setIconSize(20, nil, 22)
		boost:setFont("bh20")
		boost:setTextColor(game.UI_COLORS.RED)
		boost:setGradientColor(game.UI_COLORS.RED)
		boost:setText(_format(_T("PLATFORM_SALE_DECREASE_FIRMWARE_CRACK_SHORT", "DEC% sales (firmware crack)"), "DEC", math.round(self.affector * 100, 1)))
		catObj:addItem(boost)
	end,
	onNewWeek = function(self, platObj)
	end,
	removeFromPlatform = function(self, platObj)
		platObj:setGameSaleAffector(self.id, nil)
		platObj:setEventCooldown(self.id, timeline.curTime + self.cooldown)
		platObj:stopRandomEvent(self)
		self:removeEventHandler()
	end,
	removePlatform = function(self)
		self:removeEventHandler()
	end,
	occur = function(self, platObj)
		local range = self.affectorRange
		
		self.affector = self.affectorRange
		
		platObj:setGameSaleAffector(self.id, self.affector)
		
		local popup = gui.create("DescboxPopup")
		
		popup:setWidth(500)
		popup:setFont("pix24")
		popup:setTitle(_T("PLATFORM_FIRMWARE_CRACK_TITLE", "Firmware Crack"))
		popup:setTextFont("pix20")
		popup:setText(_format(_T("PLATFORM_FIRMWARE_CRACK_DESC", "The firmware of your 'PLATFORM' console has been cracked by pirates. This allows those with cracked firmware to install and play pirated copies of games on their consoles."), "PLATFORM", platObj:getName()))
		popup:setShowSound("bad_jingle")
		popup:hideCloseButton()
		
		local left, right, extra = popup:getDescboxes()
		
		extra:addSpaceToNextText(10)
		extra:addTextLine(popup.w - _S(20), game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		extra:addText(_format(_T("PLATFORM_GAME_SALE_DECREASE", "Console game sales decreased by DECREASE%"), "DECREASE", math.round(self.affector * 100, 1)), "bh20", game.UI_COLORS.RED, 0, popup.rawW - 20, "exclamation_point_red", 22, 22)
		extra:addTextLine(popup.w - _S(20), game.UI_COLORS.IMPORTANT_1, nil, "weak_gradient_horizontal")
		extra:addText(_T("PLATFORM_FIRMWARE_CRACK_RESTORE", "Game sales on this console will go back up only if a firmware update is released."), "bh20", nil, 0, popup.rawW - 20, "question_mark_yellow", 22, 22)
		popup:addOKButton("pix20")
		popup:center()
		frameController:push(popup)
		self:initEventHandler()
		conversations:addTopicToTalkAbout(playerPlatform.CONVERSATION_FIRMWARE_CRACK, platObj:getID())
		events:fire(playerPlatform.EVENTS.FIRMWARE_CRACK, platObj)
	end
}

function firmwareCrack:initEventHandler()
	events:addFunctionReceiver(self, self.handleFirmwareUpdate, playerPlatform.EVENTS.FIRMWARE_UPDATED)
end

function firmwareCrack:removeEventHandler()
	events:removeFunctionReceiver(self, playerPlatform.EVENTS.FIRMWARE_UPDATED)
end

function firmwareCrack:handleFirmwareUpdate(platObj)
	if platObj == self.platform then
		self:removeFromPlatform(self.platform)
	end
end

function firmwareCrack:fillInteractionComboBox(combobox, platObj)
	if not platObj:getFirmwareUpdateState() then
		platObj:addFirmwareUpdateOption(combobox)
	end
end

function firmwareCrack:save()
	local saved = firmwareCrack.baseClass.save(self)
	
	saved.affector = self.affector
	
	return saved
end

function firmwareCrack:load(data, platObj)
	firmwareCrack.baseClass.load(self, data)
	
	self.affector = data.affector
	
	platObj:setGameSaleAffector(self.id, self.affector)
	self:initEventHandler()
end

playerPlatform:registerRandomEvent(firmwareCrack)

playerPlatform.EVENTS.MEMORY_SHORTAGE = "platform_memory_shortage"

local memShort = {
	addToList = true,
	id = "memory_shortage",
	occurChance = 1,
	cooldown = timeline.DAYS_IN_MONTH * 9,
	affectorRange = {
		0.2,
		0.4
	},
	durationRange = {
		timeline.WEEKS_IN_MONTH * 2,
		timeline.WEEKS_IN_MONTH * 8
	},
	devStage = playerPlatform.FINISHED_STAGE,
	canStart = function(self, platObj)
		if not platObj:isReleased() then
			return false
		end
		
		return math.random() * 100 <= self.occurChance
	end,
	setupAffectorCategory = function(self, catObj, elemW)
		local boost = gui.create("GradientIconPanel", nil)
		
		boost:setIcon("platform_memory_debuff")
		boost:setBaseSize(elemW, 0)
		boost:setIconSize(20, nil, 22)
		boost:setFont("bh20")
		boost:setTextColor(game.UI_COLORS.RED)
		boost:setGradientColor(game.UI_COLORS.RED)
		boost:setText(_format(_T("PLATFORM_MEMORY_SHORTAGE_SALE_DECREASE_SHORT", "+INC% memory cost"), "INC", math.round(self.affector * 100, 1)))
		catObj:addItem(boost)
	end,
	onNewWeek = function(self, platObj)
		self.duration = self.duration - 1
		
		if self.duration <= 0 then
			platObj:setPartCostAffector(self.id, platformParts.TYPES.MEMORY, nil)
			platObj:setEventCooldown(self.id, timeline.curTime + self.cooldown)
			platObj:stopRandomEvent(self)
		end
	end,
	occur = function(self, platObj)
		local range = self.affectorRange
		local durRange = self.durationRange
		
		self.affector = math.round(math.randomf(range[1], range[2]), 1)
		self.duration = math.random(durRange[1], durRange[2])
		
		platObj:setPartCostAffector(self.id, platformParts.TYPES.MEMORY, self.affector)
		
		local popup = gui.create("DescboxPopup")
		
		popup:setWidth(500)
		popup:setFont("pix24")
		popup:setTitle(_T("PLATFORM_MEMORY_SHORTAGE", "Memory Shortage"))
		popup:setTextFont("pix20")
		popup:setText(_format(_T("PLATFORM_MEMORY_SHORTAGE_DESC", "A shortage of memory modules is causing a rise in the cost of every memory module we put into 'PLATFORM'."), "PLATFORM", platObj:getName()))
		popup:setShowSound("bad_jingle")
		popup:hideCloseButton()
		
		local left, right, extra = popup:getDescboxes()
		
		extra:addSpaceToNextText(10)
		extra:addTextLine(popup.w - _S(20), game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		extra:addText(_format(_T("PLATFORM_MEMORY_MODULE_COST_INCREASE", "Memory module cost temporarily increased by INC%"), "INC", math.round(self.affector * 100, 1)), "bh20", game.UI_COLORS.RED, 0, popup.rawW - 20, "exclamation_point_red", 22, 22)
		popup:addOKButton("pix20")
		popup:center()
		frameController:push(popup)
		conversations:addTopicToTalkAbout(playerPlatform.CONVERSATION_MEMORY_SHORTAGE, platObj:getID())
		events:fire(playerPlatform.EVENTS.MEMORY_SHORTAGE, platObj)
	end
}

function memShort:save()
	local saved = memShort.baseClass.save(self)
	
	saved.affector = self.affector
	saved.duration = self.duration
	
	return saved
end

function memShort:load(data, platObj)
	memShort.baseClass.load(self, data)
	
	self.affector = data.affector
	self.duration = data.duration
	
	platObj:setPartCostAffector(self.id, platformParts.TYPES.MEMORY, self.affector)
end

playerPlatform:registerRandomEvent(memShort)

playerPlatform.EVENTS.DEV_BUYOUT = "platform_dev_buyout"

local rivalDevBuyout = {
	addToList = true,
	chanceChangePerOccur = -0.1,
	percentageOfOccuranceToPay = 0.6,
	licenseChanceMult = -0.34,
	fundIncPerOccur = 5000000,
	occurChance = 2,
	maxDevsMult = -0.5,
	fundChangeForOccur = 10000000,
	id = "rival_dev_buyout",
	maxGamesMult = -0.5,
	cooldown = timeline.DAYS_IN_MONTH * 6,
	devStage = playerPlatform.FINISHED_STAGE,
	getRequiredFunds = function(self, times)
		return self.fundChangeForOccur + times * self.fundIncPerOccur
	end,
	canStart = function(self, platObj)
		local times = platObj:getEventTimes(self.id)
		
		return platObj:isReleased() and platObj:getFundChange() >= self:getRequiredFunds(times) and math.random() * 100 <= self.occurChance - self.chanceChangePerOccur * times
	end,
	hoverText = {
		{
			font = "bh18",
			wrapWidth = 400,
			iconWidth = 22,
			iconHeight = 22,
			icon = "question_mark",
			text = _T("PLATFORM_DEV_BUYOUT_PENALTY_HINT", "Developers are less likely to work with you until you dedicate some funds to forging potential partnerships.")
		}
	},
	setupAffectorCategory = function(self, catObj, elemW)
		local boost = gui.create("GradientIconPanel", nil)
		
		boost:setIcon("platform_dev_debuff")
		boost:setBaseSize(elemW, 0)
		boost:setIconSize(20, nil, 22)
		boost:setFont("bh20")
		boost:setTextColor(game.UI_COLORS.RED)
		boost:setGradientColor(game.UI_COLORS.RED)
		boost:setText(_T("PLATFORM_DECREASED_DEVELOPER_INTEREST", "Decreased developer interest"))
		boost:setHoverText(self.hoverText)
		catObj:addItem(boost)
	end,
	onNewWeek = function(self, platObj)
	end,
	onPay = function(self, platObj)
		local id = self.id
		
		platObj:stopRandomEvent(self)
		platObj:setEventCooldown(id, timeline.curTime + self.cooldown)
		platObj:setMaxGamesAffector(id, nil)
		platObj:setLicenseChanceAffector(id, nil)
		platObj:setMaxDevsAffector(id, nil)
	end,
	occur = function(self, platObj)
		local id = self.id
		local times = platObj:getEventTimes(id) - 1
		
		self.fundsToPay = self:getRequiredFunds(times) * self.percentageOfOccuranceToPay
		
		platObj:setMaxGamesAffector(id, self.maxGamesMult)
		platObj:setLicenseChanceAffector(id, self.licenseChanceMult)
		platObj:setMaxDevsAffector(id, self.maxDevsMult)
		
		local popup = gui.create("DescboxPopup")
		
		popup:setWidth(500)
		popup:setFont("pix24")
		popup:setTitle(_T("PLATFORM_FEW_DEVELOPERS_TITLE", "Few Developers"))
		popup:setTextFont("pix20")
		popup:setText(_format(_T("PLATFORM_FEW_DEVELOPERS_DESC", "Game developers are seemingly unwilling to work with us to make games for our 'PLATFORM' console, stating that they get better deals with competing console manufacturers."), "PLATFORM", platObj:getName()))
		popup:setShowSound("bad_jingle")
		popup:hideCloseButton()
		
		local left, right, extra = popup:getDescboxes()
		
		extra:addSpaceToNextText(10)
		extra:addTextLine(popup.w - _S(20), game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		extra:addText(_T("PLATFORM_DEV_BUYOUT_PENALTY", "Developers will be less likely to work with you until you dedicate some funds to forging potential partnerships."), "bh20", game.UI_COLORS.RED, 0, popup.rawW - 20, "exclamation_point_red", 22, 22)
		popup:addOKButton("pix20")
		popup:center()
		frameController:push(popup)
		conversations:addTopicToTalkAbout(playerPlatform.CONVERSATION_RIVAL_DEV_BUYOUT, platObj:getID())
		events:fire(playerPlatform.EVENTS.DEV_BUYOUT, platObj)
	end
}

function rivalDevBuyout:save()
	local saved = rivalDevBuyout.baseClass.save(self)
	
	saved.fundsToPay = self.fundsToPay
	
	return saved
end

function rivalDevBuyout:load(data, platObj)
	rivalDevBuyout.baseClass.load(self, data, platObj)
	
	self.fundsToPay = data.fundsToPay
	
	local id = self.id
	
	platObj:setMaxGamesAffector(id, self.maxGamesMult)
	platObj:setLicenseChanceAffector(id, self.licenseChanceMult)
	platObj:setMaxDevsAffector(id, self.maxDevsMult)
end

function rivalDevBuyout:resolveDevProblemsCallback()
	studio:deductFunds(self.fundsToPay)
	self.event:onPay(self.platform)
end

function rivalDevBuyout:dedicateFundsCallback()
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(500)
	popup:setFont("pix24")
	popup:setTextFont("pix20")
	popup:setTitle(_T("PLATFORM_RESOLVE_DEV_PROBLEM_TITLE", "Resolve Developer Problem?"))
	popup:setText(_T("PLATFORM_RESOLVE_DEV_PROBLEM_DESC_1", "Not many developers are willing to work with you on games because your competitors are offering better deals and contracts that are highly financially beneficial to potential developers."))
	
	local funds = studio:getFunds()
	local wrapW = popup.rawW - 20
	local lineW = _S(wrapW)
	local left, right, extra = popup:getDescboxes()
	
	extra:addSpaceToNextText(10)
	extra:addTextLine(lineW, game.UI_COLORS.IMPORTANT_1, nil, "weak_gradient_horizontal")
	extra:addText(_T("PLATFORM_RESOLVE_DEV_PROBLEM_DESC_2", "You will need to spend some money to provide better deals to potential developers."), "bh20", nil, 0, wrapW, "exclamation_point_yellow", 22, 22)
	extra:addSpaceToNextText(4)
	extra:addTextLine(lineW, game.UI_COLORS.GREEN, nil, "weak_gradient_horizontal")
	extra:addText(_format(_T("PLATFORM_RESOLVE_DEV_PROBLEM_REQUIRED_FUNDS", "Required funds: FUNDS"), "FUNDS", string.roundtobigcashnumber(self.fundsToPay)), "bh20", nil, 0, wrapW, "wad_of_cash_plus", 22, 22)
	
	if funds > self.fundsToPay then
		extra:addTextLine(lineW, game.UI_COLORS.GREEN, nil, "weak_gradient_horizontal")
	else
		extra:addTextLine(lineW, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
	end
	
	extra:addText(_format(_T("BANK_FUNDS", "Bank: FUNDS"), "FUNDS", string.roundtobigcashnumber(studio:getFunds())), "bh20", nil, 0, wrapW, "wad_of_cash_minus", 22, 22)
	
	if funds < self.fundsToPay then
		extra:addSpaceToNextText(10)
		extra:addTextLine(lineW, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		extra:addText(_T("NOT_ENOUGH_FUNDS", "You do not have enough funds."), "bh20", game.UI_COLORS.RED, 0, wrapW, "exclamation_point_red", 22, 22)
		popup:addOKButton("pix20")
	else
		local button = popup:addButton("pix20", _T("RESOLVE_DEVELOPER_PROBLEMS", "Resolve developer problems"), rivalDevBuyout.resolveDevProblemsCallback)
		
		button.fundsToPay = self.fundsToPay
		button.platform = self.platform
		button.event = self.event
		
		popup:addButton("pix20", _T("CANCEL", "Cancel"))
	end
	
	popup:center()
	frameController:push(popup)
end

function rivalDevBuyout:fillInteractionComboBox(combobox, platObj)
	local option = combobox:addOption(0, 0, 0, 24, _T("RESOLVE_DEVELOPER_PROBLEM_CONTINUE", "Resolve developer problem..."), fonts.get("pix20"), rivalDevBuyout.dedicateFundsCallback)
	
	option.platform = platObj
	option.event = self
	option.fundsToPay = self.fundsToPay
end

playerPlatform:registerRandomEvent(rivalDevBuyout)

playerPlatform.EVENTS.ARCHITECTURE_PROBLEMS = "platform_architecture_problems"

local archProblems = {
	addToList = false,
	occurCompletion = 0.4,
	id = "architecture_problems",
	affectorDropPerWeek = 0.03,
	occurChance = 0.4,
	cooldown = timeline.DAYS_IN_MONTH * 12,
	progressLoss = {
		0.2,
		0.4
	},
	devStage = playerPlatform.DEV_STAGE,
	canStart = function(self, platObj)
		local tObj = platObj:getDevTask()
		local completion = tObj:getCompletion()
		
		return completion < 1 and completion >= self.occurCompletion and math.random() * 100 <= self.occurChance
	end,
	occur = function(self, platObj)
		local tObj = platObj:getDevTask()
		local work = tObj:getFinishedWork()
		local required = tObj:getRequiredWork()
		local firstStage = tObj:getFirstStageWorkAmount()
		local progressLoss = self.progressLoss
		local lostProgress = math.min(work - firstStage, math.ceil(required * math.randomf(progressLoss[1], progressLoss[2])))
		
		tObj:setFinishedWork(work - lostProgress)
		tObj:setCompletionValue(tObj:getCompletionValue() - lostProgress)
		
		local popup = gui.create("DescboxPopup")
		
		popup:setWidth(500)
		popup:setFont("pix24")
		popup:setTitle(_T("PLATFORM_ARCHITECTURE_PROBLEMS_TITLE", "Architecture Problems"))
		popup:setTextFont("pix20")
		popup:setText(_format(_T("PLATFORM_ARCHITECTURE_PROBLEMS_DESCRIPTION", "The development team in charge of developing our 'PLATFORM' console has run into some problems with the architecture they've designed."), "PLATFORM", platObj:getName()))
		popup:setShowSound("bad_jingle")
		popup:hideCloseButton()
		
		local left, right, extra = popup:getDescboxes()
		
		extra:addSpaceToNextText(10)
		extra:addTextLine(popup.w - _S(20), game.UI_COLORS.IMPORTANT_1, nil, "weak_gradient_horizontal")
		extra:addText(_format(_T("PLATFORM_PROGRESS_SETBACK", "Progress set back by LOSS%"), "LOSS", math.round(lostProgress / required * 100, 1)), "bh20", nil, 0, popup.rawW - 20, "exclamation_point_yellow", 22, 22)
		popup:addOKButton("pix20")
		popup:center()
		frameController:push(popup)
		conversations:addTopicToTalkAbout(playerPlatform.CONVERSATION_ARCHITECTURE_PROBLEMS, platObj:getID())
		events:fire(playerPlatform.EVENTS.ARCHITECTURE_PROBLEMS, platObj)
	end
}

playerPlatform:registerRandomEvent(archProblems)
