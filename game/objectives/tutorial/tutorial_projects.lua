local hudBottom = gui.getClassTable("HUDBottom")

objectiveHandler:registerNewObjective({
	autoClaim = true,
	id = "tutorial_projects_1",
	icon = "objective_getting_started",
	name = _T("TUTORIAL_PROJECT_1", "Project Basics"),
	description = _T("TUTORIAL_PROJECT_1_DESCRIPTION", "Learn the basics of working on projects"),
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
				dialogueID = "tutorial_projects_1",
				id = "finish_dialogue",
				startDialogue = "tutorial_projects_1_1"
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
				event = projectsMenu.EVENTS.ENGINES_TAB_OPENED,
				overrides = {
					stopTime = 1,
					clickIDs = {
						projectsMenu.ELEMENT_IDS.ENGINES
					},
					arrow = {
						heightOffset = 0.5,
						angle = -90,
						widthOffset = 0.5,
						elementID = projectsMenu.ELEMENT_IDS.ENGINES,
						align = gui.SIDES.RIGHT,
						offset = {
							0,
							0
						}
					}
				}
			},
			{
				id = "wait_for_specific_events",
				events = {
					[engine.EVENTS.FINISHED_ENGINE] = true,
					[engineLicensing.EVENTS.PURCHASED] = true
				},
				overrides = {
					allowTimeAdjustment = true
				},
				getProgressData = function(self, targetTable, taskObject)
					table.insert(targetTable, {
						text = _T("TUTORIAL_PURCHASE_CREATE_ENGINE", "Purchase or create a game engine"),
						completed = taskObject:isFinished()
					})
				end
			},
			{
				dialogueID = "tutorial_projects_2",
				id = "finish_dialogue",
				startDialogue = "tutorial_projects_2_1"
			},
			{
				id = "optional_task",
				startCheck = function(self, taskObj)
					return projectsMenu:isOpen()
				end,
				checkMethod = function(self, taskObj, event)
					if event == projectsMenu.EVENTS.OPENED then
						return true
					end
				end,
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
				id = "optional_task",
				startCheck = function(self, taskObj)
					return gui:getElementByID(projectsMenu.ELEMENT_IDS.PROJECTS):isActive()
				end,
				checkMethod = function(self, taskObj, event)
					if event == projectsMenu.EVENTS.PROJECTS_TAB_OPENED then
						return true
					end
				end,
				overrides = {
					stopTime = 1,
					clickIDs = {
						projectsMenu.ELEMENT_IDS.PROJECTS
					},
					arrow = {
						heightOffset = 0.5,
						angle = 270,
						widthOffset = 1,
						elementID = projectsMenu.ELEMENT_IDS.PROJECTS,
						align = gui.SIDES.RIGHT,
						offset = {
							0,
							0
						}
					}
				}
			},
			{
				id = "optional_task",
				startCheck = function(self, taskObj)
					return gui:getElementByID(projectsMenu.ELEMENT_IDS.NEW_GAME):isActive()
				end,
				checkMethod = function(self, taskObj, event)
					if event == projectsMenu.EVENTS.NEW_GAME_TAB_OPENED then
						return true
					end
				end,
				overrides = {
					stopTime = 1,
					clickIDs = {
						projectsMenu.ELEMENT_IDS.NEW_GAME
					},
					arrow = {
						heightOffset = 1,
						angle = 0,
						widthOffset = 0.5,
						followElement = true,
						elementID = projectsMenu.ELEMENT_IDS.NEW_GAME,
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
				event = gameProject.EVENTS.BEGAN_WORK,
				overrides = {
					allowTimeAdjustment = true
				},
				getProgressData = function(self, targetTable, taskObject)
					table.insert(targetTable, {
						text = _T("THE_JOURNEY_BEGIN_WORK_ON_GAME", "Begin work on your first game"),
						completed = taskObject:isFinished()
					})
				end
			},
			{
				dialogueID = "tutorial_projects_3",
				id = "finish_dialogue",
				startDialogue = "tutorial_projects_3_1"
			},
			{
				id = "wait_for_event",
				event = gameProject.EVENTS.REACHED_RELEASE_STATE
			},
			{
				dialogueID = "tutorial_projects_4",
				id = "finish_dialogue",
				startDialogue = "tutorial_projects_4_1"
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES
			},
			{
				id = "wait_for_event",
				event = gameProject.EVENTS.OPENED_INTERACTION_MENU,
				overrides = {
					stopTime = 1,
					arrow = {
						heightOffset = 1,
						angle = 0,
						widthOffset = 0.5,
						followElement = true,
						elementID = function(self, taskObject)
							local scroller = gui:getElementByID(gui.getClassTable("ActiveProjectBox").SCROLLBAR_ID)
							local element
							
							for key, child in ipairs(scroller:getItems()) do
								if child:getClass() == "ActiveGameProjectElement" and child:getProject():getTeam() then
									element = child
									
									break
								end
							end
							
							taskObject:addClickID(element)
							
							return element
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
				id = "finish_game",
				getProgressData = function(self, targetTable, taskObject)
					table.insert(targetTable, {
						text = _T("THE_JOURNEY_FINISH_GAME", "Finish your first game"),
						completed = taskObject:isFinished()
					})
				end,
				overrides = {
					allowTimeAdjustment = true
				}
			},
			{
				dialogueID = "tutorial_projects_5",
				id = "finish_dialogue",
				startDialogue = "tutorial_projects_5_1"
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES
			},
			{
				id = "wait_for_event",
				event = gameProject.EVENTS.OPENED_INTERACTION_MENU,
				overrides = {
					stopTime = 1,
					arrow = {
						heightOffset = 1,
						angle = 0,
						widthOffset = 0.5,
						followElement = true,
						elementID = function(self, taskObject)
							local scroller = gui:getElementByID(gui.getClassTable("ActiveProjectBox").SCROLLBAR_ID)
							local element
							
							for key, child in ipairs(scroller:getItems()) do
								if child:getClass() == "ActiveGameProjectElement" and child:getProject():canReleaseGame() then
									element = child
									
									break
								end
							end
							
							taskObject:addClickID(element)
							
							return element
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
				event = gameProject.EVENTS.PRE_RELEASE_VERIFICATION,
				overrides = {
					suppressMainMenu = true,
					clickIDs = {
						gameProject.RELEASE_GAME_BUTTON_ID
					},
					arrow = {
						heightOffset = 0.5,
						angle = 270,
						widthOffset = 0,
						followElement = true,
						elementID = gameProject.RELEASE_GAME_BUTTON_ID,
						align = gui.SIDES.RIGHT,
						offset = {
							30,
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
				disableFailStateOnFinish = true,
				event = studio.EVENTS.RELEASED_GAME,
				getProgressData = function(self, targetTable, taskObject)
					table.insert(targetTable, {
						text = _T("THE_JOURNEY_RELEASE_GAME", "Release your first game"),
						completed = taskObject:isFinished()
					})
				end,
				overrides = {
					allowTimeAdjustment = true
				}
			},
			{
				dialogueID = "tutorial_projects_6",
				id = "finish_dialogue",
				startDialogue = "tutorial_projects_6_1"
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES
			},
			{
				id = "wait_for_event",
				event = projectReview.EVENTS.OPENED
			},
			{
				id = "wait_for_event",
				event = projectReview.EVENTS.CLOSED,
				getProgressData = function(self, targetTable, taskObject)
					table.insert(targetTable, {
						text = _T("TUTORIAL_READ_GAME_REVIEW", "Read a review of your game"),
						completed = taskObject:isFinished()
					})
				end
			},
			{
				dialogueID = "tutorial_projects_7",
				id = "finish_dialogue",
				startDialogue = "tutorial_projects_7_1"
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES
			}
		}
	}
})
objectiveHandler:registerNewObjective({
	id = "tutorial_construction_projects",
	requirements = {
		completedObjectives = {
			"tutorial_construction_employees"
		}
	}
}, "tutorial_projects_1")
objectiveHandler:registerNewObjective({
	id = "tutorial_employees_projects",
	requirements = {
		completedObjectives = {
			"tutorial_employees_1"
		}
	}
}, "tutorial_projects_1")
