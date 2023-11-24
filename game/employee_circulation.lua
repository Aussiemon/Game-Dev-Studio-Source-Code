employeeCirculation = {}
employeeCirculation.EVENTS = {
	JOB_OFFER_SENT = events:new(),
	SEARCH_STARTED = events:new(),
	SEARCH_CANCELLED = events:new(),
	CANDIDATE_HIRED = events:new(),
	CANDIDATE_REFUSED = events:new(),
	ADJUSTED_SEARCH_PARAMETER = events:new(),
	OPENED_MENU = events:new(),
	CANDIDATE_TARGET_TEAM_CHANGED = events:new()
}
employeeCirculation.MAX_JOB_SEEKERS = 25
employeeCirculation.NEW_EMPLOYEE_CHANCE = 100
employeeCirculation.MINIMUM_AGREE_CHANCE = 65
employeeCirculation.SKILL_TO_LOWER_CHANCE_OFFSET = 30
employeeCirculation.ACCEPT_CHANCE_DROP_PER_SKILL_POINT = -1
employeeCirculation.ACCEPT_CHANCE_INCREASE_PER_REPUTATION = 0.002
employeeCirculation.ACCEPT_CHANCE_INCREASE_PER_CASH = 2e-05
employeeCirculation.START_MIN_EMPLOYEES = 5
employeeCirculation.MIN_TIME_TO_DISAPPEAR = 7
employeeCirculation.MAX_TIME_TO_DISAPPEAR = 28
employeeCirculation.BASE_LEVEL = 1
employeeCirculation.LEVEL_CAP_PER_YEAR = 0.25
employeeCirculation.EXPERT_CHANCE = 8
employeeCirculation.EXPERT_MIN_LEVEL_INCREASE = 3
employeeCirculation.EXPERT_MAX_LEVEL_INCREASE = 4
employeeCirculation.EXPERT_MIN_TIME_TO_DISAPPEAR = 5
employeeCirculation.EXPERT_MAX_TIME_TO_DISAPPEAR = 10
employeeCirculation.MAX_BUFFERED_PAST_EMPLOYEES = 50
employeeCirculation.PERCENTAGE_EXP_GAINED_PER_WEEK = {
	0.06,
	0.1
}
employeeCirculation.BUFFERED_EMPLOYEE_JOB_SEEK_DELAY = {
	timeline.DAYS_IN_WEEK * 2,
	timeline.DAYS_IN_WEEK * 4
}
employeeCirculation.BUFFERED_EMPLOYEE_JOB_SEEKERS_CHANCE = 4
employeeCirculation.JOB_SEEK_DELAY_FACT = "job_seek_delay"
employeeCirculation.BUFFERED_MIN_TIME_TO_DISAPPEAR = 14
employeeCirculation.BUFFERED_MAX_TIME_TO_DISAPPEAR = 28
employeeCirculation.ALWAYS_ACCEPT_JOB_OFFER_FACT = "always_accept_job_offer"
employeeCirculation.EMPLOYEE_GENERATE_CHANCE = {
	max = 50,
	min = 2
}
employeeCirculation.MIN_SEARCH_BUDGET = 100
employeeCirculation.MAX_SEARCH_BUDGET = 50000
employeeCirculation.DESIRED_SEARCH_LEVEL_BUDGET_AFFECTOR = employeeCirculation.MAX_SEARCH_BUDGET / developer.MAX_LEVEL
employeeCirculation.GENERATION_CHANCE_DECREASE_LOW_BUDGET = 1 / (employeeCirculation.DESIRED_SEARCH_LEVEL_BUDGET_AFFECTOR * 0.2)
employeeCirculation.GENERATION_CHANCE_INTEREST_AFFECTOR = 10
employeeCirculation.JOB_LISTING_DURATION = timeline.DAYS_IN_MONTH
employeeCirculation.REFUSE_LISTING_CANDIDATE_RETURN_CHANCE = 50
employeeCirculation.SUCCESS_CHANCE_CHANGE_PER_CANDIDATE = -5
employeeCirculation.EMPLOYEE_AGE_RANGES = {}
employeeCirculation.AGE_TO_MAX_LEVEL_RANGE_MODIFIER = 0.2
employeeCirculation.AGE_TO_MIN_LEVEL_RANGE_MODIFIER = 0.1
employeeCirculation.FORMAT_TABLE = {}
employeeCirculation.CATCHABLE_EVENTS = {
	timeline.EVENTS.NEW_DAY,
	timeline.EVENTS.NEW_WEEK
}
employeeCirculation.jobSeekers = {}
employeeCirculation.jobSeekerTimeLeft = {}
employeeCirculation.bufferedPastEmployees = {}
employeeCirculation.mainSkills = {}
employeeCirculation.employeeSearches = {}

function employeeCirculation:addEmployeeAgeRange(data)
	table.insert(employeeCirculation.EMPLOYEE_AGE_RANGES, data)
	
	employeeCirculation.EMPLOYEE_AGE_RANGE_WEIGHT_SUM = 0
	employeeCirculation.LOWEST_EMPLOYEE_AGE = math.min(employeeCirculation.LOWEST_EMPLOYEE_AGE or math.huge, data.min)
	
	for key, data in ipairs(employeeCirculation.EMPLOYEE_AGE_RANGES) do
		employeeCirculation.EMPLOYEE_AGE_RANGE_WEIGHT_SUM = employeeCirculation.EMPLOYEE_AGE_RANGE_WEIGHT_SUM + data.weight
	end
end

employeeCirculation:addEmployeeAgeRange({
	min = 18,
	weight = 100,
	max = 26
})
employeeCirculation:addEmployeeAgeRange({
	min = 27,
	weight = 80,
	max = 34
})
employeeCirculation:addEmployeeAgeRange({
	min = 35,
	weight = 50,
	max = 42
})
employeeCirculation:addEmployeeAgeRange({
	min = 43,
	weight = 20,
	max = 50
})

