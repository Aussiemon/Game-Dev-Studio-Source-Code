preferences = {}
preferences.registered = {}
preferences.registeredByID = {}
preferences.states = {}
preferences.EVENTS = {
	PREFERENCE_STATE_CHANGED = events:new()
}

local defaultPreferenceFuncs = {}

defaultPreferenceFuncs.mtindex = {
	__index = defaultPreferenceFuncs
}

function defaultPreferenceFuncs:switchCallback(state)
end

function defaultPreferenceFuncs:isOnCheck(checkbox)
	return preferences:get(self.id)
end

function defaultPreferenceFuncs:load()
end

function defaultPreferenceFuncs:handleEvent(event)
end

function preferences:getData(id)
	return preferences.registeredByID[id]
end

function preferences:init()
	for key, data in ipairs(preferences.registered) do
		if data.catchableEvents then
			events:addDirectReceiver(data, data.catchableEvents)
		end
	end
end

function preferences:remove()
	for key, data in ipairs(preferences.registered) do
		if data.catchableEvents then
			events:removeDirectReceiver(data, data.catchableEvents)
		end
	end
	
	table.clear(self.states)
end

function preferences:registerNew(preferenceData)
	table.insert(preferences.registered, preferenceData)
	
	preferences.registeredByID[preferenceData.id] = preferenceData
	
	setmetatable(preferenceData, defaultPreferenceFuncs.mtindex)
end

function preferences:set(id, state)
	local data = preferences.registeredByID[id]
	
	if data then
		data:switchCallback(state)
	end
	
	self.states[id] = state
	
	events:fire(preferences.EVENTS.PREFERENCE_STATE_CHANGED, state, id)
end

function preferences:get(id)
	return self.states[id]
end

preferences.popupWidth = 470
preferences.popupPad = 10
preferences.elementVertPad = 5
preferences.checkboxSize = 28
preferences.elementSize = 32

function preferences:createPopup()
	local frame = gui.create("Frame")
	
	frame:setFont(fonts.get("pix24"))
	frame:setTitle(_T("OFFICE_PREFERENCES_POPUP_TITLE", "Office Preferences"))
	frame:setSize(preferences.popupWidth, 440)
	
	self.preferenceCheckboxes = {}
	self.frame = frame
	
	local scrollbar = gui.create("ScrollbarPanel", frame)
	
	scrollbar:setPos(_S(5), _S(35))
	scrollbar:setSize(preferences.popupWidth - 10, 400)
	scrollbar:addDepth(5)
	scrollbar:setPadding(3, 3)
	scrollbar:setSpacing(3)
	scrollbar:setAdjustElementSize(true)
	scrollbar:setAdjustElementPosition(true)
	
	self.scroller = scrollbar
	
	for key, prefData in ipairs(preferences.registered) do
		self:addPreferenceControl(prefData, scrollbar)
	end
	
	frame:center()
	frameController:push(self.frame)
	
	return frame
end

function preferences:addPreferenceControl(preferenceData)
	local display = gui.create("PreferenceDisplay")
	
	display:setSize(preferences.popupWidth - preferences.popupPad * 2, preferences.elementSize)
	display:setPreferenceData(preferenceData)
	self.scroller:addItem(display)
	table.insert(self.preferenceCheckboxes, display)
	
	return display
end

function preferences:save()
	return self.states
end

function preferences:load(data)
	self.states = data or self.states
	
	for id, state in pairs(self.states) do
		local data = preferences.registeredByID[id]
		
		if data then
			data:load()
		end
	end
end

