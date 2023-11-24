developerActions = {}
developerActions.registered = {}
developerActions.registeredByID = {}
developerActions.validActionPerformers = {}
developerActions.eligibleActions = {}
developerActions.validActions = {}
developerActions.activeActions = {}
developerActions.lastActionTime = 0
developerActions.TIME_BETWEEN_ACTION_ATTEMPTS = 3
developerActions.TIME_BETWEEN_SAME_ACTION_PERFORM = 25

local defaultActionFuncs = {}

defaultActionFuncs.mtindex = {
	__index = defaultActionFuncs
}

function defaultActionFuncs:isEligible(officeObject)
	return true
end

function defaultActionFuncs:canPick(target)
	return true
end

function defaultActionFuncs:isDone()
	return false
end

function defaultActionFuncs:isAborted()
	return self.aborted
end

function defaultActionFuncs:onPathInvalidated()
	return true
end

function defaultActionFuncs:init(target)
end

function defaultActionFuncs:abort(target)
	self.aborted = true
end

function defaultActionFuncs:finish(target)
end

function defaultActionFuncs:begin(target)
end

function defaultActionFuncs:update(dt)
end

function defaultActionFuncs:isSameFloor()
	return self.employee:getFloor() == self.targetObject:getFloor()
end

function defaultActionFuncs:onFinishedWalking()
end

function defaultActionFuncs:onPathFound(pathObj)
end

function defaultActionFuncs:reset()
	self.aborted = false
end

local activeAction = {}

activeAction.mtindex = {
	__index = activeAction
}

function activeAction:init(target, actionObj)
	self.target = target
	self.actionObj = actionObj
end

function activeAction:update(dt)
	local actionObj = self.actionObj
	local devObj = self.target
	
	actionObj:update(dt)
	
	if actionObj:isDone() then
		self:finish()
		
		return false
	end
	
	return true
end

function activeAction:onPathFound(pathObj)
	self.actionObj:onPathFound(pathObj)
end

function activeAction:onFinishedWalking(lastIndex)
	self.actionObj:onFinishedWalking(lastIndex)
end

function activeAction:begin()
	self.actionObj:begin(self.target)
	developerActions:addActiveAction(self)
end

function activeAction:applyCooldown()
	local devObj = self.target
	local passedTime = timeline:getPassedTime()
	
	devObj:setActionCooldown(passedTime + developer.ACTION_DELAY)
	devObj:setLastAction(self.actionObj.id, -developer.ACTION_DELAY)
end

function activeAction:finish()
	self:applyCooldown()
	self.actionObj:finish()
	self.target:setCurrentAction(nil)
	developerActions:removeActiveAction(self)
end

function activeAction:abort()
	self:applyCooldown()
	
	local devObj = self.target
	
	self.actionObj:abort()
	devObj:setCurrentAction(nil)
	developerActions:removeActiveAction(self)
end

function activeAction:onPathInvalidated()
	return self.actionObj:onPathInvalidated()
end

function developerActions.registerNew(data, inherit)
	table.insert(developerActions.registered, data)
	
	developerActions.registeredByID[data.id] = data
	
	if inherit then
		setmetatable(data, developerActions.registeredByID[inherit].mtindex)
		
		data.baseClass = developerActions.registeredByID[inherit]
	else
		setmetatable(data, defaultActionFuncs.mtindex)
		
		data.baseClass = defaultActionFuncs
	end
	
	data.mtindex = {
		__index = data
	}
end

function developerActions.create(id, target)
	local newAction = {}
	
	setmetatable(newAction, developerActions.registeredByID[id].mtindex)
	newAction:init(target)
	
	local newActionContainer = {}
	
	setmetatable(newActionContainer, activeAction.mtindex)
	newActionContainer:init(target, newAction)
	
	return newActionContainer
end

function developerActions:addActiveAction(act)
	table.insert(self.activeActions, act)
end

function developerActions:removeActiveAction(act)
	table.removeObject(self.activeActions, act)
end

function developerActions:update(dt)
	local curTime = timeline.curTime
	
	if curTime > self.lastActionTime and studio:isPathfinderFree() then
		self:attemptPerformAction()
	end
	
	local actions = self.activeActions
	
	if #actions > 0 then
		local rIdx = 1
		
		for i = 1, #actions do
			local act = actions[rIdx]
			
			if act:update(dt) then
				rIdx = rIdx + 1
			end
		end
	end
end

function developerActions:remove()
	self.lastActionTime = 0
	
	for key, actionData in ipairs(self.registered) do
		actionData:reset()
	end
	
	table.clearArray(self.activeActions)
end

