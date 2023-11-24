local fanWork = {}

fanWork.id = "fan_wants_to_work"
fanWork.eventRequirement = timeline.EVENTS.NEW_WEEK
fanWork.rollMin = 1
fanWork.rollMax = 300
fanWork.cooldownFact = "fan_wants_to_work_cooldown"
fanWork.timeCooldown = timeline.DAYS_IN_MONTH * 6
fanWork.occurChance = 1
fanWork.minimumReputation = 100
fanWork.expertChance = 20
fanWork.baseSalary = -200
fanWork.workplaceValidityStates = {
	[studio.WORKPLACE_STATUS.ALL_IN_USE] = true,
	[studio.WORKPLACE_STATUS.MAX_WORK_OFFERS] = true,
	[studio.WORKPLACE_STATUS.AVAILABLE] = true
}
fanWork.mentionWorkplacesStates = {
	[studio.WORKPLACE_STATUS.ALL_IN_USE] = true,
	[studio.WORKPLACE_STATUS.MAX_WORK_OFFERS] = true
}

function fanWork:canOccur(event)
	if studio:getReputation() <= self.minimumReputation then
		return false
	end
	
	local lastFan = studio:getFact(self.cooldownFact)
	
	if lastFan and timeline.curTime < lastFan + fanWork.timeCooldown then
		return false
	end
	
	local workplaceStatus = studio:getWorkplaceStatus()
	
	self.workplaceStatus = workplaceStatus
	
	if not self.workplaceValidityStates[workplaceStatus] then
		return false
	end
	
	return true
end

local function nonPlayerCharacterCheck(employee)
	return not employee:isPlayerCharacter()
end

function fanWork:occur()
	local employee = studio:getRandomEmployeeByCriteria(nonPlayerCharacterCheck)
	
	if employee then
		local dialogueObject = dialogueHandler:addDialogue("fan_wants_to_work_start", nil, employee)
		local fan = employeeCirculation:generateJobSeeker(attributes.profiler.roles[math.random(1, #attributes.profiler.roles)], self.expertChance, true)
		
		fan:applyDefaultSalary()
		fan:setBaseSalary(self.baseSalary)
		
		if self.mentionWorkplacesStates[self.workplaceStatus] then
			dialogueObject:setFact("no_workplaces", true)
		end
		
		dialogueObject:setFact("fan", fan)
		studio:setFact(self.cooldownFact, timeline.curTime)
	end
end

randomEvents:registerNew(fanWork)
require("game/random_events/fan_wants_to_work_dialogues")