preferences:registerNew({
	id = developer.ALWAYS_APPROVE_RAISES_PREFERENCE,
	display = _T("AUTO_APPROVE_RAISES", "Auto-approve raise requests"),
	description = _T("AUTO_APPROVE_RAISES_DESCRIPTION", "When employees are confident that their abilities have improved they will ask for a raise. It is up to you to decide whether a raise should be approved or not, but with this enabled raise requests will be approved automatically.\n\nWhenever a raise is approved you will be notified, but in a way that does not halt gameplay.")
})
preferences:registerNew({
	id = developer.ALWAYS_APPROVE_VACATIONS_PREFERENCE,
	display = _T("AUTO_APPROVE_VACATION_REQUESTS", "Auto-approve vacation requests"),
	description = _T("AUTO_APPROVE_VACATION_REQUESTS_DESCRIPTION", "Regardless of what employees do in your office, they will steadily lose Drive. When it reaches a low enough level they will ask you for a vacation, which is up to you to decide whether to approve it or not.\n\nWith this option enabled all vacation requests will be approved automatically. You will be notified of each approved vacation.")
})
preferences:registerNew({
	id = developer.AUTO_SPEND_AP_PREFERENCE,
	display = _T("AUTO_SPEND_ATTRIBUTE_POINTS", "Auto-spend attribute points"),
	description = _T("AUTO_SPEND_ATTRIBUTE_POINTS_DESCRIPTION", "When employees level up they gain 1 attribute point, and you have to manually assign it. Enabling this preference will make employees automatically spend gained attribute points into attributes which are the most important to their role."),
	switchCallback = function(self, state)
		if state then
			for key, employee in ipairs(studio:getEmployees()) do
				employee:autoSpendAttributePoints()
			end
		end
	end
})
preferences:registerNew({
	id = activities.AUTO_ORGANIZE_PREFERENCE,
	display = _T("AUTO_APPROVE_ACTIVITIES", "Auto-approve team-building activities"),
	description = _T("AUTO_APPROVE_ACTIVITIES_DESCRIPTION", "After a long period of no team-building activities being scheduled your employees might take the initiative into their own hands and organize activities on their own. Enabling this option will automatically approve any such events.")
})
preferences:registerNew({
	id = "auto_practice_each_week",
	display = _T("AUTO_PRACTICE_EACH_WEEK", "Auto-practice every week"),
	description = _T("AUTO_PRACTICE_EACH_WEEK_DESCRIPTION", "Employees that are idling will automatically have practice tasks assigned to them at the start of a new week.\n\nEnabling this will cause employees to lose their Drive faster, as any kind of task drains it."),
	catchableEvents = {
		timeline.EVENTS.NEW_WEEK
	},
	handleEvent = function(self, event)
		if preferences:get(self.id) then
			for key, teamObj in ipairs(studio:getTeams()) do
				teamObj:assignPracticeToIdlingEmployees()
			end
		end
	end
})
preferences:registerNew({
	id = interview.AUTO_MANAGER_PREFERENCE,
	display = _T("AUTO_ASSIGN_INTERVIEW_MANAGERS", "Auto-assign managers to interviews"),
	description = _T("AUTO_ASSIGN_INTERVIEW_MANAGERS_DESCRIPTION", "With this enabled, interviews will automatically have a manager take care of them if possible.\n\nIf assigning a manager is not possible, then you will need to choose what to do with the interview.")
})
preferences:registerNew({
	id = interview.ALWAYS_HYPE_PREFERENCE,
	display = _T("ALWAYS_HYPE_PREFERENCE", "Always hype interviews"),
	description = _T("ALWAYS_HYPE_PREFERENCE_DESCRIPTION", "This preference works in conjunction with auto-assigned manager interviews.\nEnabling this preference will make Managers always hype up the game project after an interview. Enable this only if you're certain you'll be able to meet or exceed the expectations!")
})
preferences:registerNew({
	id = "quietly_notify_of_new_engines",
	display = _T("QUIETLY_NOTIFY_OF_NEW_ENGINES", "Quietly notify of new engines"),
	description = _T("QUIETLY_NOTIFY_OF_NEW_ENGINES_DESCRIPTION", "Whenever an engine comes out with a notable feature, a pop-up will inform you of it.\n\nWith this preference enabled, no popups for newly released game engines will be shown.")
})
preferences:registerNew({
	id = "stop_time_on_game_finish",
	display = _T("STOP_TIME_UPON_FINISHING_A_GAME", "Stop time upon finishing a game"),
	description = _T("STOP_TIME_UPON_FINISHING_A_GAME_DESCRIPTION", "Enabling this preference will pause the time when one of your teams finishes working on a game project."),
	catchableEvents = {
		gameProject.EVENTS.INITIAL_FINISH
	},
	handleEvent = function(self, event)
		if preferences:get(self.id) then
			timeline:setSpeed(0)
			timeline:breakIteration()
		end
	end
})
preferences:registerNew({
	id = developer.SKIP_RETIRE_DIALOGUE_PREFERENCE,
	display = _T("SKIP_EMPLOYEE_RETIRE_DIALOGUES", "Skip employee retire dialogues"),
	description = _T("SKIP_EMPLOYEE_RETIRE_DIALOGUES_DESCRIPTION", "Enabling this preference will skip dialogues that occur when employees retire, and will instead add an element to the event box.")
})
