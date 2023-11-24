interactionRestrictor = {}
interactionRestrictor.unlockCallbacks = {}
interactionRestrictor.restrictCallbacks = {}

function interactionRestrictor:init()
	self.restrictedActions = self.restrictedActions or {}
	self.unlockedActions = self.unlockedActions or {}
end

function interactionRestrictor:remove()
	table.clear(self.restrictedActions)
	table.clear(self.unlockedActions)
end

function interactionRestrictor:restrictAction(actionID)
	self.restrictedActions[actionID] = true
	self.unlockedActions[actionID] = nil
	
	if self.restrictCallbacks[actionID] then
		self.restrictCallbacks[actionID]()
	end
end

function interactionRestrictor:addUnlockCallback(actionID, callback)
	self.unlockCallbacks[actionID] = callback
end

function interactionRestrictor:addRestrictCallback(actionID, callback)
	self.restrictCallbacks[actionID] = callback
end

function interactionRestrictor:restrictActions(actionList)
	for key, actionID in ipairs(actionList) do
		self.restrictedActions[actionID] = true
		
		if self.restrictCallbacks[actionID] then
			self.restrictCallbacks[actionID]()
		end
	end
end

function interactionRestrictor:canPerformAction(actionID)
	return not self.restrictedActions[actionID]
end

function interactionRestrictor:unlockAction(action)
	self.unlockedActions[action] = true
	self.restrictedActions[action] = nil
	
	if self.unlockCallbacks[action] then
		self.unlockCallbacks[action]()
	end
end

function interactionRestrictor:unlockActions()
	for actionID, state in pairs(self.unlockedActions) do
		self.restrictedActions[actionID] = nil
		
		if self.unlockCallbacks[actionID] then
			self.unlockCallbacks[actionID]()
		end
	end
end

function interactionRestrictor:save()
	return {
		restrictedActions = self.restrictedActions,
		unlockedActions = self.unlockedActions
	}
end

function interactionRestrictor:load(data)
	self.unlockedActions = data.unlockedActions or self.unlockedActions
	self.restrictedActions = data.restrictedActions or self.restrictedActions
	
	self:unlockActions()
	
	for actionID, state in pairs(self.restrictedActions) do
		if self.restrictCallbacks[actionID] then
			self.restrictCallbacks[actionID]()
		end
	end
end

require("game/interaction_restrictor_register")
