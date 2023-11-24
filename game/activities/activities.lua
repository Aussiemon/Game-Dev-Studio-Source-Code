activities = {}
activities.registered = {}
activities.registeredByID = {}
activities.registeredByInterest = {}
activities.sortedByPrice = {}
activities.enjoymentData = {}
activities.activeAffectors = {}
activities.justDiscoveredAffectors = {}
activities.ENJOYMENT_TO_DRIVE = 2.5
activities.ENJOYMENT_TO_DAYS_WITHOUT_VACACATION = 6.666666666666667
activities.COOLDOWN_LENGTH = timeline.DAYS_IN_MONTH * 2
activities.MIN_COOLDOWN_PENALTY = 0.1
activities.COLOR_DEFAULT = color(255, 255, 255, 255)
activities.COLOR_GENERIC = color(169, 240, 255, 255)
activities.HIGHEST_ENJOYMENT = 0
activities.SIGN_PER_SECTION = 0.33
activities.MAX_SIGNS = 3
activities.AUTO_ORGANIZE_COOLDOWN = timeline.DAYS_IN_MONTH * 12
activities.AUTO_ORGANIZE_COOLDOWN_NEW_GAME = timeline.DAYS_IN_MONTH * 6
activities.AUTO_ORGANIZE_TIME_PERIOD = timeline.DAYS_IN_MONTH * 15
activities.AUTO_ORGANIZE_MINIMUM_PEOPLE = 2
activities.AUTO_ORGANIZE_DIALOGUE_FACT = "activity_to_organize"
activities.AUTO_ORGANIZE_EMPLOYEE_COUNT_FACT = "activity_participants"
activities.AUTO_ORGANIZE_CHANCE = 66
activities.AUTO_ORGANIZE_PREFERENCE = "auto_approve_activities"
activities.LAST_AUTO_ORGANIZE_FACT = "last_auto_activity"
activities.POSITIVE_TEXT_COLOR = {
	color(220, 255, 220, 255),
	color(200, 255, 200, 255),
	color(180, 255, 180, 255)
}
activities.NEGATIVE_TEXT_COLOR = {
	color(255, 220, 220, 255),
	color(255, 200, 200, 255),
	color(255, 180, 180, 255)
}
activities.RESULT_TEXT = {
	{
		rating = 5,
		text = _T("ACTIVITY_RESULT_VERY_LOW", "ACTIVITY is mildly entertaining.")
	},
	{
		rating = 10,
		text = _T("ACTIVITY_RESULT_LOW", "ACTIVITY is enjoyable.")
	},
	{
		rating = 20,
		text = _T("ACTIVITY_RESULT_MEDIUM", "ACTIVITY is fun.")
	},
	{
		rating = 40,
		text = _T("ACTIVITY_RESULT_HIGH", "ACTIVITY is very fun.")
	},
	{
		rating = 70,
		text = _T("ACTIVITY_RESULT_VERY_HIGH", "ACTIVITY is extremely fun.")
	}
}
activities.CATCHABLE_EVENTS = {
	timeline.EVENTS.NEW_MONTH
}
activities.EVENTS = {
	ACTIVITY_FINISHED = events:new()
}
activities.AFFECTORS = {
	TOO_SOON = 2,
	NOT_ENOUGH_PEOPLE = 1,
	GLOBAL_COOLDOWN = 3
}
activities.AFFECTOR_TEXT = {
	[activities.AFFECTORS.NOT_ENOUGH_PEOPLE] = _T("ACTIVITY_AFFECTOR_NOT_ENOUGH_PEOPLE", "There weren't enough people to enjoy it thoroughly."),
	[activities.AFFECTORS.TOO_SOON] = _T("ACTIVITY_AFFECTOR_TOO_SOON", "This activity was scheduled too soon"),
	[activities.AFFECTORS.GLOBAL_COOLDOWN] = _T("ACTIVITY_AFFECTOR_GLOBAL_COOLDOWN", "Employees have had enough fun for now.")
}

local defaultActivityFuncs = {}

defaultActivityFuncs.mtindex = {
	__index = defaultActivityFuncs
}

