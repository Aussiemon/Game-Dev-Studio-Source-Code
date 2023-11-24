local mainHUD = gui.getClassTable("HUDBottom")
local topHUD = gui.getClassTable("HUDTop")

objectiveHandler:registerNewObjective({
	id = "tutorial_employees_1",
	icon = "objective_getting_started",
	autoClaim = true,
	name = _T("OBJECTIVE_TUTORIAL_EMPLOYEES_1", "Employee Basics"),
	description = _T("OBJECTIVE_TUTORIAL_EMPLOYEES_1_DESCRIPTION", "Learn the basics of employees"),
	task = {
		id = "sequence",
		tasks = {
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES,
				overrides = {
					stopTime = 1
				}
			},
			{
				dialogueID = "tutorial_employees_1",
				id = "finish_dialogue",
				startDialogue = "tutorial_employees_1_1"
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES
			},
			{
				id = "wait_for_event",
				event = mainHUD.EVENTS.SHOWING_EMPLOYEE_BUTTONS,
				overrides = {
					generateEachRole = true,
					clickIDs = {
						mainHUD.EMPLOYEES_BUTTON_ID
					},
					arrow = {
						heightOffset = -1,
						angle = 180,
						widthOffset = 0.5,
						elementID = mainHUD.EMPLOYEES_BUTTON_ID,
						align = gui.SIDES.TOP,
						offset = {
							0,
							0
						}
					}
				}
			},
			{
				id = "wait_for_event",
				event = employeeCirculation.EVENTS.OPENED_MENU,
				overrides = {
					stopTime = 1,
					expandHUD = mainHUD.EMPLOYEES_BUTTON_ID,
					clickIDs = {
						mainHUD.JOB_SEEKERS_MENU_ID
					},
					arrow = {
						heightOffset = 0.5,
						angle = 90,
						widthOffset = -1.5,
						elementID = mainHUD.JOB_SEEKERS_MENU_ID,
						align = gui.SIDES.LEFT,
						offset = {
							0,
							0
						}
					}
				}
			},
			{
				id = "send_job_offer_task",
				requiredRoles = {
					{
						"software_engineer",
						1
					},
					{
						"sound_engineer",
						1
					},
					{
						"artist",
						1
					},
					{
						"designer",
						1
					},
					{
						"manager",
						1
					},
					{
						"writer",
						1
					}
				},
				getProgressData = function(self, targetTable, taskObject)
					if not taskObject:hasStarted() or taskObject:isFinished() then
						return 
					end
					
					local prog = taskObject:getProgressTable()
					local roleData = attributes.profiler.rolesByID
					
					for key, data in ipairs(self.requiredRoles) do
						local roleID = data[1]
						
						table.insert(targetTable, {
							text = _format(_T("TUTORIAL_EMPLOYEE_SEND_OFFERS", "Sent offer to ROLE."), "ROLE", roleData[roleID].display),
							completed = prog[roleID] >= data[2]
						})
					end
				end
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES
			},
			{
				dialogueID = "tutorial_employees_2",
				id = "finish_dialogue",
				startDialogue = "tutorial_employees_2_1"
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES
			},
			{
				id = "wait_for_specific_events",
				events = {
					[timeline.EVENTS.SPEED_CHANGED] = true
				},
				verificationCallback = function(self, taskObj, event, newSpeed, wasLoad)
					if newSpeed <= 0 then
						return false
					end
					
					return true
				end,
				overrides = {
					stopTime = 1,
					allowTimeAdjustment = true,
					clickIDs = {
						topHUD.SPEED_ONE_ID
					},
					arrow = {
						heightOffset = 4,
						angle = 0,
						widthOffset = 0.5,
						elementID = topHUD.SPEED_ONE_ID,
						align = gui.SIDES.DOWN,
						offset = {
							0,
							0
						}
					}
				}
			},
			{
				id = "hire_employees_task",
				requiredRoles = {
					{
						"software_engineer",
						1
					},
					{
						"sound_engineer",
						1
					},
					{
						"artist",
						1
					},
					{
						"designer",
						1
					},
					{
						"manager",
						1
					},
					{
						"writer",
						1
					}
				},
				overrides = {
					jobAcceptChance = 100,
					allowTimeAdjustment = true
				}
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES
			},
			{
				dialogueID = "tutorial_employees_3",
				id = "finish_dialogue",
				startDialogue = "tutorial_employees_3_1"
			},
			{
				id = "wait_for_event",
				event = developer.EVENTS.COMBOBOX_FILLED,
				getProgressData = function(self, targetTable, taskObject)
					if not taskObject:hasStarted() or taskObject:isFinished() then
						return 
					end
					
					table.insert(targetTable, {
						text = _T("TUTORIAL_EMPLOYEE_CLICK_ON_EMPLOYEE", "Click on any employee within the game world."),
						completed = taskObject:isFinished()
					})
				end
			},
			{
				id = "wait_for_event",
				event = developer.EVENTS.INFO_MENU_OPENED,
				overrides = {
					stopTime = true,
					suppressMainMenu = true,
					disableAutoClose = developer.COMBOBOX_ID,
					clickIDs = {
						developer.EMPLOYEE_INFO_ID
					},
					arrow = {
						heightOffset = 0.5,
						angle = 90,
						widthOffset = 0,
						elementID = developer.EMPLOYEE_INFO_ID,
						align = gui.SIDES.LEFT,
						offset = {
							-25,
							0
						}
					}
				}
			}
		}
	},
	onFinish = function(self)
		game.curGametype:setHUDVisibility(3)
	end
})
objectiveHandler:registerNewObjective({
	id = "tutorial_construction_employees",
	requirements = {
		completedObjectives = {
			"tutorial_construction_1"
		}
	}
}, "tutorial_employees_1")
