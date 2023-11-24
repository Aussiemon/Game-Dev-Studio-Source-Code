rivalGameCompanies = {}
rivalGameCompanies.registered = {}
rivalGameCompanies.registeredByID = {}
rivalGameCompanies.registeredSlander = {}
rivalGameCompanies.registeredSlanderByID = {}
rivalGameCompanies.DEFAULT_EMPLOYEE_STEAL_ATTEMPT_DELAY = timeline.DAYS_IN_MONTH * 3
rivalGameCompanies.EMPLOYEE_STEAL_ATTEMPT_COOLDOWN = timeline.DAYS_IN_MONTH * 6
rivalGameCompanies.MATCH_ACCEPT_CHANCE_PER_MONTH_WORKED = 2
rivalGameCompanies.MATCH_ACCEPT_CHANCE_PER_DOLLAR = 0.05
rivalGameCompanies.MATCH_ACCEPT_CHANCE_PER_DENIED_VACATION = -10
rivalGameCompanies.MATCH_ACCEPT_CHANCE_PER_DENIED_SALARY = -5
rivalGameCompanies.MAXIMUM_MATCH_ACCEPT_CHANCE = 90
rivalGameCompanies.MINIMUM_MATCH_ACCEPT_CHANCE = 30
rivalGameCompanies.STEAL_ACCEPT_CHANCE_BAD_FINANCES_MULTIPLIER = 2
rivalGameCompanies.MATCH_ACCEPT_CHANCE_PER_CHARISMA_POINT = 2
rivalGameCompanies.MATCH_ACCEPT_CHANCE_FROM_SILVER_TONGUE = 10
rivalGameCompanies.LEAVE_CONSIDER_CHANCE_PER_DOLLAR_OFFERED = 0.125
rivalGameCompanies.LEAVE_CONSIDER_CHANCE_PER_DENIED_VACATION = 5
rivalGameCompanies.LEAVE_CONSIDER_CHANCE_PER_YEAR_IN_STUDIO = -3
rivalGameCompanies.LEAVE_CONSIDER_CHANCE_PER_YEAR_IN_STUDIO_MAX = rivalGameCompanies.LEAVE_CONSIDER_CHANCE_PER_YEAR_IN_STUDIO * 5
rivalGameCompanies.LEAVE_CONSIDER_CHANCE_PER_DENIED_SALARY = 10
rivalGameCompanies.LEAVE_CONSIDER_CHANCE_MINIMUM_CHANCE = 0
rivalGameCompanies.LEAVE_CONSIDER_CHANCE_MAXIMUM_CHANCE = 75
rivalGameCompanies.DEFAULT_SWITCH_TIME = timeline.DAYS_IN_WEEK * 2
rivalGameCompanies.REPUTATION_LOSS_ON_BRIBE_REVEAL = 0.15
rivalGameCompanies.DEFAULT_NON_BANKRUPT_BUYOUT_COST_MULTIPLIER = 10
rivalGameCompanies.MIN_RELATIONSHIP = -100
rivalGameCompanies.MAX_RELATIONSHIP = 100
rivalGameCompanies.DEFAULT_STEAL_EMPLOYEE_RELATIONSHIP_CHANGE = -10
rivalGameCompanies.DEFAULT_STEAL_EMPLOYEE_FAIL_RELATIONSHIP_CHANGE = -3
rivalGameCompanies.DEFAULT_RELATIONSHIP_RESTORE_AMOUNT = 1
rivalGameCompanies.PRE_BANKRUPT_BUYOUT_PRICE_MULTIPLIER = 10
rivalGameCompanies.SUSPICION_MAX = 150
rivalGameCompanies.SUSPICION_TO_DISCOVERY_CHANCE = 1
rivalGameCompanies.SUSPICION_DROP_PER_DAY = 0.8
rivalGameCompanies.FULL_RIVAL_DIALOGUES = "full_rival_dialogues"
rivalGameCompanies.INSTANT_COURT_BUTTONS = "instant_court_buttons"
rivalGameCompanies.DEFAULT_CALL_DIALOGUE = "call_ceo_main"
rivalGameCompanies.DEFAULT_INITIAL_CALL_DIALOGUE = "call_ceo_initial"
rivalGameCompanies.PROCEDURAL_GENERATION_COOLDOWN = {
	12,
	15
}
rivalGameCompanies.FLUFF_TEXT = {
	_T("RIVAL_COMPANY_GENERATION_FLUFF_1", "'We're excited to enter this market and bring our collective vision to the table of game development.', the CEO stated."),
	_T("RIVAL_COMPANY_GENERATION_FLUFF_2", "'As gamers ourselves, we're really excited to show our work to fellow video game enthusiasts.', the CEO stated."),
	_T("RIVAL_COMPANY_GENERATION_FLUFF_3", "'We can't wait to bring new, interesting, innovative tech, and gameplay mechanics to the world of video games.', the CEO stated."),
	_T("RIVAL_COMPANY_GENERATION_FLUFF_4", "'At the heart of our studio are hardcore gamers, and we can't wait to show you our vision.', the CEO stated.")
}
rivalGameCompanies.EVENTS = {
	LOCKED = events:new(),
	UNLOCKED = events:new(),
	OPENED_MENU = events:new(),
	COMPANY_DEFUNCT = events:new()
}

