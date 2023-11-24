platformParts = {}
platformParts.registered = {}
platformParts.registeredByID = {}
platformParts.registeredByPartType = {}
platformParts.registeredSpecialists = {}
platformParts.registeredSpecialistsByID = {}
platformParts.registeredCases = {}
platformParts.registeredCasesByID = {}
platformParts.PART_COUNT = 0
platformParts.TYPES = {}
platformParts.TYPES_LIST = {}
platformParts.TYPES_ENUM = {}
platformParts.FEMALE_CHANCE = 20
platformParts.BUSY_CHANCE = 5
platformParts.INITIAL_BUSY_CHANCE = 30
platformParts.BUSY_TIME_RANGE = {
	timeline.DAYS_IN_YEAR * 0.5,
	timeline.DAYS_IN_YEAR * 1.5
}
platformParts.EVENTS = {
	MENU_OPENED = events:new()
}

local basePartFuncs = {}

basePartFuncs.mtindex = {
	__index = basePartFuncs
}

function basePartFuncs:getID()
	return self.id
end

function basePartFuncs:setLevel(level)
	self.level = level
	
	if self.progression then
		self.realScale = self.progression[self.level].scale
	end
end

function basePartFuncs:getLevel()
	return self.level
end

function basePartFuncs:getPartType()
	return self.partType
end

function basePartFuncs:getDevTime()
	return self.devTime
end

function basePartFuncs:getPrice()
	return self.price
end

function basePartFuncs:getAttractiveness()
	return self.attractiveness
end

function basePartFuncs:getGameScaleChange(level)
	if level and self.progression then
		return self.progression[level].scale
	end
	
	return self.realScale
end

function basePartFuncs:getDevDifficultyChange()
	return self.devDifficulty
end

function basePartFuncs:getDevCostMult()
	return self.devCostMult
end

function basePartFuncs:apply(platObj)
end

function basePartFuncs:setupDescboxInfo(descbox, wrapWidth)
	descbox:addText(self.display, "bh20", game.UI_COLORS.LIGHT_BLUE, 5, wrapWidth)
	descbox:addText(_format(_T("PLATFORM_PART_COST", "Production cost: +$COST"), "COST", self.price), "bh18", nil, 4, wrapWidth, "platform_manufacture_cost", 22, 22)
	
	if self.attractiveness ~= 0 then
		descbox:addText(_format(_T("PLATFORM_PART_ATTRACTIVENESS", "Attractiveness: +ATTRACT pts"), "ATTRACT", self.attractiveness), "bh18", nil, 2, wrapWidth, "platform_attractiveness", 22, 22)
	end
	
	local change = self:getGameScaleChange()
	
	if change ~= 0 then
		descbox:addText(_format(_T("PLATFORM_PART_GAME_SCALE", "Max. game scale: +xINCREASE"), "INCREASE", change), "bh18", nil, 0, wrapWidth, "platform_max_game_scale", 22, 22)
	end
	
	if self.devDifficulty ~= 0 then
		descbox:addText(_format(_T("PLATFORM_PART_DEV_DIFFICULTY", "Development difficulty: +INCREASE%"), "INCREASE", math.round(self.devDifficulty * 100)), "bh18", nil, 0, wrapWidth, "platform_dev_difficulty", 22, 22)
	end
end

function platformParts:calculateDevCost(platformObj)
	return (platformObj or self.platformObject):calculateDevCost()
end

function platformParts:calculateFullDevCost(platformObj)
	local plat = platformObj or self.platformObject
	
	return plat:calculateDevCost() * plat:getDevTime()
end

