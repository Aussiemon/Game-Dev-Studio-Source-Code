local gameTypeData = game.getGameTypeData("scenario_console_domination")
local hudBottom = gui.getClassTable("HUDBottom")

objectiveHandler:registerNewObjective({
	autoClaim = true,
	id = "console_domination_1",
	icon = "objective_pay_denbts",
	name = _T("CONSOLE_DOMINATION", "Console Domination"),
	description = _T("CONSOLE_DOMINATION_DESC_1", "Begin work on your first game console"),
	descriptionTwo = _T("CONSOLE_DOMINATION_DESC_2", "Finish your first game console"),
	descriptionThree = _T("CONSOLE_DOMINATION_DESC_3", "Continue with the release of the console"),
	getDescription = function(self, objectiveObj)
		local taskID = objectiveObj:getTask():getProgressValues()
		
		if taskID < 10 then
			return self.description
		elseif taskID < 28 then
			return self.descriptionTwo
		end
		
		return self.descriptionThree
	end,
	task = {
		id = "sequence",
		tasks = {
			{
				id = "wait_for_event",
				event = studio.EVENTS.CONFIRM_STUDIO_NAME
			},
			{
				dialogueID = "console_domination_1",
				id = "finish_dialogue",
				startDialogue = "console_domination_1_1"
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES
			},
			{
				dialogueID = "console_domination_2",
				id = "finish_dialogue",
				startDialogue = "console_domination_2_1"
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES
			},
			{
				id = "wait_for_event",
				event = projectsMenu.EVENTS.OPENED,
				overrides = {
					stopTime = 1,
					clickIDs = {
						hudBottom.PROJECTS_BUTTON_ID
					},
					arrow = {
						heightOffset = -1,
						angle = 180,
						widthOffset = 0.5,
						elementID = hudBottom.PROJECTS_BUTTON_ID,
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
				event = projectsMenu.EVENTS.PLATFORMS_TAB_OPENED,
				overrides = {
					stopTime = 1,
					clickIDs = {
						projectsMenu.ELEMENT_IDS.PLATFORMS
					},
					arrow = {
						heightOffset = 0.5,
						angle = -90,
						widthOffset = 0.25,
						elementID = projectsMenu.ELEMENT_IDS.PLATFORMS,
						align = gui.SIDES.RIGHT,
						offset = {
							0,
							0
						}
					}
				}
			},
			{
				id = "wait_for_event",
				event = platformParts.EVENTS.MENU_OPENED,
				overrides = {
					stopTime = 1,
					clickIDs = {
						projectsMenu.ELEMENT_IDS.NEW_PLATFORM_BUTTON
					},
					arrow = {
						heightOffset = 0.5,
						angle = -90,
						widthOffset = 0.5,
						elementID = projectsMenu.ELEMENT_IDS.NEW_PLATFORM_BUTTON,
						align = gui.SIDES.RIGHT,
						offset = {
							0,
							0
						}
					}
				}
			},
			{
				id = "wait_for_event",
				event = playerPlatform.EVENTS.BEGUN_WORK_ON_PLATFORM
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES
			},
			{
				dialogueID = "console_domination_3",
				id = "finish_dialogue",
				startDialogue = "console_domination_3_1"
			},
			{
				id = "reach_platform_dev_stage",
				stage = 2,
				overrides = {
					resumeTime = true,
					allowTimeAdjustment = true
				}
			},
			{
				dialogueID = "console_domination_4",
				id = "finish_dialogue",
				startDialogue = "console_domination_4_1",
				overrides = {
					unlockActions = {
						"look_for_developers"
					}
				}
			},
			{
				id = "wait_for_event",
				event = playerPlatform.EVENTS.OPENED_INTERACTION_MENU,
				overrides = {
					stopTime = 1,
					getClickIDs = function(self, taskObj)
						return {
							studio:getDevPlayerPlatforms()[1]:getID()
						}
					end,
					arrow = {
						heightOffset = 1,
						angle = 0,
						widthOffset = 0.5,
						followElement = true,
						elementID = function(self, taskObject)
							return gui:getElementByID(studio:getDevPlayerPlatforms()[1]:getID())
						end,
						align = gui.SIDES.BOTTOM,
						offset = {
							0,
							0
						}
					}
				}
			},
			{
				id = "wait_for_event",
				event = playerPlatform.EVENTS.DEV_SEARCH_STARTED,
				overrides = {
					suppressMainMenu = true,
					clickIDs = {
						playerPlatform.LOOK_FOR_DEVS_BUTTON_ID
					},
					arrow = {
						heightOffset = 0.5,
						angle = 270,
						widthOffset = 0.25,
						followElement = true,
						elementID = playerPlatform.LOOK_FOR_DEVS_BUTTON_ID,
						align = gui.SIDES.RIGHT,
						offset = {
							0,
							0
						},
						onAttach = function(self, attachedElement)
							attachedElement:getTree():setAutoClose(false)
						end
					}
				}
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES
			},
			{
				dialogueID = "console_domination_5",
				id = "finish_dialogue",
				startDialogue = "console_domination_5_1",
				overrides = {
					allowTimeAdjustment = true
				}
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES
			},
			{
				id = "wait_for_event",
				event = playerPlatform.EVENTS.DEV_SEARCH_FINISHED
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES
			},
			{
				dialogueID = "console_domination_6",
				id = "finish_dialogue",
				startDialogue = "console_domination_6_1"
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES
			},
			{
				id = "reach_platform_dev_stage",
				stage = 3
			},
			{
				dialogueID = "console_domination_7",
				id = "finish_dialogue",
				startDialogue = "console_domination_7_1"
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES
			},
			{
				id = "wait_for_event",
				event = playerPlatform.EVENTS.OPENED_INTERACTION_MENU,
				overrides = {
					stopTime = 1,
					getClickIDs = function(self, taskObj)
						return {
							studio:getDevPlayerPlatforms()[1]:getID()
						}
					end,
					arrow = {
						heightOffset = 1,
						angle = 0,
						widthOffset = 0.5,
						followElement = true,
						elementID = function(self, taskObject)
							return gui:getElementByID(studio:getDevPlayerPlatforms()[1]:getID())
						end,
						align = gui.SIDES.BOTTOM,
						offset = {
							0,
							0
						}
					}
				}
			},
			{
				id = "wait_for_event",
				event = playerPlatform.EVENTS.PLATFORM_RELEASED,
				overrides = {
					allowTimeAdjustment = true
				}
			},
			{
				dialogueID = "console_domination_8",
				id = "finish_dialogue",
				startDialogue = "console_domination_8_1",
				overrides = {
					unlockActions = {
						"cancel_platform"
					}
				}
			},
			{
				id = "wait_for_time",
				time = 40
			},
			{
				dialogueID = "console_domination_9",
				id = "finish_dialogue",
				startDialogue = "console_domination_9_1",
				overrides = {
					unlockActions = {
						"discontinue_platform"
					}
				}
			}
		}
	}
})
objectiveHandler:registerNewObjective({
	autoClaim = true,
	id = "console_domination_2",
	icon = "objective_pay_denbts",
	name = _T("CONSOLE_DOMINATION", "Console Domination"),
	description = _T("CONSOLE_DOMINATION_2_DESC", "Earn a profit of MONEY within TIME"),
	requirements = {
		completedObjectives = {
			"console_domination_1"
		}
	},
	getDescription = function(self, objectiveObj)
		return _format(self.description, "MONEY", string.roundtobigcashnumber(gameTypeData.fundsToFinish), "TIME", timeline:getTimePeriodText(gameTypeData.timeLimit))
	end,
	failState = {
		id = "time_limit",
		dialogueOnFail = "console_domination_timelimit",
		timeLimit = gameTypeData.timeLimit
	},
	task = {
		id = "multiple_sequences",
		mainSequences = {
			1
		},
		sequences = {
			{
				tasks = {
					{
						dialogueID = "console_domination_10",
						id = "finish_dialogue",
						startDialogue = "console_domination_10_1"
					},
					{
						id = "get_platform_funds",
						amount = gameTypeData.fundsToFinish,
						getProgressData = function(self, targetTable, taskObject)
							local accumulated, required = taskObject:getProgressValues()
							
							table.insert(targetTable, {
								text = _format(_T("ON_MY_OWN_CASH_PROGRESS", "$ACC out of $REQ earned"), "ACC", string.comma(math.min(required, accumulated)), "REQ", string.comma(required)),
								completed = taskObject:isFinished()
							})
						end
					},
					{
						dialogueID = "console_domination_finish",
						id = "finish_dialogue",
						startDialogue = "console_domination_finish_1"
					}
				}
			},
			{
				tasks = {
					{
						id = "wait_for_event",
						event = playerPlatform.EVENTS.DEV_BUYOUT
					},
					{
						id = "wait_for_event",
						event = frameController.EVENTS.CLEARED_FRAMES
					},
					{
						dialogueID = "console_domination_dev_buyout",
						id = "finish_dialogue",
						startDialogue = "console_domination_dev_buyout_1"
					}
				}
			},
			{
				tasks = {
					{
						id = "wait_for_event",
						event = playerPlatform.EVENTS.DEV_BUYOUT
					},
					{
						id = "wait_for_event",
						event = frameController.EVENTS.CLEARED_FRAMES
					},
					{
						dialogueID = "console_domination_dev_buyout",
						id = "finish_dialogue",
						startDialogue = "console_domination_dev_buyout_1"
					}
				}
			},
			{
				tasks = {
					{
						id = "wait_for_event",
						event = playerPlatform.EVENTS.ARCHITECTURE_PROBLEMS
					},
					{
						id = "wait_for_event",
						event = frameController.EVENTS.CLEARED_FRAMES
					},
					{
						dialogueID = "console_domination_architecture_problems",
						id = "finish_dialogue",
						startDialogue = "console_domination_architecture_problems_1"
					}
				}
			},
			{
				tasks = {
					{
						id = "wait_for_event",
						event = playerPlatform.EVENTS.FIRMWARE_CRACK
					},
					{
						id = "wait_for_event",
						event = frameController.EVENTS.CLEARED_FRAMES
					},
					{
						dialogueID = "console_domination_firmware_crack",
						id = "finish_dialogue",
						startDialogue = "console_domination_firmware_crack_1"
					}
				}
			}
		}
	}
})
require("game/dialogue/scenarios/console_domination_1")