function rivalGameCompanies.registerNew(data, baseClass)
	table.insert(rivalGameCompanies.registered, data)
	
	rivalGameCompanies.registeredByID[data.id] = data
	data.mtindex = {
		__index = data
	}
	data.stealEmployeeRelationshipChange = data.stealEmployeeRelationshipChange or rivalGameCompanies.DEFAULT_STEAL_EMPLOYEE_RELATIONSHIP_CHANGE
	data.failStealEmployeeRelationshipChange = data.failStealEmployeeRelationshipChange or rivalGameCompanies.DEFAULT_STEAL_EMPLOYEE_FAIL_RELATIONSHIP_CHANGE
	data.employeeStealing.cooldown = data.employeeStealing.cooldown or rivalGameCompanies.DEFAULT_EMPLOYEE_STEAL_ATTEMPT_DELAY
	data.threatToPlayerOnReputation = data.threatToPlayerOnReputation or math.huge
	data.relationshipRestoreAmount = data.relationshipRestoreAmount or rivalGameCompanies.DEFAULT_RELATIONSHIP_RESTORE_AMOUNT
	data.switchToPlayerTime = data.switchToPlayerTime or rivalGameCompanies.DEFAULT_SWITCH_TIME
	data.callDialogue = data.callDialogue or rivalGameCompanies.DEFAULT_CALL_DIALOGUE
	data.initialCallDialogue = data.initialCallDialogue or rivalGameCompanies.DEFAULT_INITIAL_CALL_DIALOGUE
	data.preBankruptBuyoutCostMultiplier = data.preBankruptBuyoutCostMultiplier or rivalGameCompanies.PRE_BANKRUPT_BUYOUT_PRICE_MULTIPLIER
	
	if baseClass then
		setmetatable(data, rivalGameCompanies.registeredByID[baseClass].mtindex)
	end
end

function rivalGameCompanies:setCanGenerateRivals(can)
	self.generateRivals = can
end

function rivalGameCompanies:getCanGenerateRivals()
	return self.generateRivals
end

function rivalGameCompanies:init()
	self.companies = table.reuse(self.companies)
	self.companiesByID = table.reuse(self.companiesByID)
	self.defunctCompanies = table.reuse(self.defunctCompanies)
	self.defunctCompaniesByID = table.reuse(self.defunctCompaniesByID)
	self.proceduralRivals = {}
	self.seenNameIndexes = {}
	self.reservedNameIDs = {}
	self.playerCanHangUp = true
	
	self:initEventReceiver()
	
	self.generationCooldown = 0
end

function rivalGameCompanies:reserveNameIDs(first, second)
	local subTable = self.reservedNameIDs[first]
	
	if not subTable then
		subTable = {
			total = 1
		}
		self.reservedNameIDs[first] = subTable
	else
		subTable.total = subTable.total + 1
	end
	
	self.reservedNameIDs[first][second] = true
