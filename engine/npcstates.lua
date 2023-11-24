registered.npcStates = {}
npcState = {}

function register.npcState(name, state)
	print("registering new logic type ", name)
	
	registered.npcStates[name] = state
end

function npcState.get(name, host, ...)
	local newState = {}
	local logic = registered.npcStates[name]
	
	if logic then
		setmetatable(newState, {
			__index = logic
		})
		
		newState.host = host
		
		if newState.initFunc then
			newState:initFunc(host, ...)
		end
		
		return newState
	end
	
	return nil
end

function npcState.getInitFunc(name)
	local logic = registered.npcStates[name]
	
	if logic then
		return logic.initFunc
	end
	
	return nil
end

function npcState.getLogicFunc(name)
	local logic = registered.npcStates[name]
	
	if logic then
		return logic.logicFunc
	end
	
	return nil
end
