local failState = {}

failState.id = "base_fail_state"

function failState:init(objectiveObj, failStateConfig)
	self.objective = objectiveObj
	self.config = failStateConfig
end

function failState:getProgressData(targetTable)
end

function failState:disable()
	self.disabled = true
end

function failState:isDisabled()
	return self.disabled
end

function failState:handleEvent(...)
end

function failState:save()
	return {
		disabled = self.disabled
	}
end

function failState:load(data)
	self.disabled = data.disabled
end

objectiveHandler:registerNewFailState(failState)
require("game/objectives/fail_states/time_limit")
