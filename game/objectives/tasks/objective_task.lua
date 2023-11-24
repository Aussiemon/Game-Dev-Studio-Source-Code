local objectiveTask = {}

objectiveTask.id = "base_task"

function objectiveTask:init(objectiveObject)
	self.objective = objectiveObject
	self.progressTable = {}
end

function objectiveTask:initConfig(cfg)
	self.config = cfg
end

function objectiveTask:getConfig()
	return self.config
end

function objectiveTask:onStart()
	self:attemptCreateTracking()
end

function objectiveTask:attemptCreateTracking()
	local track = self.config.progressTracking
	
	if track then
		self:createProgressTracking(track.class, track.w or 200, track.h or 26)
	end
end

function objectiveTask:onGameLogicStarted()
	self:attemptCreateTracking()
end

function objectiveTask:createProgressTracking(class, w, h)
	local element = gui.create(class)
	
	element:setSize(w, h)
	element:setTask(self)
	self:positionTrackingElement(element)
	
	return element
end

function objectiveTask:positionTrackingElement(element)
	element:centerX()
	element:setY(_S(70, "new_hud"))
end

function objectiveTask:onFinish()
	if self.config.disableFailStateOnFinish then
		local failstate = self.objective:getFailState()
		
		if failstate then
			failstate:disable()
		end
	end
	
	events:fire(objectiveHandler.EVENTS.TASK_FINISHED, self)
end

function objectiveTask:handleEvent(...)
end

function objectiveTask:setHasStarted(state)
	self.hasStartedTask = state
end

function objectiveTask:hasStarted()
	return self.hasStartedTask
end

function objectiveTask:getProgress()
	local current, max = self:getProgressValues()
	
	self.progressTable[1] = current
	self.progressTable[2] = math.min(current, max)
	
	return self.progressTable
end

function objectiveTask:getProgressValues()
	return self.completed and 1 or 0, 1
end

function objectiveTask:getProgressData(targetTable)
	if self.config.getProgressData then
		self.config:getProgressData(targetTable, self)
	end
end

function objectiveTask:isActive()
	return true
end

function objectiveTask:getProgressPercentage()
	local current, max = self:getProgressValues()
	
	return current / math.min(current, max)
end

function objectiveTask:isFinished()
	return self.completed
end

function objectiveTask:remove()
end

function objectiveTask:save()
	return {
		id = self.id,
		completed = self.completed,
		hasStartedTask = self.hasStartedTask
	}
end

function objectiveTask:load(data)
	self.completed = data.completed
	self.hasStartedTask = data.hasStartedTask
end

objectiveHandler:registerNewTask(objectiveTask)
require("game/objectives/tasks/wait_for_event")
require("game/objectives/tasks/wait_for_specific_events")
require("game/objectives/tasks/finish_game_task")
require("game/objectives/tasks/reach_release_state_task")
require("game/objectives/tasks/game_off_market_task")
require("game/objectives/tasks/sequence_task")
require("game/objectives/tasks/multiple_sequences_task")
require("game/objectives/tasks/get_funds_task")
require("game/objectives/tasks/finish_dialogue_task")
require("game/objectives/tasks/story_wrapper")
require("game/objectives/tasks/have_room_types_task")
require("game/objectives/tasks/have_employees_task")
require("game/objectives/tasks/reach_reputation_task")
require("game/objectives/tasks/decrease_in_reputation_task")
require("game/objectives/tasks/wait_for_bad_game_task")
require("game/objectives/tasks/give_popularity_to_first_project_task")
require("game/objectives/tasks/steal_employees_task")
require("game/objectives/tasks/bankrupt_rival")
require("game/objectives/tasks/receive_coworker")
require("game/objectives/tasks/rival_stops_existing_task")
require("game/objectives/tasks/reach_platform_dev_stage_task")
require("game/objectives/tasks/wait_for_time_task")
require("game/objectives/tasks/get_platform_funds_task")
require("game/objectives/tasks/send_job_offer_task")
require("game/objectives/tasks/hire_employees_task")
require("game/objectives/tasks/have_workplaces_task")
require("game/objectives/tasks/have_objects_task")
require("game/objectives/tasks/expand_office_task")
require("game/objectives/tasks/optional_task")
