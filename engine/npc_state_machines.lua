registered.npcStateMachines = {}
npcStateMachine = {}

function register.npcStateMachine(stateMachine)
	print("registering new state machine called " .. stateMachine.name)
	
	registered.npcStateMachines[stateMachine.name] = stateMachine
	stateMachine.mtindex = {
		__index = stateMachine
	}
	
	print(stateMachine, stateMachine.saveToFile, stateMachine.resetPointPickValues)
end

function npcStateMachine.initialize(entity, stateMachineName, ...)
	local stateMachine = registered.npcStateMachines[stateMachineName]
	
	if stateMachine then
		local newStateMachine = {}
		
		setmetatable(newStateMachine, stateMachine.mtindex)
		
		newStateMachine.host = entity
		entity.stateMachine = newStateMachine
		
		if newStateMachine.initFunc then
			newStateMachine.initFunc(entity, ...)
		end
		
		if newStateMachine.handleEvent then
			events:addReceiver(newStateMachine)
		end
		
		return newStateMachine
	end
	
	return nil
end

function npcStateMachine.initializeByID(entity, id, ...)
	for key, stateMachine in pairs(registered.npcStateMachines) do
		if id == stateMachine.id then
			return npcStateMachine.initialize(entity, stateMachine.name, ...)
		end
	end
	
	return nil
end