function platformParts:registerPartType(id)
	self.PART_COUNT = self.PART_COUNT + 1
	platformParts.TYPES[id] = self.PART_COUNT
	platformParts.TYPES_LIST[#platformParts.TYPES_LIST + 1] = id
	platformParts.TYPES_ENUM[#platformParts.TYPES_ENUM + 1] = self.PART_COUNT
	self.registeredByPartType[self.PART_COUNT] = {}
end

platformParts:registerPartType("CPU")
platformParts:registerPartType("GPU")
platformParts:registerPartType("MEMORY")
platformParts:registerPartType("STORAGE")
platformParts:registerPartType("CONTROLLER")

function platformParts:registerNew(data, inherit)
	table.insert(platformParts.registered, data)
	
	local id = data.id
	
	platformParts.registeredByID[data.id] = data
	
	if not data.quad then
		data.quad = "role_sound_engineer"
	end
	
	if inherit then
		local base = platformParts.registeredByID[inherit]
		
		setmetatable(data, base.mtindex)
		
		data.baseClass = base
	else
		setmetatable(data, basePartFuncs.mtindex)
		
		data.baseClass = basePartFuncs
	end
	
	if data.progression then
		data.realScale = data.progression[1].scale
		
		for key, progData in ipairs(data.progression) do
			local progID = id .. "_progress_" .. key
			
			scheduledEvents:registerNew({
				id = progID,
				level = key,
				partID = id,
				date = progData
			}, "platform_part_advance")
		end
	else
		data.realScale = data.gameScale
	end
	
	table.insert(platformParts.registeredByPartType[data.partType], data)
	
	data.mtindex = {
		__index = data
	}
end

function platformParts:registerNewCase(data)
	table.insert(platformParts.registeredCases, data)
	
	platformParts.registeredCasesByID[data.id] = data
end

platformParts:registerNewCase({
	id = "case_1",
	quad = "player_platform_1"
})
platformParts:registerNewCase({
	id = "case_2",
	quad = "player_platform_2"
})
platformParts:registerNewCase({
	id = "case_3",
	quad = "player_platform_3"
})
platformParts:registerNewCase({
	id = "case_4",
	quad = "player_platform_4"
})
platformParts:registerNewCase({
	id = "case_5",
	quad = "player_platform_5"
})
platformParts:registerNewCase({
	id = "case_6",
	quad = "player_platform_6"
})
platformParts:registerNewCase({
	id = "case_7",
	quad = "player_platform_7"
})
platformParts:registerNewCase({
	id = "case_8",
	quad = "player_platform_8"
})
platformParts:registerNewCase({
	id = "case_9",
	quad = "player_platform_9"
})
platformParts:registerNewCase({
	id = "case_10",
	quad = "player_platform_10"
})

local baseSpecFuncs = {}

baseSpecFuncs.mtindex = {
	__index = baseSpecFuncs
}

function baseSpecFuncs:getCost()
	return self.cost
end

function baseSpecFuncs:getBoostHoverText()
	return {
		{
			font = "bh18",
			icon = "question_mark",
			iconHeight = 22,
			iconWidth = 22,
			text = _format(_T("PLATFORM_BOOSTED_BY_SPECIALIST", "Boosted by SPECIALIST"), "SPECIALIST", self.display)
		}
	}
end

function platformParts:registerNewSpecialist(data, inherit)
	table.insert(platformParts.registeredSpecialists, data)
	
	platformParts.registeredSpecialistsByID[data.id] = data
	
	if inherit then
		setmetatable(data, platformParts.registeredSpecialistsByID[inherit].mtindex)
	else
		setmetatable(data, baseSpecFuncs.mtindex)
	end
	
	data.mtindex = {
		__index = data
	}
end

function platformParts:init()
	self.specialistIdentities = {}
	
	self:initEventHandler()
end

function platformParts:remove()
	for key, data in ipairs(platformParts.registeredSpecialists) do
		self.specialistIdentities[data.id] = nil
	end
	
	self:removeEventHandler()
end

platformParts.CATCHABLE_EVENTS = {
	timeline.EVENTS.NEW_MONTH
}

function platformParts:initEventHandler()
	events:addDirectReceiver(self, platformParts.CATCHABLE_EVENTS)
end

function platformParts:removeEventHandler()
	events:removeDirectReceiver(self, platformParts.CATCHABLE_EVENTS)
end

function platformParts:onNewGame()
	self:verifySpecialistIdentities()
end

function platformParts:verifySpecialistIdentities()
	for key, spec in ipairs(platformParts.registeredSpecialists) do
		if not self.specialistIdentities[spec.id] then
			self.specialistIdentities[spec.id] = self:generateSpecialistIdentity()
		end
	end
end

function platformParts:handleEvent(event)
	local idents = self.specialistIdentities
	local timeVal = timeline.curTime
	local daysInMonth = timeline.DAYS_IN_MONTH
	local chance = platformParts.BUSY_CHANCE
	
	for key, data in ipairs(platformParts.registeredSpecialists) do
		local id = data.id
		local ident = idents[id]
		
		if ident.busyTime > 0 then
			ident.busyTime = math.max(0, ident.busyTime - daysInMonth)
		elseif chance >= math.random(1, 100) then
			local rng = platformParts.BUSY_TIME_RANGE
			
			ident.busyTime = math.random(rng[1], rng[2])
		end
	end
end

function platformParts:updateSpecialistIdentities()
	local year, month = timeline:getYear(), timeline:getMonth()
	
	for key, data in ipairs(platformParts.registeredSpecialists) do
		local id = data.id
		local spec = self.specialistIdentities[id]
		
		if not spec then
			self.specialistIdentities[id] = self:generateSpecialistIdentity()
		elseif year > spec.year then
			self:updateSpecialistIdentity(data)
		elseif year == spec.year and month >= spec.month then
			self:updateSpecialistIdentity(data)
		end
	end
end

function platformParts:generateSpecialistIdentity()
	local data = {}
	
	self:updateSpecialistIdentity(data)
	
	return data
end

platformParts.SPECIALIST_YEARS = {
	3,
	20
}

function platformParts:updateSpecialistIdentity(data)
	local yearRange = platformParts.SPECIALIST_YEARS
	
	data.year = timeline:getYear() + math.random(yearRange[1], yearRange[2])
	data.month = math.random(1, timeline.MONTHS_IN_YEAR)
	
	if not data.portrait then
		data.portrait = portrait.new()
	end
	
	local fem = math.random(1, 100) <= platformParts.FEMALE_CHANCE
	
	data.female = fem
	data.nameID, data.surnameID, data.background = names:getRandomSequentialName(fem)
	
	data.portrait:createRandomAppearance(data.background, fem)
	
	if math.random(1, 100) <= platformParts.INITIAL_BUSY_CHANCE then
		local rng = platformParts.BUSY_TIME_RANGE
		
		data.busyTime = math.random(rng[1], rng[2])
	else
		data.busyTime = 0
	end
end

function platformParts:isSpecialistAvailable(data)
	return data.busyTime <= 0
end

function platformParts:getPlatformObject()
	return self.platformObject
end

platformParts.elementSize = 36
platformParts.elementGap = 4
platformParts.leadArchitectsText = {
	{
		font = "bh20",
		wrapWidth = 350,
		iconHeight = 22,
		icon = "question_mark",
		iconWidth = 22,
		text = _T("PLATFORM_LEAD_ARCHITECT_DESC_1", "Select a lead hardware architect with expertise in a specific field.")
	},
	{
		font = "pix18",
		wrapWidth = 350,
		text = _T("PLATFORM_LEAD_ARCHITECT_DESC_2", "This is optional, but having a specialized lead architect will provide a boost to a specific aspect of your platform.")
	}
}

function platformParts:beginWork(skipDevTimeCheck, skipCostCheck)
	if not skipDevTimeCheck and self.platformObject:getDevTime() * timeline.DAYS_IN_MONTH < self.platformObject:getMinimumWork() then
		self:createDevTimeConfirmationPopup()
		
		return 
	end
	
	if not skipCostCheck then
		local cost = platformParts:calculateFullDevCost()
		
		if cost > studio:getFunds() then
			self:createCostConfirmationPopup(cost)
			
			return 
		end
	end
	
	self.platformObject:beginWork()
	
	self.platformObject = nil
	
	if self.frame and self.frame:isValid() then
		self.frame:kill()
	end
end

function platformParts:beginPlatformDevCallback()
	platformParts:beginWork(true)
end

function platformParts:beginPlatformDevFullCallback()
	platformParts:beginWork(true, true)
end

function platformParts:createDevTimeConfirmationPopup()
	local selected, minimum = self.platformObject:getDevTime(), self.platformObject:getMinimumWork()
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(500)
	popup:setFont("pix24")
	popup:setTextFont("pix20")
	popup:setTitle(_T("PLATFORM_LOW_DEV_TIME_TITLE", "Low Development Time"))
	popup:setText(_format(_T("PLATFORM_LOW_DEV_TIME_WARNING", "You're about to start developing a console over the span of SELECTED, whereas the minimum required time for proper hardware implementation is MINIMUM.\n\nAre you sure you want to proceed?"), "SELECTED", timeline:getTimePeriodText(selected * timeline.DAYS_IN_MONTH), "MINIMUM", timeline:getTimePeriodText(self.platformObject:getMinimumWorkMonths() * timeline.DAYS_IN_MONTH)))
	
	local left, right, extra = popup:getDescboxes()
	
	extra:addSpaceToNextText(10)
	extra:addTextLine(popup.w - _S(20), game.UI_COLORS.IMPORTANT_1, nil, "weak_gradient_horizontal")
	extra:addText(_T("PLATFORM_LOW_DEV_TIME_HINT", "Insufficient development time can lead to an increase of hardware failure rates, leading to higher repair expenses, and other potential issues."), "bh20", nil, 0, popup.rawW - 20, "exclamation_point_yellow", 22, 22)
	
	local opt = popup:addButton("pix20", _T("BEGIN_PLATFORM_DEVELOPMENT", "Begin platform development"), platformParts.beginPlatformDevCallback)
	
	opt.platform = self
	
	popup:addButton("pix20", _T("CANCEL", "Cancel"))
	popup:center()
	frameController:push(popup)
end

function platformParts:createCostConfirmationPopup(cost)
	local selected, minimum = self.platformObject:getDevTime(), self.platformObject:getMinimumWork()
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(500)
	popup:setFont("pix24")
	popup:setTextFont("pix20")
	popup:setTitle(_T("PLATFORM_LOW_CASH_TITLE", "Low Cash"))
	popup:setText(_T("PLATFORM_LOW_CASH_WARNING", "You're about to start developing a console with a total cost greater than what you have."))
	
	local left, right, extra = popup:getDescboxes()
	local wrapW, lineW = popup.rawW - 20, popup.w - _S(20)
	
	extra:addSpaceToNextText(10)
	extra:addTextLine(lineW, game.UI_COLORS.GREEN, nil, "weak_gradient_horizontal")
	extra:addText(_format(_T("PLATFORM_DEV_COST", "Development cost: COST."), "COST", string.roundtobigcashnumber(cost)), "bh20", nil, 0, wrapW, "wad_of_cash_plus", 22, 22)
	extra:addTextLine(lineW, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
	extra:addText(_format(_T("BANK_FUNDS", "Bank: FUNDS"), "FUNDS", string.roundtobigcashnumber(studio:getFunds())), "bh20", nil, 0, wrapW, "wad_of_cash_minus", 22, 22)
	extra:addSpaceToNextText(10)
	extra:addText(_T("GENERIC_PROCEED_CONFIRM", "Are you sure you want to proceed?"), "bh20", nil, 0, wrapW)
	
	local opt = popup:addButton("pix20", _T("BEGIN_PLATFORM_DEVELOPMENT", "Begin platform development"), platformParts.beginPlatformDevFullCallback)
	
	opt.platform = self
	
	popup:addButton("pix20", _T("CANCEL", "Cancel"))
	popup:center()
	frameController:push(popup)
end

function platformParts:postKillFrame()
	platformParts:clearMenuData()
end

function platformParts:clearMenuData()
	self.platformObject = nil
	self.frame = nil
end

platformParts.MAX_PLATFORM_NAME = 16

function platformParts:openPlatformCreationMenu()
	self:updateSpecialistIdentities()
	
	local plat = playerPlatform.new()
	
	self.platformObject = plat
	
	self.platformObject:setDevTime(playerPlatform.DEFAULT_DEV_TIME)
	self.platformObject:setCaseDisplay(platformParts.registeredCases[1].id)
	
	local frame = gui.create("Frame")
	
	frame:setSize(440, 520)
	frame:setFont("pix24")
	frame:setTitle(_T("PLATFORM_CREATION_TITLE", "Platform Creation"))
	
	frame.postKill = platformParts.postKillFrame
	
	local textbox = gui.create("PlatformNameTextbox", frame)
	
	textbox:setFont("bh22")
	textbox:setSize(250, 26)
	textbox:setPos(_S(5), _S(35))
	textbox:setPlatform(plat)
	textbox:setMaxText(platformParts.MAX_PLATFORM_NAME)
	
	local scrollbar = gui.create("ScrollbarPanel", frame)
	
	scrollbar:setPos(_S(5), _S(65))
	scrollbar:setSize(frame.rawW - 10, 300)
	scrollbar:setAdjustElementPosition(true)
	scrollbar:setSpacing(3)
	scrollbar:setPadding(3, 3)
	scrollbar:addDepth(100)
	
	local leadArch = gui.create("Category")
	
	leadArch:setWidth(370)
	leadArch:setHeight(28)
	leadArch:setFont(fonts.get("bh24"))
	leadArch:setText(_T("PLATFORM_LEAD_ARCHITECTS", "Lead Architects"))
	leadArch:assumeScrollbar(scrollbar)
	leadArch:setHoverText(platformParts.leadArchitectsText)
	scrollbar:addItem(leadArch)
	
	local elemW = scrollbar.rawW - 20
	local identities = self.specialistIdentities
	
	for key, data in ipairs(platformParts.registeredSpecialists) do
		local elem = gui.create("PlatformSpecialistSelection")
		
		elem:setWrapWidth(elemW)
		elem:setData(data.id, identities[data.id])
		elem:setHeight(110)
		leadArch:addItem(elem)
	end
	
	local appearFrame = gui.create("Frame")
	
	appearFrame:setSize(120, 300)
	appearFrame:setFont("bh20")
	appearFrame:setTitle(_T("PLATFORM_APPEARANCE", "Appearance"))
	appearFrame:hideCloseButton()
	appearFrame:tieVisibilityTo(frame)
	
	local appearanceScroll = gui.create("ScrollbarPanel", appearFrame)
	
	appearanceScroll:setPos(_S(5), _S(30))
	appearanceScroll:setSize(110, 265)
	appearanceScroll:setAdjustElementPosition(true)
	appearanceScroll:setSpacing(3)
	appearanceScroll:setPadding(3, 3)
	appearanceScroll:addDepth(500)
	
	for key, data in ipairs(platformParts.registeredCases) do
		local elem = gui.create("PlatformCaseDisplay")
		
		elem:setSize(88, 88)
		elem:setData(data)
		elem:setPlatform(plat)
		appearanceScroll:addItem(elem)
	end
	
	local size, gap = self.elementSize, self.elementGap
	local sSize, sGap = _S(size), _S(gap)
	local x, y = _S(5), frame.h - _S(size) - _S(5)
	
	for key, typeID in ipairs(platformParts.TYPES_ENUM) do
		local element = gui.create("SelectedPlatformPart", frame)
		
		element:setPlatform(plat)
		element:setSize(size, size)
		element:setPos(x, y)
		element:setPartType(typeID)
		
		x = x + sSize + sGap
	end
	
	local costDisplay = gui.create("PlatformCreationCostDisplay", frame)
	
	costDisplay:setSize(190, 36)
	costDisplay:setPos(x, frame.h - _S(5) - costDisplay.h)
	costDisplay:setFont("bh20")
	costDisplay:updateDevCost()
	
	local beginWork = gui.create("BeginPlatformDevButton", frame)
	
	beginWork:setSize(36, 36)
	beginWork:setPos(costDisplay.x + _S(3) + costDisplay.w, costDisplay.y)
	beginWork:updateState()
	
	local workSlider = gui.create("PlatformDevTimeSlider", frame)
	
	workSlider:setFont("bh20")
	workSlider:setText(_T("PLATFORM_DEVELOPMENT_TIME_MONTHS", "Development time: SLIDER_VALUE months"))
	workSlider:setMin(playerPlatform.MINIMUM_DEV_TIME)
	workSlider:setMax(playerPlatform.MAXIMUM_DEV_TIME)
	workSlider:setSize(frame.rawW - 10, 38)
	workSlider:setPos(_S(5), y - _S(5) - workSlider.h)
	workSlider:setRounding(0)
	
	local element = self.platformObject:createCostAdjustmentPanel(frame, frame.rawW - 10)
	
	element:setPos(_S(5), workSlider.y - element.h - _S(3))
	frame:center()
	appearFrame:setPos(frame.x - appearFrame.w - _S(10), frame.y)
	
	local setupInfo = gui.create("PlatformSetupInfo")
	
	setupInfo:tieVisibilityTo(frame)
	setupInfo:setPlatform(self.platformObject)
	setupInfo:setPos(frame.x + frame.w + _S(5), frame.y)
	setupInfo:overwriteDepth(5000)
	setupInfo:updateDisplay()
	frameController:push(frame)
	
	self.frame = frame
	
	events:fire(platformParts.EVENTS.MENU_OPENED)
end

function platformParts:setOptionTab(tab)
	self.optionTab = tab
end

function platformParts:getOptionTab()
	return self.optionTab
end

function platformParts:closeOptionTab()
	if self.optionTab and self.optionTab:isValid() then
		self.optionTab:kill()
		
		self.optionTab = nil
	end
end

function platformParts:createTestPlatform()
	local plat = playerPlatform.new()
	
	plat:setPartID(platformParts.TYPES.CPU, "cpu_3")
	plat:setPartID(platformParts.TYPES.GPU, "gpu_3")
	plat:setPartID(platformParts.TYPES.MEMORY, "memory_3")
	plat:setPartID(platformParts.TYPES.STORAGE, "storage_3")
	plat:release()
end

function platformParts:save()
	local saved = {}
	
	saved.identities = {}
	
	local idents = self.specialistIdentities
	
	for key, data in ipairs(platformParts.registeredSpecialists) do
		local id = data.id
		local spec = self.specialistIdentities[id]
		
		if spec then
			saved.identities[id] = {
				year = spec.year,
				month = spec.month,
				portrait = spec.portrait:save(),
				nameID = spec.nameID,
				surnameID = spec.surnameID,
				background = spec.background,
				busyTime = spec.busyTime,
				female = spec.female
			}
		end
	end
	
	return saved
end

function platformParts:load(data)
	local idents = self.specialistIdentities
	local savedIdents = data.identities
	
	for key, data in ipairs(platformParts.registeredSpecialists) do
		local id = data.id
		local spec = savedIdents[id]
		
		if spec then
			local portObj = portrait.new()
			
			portObj:load(spec.portrait)
			
			idents[id] = {
				year = spec.year,
				month = spec.month,
				portrait = portObj,
				nameID = spec.nameID,
				surnameID = spec.surnameID,
				background = spec.background,
				busyTime = spec.busyTime,
				female = spec.female
			}
		end
	end
	
	self:verifySpecialistIdentities()
end

require("game/platform/parts/cpus")
require("game/platform/parts/gpus")
require("game/platform/parts/memory")
require("game/platform/parts/storage")
require("game/platform/parts/controllers")
require("game/platform/specialists")
