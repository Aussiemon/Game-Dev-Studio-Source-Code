local haveRoomTypesTask = {}

haveRoomTypesTask.id = "have_room_types"

function haveRoomTypesTask:initConfig(cfg)
	haveRoomTypesTask.baseClass.initConfig(self, cfg)
	
	self.roomTypes = cfg.roomTypes
end

function haveRoomTypesTask:onStart()
	haveRoomTypesTask.baseClass.onStart(self)
	self:checkCompletion()
end

function haveRoomTypesTask:checkCompletion()
	local validRoomTypes = studio:getValidRoomTypes()
	local finished = true
	
	for roomTypeID, amount in pairs(self.roomTypes) do
		if amount > (validRoomTypes[roomTypeID] or 0) then
			finished = false
			
			break
		end
	end
	
	self.completed = finished
end

function haveRoomTypesTask:handleEvent(event)
	if event == studio.EVENTS.ROOM_UPDATED or event == studio.EVENTS.ROOMS_UPDATED then
		self:checkCompletion()
	end
end

objectiveHandler:registerNewTask(haveRoomTypesTask, "base_task")