end

function rivalGameCompanies:unreserveNameIDs(first, second)
	local subTable = self.reservedNameIDs[first]
	
	subTable.total = subTable.total - 1
	
	if subTable.total == 0 then
		self.reservedNameIDs[first] = nil
	else
		subTable[second] = nil
	end
end

function rivalGameCompanies:getReservedNameIDs()
	return self.reservedNameIDs
end

function rivalGameCompanies:applyStartingStats()
	for key, companyObject in ipairs(self.companies) do
		companyObject:applyStartingStats()
	end
end

function rivalGameCompanies:addPlatformOwnership(platformID)
	for key, company in ipairs(self.companies) do
		company:addPlatformLicense(platformID)
	end
end

function rivalGameCompanies:remove()
	for key, companyObj in ipairs(self.companies) do
		companyObj:remove()
		
		self.companies[key] = nil
	end
	
	self.locked = nil
	
	table.clear(self.companiesByID)
	table.clear(self.defunctCompanies)
	table.clear(self.defunctCompaniesByID)
	table.clearArray(self.proceduralRivals)
	self:removeEventReceiver()
end

function rivalGameCompanies:setLatestEmployeeStealAttempt(time)
	self.lastEmployeeStealAttempt = time
end

function rivalGameCompanies:getLatestEmployeeStealAttempt()
	return self.lastEmployeeStealAttempt
end

function rivalGameCompanies:getEmployeeByUniqueID(id)
	for key, companyObject in ipairs(self.companies) do
		local employee = companyObject:getEmployeeByUniqueID(id)
		
		if employee then
			return employee
		end
	end
	
	return nil
end

function rivalGameCompanies:getCompanyByID(companyID)
	return self.companiesByID[companyID] or self.defunctCompaniesByID[companyID]
end

rivalGameCompanies.EXTRA_RIVAL_INFO_PANEL_ID = "extra_rival_info_panel"

function rivalGameCompanies:createMenu()
	if self.locked then
		local popup = game.createPopup(600, _T("MENU_UNAVAILABLE_TITLE", "Menu Unavailable"), _T("RIVAL_GAME_COMPANIES_UNAVAILABLE", "The rival game companies menu is currently unavailable. Please check back later."), "pix24", "pix20", nil)
		
		frameController:push(popup)
		
		return false
	end
	
	if self.frame and self.frame:isValid() then
		frameController:pop()
	end
	
	local frame = gui.create("RivalFrame")
	
	frame:setSize(350, 500)
	frame:setFont(fonts.get("pix24"))
	frame:setTitle(_T("RIVAL_GAME_COMPANIES_TITLE", "Rival Game Companies"))
	frame:center()
	
	local scrollBarPanel = gui.create("RivalScrollbarPanel", frame)
	
	scrollBarPanel:setPos(_S(5), _S(35))
	scrollBarPanel:setSize(340, frame.rawH - 40)
	scrollBarPanel:setAdjustElementPosition(true)
	scrollBarPanel:setPadding(3, 3)
	scrollBarPanel:setSpacing(3)
	scrollBarPanel:addDepth(50)
	
	for key, companyObj in ipairs(self.companies) do
		local companyDisplay = gui.create("RivalInfoDisplay")
		
		companyDisplay:setSize(310, 20)
		companyDisplay:setCompany(companyObj)
		companyDisplay:setBasePanel(self.frame)
		companyDisplay:setID(companyObj:getID())
		scrollBarPanel:addItem(companyDisplay)
	end
	
	local extraInfoPanel = gui.create("RivalCompanyInfo")
	
	extraInfoPanel:setPos(frame.x + _S(10) + frame.w, frame.y)
	extraInfoPanel:setID(rivalGameCompanies.EXTRA_RIVAL_INFO_PANEL_ID)
	extraInfoPanel:setWidth(250)
	extraInfoPanel:hideDisplay()
	extraInfoPanel:overwriteDepth(5000)
	frameController:push(frame)
	events:fire(rivalGameCompanies.EVENTS.OPENED_MENU)
	
	return true