function defaultActivityFuncs:calculateEnjoyment(employee, participantCount, autoOrganized)
	local enjoymentRating = self.baseEnjoymentRating
	local lastActivity = employee:getActivityTime(self.id)
	
	if self.randomEnjoymentOffset then
		enjoymentRating = enjoymentRating * math.randomf(self.randomEnjoymentOffset[1], self.randomEnjoymentOffset[2])
	end
	
	if self.minimumPeopleAmount then
		local lackingPeople = self.minimumPeopleAmount - participantCount
		
		if lackingPeople > 0 then
			local enjoymentDecrease = 1 - self.notEnoughPeopleEnjoymentReduction * lackingPeople
			
			enjoymentRating = enjoymentRating * enjoymentDecrease
			
			local activeAff = activities.activeAffectors
			
			if not autoOrganized and not table.find(activeAff, activities.AFFECTORS.NOT_ENOUGH_PEOPLE) then
				activeAff[#activeAff + 1] = activities.AFFECTORS.NOT_ENOUGH_PEOPLE
			end
		end
	end
	
	if self.contributingInterests then
		for key, interest in ipairs(employee:getInterests()) do
			local interestScale = self.contributingInterests[interest] or 1
			
			enjoymentRating = enjoymentRating * interestScale
		end
	end
	
	if lastActivity then
		local timeDifference = timeline.curTime - lastActivity
		
		if timeDifference < self.reducedEnjoymentTime then
			local scale = 1 - math.min(timeDifference / self.reducedEnjoymentTime, self.maxReducedEnjoyment)
			
			enjoymentRating = enjoymentRating * scale
			
			local activeAff = activities.activeAffectors
			
			if not autoOrganized and not table.find(activeAff, activities.AFFECTORS.TOO_SOON) then
				activeAff[#activeAff + 1] = activities.AFFECTORS.TOO_SOON
			end
		end
	end
	
	if self.notOnTheHouseEnjoymentScale and not studio:isActivityOnTheHouse() then
		enjoymentRating = enjoymentRating * self.notOnTheHouseEnjoymentScale
	end
	
	return enjoymentRating
end

function defaultActivityFuncs:setupInfoDescbox(descBox, wrapWidth, skipContributors)
	for key, data in ipairs(self.description) do
		descBox:addText(data.text, data.font or "pix18", data.color, data.lineSpace, wrapWidth)
	end
	
	if self.minimumPeopleAmount then
		descBox:addText(_format(_T("ACTIVITY_PEOPLE_REQUIREMENT", "Requires at least PEOPLE to be enjoyable."), "PEOPLE", developer:getPeopleCountText(self.minimumPeopleAmount)), "bh20", activities.COLOR_GENERIC, 0, wrapWidth)
	end
	
	if not skipContributors then
		local neutral = true
		
		if self.contributingInterests then
			local positiveContributors, negativeContributors = activities:getDiscoveredActivityContributors(self.id)
			
			if #positiveContributors > 0 then
				descBox:addSpaceToNextText(10)
				descBox:addText(_T("CONTRIBUTING_INTERESTS", "Contributing interests"), "bh22", game.UI_COLORS.LIGHT_BLUE, 3, wrapWidth, "increase", 24, 24)
				descBox:addSpaceToNextText(4)
				
				for key, contributor in ipairs(positiveContributors) do
					local signs, color = activities:getActivityContributorSign(self, contributor)
					local data = interests:getData(contributor)
					local text = string.easyformatbykeys(_T("INTEREST_CONTRIBUTION_LAYOUT", "SIGNS INTEREST"), "SIGNS", signs, "INTEREST", data.display)
					
					descBox:addText(text, "pix18", color, 0, wrapWidth, data:getIconConfig(24, 20))
				end
				
				neutral = false
			end
			
			if #negativeContributors > 0 then
				if #positiveContributors > 0 then
					descBox:addSpaceToNextText(10)
				end
				
				descBox:addText(_T("CONFLICTING_INTERESTS", "Conflicting interests"), "bh22", game.UI_COLORS.RED, 3, wrapWidth, "decrease_red", 24, 24)
				descBox:addSpaceToNextText(4)
				
				for key, contributor in ipairs(negativeContributors) do
					local signs, color = activities:getActivityContributorSign(self, contributor)
					local data = interests:getData(contributor)
					local text = string.easyformatbykeys(_T("INTEREST_CONTRIBUTION_LAYOUT", "SIGNS INTEREST"), "SIGNS", signs, "INTEREST", data.display)
					
					descBox:addText(text, "pix18", color, 0, wrapWidth, data:getIconConfig(24, 20))
				end
				
				neutral = false
			end
		end
		
		if neutral then
			descBox:addSpaceToNextText(10)
			descBox:addText(_T("NO_KNOWN_OR_CONFLICTING_INTERESTS", "No known contributing or conflicting interests."), "bh20", nil, 0, wrapWidth)
		end
	end
	
	if studio:getActivityTime(self.id) and self.knowledgeIncrease then
		descBox:addSpaceToNextText(10)
		activities:addKnowledgeIncreaseText(self.knowledgeIncrease, descBox, wrapWidth)
	end
end

function defaultActivityFuncs:formatMentionHintText(mentionedEmployee)
	return _format(self.mentionHint, "NAME", mentionedEmployee:getFullName(true))
end

function defaultActivityFuncs:getPrice(employeeCount)
	return self.costPerEmployee * employeeCount
end

defaultActivityFuncs.getCost = defaultActivityFuncs.getPrice

function defaultActivityFuncs:doesEmployeeWantToGo(employee)
	if employee:isPlayerCharacter() then
		return true
	end
	
	local previousDecision = employee:getActivityDesireToGo(self.id)
	
	if previousDecision ~= nil then
		return previousDecision
	end
	
	local grumpynessFactor = employee:getGrumpyness() * self.chanceToGoGrumpynessAffector * 100
	local randomRating = math.random(1, 15)
	local finalChance = grumpynessFactor + randomRating
	
	if self.chanceToTurnDown then
		for key, data in ipairs(self.chanceToTurnDownNumeric) do
			if employee:hasInterest(data.interest) then
				local modifiers = data.data
				
				if modifiers.add then
					finalChance = finalChance + modifiers.add
				end
				
				if modifiers.mul then
					finalChance = finalChance * modifiers.mul
				end
				
				if modifiers.div then
					finalChance = finalChance / modifiers.div
				end
			end
		end
	end
	
	local willGo = finalChance <= math.random(1, 100)
	
	employee:setActivityDesireToGo(self.id, willGo)
	
	return willGo
end

local function sortByPrice(a, b)
	return a.costPerEmployee < b.costPerEmployee
end

function activities:getActivityContributorSign(data, contributor)
	local amount = data.contributingInterests[contributor]
	
	return game.getContributionSign(1, amount, activities.SIGN_PER_SECTION, activities.MAX_SIGNS, nil, nil, false)
end

function activities:registerNew(data)
	setmetatable(data, defaultActivityFuncs.mtindex)
	
	if data.chanceToTurnDown then
		data.chanceToTurnDownNumeric = {}
		
		for interest, chanceData in pairs(data.chanceToTurnDown) do
			table.insert(data.chanceToTurnDownNumeric, {
				interest = interest,
				data = chanceData
			})
		end
	end
	
	if data.contributingInterests then
		data.contributingInterestsNumeric = {}
		
		for interest, amount in pairs(data.contributingInterests) do
			table.insert(data.contributingInterestsNumeric, {
				interest = interest,
				contribution = amount
			})
			
			if not activities.registeredByInterest[interest] then
				activities.registeredByInterest[interest] = {}
			end
			
			table.insert(activities.registeredByInterest[interest], data)
		end
	end
	
	table.insert(activities.registered, data)
	table.insert(activities.sortedByPrice, data)
	table.sort(activities.sortedByPrice, sortByPrice)
	
	activities.registeredByID[data.id] = data
	data.maxReducedEnjoyment = data.maxReducedEnjoyment or 0.8
	data.chanceToGoGrumpynessAffector = 1
	data.notOnTheHouseEnjoymentScale = data.notOnTheHouseEnjoymentScale or 0.8
	activities.HIGHEST_ENJOYMENT = math.max(activities.HIGHEST_ENJOYMENT, data.baseEnjoymentRating)
	
	if data.description then
		for key, textData in ipairs(data.description) do
			textData.font = textData.font or "pix20"
			textData.color = textData.color or activities.COLOR_DEFAULT
			textData.lineSpace = textData.lineSpace or 0
		end
	end
end

function activities:init()
	events:addDirectReceiver(self, activities.CATCHABLE_EVENTS)
end

function activities:remove()
	events:removeDirectReceiver(self, activities.CATCHABLE_EVENTS)
end

local goodActivities = {}
local participantsByActivity = {}

function activities:getGoodActivities()
	table.clearArray(goodActivities)
	table.clear(participantsByActivity)
	
	for key, activityData in ipairs(activities.registered) do
		local participants = studio:getWillingActivityParticipants(activityData.id)
		
		if #participants > 0 then
			local canAdd = true
			
			if activityData.minimumPeopleAmount and activityData.minimumPeopleAmount > #participants then
				canAdd = false
			end
			
			if canAdd then
				goodActivities[#goodActivities + 1] = activityData
				participantsByActivity[activityData.id] = #participants
			end
		end
	end
	
	return goodActivities
end

function activities:onStartNewGame()
	studio:setFact(activities.LAST_AUTO_ORGANIZE_FACT, timeline.curTime + activities.AUTO_ORGANIZE_COOLDOWN_NEW_GAME)
end

function activities:handleEvent(event)
	local autoOrganizeTime = studio:getFact(activities.LAST_AUTO_ORGANIZE_FACT)
	
	if autoOrganizeTime and autoOrganizeTime > timeline.curTime then
		return 
	end
	
	local actTime = studio:getActivityTime()
	local alwaysOrganize = preferences:get(activities.AUTO_ORGANIZE_PREFERENCE)
	
	if (not actTime or timeline.curTime >= actTime + activities.AUTO_ORGANIZE_TIME_PERIOD) and #studio:getEmployees() >= activities.AUTO_ORGANIZE_MINIMUM_PEOPLE and (alwaysOrganize or math.random(1, 100) <= activities.AUTO_ORGANIZE_CHANCE) then
		local activityList = self:getGoodActivities()
		
		if #activityList > 0 then
			local activity = activityList[math.random(1, #activityList)]
			
			if alwaysOrganize and studio:getFunds() >= activity:getPrice(participantsByActivity[activity.id]) then
				studio:scheduleActivity(activity.id, nil, true)
			else
				local employee = studio:getRandomNonPlayerEmployee()
				local dialogueObject = dialogueHandler:addDialogue("activity_organization_1", nil, employee, nil)
				
				dialogueObject:setFact(activities.AUTO_ORGANIZE_DIALOGUE_FACT, activity)
				dialogueObject:setFact(activities.AUTO_ORGANIZE_EMPLOYEE_COUNT_FACT, participantsByActivity[activity.id])
				studio:setFact(activities.LAST_AUTO_ORGANIZE_FACT, timeline.curTime + activities.AUTO_ORGANIZE_COOLDOWN)
			end
			
			table.clear(goodActivities)
			table.clear(participantsByActivity)
		end
	end
end

function activities:getData(activity)
	return activities.registeredByID[activity]
end

function activities:calculateEnjoyment(data, employee, participants, autoOrganized)
	local participantCount = #participants
	
	return data:calculateEnjoyment(employee, participantCount, autoOrganized)
end

eventBoxText:registerNew({
	id = "auto_organized_activity_result",
	getText = function(self, data)
		if not activities.registeredByID[data.activity] then
			return _format(_T("INVALID_ACTIVITY", "Invalid activity 'ACTIVITY'!"), "ACTIVITY", data.activity)
		end
		
		return _format(_T("EMPLOYEES_VISITED_ACTIVITY", "EMPLOYEES employees went to ACTIVITY, average enjoyment rating is RATING points."), "EMPLOYEES", data.participants, "ACTIVITY", activities.registeredByID[data.activity].autoOrganizedAction, "RATING", data.totalEnjoyment)
	end
})

function activities:calculateCooldownPenalty(dev)
	local cooldown = activities.COOLDOWN_LENGTH
	local activityDelta = dev:getLastActivityTime() + cooldown - timeline.curTime
	
	if activityDelta > 0 then
		return math.max(activities.MIN_COOLDOWN_PENALTY, math.log(cooldown - activityDelta, cooldown))
	else
		return 1
	end
end

function activities:visit(activity, participants, autoOrganized)
	table.clear(self.enjoymentData)
	
	local data = activities.registeredByID[activity]
	local employees = studio:getEmployeesByUID()
	local totalEnjoyment = 0
	local curIndex = 1
	local cooldownLength = activities.COOLDOWN_LENGTH
	local timeVal = timeline.curTime
	local scheduledTooSoon = false
	local avgDriveGain = 0
	
	for i = 1, #participants do
		local uniqueID = participants[curIndex]
		local employee = employees[uniqueID]
		
		if employee then
			local effMult = 1
			local activityDelta = employee:getLastActivityTime() + cooldownLength - timeVal
			
			if activityDelta > 0 then
				effMult = math.max(activities.MIN_COOLDOWN_PENALTY, math.log(cooldownLength - activityDelta, cooldownLength))
				
				if not autoOrganized then
					scheduledTooSoon = true
				end
			else
				effMult = 1
			end
			
			local enjoyment = self:calculateEnjoyment(data, employee, participants, autoOrganized) * effMult
			
			if data.contributingInterests then
				for key, contribData in ipairs(data.contributingInterestsNumeric) do
					if employee:hasInterest(contribData.interest) then
						local justDiscovered = studio:discoverActivityAffector(activity, contribData.interest)
						
						if justDiscovered then
							self.justDiscoveredAffectors[contribData.interest] = true
						end
					end
				end
			end
			
			self.enjoymentData[uniqueID] = enjoyment
			totalEnjoyment = totalEnjoyment + enjoyment
			avgDriveGain = avgDriveGain + self:convertEnjoymentToDrive(enjoyment)
			
			local knowInc = data.knowledgeIncrease
			
			if knowInc then
				if knowInc[1] then
					for key, data in ipairs(knowInc) do
						employee:addKnowledge(data.id, math.random(data.min, data.max))
					end
				else
					employee:addKnowledge(knowInc.id, math.random(knowInc.min, knowInc.max))
				end
			end
			
			if data.postActivityVisit then
				data:postActivityVisit(employee, enjoyment)
			end
			
			if data.mainInterest then
				interests:attemptGiveNewInterest(employee, data.mainInterest)
			end
			
			curIndex = curIndex + 1
		else
			table.remove(participants, curIndex)
		end
	end
	
	self.averageDriveGain = math.ceil(avgDriveGain / #participants)
	
	if scheduledTooSoon and not table.find(self.activeAffectors, activities.AFFECTORS.GLOBAL_COOLDOWN) then
		table.insert(self.activeAffectors, activities.AFFECTORS.GLOBAL_COOLDOWN)
	end
	
	if autoOrganized then
		game.addToEventBox("auto_organized_activity_result", {
			participants = #participants,
			totalEnjoyment = math.round(totalEnjoyment / #participants),
			activity = activity
		}, 1, nil, "exclamation_point")
	else
		self:createVerdictPopup(activity, participants, self.enjoymentData)
	end
	
	self:postActivityVisit(data)
	table.clear(self.justDiscoveredAffectors)
	table.clear(self.activeAffectors)
	events:fire(activities.EVENTS.ACTIVITY_FINISHED)
	
	return self.enjoymentData
end

function activities:postActivityVisit(data)
	local participants = studio:getActivitySchedule().participants
	local time = timeline.curTime
	
	studio:markActivityTime(data.id, time)
	
	for key, employee in ipairs(studio:getEmployees()) do
		employee:setActivityDesireToGo(data.id, nil)
		employee:markActivityTime(data.id, time)
	end
	
	local employees = studio:getEmployeesByUID()
	local toNoVac = activities.ENJOYMENT_TO_DAYS_WITHOUT_VACACATION
	
	for key, uniqueID in ipairs(participants) do
		local participant = employees[uniqueID]
		local enjoyment = self.enjoymentData[uniqueID]
		
		participant:addDrive(self:convertEnjoymentToDrive(enjoyment))
		participant:addDaysWithoutVacation(-enjoyment / toNoVac)
	end
	
	studio:resetScheduledActivity()
end

local positiveContributors = {}
local negativeContributors = {}

function activities:getDiscoveredActivityContributors(activityID, targetEmployee)
	table.clear(positiveContributors)
	table.clear(negativeContributors)
	
	local data = activities.registeredByID[activityID]
	
	if data.contributingInterests then
		for key, contribData in ipairs(data.contributingInterestsNumeric) do
			if (targetEmployee and targetEmployee:hasInterest(contribData.interest) or not targetEmployee) and studio:hasDiscoveredActivityAffector(data.id, contribData.interest) then
				if contribData.contribution < 1 then
					table.inserti(negativeContributors, contribData.interest)
				elseif contribData.contribution > 1 then
					table.inserti(positiveContributors, contribData.interest)
				end
			end
		end
	end
	
	return positiveContributors, negativeContributors
end

activities.VERDICT_BOX_COLOR = color(150, 150, 150, 255)

function activities:wasAffectorJustDiscovered(interestID)
	return self.justDiscoveredAffectors[interestID]
end

function activities:createActivityConfirmationMenu(activityID)
	local participants, nonParticipants = studio:getWillingActivityParticipants(activityID)
	local frame = gui.create("Frame")
	
	frame:setSize(400, 600)
	frame:setFont(fonts.get("pix20"))
	frame:setTitle(_T("ACTIVITY_PARTICIPANTS_TITLE", "Participants"))
	frame:center()
	
	local penaltyPresent = false
	
	for key, participant in ipairs(participants) do
		if self:calculateCooldownPenalty(participant) < 1 then
			penaltyPresent = true
			
			break
		end
	end
	
	local descBox = gui.create("GenericDescbox", frame)
	
	descBox:setPos(_S(5), _S(30))
	self.registeredByID[activityID]:setupInfoDescbox(descBox, 390, true)
	
	if penaltyPresent then
		descBox:addSpaceToNextText(6)
		descBox:addTextLine(-1, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		descBox:addText(_T("ACTIVITY_COOLDOWN_ACTIVE", "Some employees have had enough of team building activities for now."), "bh20", game.UI_COLORS.RED, 0, 390, "exclamation_point_red", 22, 22)
	end
	
	descBox:setWidth(_S(390))
	
	local offset = descBox.localY + descBox.h + _S(5)
	local scrollPanel = gui.create("ScrollbarPanel", frame)
	
	scrollPanel:setSize(390, _US(frame.h - offset) - 35)
	scrollPanel:setPos(_S(5), offset)
	scrollPanel:setPadding(2, 2)
	scrollPanel:setAdjustElementPosition(true)
	scrollPanel:setSpacing(4)
	scrollPanel:setPadding(4, 4)
	scrollPanel:addDepth(100)
	
	local goingCategory = gui.create("Category")
	
	goingCategory:setFont(fonts.get("pix24"))
	goingCategory:setText(_T("ACTIVITY_GOING", "Going"))
	goingCategory:setWidth(340)
	scrollPanel:addItem(goingCategory)
	
	for key, participant in ipairs(participants) do
		local display = gui.create("ActivityParticipantDisplay")
		
		display:setSize(300, 20)
		display:setEmployee(participant)
		scrollPanel:addItem(display)
	end
	
	if #nonParticipants > 0 then
		local notGoingCategory = gui.create("Category")
		
		notGoingCategory:setFont(fonts.get("pix24"))
		notGoingCategory:setText(_T("ACTIVITY_NOT_GOING", "Not going"))
		notGoingCategory:setWidth(340)
		scrollPanel:addItem(notGoingCategory)
		
		for key, employee in ipairs(nonParticipants) do
			local display = gui.create("ActivityParticipantDisplay")
			
			display:setSize(300, 20)
			display:setEmployee(employee)
			scrollPanel:addItem(display)
		end
	end
	
	local y = _S(570)
	local cost = activities:getData(activityID):getPrice(#participants)
	local costDisplay = gui.create("CostDisplay", frame)
	
	costDisplay:setSize(200, 25)
	costDisplay:setPos(_S(5), y)
	costDisplay:setFont("pix24")
	costDisplay:setCost(cost)
	
	local scheduleButton = gui.create("ScheduleActivityButton", frame)
	
	scheduleButton:setSize(185, 25)
	scheduleButton:setPos(frame.w - scheduleButton.w - _S(5), y)
	scheduleButton:setActivityID(activityID)
	scheduleButton:setFont(fonts.get("pix24"))
	scheduleButton:setCost(cost)
	frameController:push(frame)
end

function activities:createVerdictPopup(activity, participants, enjoymentData)
	local frame = gui.create("Frame")
	
	frame:setSize(400, 600)
	frame:setFont(fonts.get("pix24"))
	frame:setTitle(_T("ACTIVITY_VERDICT_TITLE", "Activity Verdict"))
	
	local verdictBox = gui.create("GenericDescbox", frame)
	
	verdictBox:setPos(_S(5), _S(30))
	verdictBox:setWidth(_S(390))
	verdictBox:setFadeInSpeed(0)
	self:formatVerdictDescbox(verdictBox, activity, participants, enjoymentData, 390)
	verdictBox:setWidth(_S(390))
	
	local verdictBoxHeight = verdictBox:getHeight()
	local scroller = gui.create("ScrollbarPanel", frame)
	
	scroller:setPos(_S(5), _S(35) + verdictBoxHeight)
	scroller:setSize(390, 530 - _US(verdictBoxHeight))
	scroller:setAdjustElementPosition(true)
	scroller:setSpacing(4)
	scroller:setPadding(4, 4)
	scroller:addDepth(20)
	
	local employees = studio:getEmployeesByUID()
	local participants = studio:getActivitySchedule().participants
	
	for key, uniqueID in ipairs(participants) do
		local employee = employees[uniqueID]
		local ratingDisplay = gui.create("EnjoymentRatingDisplay")
		
		ratingDisplay:setEmployee(employee)
		ratingDisplay:setEnjoyment(enjoymentData[uniqueID])
		ratingDisplay:setActivity(activities.registeredByID[activity])
		ratingDisplay:setSize(380, 25)
		scroller:addItem(ratingDisplay)
	end
	
	local close = gui.create("CloseButton", frame)
	
	close:setPos(_S(6), _S(570))
	close:setSize(388, 25)
	close:setFont(fonts.get("pix24"))
	close:setText(_T("OK", "OK"))
	frame:center()
	frameController:push(frame)
end

local conflictingInterestsTable = {}

activities.conflictingInterests = {}
activities.positiveInterests = {}

function activities:formatVerdictDescbox(verdictBox, activity, participantIDs, enjoymentData, wrapWidth)
	local data = activities.registeredByID[activity]
	local employees = studio:getEmployeesByUID()
	local verdictText = _format(self:getRatingText(data.baseEnjoymentRating), "ACTIVITY", data.displayPopup)
	
	verdictBox:addText(verdictText, "pix20", nil, 5, wrapWidth)
	
	local textLineW = _S(wrapWidth - 20)
	
	verdictBox:addTextLine(-1, game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
	verdictBox:addText(_format(_T("ACTIVITY_AVERAGE_DRIVE_GAIN", "Avg. Drive gained: AMOUNT Pts."), "AMOUNT", self.averageDriveGain), "bh20", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth, "increase", 22, 22)
	
	if data.knowledgeIncrease then
		verdictBox:addSpaceToNextText(5)
		self:addKnowledgeIncreaseText(data.knowledgeIncrease, verdictBox, wrapWidth)
	end
	
	if data.contributingInterests then
		for key, uniqueID in ipairs(participantIDs) do
			local employee = employees[uniqueID]
			
			for key, interest in ipairs(employee:getInterests()) do
				local affector = data.contributingInterests[interest]
				
				if affector then
					if affector < 1 then
						if not table.find(activities.conflictingInterests, interest) then
							activities.conflictingInterests[#activities.conflictingInterests + 1] = interest
						end
					elseif affector > 1 and not table.find(activities.positiveInterests, interest) then
						activities.positiveInterests[#activities.positiveInterests + 1] = interest
					end
				end
			end
		end
	end
	
	self:_addInterestAffectorText(activity, activities.positiveInterests, verdictBox, _T("ACTIVITY_CONTRIBUTING_INTERESTS", "Contributing interests:"), game.UI_COLORS.LIGHT_BLUE, "increase", wrapWidth)
	self:_addInterestAffectorText(activity, activities.conflictingInterests, verdictBox, _T("ACTIVITY_CONFLICTING_INTERESTS", "Conflicting interests:"), game.UI_COLORS.RED, "decrease_red", wrapWidth)
	
	if #self.activeAffectors > 0 then
		verdictBox:addSpaceToNextText(5)
		
		local red = game.UI_COLORS.RED
		local actAffectors = self.activeAffectors
		
		for i = 1, #self.activeAffectors do
			local affector = actAffectors[i]
			
			verdictBox:addTextLine(-1, red, nil, "weak_gradient_horizontal")
			verdictBox:addText(activities.AFFECTOR_TEXT[affector], "bh20", red, 0, wrapWidth, "exclamation_point_red", 22, 22)
			
			actAffectors[i] = nil
		end
	end
end

function activities:addKnowledgeIncreaseText(knowledgeIncrease, verdictBox, wrapWidth)
	if knowledgeIncrease[1] then
		for key, data in ipairs(knowledgeIncrease) do
			self:_addKnowledgeIncreaseText(data, verdictBox, wrapWidth)
		end
	else
		self:_addKnowledgeIncreaseText(knowledgeIncrease, verdictBox, wrapWidth)
	end
end

function activities:_addKnowledgeIncreaseText(knowledgeIncrease, verdictBox, wrapWidth)
	local knowledgeData = knowledge.registeredByID[knowledgeIncrease.id]
	
	verdictBox:addTextLine(-1, game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
	verdictBox:addText(_format(_T("ACTIVITY_PROVIDES_KNOWLEDGE", "Provides knowledge in KNOWLEDGE"), "KNOWLEDGE", knowledgeData.display), "bh20", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth, {
		{
			height = 24,
			icon = "profession_backdrop",
			width = 24
		},
		{
			width = 20,
			height = 20,
			y = 1,
			x = 1,
			icon = knowledgeData.icon
		}
	})
end

function activities:_addInterestAffectorText(activity, interestList, verdictBox, headerText, headerColor, headerIcon, wrapWidth)
	if #interestList > 0 then
		verdictBox:addSpaceToNextText(10)
		
		local textLineW = _S(wrapWidth - 20)
		
		verdictBox:addTextLine(-1, headerColor, nil, "weak_gradient_horizontal")
		verdictBox:addText(headerText, "bh20", headerColor, 0, wrapWidth, headerIcon, 22, 22)
		verdictBox:addSpaceToNextText(4)
		
		for key, interest in ipairs(interestList) do
			local signs, color = activities:getActivityContributorSign(activities.registeredByID[activity], interest)
			local data = interests.registeredByID[interest]
			local iconConfig = data:getIconConfig(24, 20)
			
			if signs then
				verdictBox:addTextLine(-1, color, nil, "weak_gradient_horizontal")
				verdictBox:addText(_format("SIGNS DISPLAY", "SIGNS", signs, "DISPLAY", data.display), "bh18", color, 0, wrapWidth, iconConfig)
			else
				verdictBox:addText(data.display, "bh18", nil, 0, wrapWidth, iconConfig)
			end
			
			interestList[key] = nil
		end
	end
end

function activities:getRatingText(baseRating)
	local highest = 0
	local mostValid
	
	for key, data in ipairs(activities.RESULT_TEXT) do
		if baseRating > data.rating and highest < data.rating then
			highest = data.rating
			mostValid = data.text
		end
	end
	
	return mostValid
end

function activities:convertEnjoymentToDrive(enjoyment)
	return enjoyment / activities.ENJOYMENT_TO_DRIVE
end

function activities:willEmployeeGo(activity, employee)
	return activities.registeredByID[activity]:doesEmployeeWantToGo(employee)
end

require("game/activities/basic_activities")