function employeeCirculation:getEmployeeSearchChance(searchData)
	local normalizedMax = employeeCirculation.MAX_SEARCH_BUDGET - employeeCirculation.MIN_SEARCH_BUDGET
	local normalizedBudget = searchData.budget - employeeCirculation.MIN_SEARCH_BUDGET
	local difference = searchData.level * employeeCirculation.DESIRED_SEARCH_LEVEL_BUDGET_AFFECTOR - normalizedBudget
	local baseChance = math.lerp(employeeCirculation.EMPLOYEE_GENERATE_CHANCE.min, employeeCirculation.EMPLOYEE_GENERATE_CHANCE.max, normalizedBudget / normalizedMax)
	
	if difference > 0 then
		baseChance = baseChance - employeeCirculation.GENERATION_CHANCE_DECREASE_LOW_BUDGET * difference
	end
	
	baseChance = baseChance + employeeCirculation.SUCCESS_CHANCE_CHANGE_PER_CANDIDATE * searchData.totalOffers
	
	return math.max(employeeCirculation.EMPLOYEE_GENERATE_CHANCE.min, baseChance - #searchData.interests * employeeCirculation.GENERATION_CHANCE_INTEREST_AFFECTOR)
end

function employeeCirculation:createEmployeeSearchData()
	return {
		totalOffers = 0,
		level = 1,
		budget = employeeCirculation.MIN_SEARCH_BUDGET,
		role = attributes.profiler.roles[1].id,
		timeLeft = employeeCirculation.JOB_LISTING_DURATION,
		candidates = {},
		interests = {}
	}
end

function employeeCirculation:getEmployeeSearches()
	return self.employeeSearches
end

function employeeCirculation:isSearchingForRole(roleID)
	for key, data in ipairs(self.employeeSearches) do
		if data.role == roleID then
			return true
		end
	end
	
	return false
end

function employeeCirculation:overrideAcceptChance(chance)
	self.acceptChanceOverride = chance
end

function employeeCirculation:addEmployeeSearch(searchData)
	studio:deductFunds(searchData.budget, nil, "misc")
	table.insert(self.employeeSearches, searchData)
	
	searchData.successChance = self:getEmployeeSearchChance(searchData)
	
	events:fire(employeeCirculation.EVENTS.SEARCH_STARTED, searchData)
end

function employeeCirculation:cancelEmployeeSearch(searchData)
	table.removeObject(self.employeeSearches, searchData)
	
	for key, candidate in ipairs(searchData.candidates) do
		candidate:remove()
		
		searchData.candidates[key] = nil
	end
	
	events:fire(employeeCirculation.EVENTS.SEARCH_CANCELLED, searchData)
end

function employeeCirculation:getRandomAge()
	local section = math.random(1, employeeCirculation.EMPLOYEE_AGE_RANGE_WEIGHT_SUM)
	local curWeight = 0
	local finalRange
	
	for key, data in ipairs(employeeCirculation.EMPLOYEE_AGE_RANGES) do
		curWeight = curWeight + data.weight
		
		if section <= curWeight then
			finalRange = data
			
			break
		end
	end
	
	return math.randomf(finalRange.min, finalRange.max)
end

function employeeCirculation:getMinLevelModifierFromAge(age)
	return math.floor((age - employeeCirculation.LOWEST_EMPLOYEE_AGE) * employeeCirculation.AGE_TO_MIN_LEVEL_RANGE_MODIFIER)
end

function employeeCirculation:getMaxLevelModifierFromAge(age)
	return math.round((age - employeeCirculation.LOWEST_EMPLOYEE_AGE) * employeeCirculation.AGE_TO_MAX_LEVEL_RANGE_MODIFIER)
end

function employeeCirculation:init()
	table.clear(self.jobSeekers)
	table.clear(self.jobSeekerTimeLeft)
	table.clear(self.bufferedPastEmployees)
	table.clear(self.mainSkills)
	table.clear(self.employeeSearches)
	
	self.pendingCandidates = {}
	
	events:addDirectReceiver(self, employeeCirculation.CATCHABLE_EVENTS)
end

function employeeCirculation:remove()
	events:removeDirectReceiver(self, employeeCirculation.CATCHABLE_EVENTS)
	
	for key, obj in ipairs(self.jobSeekers) do
		obj:remove()
		
		self.jobSeekers[key] = nil
	end
	
	for key, obj in ipairs(self.bufferedPastEmployees) do
		obj:remove()
		
		self.bufferedPastEmployees[key] = nil
	end
	
	table.clear(self.jobSeekerTimeLeft)
	table.clear(self.mainSkills)
	table.clear(self.bufferedPastEmployees)
	table.clearArray(self.pendingCandidates)
	
	for key, data in ipairs(self.employeeSearches) do
		for key, candidate in ipairs(data.candidates) do
			candidate:remove()
			
			data.candidates[key] = nil
		end
		
		self.employeeSearches[key] = nil
	end
end

function employeeCirculation:generateEmployeesFromConfig(cfg, employer, countMultiplier, levelOffset)
	countMultiplier = countMultiplier or 1
	
	if type(cfg) == "table" then
		for key, data in ipairs(cfg) do
			if data.repeatFor then
				for i = 1, math.round(data.repeatFor * countMultiplier) do
					local employee = self:generateEmployeeFromConfig(data, levelOffset)
					
					employer:hireEmployee(employee)
					
					if data.hireTime then
						self:_applyHireTime(employee, data.hireTime)
					end
				end
			else
				local employee = self:generateEmployeeFromConfig(data, levelOffset)
				
				employer:hireEmployee(employee)
				
				if data.hireTime then
					self:_applyHireTime(employee, data.hireTime)
				end
			end
		end
	else
		for i = 1, cfg do
			local employee = game.generateRandomEmployee()
			
			employee:applyDefaultSalary()
			employer:hireEmployee(employee)
		end
	end
end

function employeeCirculation:_applyHireTime(employee, hireTime)
	local time = 0
	
	if hireTime.year then
		time = time + timeline:yearToTime(math.random(hireTime.year[1], hireTime.year[2]))
	end
	
	if hireTime.month then
		time = time + timeline:monthToTime(math.random(hireTime.month[1], hireTime.month[2]))
	end
	
	employee:setHireTime(time)
end

function employeeCirculation:setTargetTeam(teamObj)
	self.targetTeam = teamObj
	
	events:fire(employeeCirculation.EVENTS.CANDIDATE_TARGET_TEAM_CHANGED, teamObj)
end

function employeeCirculation:getTargetTeam()
	return self.targetTeam
end

employeeCirculation.CANDIDATE_TEAM_DEST_DESCBOX_ID = "candidate_team_destination_descbox"

function employeeCirculation:createTargetTeamSelectionMenu()
	local frame = gui.create("Frame")
	
	frame:setSize(400, 500)
	frame:setFont("pix24")
	frame:setText(_T("TARGET_TEAM_SELECTION_TITLE", "Target Team Selection"))
	
	local scroller = gui.create("ScrollbarPanel", frame)
	
	scroller:setPos(_S(5), _S(35))
	scroller:setSize(frame.rawW - 10, frame.rawH - 40)
	scroller:setAdjustElementPosition(true)
	scroller:setPadding(3, 3)
	scroller:setSpacing(3)
	
	local elemW = frame.rawW - 15
	local descID = employeeCirculation.CANDIDATE_TEAM_DEST_DESCBOX_ID
	
	for key, teamObj in ipairs(studio:getTeams()) do
		local elem = gui.create("CandidateTargetTeamSelection")
		
		elem:setWidth(elemW)
		elem:setTeamInfoDescboxID(descID)
		elem:setThoroughDescription(true)
		elem:setTeam(teamObj)
		scroller:addItem(elem)
	end
	
	frame:center()
	
	local teamDescbox = gui.create("TeamInfoDescbox")
	
	teamDescbox:setShowPenaltyDescription(false)
	teamDescbox:setID(descID)
	teamDescbox:tieVisibilityTo(frame)
	teamDescbox:hideDisplay()
	teamDescbox:setPos(frame.x + frame.w + _S(10), frame.y)
	frameController:push(frame)
end

function employeeCirculation:onCloseCandidatesPopup()
	self.targetTeam = nil
end

function employeeCirculation:postKillCandidatesFrame()
	employeeCirculation:onCloseCandidatesPopup()
end

function employeeCirculation:viewListingCandidates(searchData)
	local frame = gui.create("Frame")
	
	frame:setFont("pix24")
	frame:setTitle(_T("JOB_CANDIDATES_TITLE", "Job Candidates"))
	frame:setSize(500, 600)
	
	frame.postKill = self.postKillCandidatesFrame
	self.targetTeam = studio:getStudioTeam()
	
	local scrollbar = gui.create("ScrollbarPanel", frame)
	
	scrollbar:setSize(490, 530)
	scrollbar:setPos(_S(5), _S(30))
	scrollbar:setAdjustElementPosition(true)
	scrollbar:setSpacing(3)
	scrollbar:setPadding(3, 3)
	scrollbar:addDepth(50)
	
	local candidates = searchData.candidates
	
	for key, candidate in ipairs(candidates) do
		local element = gui.create("JobListingCandidate")
		
		element:setWidth(470)
		element:setSearchData(searchData)
		element:setEmployee(candidate)
		scrollbar:addItem(element)
	end
	
	local targetTeam = gui.create("JobCandidateTeamSelection", frame)
	
	targetTeam:setFont("bh24")
	targetTeam:updateText()
	targetTeam:setSize(250, 30)
	targetTeam:setPos(_S(5), frame.h - targetTeam.h - _S(5))
	
	local acceptAll = gui.create("AcceptAllCandidatesButton", frame)
	
	acceptAll:setSize(30, 30)
	acceptAll:setPos(targetTeam.localX + targetTeam.w + _S(5), targetTeam.localY)
	acceptAll:setSearchData(searchData)
	acceptAll:setCandidateList(candidates)
	
	local refuseAll = gui.create("RefuseAllCandidatesButton", frame)
	
	refuseAll:setSize(30, 30)
	refuseAll:setPos(acceptAll.localX + acceptAll.w + _S(5), targetTeam.localY)
	refuseAll:setSearchData(searchData)
	refuseAll:setCandidateList(candidates)
	frame:center()
	
	local infoBox = gui.create("StudioEmploymentInfoDescbox")
	
	infoBox:setPos(frame.x + frame.w + _S(10), frame.y)
	infoBox:updateDisplay()
	infoBox:tieVisibilityTo(frame)
	infoBox:setShowEmployeeOverview(true)
	frameController:push(frame)
end

function employeeCirculation:acceptListingCandidate(searchData, candidate)
	table.removeObject(searchData.candidates, candidate)
	self:finishHiringEmployee(candidate)
	events:fire(employeeCirculation.EVENTS.CANDIDATE_HIRED, candidate, searchData)
end

function employeeCirculation:acceptCandidate(candidate)
	table.removeObject(self.pendingCandidates, candidate)
	self:finishHiringEmployee(candidate)
	events:fire(employeeCirculation.EVENTS.CANDIDATE_HIRED, candidate, nil)
end

function employeeCirculation:refuseListingCandidate(searchData, candidate)
	table.removeObject(searchData.candidates, candidate)
	candidate:remove()
	events:fire(employeeCirculation.EVENTS.CANDIDATE_REFUSED, candidate, searchData)
end

function employeeCirculation:generateOneOfEach()
	for key, data in ipairs(attributes.profiler.roles) do
		if not data.invisible then
			self:generateJobSeeker(data.id, nil, nil)
		end
	end
end

function employeeCirculation:generateEmployeeFromConfig(data, levelOffset)
	local level = type(data.level) == "table" and math.random(data.level[1], data.level[2]) or data.level
	
	if levelOffset then
		level = math.min(developer.MAX_LEVEL, level + levelOffset)
	end
	
	local employee = game.generateSpecificEmployee(nil, nil, level, data.role, data.age, data.female, nil, nil)
	
	employee:applyDefaultSalary()
	
	return employee
end

function employeeCirculation:generateStartingEmployees()
	for i = 1, employeeCirculation.START_MIN_EMPLOYEES do
		self:generateJobSeeker()
	end
end

function employeeCirculation:getJobSeekers()
	return self.jobSeekers
end

function employeeCirculation:bufferEmployee(employee)
	table.insert(self.bufferedPastEmployees, employee)
	
	local range = employeeCirculation.BUFFERED_EMPLOYEE_JOB_SEEK_DELAY
	
	employee:setFact(employeeCirculation.JOB_SEEK_DELAY_FACT, timeline.curTime + math.random(range[1], range[2]))
end

function employeeCirculation:countOfferedWorkByRole(role)
	local total = 0
	
	for key, jobSeeker in ipairs(self.jobSeekers) do
		if jobSeeker:hasOfferedWork() and jobSeeker:getRole() == role then
			total = total + 1
		end
	end
	
	return total
end

function employeeCirculation:getAcceptChance(employee)
	if self.acceptChanceOverride then
		return self.acceptChanceOverride
	end
	
	if employee:getFact(employeeCirculation.ALWAYS_ACCEPT_JOB_OFFER_FACT) then
		return 100
	end
	
	local mainSkill = employee:getMainSkill()
	local skillLevel = 0
	
	if not mainSkill then
		skillLevel = select(2, employee:getHighestSkill())
	else
		skillLevel = employee:getSkillLevel(mainSkill)
	end
	
	skillLevel = skillLevel - employeeCirculation.SKILL_TO_LOWER_CHANCE_OFFSET
	
	return math.max(employeeCirculation.MINIMUM_AGREE_CHANCE, employeeCirculation.MINIMUM_AGREE_CHANCE + employeeCirculation.ACCEPT_CHANCE_INCREASE_PER_REPUTATION * studio:getReputation() + employeeCirculation.ACCEPT_CHANCE_DROP_PER_SKILL_POINT * skillLevel + employeeCirculation.ACCEPT_CHANCE_INCREASE_PER_CASH * studio:getFunds())
end

employeeCirculation.concatJobListingNames = {}

eventBoxText:registerNew({
	id = "job_listing_expired",
	getText = function(self, data)
		return employeeCirculation:getJobListingExpirationText(data)
	end
})

function employeeCirculation:getJobListingExpirationText(list)
	local count = #list
	local profiler = attributes.profiler.rolesByID
	
	if count == 1 then
		return _format(_T("JOB_LISTING_RAN_OUT_OF_TIME", "Your job listing for ROLE position has expired."), "ROLE", profiler[list[1]].personDisplay)
	elseif count == 2 then
		local one = list[1]
		local two = list[2]
		
		return _format(_T("JOB_LISTINGS_RAN_OUT_OF_TIME", "Your job listings for ONE and TWO positions have expired."), "ONE", profiler[one].personDisplay, "TWO", profiler[two].personDisplay)
	else
		local final = list[#list]
		local concat = employeeCirculation.concatJobListingNames
		
		for i = 1, #list - 1 do
			local roleID = list[i]
			
			concat[#concat + 1] = profiler[roleID].personDisplay
		end
		
		local text = _format(_T("JOB_LISTINGS_RAN_OUT_OF_TIME", "Your job listings for ONE and TWO positions have expired."), "ONE", table.concat(concat, ", "), "TWO", profiler[final].personDisplay)
		
		table.clearArray(concat)
		
		return text
	end
end

function employeeCirculation:handleEvent(event)
	if event == timeline.EVENTS.NEW_DAY then
		local shouldBreak = false
		
		self:rollEmployeeGeneration()
		
		local cur = 1
		
		for key = 1, #self.jobSeekers do
			local employee = self.jobSeekers[cur]
			
			if employee:hasOfferedWork() then
				if math.randomf(1, 100) >= self:getAcceptChance(employee) then
					self:showOfferResultPopup(_T("JOB_OFFER_REFUSED_TITLE", "Job offer refused"), _T("JOB_OFFER_REFUSED_DESC", "NAME has refused your job offer for a ROLE position."), employee)
					self:removeEmployee(employee, cur)
					employee:setFact(employeeCirculation.ALWAYS_ACCEPT_JOB_OFFER_FACT, nil)
					
					shouldBreak = true
				else
					self:showOfferResultPopup(_T("JOB_OFFER_ACCEPTED_TITLE", "Job offer accepted"), _T("JOB_OFFER_ACCEPTED_DESC", "NAME has accepted your job offer for a ROLE position and is now available in office starting today."), employee)
					self:hireJobSeeker(employee, cur)
					
					shouldBreak = true
				end
				
				employee:removeWorkOffer()
			else
				self.jobSeekerTimeLeft[cur] = self.jobSeekerTimeLeft[cur] - 1
				
				if self.jobSeekerTimeLeft[cur] <= 0 then
					self:removeEmployee(nil, cur)
				else
					cur = cur + 1
				end
			end
		end
		
		if #self.employeeSearches > 0 then
			local curIndex = 1
			local removedListings
			local pendingCandidates = self.pendingCandidates
			
			for i = 1, #self.employeeSearches do
				local searchData = self.employeeSearches[curIndex]
				local wasRemoved = false
				
				if searchData.timeLeft == 1 then
					table.remove(self.employeeSearches, curIndex)
					
					removedListings = removedListings or {}
					
					if not table.find(removedListings, searchData.role) then
						removedListings[#removedListings + 1] = searchData.role
					end
					
					for key, candidate in ipairs(searchData.candidates) do
						table.insert(pendingCandidates, candidate)
					end
					
					wasRemoved = true
				else
					searchData.timeLeft = searchData.timeLeft - 1
					curIndex = curIndex + 1
				end
				
				if math.random(1, 100) <= searchData.successChance then
					self:createJobListingEmployee(searchData, wasRemoved)
					
					shouldBreak = true
				end
			end
			
			if removedListings then
				if #self.pendingCandidates > 0 then
					self:createPendingCandidatesConfirmPopup(removedListings)
					
					self.removedListings = removedListings
				end
				
				game.addToEventBox("job_listing_expired", removedListings, 1, nil, "question_mark")
			end
		end
		
		if shouldBreak then
			timeline:breakIteration()
		end
	elseif event == timeline.EVENTS.NEW_WEEK then
		local employeeList = self.bufferedPastEmployees
		
		if #employeeList > 0 then
			local gainMin, gainMax = employeeCirculation.PERCENTAGE_EXP_GAINED_PER_WEEK[1], employeeCirculation.PERCENTAGE_EXP_GAINED_PER_WEEK[2]
			local realIndex = 1
			local jobSeekDelayFact = employeeCirculation.JOB_SEEK_DELAY_FACT
			local chance = employeeCirculation.BUFFERED_EMPLOYEE_JOB_SEEKERS_CHANCE
			
			for key = 1, #employeeList do
				local employee = employeeList[realIndex]
				local roleData = employee:getRoleData()
				local highestMult = 0
				
				for skillID, multiplier in pairs(roleData.skillAdvanceModifier) do
					highestMult = math.max(highestMult, multiplier)
				end
				
				for skillID, multiplier in pairs(roleData.skillAdvanceModifier) do
					if highestMult <= multiplier then
						table.insert(self.mainSkills, skillID)
					end
				end
				
				for key, skillID in ipairs(self.mainSkills) do
					local expCurve = skills:getRequiredExperience(employee:getSkillLevel(skillID))
					local gainedExp = expCurve * math.randomf(gainMin, gainMax)
					
					skills:progressSkill(employee, skillID, gainedExp)
				end
				
				table.clearArray(self.mainSkills)
				
				local delay = employee:getFact(jobSeekDelayFact)
				
				if not delay or delay <= timeline.curTime then
					if chance >= math.random(1, 100) then
						local disappearTime = math.random(employeeCirculation.BUFFERED_MIN_TIME_TO_DISAPPEAR, employeeCirculation.BUFFERED_MAX_TIME_TO_DISAPPEAR)
						
						employee:applyDefaultSalary()
						
						if delay then
							employee:removeFact(jobSeekDelayFact)
						end
						
						self:addJobSeeker(employee, disappearTime)
						table.remove(employeeList, realIndex)
					else
						realIndex = realIndex + 1
					end
				else
					realIndex = realIndex + 1
				end
			end
		end
	end
end

function employeeCirculation:viewCandidatesCallback()
	employeeCirculation:createPendingCandidatesPopup()
end

function employeeCirculation:dismissCandidatesCallback()
	employeeCirculation:clearPendingCandidates()
end

function employeeCirculation:postKillPendingCandidatesPopup()
	employeeCirculation:onClosePendingCandidatesPopup()
end

function employeeCirculation:createPendingCandidatesConfirmPopup(removedListings)
	local text = employeeCirculation:getJobListingExpirationText(removedListings)
	local popup = gui.create("Popup")
	
	popup:setWidth(500)
	popup:setFont("pix24")
	popup:setTitle(_T("POTENTIAL_JOB_CANDIDATES_TITLE", "Potential Job Candidates"))
	popup:setTextFont("pix20")
	popup:setText(_format(_T("POTENTIAL_JOB_CANDIDATES_DESC", "REMOVED_LISTINGS\nThere are a total of CANDIDATES candidates for you to look over. Would you like to see the candidates or dismiss them?"), "REMOVED_LISTINGS", text, "CANDIDATES", #self.pendingCandidates))
	popup:hideCloseButton()
	popup:addButton("pix20", _T("VIEW_CANDIDATES", "View candidates"), employeeCirculation.viewCandidatesCallback)
	popup:addButton("pix20", _T("DISMISS_CANDIDATES", "Dismiss candidates"), employeeCirculation.dismissCandidatesCallback)
	popup:center()
	frameController:push(popup)
end

function employeeCirculation:onClosePendingCandidatesPopup()
	self.targetTeam = nil
	
	table.clearArray(self.pendingCandidates)
end

function employeeCirculation:createPendingCandidatesPopup()
	local frame = gui.create("FinalCandidatesFrame")
	
	frame:setSize(450, 550)
	frame:setFont("pix24")
	frame:setText(_T("POTENTIAL_JOB_CANDIDATES_TITLE", "Potential Job Candidates"))
	frame:center()
	
	frame.postKill = employeeCirculation.postKillPendingCandidatesPopup
	self.targetTeam = studio:getStudioTeam()
	
	local infoBox = gui.create("StudioEmploymentInfoDescbox")
	
	infoBox:setPos(frame.x + frame.w + _S(10), frame.y)
	infoBox:updateDisplay()
	infoBox:tieVisibilityTo(frame)
	infoBox:setShowEmployeeOverview(true)
	
	local scrollbar = gui.create("RoleScrollbarPanel", frame)
	
	scrollbar:setSize(frame.rawW - 10, frame.rawH - 70)
	scrollbar:setPos(_S(5), _S(30))
	scrollbar:setSpacing(3)
	scrollbar:setPadding(3, 3)
	scrollbar:addDepth(100)
	scrollbar:setAdjustElementPosition(true)
	
	local list = game.createRoleFilter(scrollbar, false)
	
	list:setPos(frame.x - list.w - _S(10), frame.y)
	scrollbar:setRoleFilterList(list)
	
	for key, candidate in ipairs(self.pendingCandidates) do
		local element = gui.create("JobListingCandidate")
		
		element:setWidth(430)
		element:setEmployee(candidate)
		scrollbar:addEmployeeItem(element)
	end
	
	local targetTeam = gui.create("JobCandidateTeamSelection", frame)
	
	targetTeam:setFont("bh24")
	targetTeam:updateText()
	targetTeam:setSize(250, 30)
	targetTeam:setPos(_S(5), frame.h - targetTeam.h - _S(5))
	
	local acceptAll = gui.create("AcceptAllCandidatesButton", frame)
	
	acceptAll:setSize(30, 30)
	acceptAll:setPos(targetTeam.localX + _S(5) + targetTeam.w, targetTeam.localY)
	acceptAll:setSearchData(searchData)
	acceptAll:setCandidateList(self.pendingCandidates)
	frameController:push(frame)
	
	self.removedListings = nil
end

function employeeCirculation:clearPendingCandidates()
	for key, candidate in ipairs(self.pendingCandidates) do
		if not candidate:getEmployer() then
			candidate:remove()
		end
		
		self.pendingCandidates[key] = nil
	end
	
	self.removedListings = nil
end

function employeeCirculation:viewMoreInfoCallback()
	self.employee:createEmployeeMenu()
end

function employeeCirculation:hireEmployeeCallback()
	employeeCirculation:finishHiringEmployee(self.employee)
end

function employeeCirculation:createJobListingEmployee(searchData)
	local interestList = #searchData.interests > 0 and searchData.interests or nil
	local employee = game.generateSpecificEmployee(nil, nil, searchData.level, searchData.role, nil, nil, nil, interestList)
	
	employee:applyDefaultSalary()
	
	searchData.totalOffers = searchData.totalOffers + 1
	searchData.candidates[#searchData.candidates + 1] = employee
end

function employeeCirculation:showOfferResultPopup(title, contents, employee)
	employeeCirculation.FORMAT_TABLE.NAME = employee:getFullName(true)
	employeeCirculation.FORMAT_TABLE.ROLE = attributes.profiler:getRoleName(employee:getRole())
	
	local popup = gui.create("Popup")
	
	popup:setWidth(450)
	popup:centerX()
	popup:setTextFont("pix20")
	popup:setFont("pix24")
	popup:setTitle(title)
	popup:setText(string.formatbykeys(contents, employeeCirculation.FORMAT_TABLE))
	popup:setDepth(105)
	popup:addButton(fonts.get("pix24"), "OK")
	popup:performLayout()
	popup:centerY()
	frameController:push(popup)
end

function employeeCirculation:createMaxWorkOffersPopup()
	local popup = gui.create("Popup")
	
	popup:setWidth(500)
	popup:setFont(fonts.get("pix24"))
	popup:setTitle(_T("MAX_WORK_OFFERS_TITLE", "Maximum Work Offers"))
	popup:setTextFont(fonts.get("pix24"))
	popup:setText(_T("MAX_WORK_OFFERS_DESCRIPTION", "Can not send any more job offers as you would run out of workplaces in case all of the currently offered work positions would be accepted."))
	popup:createOKButton(fonts.get("pix20"))
	popup:setDepth(105)
	popup:center()
	frameController:push(popup)
end

function employeeCirculation:createMaxOfficeCapacity()
	local popup = gui.create("Popup")
	
	popup:setWidth(500)
	popup:setFont(fonts.get("pix24"))
	popup:setTitle(_T("MAX_OFFICE_CAPACITY_TITLE", "Maximum Office Capacity"))
	popup:setTextFont(fonts.get("pix24"))
	popup:setText(_T("MAX_OFFICE_CAPACITY_DESCRIPTION", "Can not send any job offers as your office capacity is at its maximum at the moment."))
	popup:createOKButton(fonts.get("pix20"))
	popup:setDepth(105)
	popup:center()
	frameController:push(popup)
end

function employeeCirculation:createNoFreeWorkplacesPopup()
	local popup = gui.create("Popup")
	
	popup:setWidth(500)
	popup:setFont(fonts.get("pix24"))
	popup:setTitle(_T("NO_FREE_WORKPLACES_TITLE", "No Free Workplaces"))
	popup:setTextFont(fonts.get("pix24"))
	popup:setText(_T("NO_FREE_WORKPLACES_DESCRIPTION", "Can not send any job offers as you have no free workplaces."))
	popup:createOKButton(fonts.get("pix20"))
	popup:setDepth(105)
	popup:center()
	frameController:push(popup)
end

function employeeCirculation:createWouldReachMaxEmployeesPopup()
	local popup = gui.create("Popup")
	
	popup:setWidth(500)
	popup:setFont(fonts.get("pix24"))
	popup:setTitle(_T("EMPLOYEE_LIMIT_TITLE", "Employee Limit"))
	popup:setTextFont(fonts.get("pix20"))
	popup:setText(string.easyformatbykeys(_T("EMPLOYEE_LIMIT_DESCRIPTION", "Can not send any job offers as you would reach the LIMIT employee limit."), "LIMIT", game.MAX_EMPLOYEES))
	popup:createOKButton(fonts.get("pix20"))
	popup:setDepth(105)
	popup:center()
	frameController:push(popup)
end

function employeeCirculation:createMaxEmployeesReachedPopup()
	local popup = gui.create("Popup")
	
	popup:setWidth(500)
	popup:setFont(fonts.get("pix24"))
	popup:setTitle(_T("EMPLOYEE_LIMIT_REACHED_TITLE", "Employee Limit Reached"))
	popup:setTextFont(fonts.get("pix20"))
	popup:setText(string.easyformatbykeys(_T("EMPLOYEE_LIMIT_REACHED_DESCRIPTION", "Can not send any job offers as you have reached the LIMIT employee limit.\n\nPlease fire some of your employees before sending any more job offers."), "LIMIT", game.MAX_EMPLOYEES))
	popup:setDepth(105)
	popup:center()
	frameController:push(popup)
end

function employeeCirculation:generateJobSeeker(role, expertChance, skipAdding)
	expertChance = expertChance or employeeCirculation.EXPERT_CHANCE
	
	local isExpert = expertChance >= math.random(1, 100)
	local minTime, maxTime, minLevel, maxLevel
	
	if isExpert then
		minTime, maxTime = employeeCirculation.EXPERT_MIN_TIME_TO_DISAPPEAR, employeeCirculation.EXPERT_MAX_TIME_TO_DISAPPEAR
		minLevel = employeeCirculation.BASE_LEVEL + employeeCirculation.EXPERT_MIN_LEVEL_INCREASE
		maxLevel = minLevel + timeline:getPassedYears() * employeeCirculation.LEVEL_CAP_PER_YEAR + employeeCirculation.EXPERT_MAX_LEVEL_INCREASE
	else
		minTime, maxTime = employeeCirculation.MIN_TIME_TO_DISAPPEAR, employeeCirculation.MAX_TIME_TO_DISAPPEAR
		minLevel = employeeCirculation.BASE_LEVEL
		maxLevel = minLevel + timeline:getPassedYears() * employeeCirculation.LEVEL_CAP_PER_YEAR
	end
	
	local generated = self:_generateJobSeeker(minTime, maxTime, minLevel, maxLevel, role)
	
	if not skipAdding then
		self:addJobSeeker(generated, disappearTime)
	end
	
	return generated
end

function employeeCirculation:_generateJobSeeker(minTime, maxTime, minLevel, maxLevel, role, age)
	age = age or self:getRandomAge()
	minLevel = minLevel + self:getMinLevelModifierFromAge(age)
	maxLevel = maxLevel + self:getMaxLevelModifierFromAge(age)
	
	local level = math.min(math.random(minLevel, maxLevel), developer.MAX_LEVEL)
	local jobSeeker = game.generateSpecificEmployee(nil, nil, level, role, age)
	
	jobSeeker:applyDefaultSalary()
	
	local disappearTime = math.random(minTime, maxTime)
	
	return jobSeeker
end

function employeeCirculation:addJobSeeker(jobSeeker, disappearTime)
	if not jobSeeker.facts then
		assert(false, "attempt to add destroyed developer to employeeCirculation")
	end
	
	disappearTime = disappearTime or math.random(employeeCirculation.MIN_TIME_TO_DISAPPEAR, employeeCirculation.MAX_TIME_TO_DISAPPEAR)
	
	table.insert(self.jobSeekerTimeLeft, disappearTime)
	table.insert(self.jobSeekers, jobSeeker)
	
	if self.frame and self.frame:isValid() then
		self:addJobSeekerToMenu(jobSeeker)
	end
end

function employeeCirculation:hireJobSeeker(jobSeeker, index)
	self:finishHiringEmployee(jobSeeker)
	self:removeEmployee(jobSeeker, index)
end

function employeeCirculation:finishHiringEmployee(jobSeeker)
	local teamObj
	
	if self.targetTeam then
		teamObj = self.targetTeam
	else
		local targetTeam = jobSeeker:getTargetTeam()
		
		if targetTeam then
			teamObj = studio:getTeamByUniqueID(targetTeam)
		end
	end
	
	studio:hireEmployee(jobSeeker, teamObj)
	jobSeeker:getTeam():assignFreeEmployees()
end

studio.WORKPLACE_STATUS = {
	NO_WORKPLACES = 2,
	ALL_IN_USE = 1,
	MAX_WORK_OFFERS = 3,
	AVAILABLE = 4
}

function employeeCirculation:verifyJobOfferValidity()
	local state = studio:getWorkplaceStatus()
	
	if state == studio.WORKPLACE_STATUS.ALL_IN_USE then
		self:createMaxOfficeCapacity()
		
		return false
	elseif state == studio.WORKPLACE_STATUS.NO_WORKPLACES then
		self:createNoFreeWorkplacesPopup()
		
		return false
	elseif state == studio.WORKPLACE_STATUS.MAX_WORK_OFFERS then
		self:createMaxWorkOffersPopup()
		
		return false
	elseif state == studio.WORKPLACE_STATUS.MAX_EMPLOYEES_REACHED then
		self:createMaxEmployeesReachedPopup()
		
		return false
	end
	
	return true
end

function employeeCirculation:verifyJobSearchAvailability()
	local state = studio:getWorkplaceStatus()
	
	if state == studio.WORKPLACE_STATUS.ALL_IN_USE or state == studio.WORKPLACE_STATUS.NO_WORKPLACES then
		return _T("JOB_SEARCH_NO_WORKPLACES_AVAILABLE", "You currently have no free workplaces. Are you sure you want to add this job offer?")
	elseif state == studio.WORKPLACE_STATUS.MAX_WORK_OFFERS then
		return _T("JOB_SEARCH_NO_WORKPLACES_MAX_WORK_OFFERS", "The job offers you sent out could use up all available workplaces. Are you sure you want to add this job offer?")
	end
	
	return nil
end

function employeeCirculation:verifyCandidateWorkplaceAvailability()
	local state = studio:getWorkplaceStatus()
	
	if state == studio.WORKPLACE_STATUS.ALL_IN_USE or state == studio.WORKPLACE_STATUS.NO_WORKPLACES then
		return _T("CANDIDATE_NO_WORKPLACES_AVAILABLE", "You currently have no free workplaces. Are you sure you want to hire this candidate?")
	elseif state == studio.WORKPLACE_STATUS.MAX_WORK_OFFERS then
		return _T("CANDIDATE_NO_WORKPLACES_MAX_WORK_OFFERS", "The job offers you sent out could use up all available workplaces. Are you sure you want to hire this candidate?")
	end
	
	return nil
end

employeeCirculation.targetTeamDescboxID = "target_team_descbox"

function employeeCirculation:createTeamAssignmentPopup(jobSeeker, jobSeekerElement)
	local frame = gui.create("Frame")
	
	frame:setAnimated(false)
	frame:setFadeIn(true)
	frame:setSize(400, 600)
	frame:setFont("pix24")
	frame:setText(_T("SELECT_MEMBER_TEAM", "Select member team"))
	frame:center()
	
	local scroller = gui.create("ScrollbarPanel", frame)
	
	scroller:setPos(_S(5), _S(35))
	scroller:setSize(390, 560)
	scroller:setSpacing(3)
	scroller:setPadding(3, 3)
	scroller:addDepth(50)
	scroller:setAdjustElementPosition(true)
	
	local id = employeeCirculation.targetTeamDescboxID
	
	for key, teamObj in ipairs(studio:getTeams()) do
		local element = gui.create("TargetTeamJobSeeker")
		
		element:setThoroughDescription(true)
		element:setJobSeeker(jobSeeker)
		element:setSize(scroller.rawW - 20, 10)
		element:setTeam(teamObj)
		element:setJobSeekerElement(jobSeekerElement)
		element:updateDescbox()
		
		element.descboxID = id
		element.basePanel = frame
		
		scroller:addItem(element)
	end
	
	local teamDescbox = gui.create("TeamInfoDescbox")
	
	teamDescbox:setShowPenaltyDescription(false)
	teamDescbox:setID(id)
	teamDescbox:tieVisibilityTo(frame)
	teamDescbox:hideDisplay()
	teamDescbox:setPos(frame.x + frame.w + _S(10), frame.y)
	frameController:push(frame)
end

function employeeCirculation:revokeJobOffer(jobSeeker)
	jobSeeker:removeWorkOffer()
end

function employeeCirculation:offerJob(jobSeeker, targetTeam)
	jobSeeker:offerJob(targetTeam)
	events:fire(employeeCirculation.EVENTS.JOB_OFFER_SENT, jobSeeker)
end

function employeeCirculation:removeEmployee(employee, index)
	if index then
		table.remove(self.jobSeekers, index)
		table.remove(self.jobSeekerTimeLeft, index)
	else
		for key, otherEmployee in ipairs(self.jobSeekers) do
			if otherEmployee == employee then
				table.remove(self.jobSeekers, key)
				table.remove(self.jobSeekerTimeLeft, key)
				
				break
			end
		end
	end
end

function employeeCirculation:rollEmployeeGeneration()
	if #self.jobSeekers < employeeCirculation.MAX_JOB_SEEKERS and math.random(1, 100) <= employeeCirculation.NEW_EMPLOYEE_CHANCE then
		self:generateJobSeeker()
	end
end

function employeeCirculation:addJobSeekerToMenu(employeeObj)
	local seekerDisplay = gui.create("JobSeekerDisplay")
	
	seekerDisplay:setSize(410, 20)
	seekerDisplay:setEmployee(employeeObj)
	seekerDisplay:setBasePanel(self.frame)
	
	if employeeObj:hasOfferedWork() then
		self.sentCategory:addItem(seekerDisplay, true)
	else
		self.unsentCategory:addItem(seekerDisplay, true)
	end
	
	self.scroller:accountEmployeeItem(seekerDisplay)
end

function employeeCirculation.postKillFrame(frame)
	if frame.roleCountList then
		frame.roleCountList:kill()
	end
end

employeeCirculation.roleCountListColor = color(0, 0, 0, 200)

function employeeCirculation:toggleMenu()
	if self.frame and self.frame:isValid() then
		frameController:pop()
	end
	
	self.frame = gui.create("Frame")
	
	self.frame:setSize(450, 600)
	self.frame:setFont(fonts.get("pix24"))
	self.frame:setTitle(_T("JOB_SEEKERS_TITLE", "Job Seekers"))
	self.frame:center()
	self.frame:setCloseKey(keyBinding:getCommandKey(keyBinding.COMMANDS.JOB_SEEKERS))
	
	self.frame.postKill = employeeCirculation.postKillFrame
	
	local propertySheet = gui.create("PropertySheet", self.frame)
	
	propertySheet:setSize(440, 575)
	propertySheet:setPos(_S(5), _S(35))
	propertySheet:setFont(fonts.get("bh24"))
	
	local jobSeekersPanel = gui.create("Panel")
	
	jobSeekersPanel:setSize(440, 528)
	
	jobSeekersPanel.shouldDraw = false
	
	local scrollBarPanel = gui.create("RoleScrollbarPanel", jobSeekersPanel)
	
	scrollBarPanel:setSize(440, 528)
	scrollBarPanel:setAdjustElementPosition(true)
	scrollBarPanel:setPadding(3, 3)
	scrollBarPanel:setSpacing(3)
	scrollBarPanel:addDepth(50)
	
	self.scroller = scrollBarPanel
	
	local unsentCategory = gui.create("Category")
	
	unsentCategory:setFont("pix26")
	unsentCategory:setText(_T("AVAILABLE_JOB_SEEKERS", "Available job seekers"))
	
	unsentCategory.unsentCategory = true
	self.unsentCategory = unsentCategory
	
	scrollBarPanel:addItem(unsentCategory)
	unsentCategory:assumeScrollbar(scrollBarPanel)
	
	local sentCategory = gui.create("Category")
	
	sentCategory:setFont("pix26")
	sentCategory:setText(_T("WAITING_FOR_RESPONSE", "Waiting for response from"))
	
	sentCategory.sentCategory = true
	self.sentCategory = sentCategory
	
	scrollBarPanel:addItem(sentCategory)
	sentCategory:assumeScrollbar(scrollBarPanel)
	propertySheet:addItem(jobSeekersPanel, _T("JOB_SEEKERS", "Job seekers"), nil, nil, nil)
	
	local infoBox = gui.create("StudioEmploymentInfoDescbox")
	
	infoBox:setPos(self.frame.x + self.frame.w + _S(10), self.frame.y)
	infoBox:updateDisplay()
	infoBox:tieVisibilityTo(self.frame)
	infoBox:setShowEmployeeOverview(true)
	
	local list = game.createRoleFilter(scrollBarPanel)
	
	list:setPos(self.frame.x - list.w - _S(10), self.frame.y)
	scrollBarPanel:setRoleFilterList(list)
	
	self.frame.roleCountList = roleCountList
	
	for key, employeeObj in ipairs(self.jobSeekers) do
		self:addJobSeekerToMenu(employeeObj)
	end
	
	local searchPanel = gui.create("Panel")
	
	searchPanel:setSize(440, 528)
	
	searchPanel.shouldDraw = false
	
	local searchSetup = gui.create("EmployeeSearchSetup", searchPanel)
	
	searchSetup:setSize(440, 112)
	searchSetup:createElements()
	
	local scrollBarPanel = gui.create("JobListingScrollbar", searchPanel)
	
	scrollBarPanel:setSize(440, 528 - searchSetup.rawH - 5)
	scrollBarPanel:setAdjustElementPosition(true)
	scrollBarPanel:setPadding(3, 3)
	scrollBarPanel:setSpacing(3)
	scrollBarPanel:addDepth(50)
	scrollBarPanel:setPos(0, searchSetup.localY + searchSetup.h + _S(5))
	scrollBarPanel:fillListings()
	propertySheet:addItem(searchPanel, _T("JOB_SEEKER_SEARCH_TAB", "Search"), nil, nil, nil)
	frameController:push(self.frame)
	game.setCurrentWindow(self.frame)
	events:fire(employeeCirculation.EVENTS.OPENED_MENU)
end

function employeeCirculation:save()
	local searches = {}
	
	for key, data in ipairs(self.employeeSearches) do
		local candidates = {}
		
		searches[key] = {
			level = data.level,
			budget = data.budget,
			role = data.role,
			timeLeft = data.timeLeft,
			interests = data.interests,
			totalOffers = data.totalOffers,
			candidates = candidates
		}
		
		for candKey, candidate in ipairs(data.candidates) do
			candidates[candKey] = candidate:save()
		end
	end
	
	local saved = {
		jobSeekers = {},
		bufferedPastEmployees = {},
		employeeSearches = searches
	}
	
	for key, employee in ipairs(self.jobSeekers) do
		table.insert(saved.jobSeekers, employee:save())
	end
	
	for key, employee in ipairs(self.bufferedPastEmployees) do
		table.insert(saved.bufferedPastEmployees, employee:save())
	end
	
	if self.pendingCandidates and #self.pendingCandidates > 0 then
		saved.pendingCandidates = {}
		saved.removedListings = self.removedListings
		
		for key, candidate in ipairs(self.pendingCandidates) do
			saved.pendingCandidates[key] = candidate:save()
		end
	end
	
	saved.jobSeekerTimeLeft = self.jobSeekerTimeLeft
	
	return saved
end

function employeeCirculation:load(data)
	for key, employeeData in ipairs(data.jobSeekers) do
		local timeUntilGone = data.jobSeekerTimeLeft[key]
		local employee = developer.new()
		
		employee:load(employeeData)
		
		self.jobSeekers[key] = employee
	end
	
	for key, employeeData in ipairs(data.bufferedPastEmployees) do
		local employee = developer.new()
		
		employee:load(employeeData)
		
		self.bufferedPastEmployees[key] = employee
	end
	
	self.jobSeekerTimeLeft = data.jobSeekerTimeLeft
	
	for key, searchData in ipairs(data.employeeSearches) do
		local loadedCandidates = {}
		
		if searchData.candidates then
			for key, candidateData in ipairs(searchData.candidates) do
				local employee = developer.new()
				
				employee:load(candidateData)
				
				loadedCandidates[key] = employee
			end
		end
		
		searchData.candidates = loadedCandidates
	end
	
	self.employeeSearches = data.employeeSearches or self.employeeSearches
	
	for key, data in ipairs(self.employeeSearches) do
		data.successChance = self:getEmployeeSearchChance(data)
	end
	
	if data.pendingCandidates then
		self.removedListings = data.removedListings
		
		for key, candData in ipairs(data.pendingCandidates) do
			local dev = developer.new()
			
			dev:load(candData)
			
			self.pendingCandidates[key] = dev
		end
	end
end

function employeeCirculation:postLoad()
	if self.pendingCandidates and #self.pendingCandidates > 0 then
		self:createPendingCandidatesConfirmPopup(self.removedListings)
		
		self.removedListings = nil
	end
end