end

function rivalGameCompanies:initCompanies(companyIDs)
	for key, companyID in ipairs(companyIDs) do
		self:initCompany(companyID)
	end
end

function rivalGameCompanies:initCompany(companyID, procedural, skipNames)
	local companyData = rivalGameCompanies.registeredByID[companyID]
	local object = rivalGameCompany.new(companyData.id, procedural)
	
	self.companies[#self.companies + 1] = object
	self.companiesByID[companyData.id] = object
	
	if not skipNames then
		object:reserveGameNames()
	end
	
	return object
end

function rivalGameCompanies:onCompanyDefunct(companyObject)
	local id = companyObject:getID()
	
	self:makeCompanyDefunct(id)
	
	local cooldown = rivalGameCompanies.PROCEDURAL_GENERATION_COOLDOWN
	
	self.generationCooldown = math.max(self.generationCooldown, math.random(cooldown[1], cooldown[2]))
	self.proceduralAllowed = true
	
	self:addToProceduralList(id)
	events:fire(rivalGameCompanies.EVENTS.COMPANY_DEFUNCT, companyObject)
end

function rivalGameCompanies:addToProceduralList(id)
	if not table.find(self.proceduralRivals, id) then
		table.insert(self.proceduralRivals, id)
	end
end

function rivalGameCompanies:attemptCreateProceduralRival()
	local count = #self.proceduralRivals
	
	if count > 0 then
		local id = self.proceduralRivals[math.random(1, count)]
		
		if not self.companiesByID[id] then
			local object = self:initCompany(id, true)
			local nameIndex = object:getNameIndex()
			local names = self.seenNameIndexes[nameIndex]
			local popupText
			
			if names then
				self.seenNameIndexes[nameIndex] = names + 1
				popupText = _T("RIVAL_COMPANY_REVIVED", "The game development studio 'COMPANY' has been re-assembled by investors looking to return it to its former glory.\n\nFLUFF_TEXT")
			else
				self.seenNameIndexes[nameIndex] = 1
				popupText = _T("RIVAL_COMPANY_NEW_GENERATED", "A new game development studio 'COMPANY' has entered the market, made of experienced developers.\n\nFLUFF_TEXT")
			end
			
			popupText = _format(popupText, "COMPANY", object:getName(), "FLUFF_TEXT", rivalGameCompanies.FLUFF_TEXT[math.random(1, #rivalGameCompanies.FLUFF_TEXT)])
			
			local popup = game.createPopup(600, _T("NEW_RIVAL_COMPANY", "New Rival Company"), popupText, "bh24", "pix20", nil)
			
			popup:hideCloseButton()
			frameController:push(popup)
		end
		
		local object = self.defunctCompaniesByID[id]
		
		if object then
			table.removeObject(self.defunctCompanies, object)
			
			self.defunctCompaniesByID[id] = nil
		end
		
		studio:clearRivalSlanderKnowledge(id)
		studio:resetSlanderReputationLoss(id)
		
		return true
	end
	
	return false
end

function rivalGameCompanies:makeCompanyDefunct(companyObjectID)
	local companyObject
	
	for key, otherCompany in ipairs(self.companies) do
		if otherCompany:getID() == companyObjectID then
			companyObject = otherCompany
			
			table.remove(self.companies, key)
			
			break
		end
	end
	
	if companyObject then
		self.companiesByID[companyObjectID] = nil
		
		table.insert(self.defunctCompanies, companyObject)
		
		self.defunctCompaniesByID[companyObjectID] = companyObject
		
		companyObject:remove()
	end
	
	return companyObject
end

function rivalGameCompanies:getCompanies()
	return self.companies
end

function rivalGameCompanies:getDefunctCompanies()
	return self.defunctCompanies
end

function rivalGameCompanies:initEventReceiver()
	events:addDirectReceiver(self, rivalGameCompanies.CATCHABLE_EVENTS)
	events:addFunctionReceiver(self, rivalGameCompanies.handleNewMonth, timeline.EVENTS.NEW_MONTH)
end

function rivalGameCompanies:removeEventReceiver()
	events:removeDirectReceiver(self, rivalGameCompanies.CATCHABLE_EVENTS)
	events:removeFunctionReceiver(self, timeline.EVENTS.NEW_MONTH)
end

function rivalGameCompanies:lock()
	self.locked = true
	
	self:removeEventReceiver()
	
	for key, companyObject in ipairs(self.companies) do
		companyObject:lock()
	end
	
	events:fire(rivalGameCompanies.EVENTS.LOCKED)
end

function rivalGameCompanies:unlock()
	self.locked = false
	
	self:initEventReceiver()
	
	for key, companyObject in ipairs(self.companies) do
		companyObject:unlock()
	end
	
	events:fire(rivalGameCompanies.EVENTS.UNLOCKED)
end

function rivalGameCompanies:isLocked()
	return self.locked
end

function rivalGameCompanies:handleEvent(event, ...)
	for key, object in ipairs(self.companies) do
		object:handleEvent(event, ...)
	end
end

function rivalGameCompanies:handleNewMonth()
	for key, object in ipairs(self.companies) do
		object:handleEvent()
	end
	
	if self.generationCooldown > 0 then
		self.generationCooldown = self.generationCooldown - 1
	elseif self.proceduralAllowed and self.generateRivals then
		self:attemptCreateProceduralRival()
	end
end

function rivalGameCompanies:save()
	local saved = {}
	
	saved.companies = {}
	saved.defunctCompanies = {}
	saved.lastEmployeeStealAttempt = self.lastEmployeeStealAttempt
	saved.seenNameIndexes = self.seenNameIndexes
	saved.proceduralAllowed = self.proceduralAllowed
	saved.generationCooldown = self.generationCooldown
	saved.generateRivals = self.generateRivals
	saved.reservedNameIDs = self.reservedNameIDs
	
	for key, companyObject in ipairs(self.companies) do
		saved.companies[#saved.companies + 1] = companyObject:save()
	end
	
	for key, companyObject in ipairs(self.defunctCompanies) do
		saved.defunctCompanies[#saved.defunctCompanies + 1] = companyObject:save()
	end
	
	return saved
end

function rivalGameCompanies:load(data)
	if data.generateRivals == nil then
		self.generateRivals = true
	else
		self.generateRivals = data.generateRivals
	end
	
	self.lastEmployeeStealAttempt = data.lastEmployeeStealAttempt
	self.seenNameIndexes = data.seenNameIndexes or self.seenNameIndexes
	self.proceduralAllowed = data.proceduralAllowed
	self.generationCooldown = data.generationCooldown or self.generationCooldown
	self.reservedNameIDs = data.reservedNameIDs or self.reservedNameIDs
	
	for key, companyData in ipairs(data.companies) do
		local object = self.companiesByID[companyData.id] or self:initCompany(companyData.id, nil, true)
		
		if object then
			object:load(companyData)
		end
	end
	
	for key, companyData in ipairs(data.defunctCompanies) do
		self:loadDefunctCompany(companyData)
	end
	
	local rivals = game.curGametype:getRivals(game.worldObject:getMapID())
	
	if rivals then
		local allowProcedural = false
		
		for key, id in ipairs(rivals) do
			if not self.companiesByID[id] then
				self:addToProceduralList(id)
				
				allowProcedural = true
			end
		end
		
		if allowProcedural then
			self.proceduralAllowed = true
		end
	end
end

function rivalGameCompanies:loadDefunctCompany(companyData)
	local id = companyData.id
	local object = self.companiesByID[id] or self:initCompany(id)
	
	if object then
		object:load(companyData)
		self:makeCompanyDefunct(id)
	end
end

require("game/rival_game_companies/rival_game_company")
require("game/rival_game_companies/rivals")
require("game/rival_game_companies/back_in_the_game")
require("game/rival_game_companies/pay_denbts")
require("game/rival_game_companies/ravioli_and_pepperoni")
require("game/rival_game_companies/console_domination")
require("game/rival_game_companies/slander_types")
require("game/dialogue/rivals/rivals")
