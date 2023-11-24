keyBinding.COMMANDS = {
	FLOOR_DOWN = "floor_down",
	SPEED_4 = "speed_4",
	PROPERTY = "property",
	SPEED_1 = "speed_1",
	EMPLOYEE_MANAGE = "employee_manage",
	SPEED_2 = "speed_2",
	TOGGLE_TIME = "toggle_time",
	JOB_SEEKERS = "job_seekers",
	EXPENSES = "expenses",
	PROJECTS = "projects",
	FLOOR_UP = "floor_up",
	SPEED_5 = "speed_5",
	TIMELINE = "timeline",
	SPEED_3 = "speed_3"
}
keyBinding.DEFAULT_KEYS = {
	[keyBinding.COMMANDS.SPEED_1] = "1",
	[keyBinding.COMMANDS.SPEED_2] = "2",
	[keyBinding.COMMANDS.SPEED_3] = "3",
	[keyBinding.COMMANDS.SPEED_4] = "4",
	[keyBinding.COMMANDS.SPEED_5] = "5",
	[keyBinding.COMMANDS.TOGGLE_TIME] = "space",
	[keyBinding.COMMANDS.TIMELINE] = "t",
	[keyBinding.COMMANDS.EXPENSES] = "e",
	[keyBinding.COMMANDS.PROPERTY] = "p",
	[keyBinding.COMMANDS.PROJECTS] = "c",
	[keyBinding.COMMANDS.JOB_SEEKERS] = "j",
	[keyBinding.COMMANDS.EMPLOYEE_MANAGE] = "m",
	[keyBinding.COMMANDS.FLOOR_UP] = "pageup",
	[keyBinding.COMMANDS.FLOOR_DOWN] = "pagedown"
}

keyBinding:allowDefaultKeys()
keyBinding:removeAssignableKeys("w", "a", "s", "d", "1", "2", "3", "4", "5")
keyBinding:addAssignableKey("`")
keyBinding:addAssignableKey("space")
keyBinding:addAssignableKey(",")
keyBinding:addAssignableKey(".")
keyBinding:addAssignableKey("pageup")
keyBinding:addAssignableKey("pagedown")
keyBinding:addKeyDisplay("`", _T("TILDE_KEY", "` (Tilde)"))
keyBinding:addKeyDisplay("backspace", _T("BACKSPACE_KEY", "Backspace"))
keyBinding:addKeyDisplay("escape", _T("ESCAPE_KEY", "Escape"))
keyBinding:addKeyDisplay("pageup", _T("PAGEUP_KEY", "Page up"))
keyBinding:addKeyDisplay("pagedown", _T("PAGEDOWN_KEY", "Page down"))
keyBinding:assignCallbackToCommand("toggle_time", function()
	timeline:attemptSetSpeed(0)
end)
keyBinding:assignCallbackToCommand("speed_1", function()
	timeline:attemptSetSpeed(1)
end)
keyBinding:assignCallbackToCommand("speed_2", function()
	timeline:attemptSetSpeed(2)
end)
keyBinding:assignCallbackToCommand("speed_3", function()
	timeline:attemptSetSpeed(3)
end)
keyBinding:assignCallbackToCommand("speed_4", function()
	timeline:attemptSetSpeed(4)
end)
keyBinding:assignCallbackToCommand("speed_5", function()
	timeline:attemptSetSpeed(5)
end)
keyBinding:assignCallbackToCommand(keyBinding.COMMANDS.TIMELINE, function()
	if frameController:getFrameCount() == 0 then
		game.createTimelineMenu()
		
		return true
	end
	
	return false
end)
keyBinding:assignCallbackToCommand(keyBinding.COMMANDS.EXPENSES, function()
	if frameController:getFrameCount() == 0 then
		monthlyCost.createMenu()
		
		return true
	end
	
	return false
end)
keyBinding:assignCallbackToCommand(keyBinding.COMMANDS.PROPERTY, function()
	if frameController:getFrameCount() == 0 then
		studio.expansion:createMenu()
		
		return true
	end
	
	return false
end)
keyBinding:assignCallbackToCommand(keyBinding.COMMANDS.PROJECTS, function()
	if frameController:getFrameCount() == 0 then
		projectsMenu:open()
		
		return true
	end
	
	return false
end)
keyBinding:assignCallbackToCommand(keyBinding.COMMANDS.JOB_SEEKERS, function()
	if frameController:getFrameCount() == 0 then
		employeeCirculation:toggleMenu()
		
		return true
	end
	
	return false
end)
keyBinding:assignCallbackToCommand(keyBinding.COMMANDS.EMPLOYEE_MANAGE, function()
	if frameController:getFrameCount() == 0 then
		game.createTeamManagementMenu()
		
		return true
	end
	
	return false
end)
keyBinding:assignCallbackToCommand(keyBinding.COMMANDS.FLOOR_UP, function()
	camera:changeFloor(1)
	
	return true
end)
keyBinding:assignCallbackToCommand(keyBinding.COMMANDS.FLOOR_DOWN, function()
	camera:changeFloor(-1)
	
	return true
end)
keyBinding:addCommandName("toggle_time", _T("TOGGLE_TIME", "Toggle time"))
keyBinding:addCommandName("timeline", _T("TIMELINE_MENU", "Timeline menu"))
keyBinding:addCommandName("expenses", _T("EXPENDITURES_MENU", "Expenditures menu"))
keyBinding:addCommandName("property", _T("STUDIO_EXPANSION", "Studio expansion"))
keyBinding:addCommandName("projects", _T("PROJECTS_MENU", "Projects menu"))
keyBinding:addCommandName("job_seekers", _T("JOB_SEEKERS_MENU", "Job seekers menu"))
keyBinding:addCommandName("employee_manage", _T("EMPLOYEE_MANAGEMENT", "Management menu"))
keyBinding:addCommandName("floor_up", _T("FLOOR_UP", "Floor up"))
keyBinding:addCommandName("floor_down", _T("FLOOR_DOWN", "Floor down"))

keyBinding.oldLoad = keyBinding.load

function keyBinding:assignDefaultKeys()
	for commandID, key in pairs(keyBinding.DEFAULT_KEYS) do
		keyBinding:assignKey(key, commandID)
	end
end

function keyBinding:load(keyBinds)
	self:clearKeys()
	self:assignDefaultKeys()
	
	for key, commandName in pairs(keyBinds) do
		self:assignKey(key, commandName)
	end
end