function developerActions:attemptPerformAction()
	local randomOffice = studio:getOwnedBuildings()
	
	if #randomOffice == 0 then
		return 
	end
	
	randomOffice = randomOffice[math.random(1, #randomOffice)]
	
	local employees = self:getValidActionPerformers(randomOffice)
	local eligibleActions = self:getEligibleActions(randomOffice)
	
	while true do
		local randomEmployeeIndex = math.random(1, #employees)
		local employee = employees[randomEmployeeIndex]
		
		if not employee then
			break
		else
			table.remove(employees, randomEmployeeIndex)
			
			local validActions = self:getValidActions(employee)
			local randomIndex = math.random(1, #validActions)
			local randomAction = validActions[randomIndex]
			
			if randomAction then
				local action = developerActions.create(randomAction.id, employee)
				
				employee:setCurrentAction(action)
				
				break
			end
		end
	end
	
	self.lastActionTime = timeline.curTime + self.TIME_BETWEEN_ACTION_ATTEMPTS
	
	table.clearArray(employees)
	table.clearArray(eligibleActions)
	table.clearArray(self.validActions)
	table.clearArray(self.validActionPerformers)
end

function developerActions:getValidActionPerformers(officeObject)
	local passedTime = timeline:getPassedTime()
	
	for key, employee in ipairs(officeObject:getEmployees()) do
		if employee:getWorkplace() and not employee:getCurrentAction() and not employee:getWalkPath() and employee:isCooldownOver() and not employee:getConversation() then
			table.insert(self.validActionPerformers, employee)
		end
	end
	
	return self.validActionPerformers
end

function developerActions:getEligibleActions(officeObject)
	table.clearArray(self.eligibleActions)
	
	for key, actionData in ipairs(developerActions.registered) do
		if actionData:isEligible(officeObject) then
			table.insert(self.eligibleActions, actionData)
		end
	end
	
	return developerActions.eligibleActions
end

function developerActions:getValidActions(employee)
	local passedTime = timeline:getPassedTime()
	
	for key, actionData in ipairs(self.eligibleActions) do
		if employee:getAvatar():isAnimQueueEmpty() and actionData:canPick(employee) and passedTime > employee:getLastActionIDTime(actionData.id) + developerActions.TIME_BETWEEN_SAME_ACTION_PERFORM then
			table.insert(self.validActions, actionData)
		end
	end
	
	return self.validActions
end

local useWaterDispenser = {}

useWaterDispenser.id = "use_water_dispenser"
useWaterDispenser.targetObjectClass = "water_dispenser"
useWaterDispenser.interactTime = 1
useWaterDispenser.validObjects = {}

function useWaterDispenser:reset()
	table.clearArray(self.validObjects)
	
	self.done = false
end

function useWaterDispenser:init(target)
	self.employee = target
	self.done = false
	
	events:addFunctionReceiver(self, useWaterDispenser.handleObjectSell, studio.expansion.EVENTS.REMOVED_OBJECT)
end

function useWaterDispenser:finish()
	useWaterDispenser.baseClass.finish(self)
	self:removeEventHandler()
end

function useWaterDispenser:removeEventHandler()
	events:removeFunctionReceiver(self, studio.expansion.EVENTS.REMOVED_OBJECT)
end

function useWaterDispenser:handleObjectSell(object)
	if object == self.targetObject then
		self.employee:abortCurrentAction()
	end
end

function useWaterDispenser:isEligible(officeObject)
	table.clearArray(self.validObjects)
	
	local list = officeObject:getObjectsByClass(self.targetObjectClass)
	
	if list then
		for key, object in ipairs(list) do
			if object:isPartOfValidRoom() and object:isValidForInteraction() and not object:getInteractionTarget() then
				self.validObjects[#self.validObjects + 1] = object
			end
		end
	end
	
	return #self.validObjects > 0
end

function useWaterDispenser:canPick(target)
	return target:isThirsty()
end

function useWaterDispenser:begin(target)
	local randomIndex = math.random(1, #self.validObjects)
	local randomObject = self.validObjects[randomIndex]
	
	self.employee = target
	self.targetObject = randomObject
	
	randomObject:setInteractionTarget(target)
	table.clearArray(self.validObjects)
end

function useWaterDispenser:isDone()
	return self.done
end

function useWaterDispenser:abort(target)
	useWaterDispenser.baseClass.abort(self, target)
	self.employee:setWalkPath(nil)
	
	self.employee = nil
	
	self.targetObject:setInteractionTarget(nil)
	
	self.targetObject = nil
	
	self:removeEventHandler()
end

function useWaterDispenser:onPathInvalidated()
	return self.targetObject:isValidForInteraction()
end

function useWaterDispenser:onPathFound(pathObj)
end

function useWaterDispenser:update(dt)
	if self.facing and self.employee:getAvatar():isAnimQueueEmpty() then
		self.done = true
		
		self.targetObject:setInteractionTarget(nil)
	end
end

function useWaterDispenser:onFinishedWalking(index)
	if self:isSameFloor() then
		self.facing = true
		
		self.employee:faceObject(self.targetObject)
	end
end

developerActions.registerNew(useWaterDispenser)

local goToToilet = {}

goToToilet.id = "go_to_toilet"
goToToilet.targetObjectClass = "toilet"
goToToilet.validToilets = {}
goToToilet.toiletVisitTime = {
	5,
	25
}
goToToilet.EVENT_SHITTING = "shitting"

function goToToilet:init(target)
	self.waitTime = nil
	self.done = false
	
	events:addFunctionReceiver(self, goToToilet.handleObjectSell, studio.expansion.EVENTS.REMOVED_OBJECT)
end

function goToToilet:handleObjectSell(object)
	if object == self.targetObject then
		self.employee:abortCurrentAction()
	end
end

function goToToilet:reset()
	table.clearArray(self.validToilets)
end

function goToToilet:onPathInvalidated()
	return self.targetObject:isValidForInteraction()
end

function goToToilet:isEligible(officeObject)
	table.clearArray(self.validToilets)
	
	local list = officeObject:getObjectsByClass(self.targetObjectClass)
	
	if list then
		for key, object in ipairs(list) do
			if object:isPartOfValidRoom() and object:isValidForInteraction() and not object:getInteractionTarget() then
				self.validToilets[#self.validToilets + 1] = object
			end
		end
	end
	
	return #self.validToilets > 0
end

function goToToilet:canPick(target)
	return target:canShit()
end

function goToToilet:abort(target)
	goToToilet.baseClass.abort(self, target)
	
	self.employee = nil
	
	self.targetObject:setInteractionTarget(nil)
	
	self.targetObject = nil
	
	self:removeEventHandler()
end

function goToToilet:begin(target)
	local randomIndex = math.random(1, #goToToilet.validToilets)
	local randomToilet = goToToilet.validToilets[randomIndex]
	
	self.employee = target
	self.targetObject = randomToilet
	
	randomToilet:setInteractionTarget(target)
	table.clearArray(self.validToilets)
end

function goToToilet:isDone()
	return self.done
end

function goToToilet:finish()
	if self.targetObject then
		self.targetObject:playSound("use_toilet", true)
	end
	
	self:removeEventHandler()
end

function goToToilet:removeEventHandler()
	events:removeFunctionReceiver(self, studio.expansion.EVENTS.REMOVED_OBJECT)
end

function goToToilet:onFinishedWalking(index)
	if self:isSameFloor() then
		self.employee:faceObject(self.targetObject)
		
		self.waitTime = math.random(goToToilet.toiletVisitTime[1], goToToilet.toiletVisitTime[2])
		
		events:fire(goToToilet.EVENT_SHITTING, self.targetObject, self.employee)
	end
end

function goToToilet:update(dt)
	if self.waitTime then
		if self.waitTime <= 0 then
			self.done = true
			
			self.targetObject:setInteractionTarget(nil)
		else
			self.waitTime = self.waitTime - dt
		end
	end
end

developerActions.registerNew(goToToilet)

local useVendingMachine = {}

useVendingMachine.id = "use_vending_machine"
useVendingMachine.targetObjectClass = "snack_vending_machine"
useVendingMachine.interactTime = 1
useVendingMachine.validObjects = {}

function useVendingMachine:canPick(target)
	return target:isHungry()
end

developerActions.registerNew(useVendingMachine, "use_water_dispenser")

local useCoffeeMachine = {}

useCoffeeMachine.id = "use_coffee_machine"
useCoffeeMachine.targetObjectClass = "coffee_machine"
useCoffeeMachine.interactTime = 1
useCoffeeMachine.validObjects = {}

function useCoffeeMachine:canPick(target)
	return (target:getFact("coffee") or 0) <= 0
end

developerActions.registerNew(useCoffeeMachine, "use_water_dispenser")

local useGumballMachine = {}

useGumballMachine.id = "use_gumball_machine"
useGumballMachine.targetObjectClass = "gumball_machine"
useGumballMachine.interactTime = 1
useGumballMachine.validObjects = {}

function useGumballMachine:canPick(target)
	return target:isHungry()
end

developerActions.registerNew(useGumballMachine, "use_water_dispenser")

local checkServers = {}

checkServers.id = "check_servers"
checkServers.targetObjectClass = "server_rack"
checkServers.validServers = {}
checkServers.waitTime = {
	2,
	5
}
checkServers.textValid = {
	low = {
		_T("SERVER_CHECK_EMPLOYEE_LOW_1", "Great, server loads are at a low level."),
		_T("SERVER_CHECK_EMPLOYEE_LOW_2", "Servers seem to be at a low load.")
	},
	medium = {
		_T("SERVER_CHECK_EMPLOYEE_MEDIUM_1", "Servers are under decent load, but fine nonetheless."),
		_T("SERVER_CHECK_EMPLOYEE_MEDIUM_2", "Servers are moderately loaded...")
	},
	high = {
		_T("SERVER_CHECK_EMPLOYEE_HIGH_1", "Servers are near maximum capacity..."),
		_T("SERVER_CHECK_EMPLOYEE_HIGH_2", "Hm, might need to expand on the servers soon.")
	},
	overloaded = {
		_T("SERVER_CHECK_EMPLOYEE_OVERLOAD_1", "Oh dear, the servers are overloaded."),
		_T("SERVER_CHECK_EMPLOYEE_OVERLOAD_2", "Might need to let our boss know the servers are overloaded.")
	}
}
checkServers.textInvalid = {
	normal = {
		_T("SERVER_CHECK_EMPLOYEE_NO_CLUE_NORMAL_1", "Well, it looks fine to me, what do I know."),
		_T("SERVER_CHECK_EMPLOYEE_NO_CLUE_NORMAL_2", "Hm, it looks OK, I guess.")
	},
	overloaded = {
		_T("SERVER_CHECK_EMPLOYEE_NO_CLUE_OVERLOADED_1", "Says 'overloaded' here..."),
		_T("SERVER_CHECK_EMPLOYEE_NO_CLUE_OVERLOADED_2", "Hmm, this red 'overloaded' text is no joke, probably.")
	}
}

function checkServers:init(target)
	self.stayStill = nil
	self.done = false
	
	events:addFunctionReceiver(self, checkServers.handleObjectSell, studio.expansion.EVENTS.REMOVED_OBJECT)
end

function checkServers:finish()
	local serverUse = studio:getServerUsePercentage()
	
	if self.employee:getRole() == "software_engineer" then
		local text
		
		if serverUse <= 0.4 then
			text = self.textValid.low
		elseif serverUse <= 0.7 then
			text = self.textValid.medium
		elseif serverUse <= 1 then
			text = self.textValid.high
		else
			text = self.textValid.overloaded
		end
		
		self.employee:setTalkText(text[math.random(1, #text)], nil)
	else
		local text
		
		if serverUse <= 1 then
			text = self.textInvalid.normal
		else
			text = self.textInvalid.overloaded
		end
		
		self.employee:setTalkText(text[math.random(1, #text)], nil)
	end
	
	self:removeEventHandler()
end

function checkServers:handleObjectSell(object)
	if object == self.targetObject then
		self.employee:abortCurrentAction()
	end
end

function checkServers:reset()
	table.clearArray(self.validServers)
end

function checkServers:onPathInvalidated()
	return self.targetObject:isValidForInteraction()
end

function checkServers:isEligible(officeObject)
	table.clearArray(self.validServers)
	
	local list = officeObject:getObjectsByClass(self.targetObjectClass)
	
	if list then
		for key, object in ipairs(list) do
			if object:isPartOfValidRoom() and object:isValidForInteraction() and not object:getInteractionTarget() then
				self.validServers[#self.validServers + 1] = object
			end
		end
	end
	
	return #self.validServers > 0
end

function checkServers:canPick(target)
	return true
end

function checkServers:abort(target)
	checkServers.baseClass.abort(self, target)
	
	self.employee = nil
	
	self.targetObject:setInteractionTarget(nil)
	
	self.targetObject = nil
	
	self:removeEventHandler()
end

function checkServers:begin(target)
	local randomIndex = math.random(1, #checkServers.validServers)
	local randomServer = checkServers.validServers[randomIndex]
	
	self.employee = target
	self.targetObject = randomServer
	
	randomServer:setInteractionTarget(target)
	table.clearArray(self.validServers)
end

function checkServers:isDone()
	return self.done
end

function checkServers:removeEventHandler()
	events:removeFunctionReceiver(self, studio.expansion.EVENTS.REMOVED_OBJECT)
end

function checkServers:onFinishedWalking(index)
	if self:isSameFloor() then
		self.employee:faceObject(self.targetObject)
		self.employee:setAnimation(self.employee:getStandAnimation())
		
		self.stayStill = math.random(checkServers.waitTime[1], checkServers.waitTime[2])
	end
end

function checkServers:update(dt)
	if self.stayStill then
		if self.stayStill <= 0 then
			self.done = true
			
			self.targetObject:setInteractionTarget(nil)
		else
			self.stayStill = self.stayStill - dt
		end
	end
end

developerActions.registerNew(checkServers)
