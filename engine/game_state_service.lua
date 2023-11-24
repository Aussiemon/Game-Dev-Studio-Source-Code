gameStateService = {}
gameStateService.states = {}

function gameStateService:addState(state)
	table.insert(self.states, state)
end

function gameStateService:removeState(state)
	table.removeObject(self.states, state)
end

function gameStateService:updateStates(dt)
	for key, state in ipairs(self.states) do
		state:update(dt)
	end
end
