local hudBottom = gui.getClassTable("HUDBottom")

objectiveHandler:registerNewObjective({
	autoClaim = true,
	id = "getting_started",
	icon = "objective_getting_started",
	name = _T("GETTING_STARTED_NAME", "Getting Started"),
	description = _T("GETTING_STARTED_DESCRIPTION", "Construct 1 restroom and 1 work room"),
	task = {
		id = "sequence",
		tasks = {
			{
				id = "wait_for_event",
				event = studio.EVENTS.CONFIRM_STUDIO_NAME
			},
			{
				dialogueID = "getting_started_dialogue",
				id = "finish_dialogue",
				startDialogue = "getting_started_dialogue_1"
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES
			},
			{
				id = "wait_for_event",
				event = hudBottom.EVENTS.SHOWING_PROPERTY_BUTTONS,
				overrides = {
					stopTime = 1,
					clickIDs = {
						hudBottom.PROPERTY_AND_RIVALS_BUTTON_ID
					},
					arrow = {
						heightOffset = -1,
						angle = 180,
						widthOffset = 0.5,
						elementID = hudBottom.PROPERTY_AND_RIVALS_BUTTON_ID,
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
				event = studio.expansion.EVENTS.ENTER_EXPANSION_MODE,
				overrides = {
					expandHUD = "property_and_rivals_button",
					stopTime = 1,
					clickIDs = {
						hudBottom.PROPERTY_BUTTON_ID
					},
					arrow = {
						heightOffset = 0.5,
						angle = 90,
						widthOffset = -1.5,
						elementID = hudBottom.PROPERTY_BUTTON_ID,
						align = gui.SIDES.LEFT,
						offset = {
							0,
							0
						}
					}
				}
			},
			{
				id = "have_room_types",
				roomTypes = {
					[studio.ROOM_TYPES.TOILET] = 1,
					[studio.ROOM_TYPES.OFFICE] = 1
				},
				overrides = {
					expansionRoomTypes = {
						[studio.ROOM_TYPES.TOILET] = 1,
						[studio.ROOM_TYPES.OFFICE] = 1
					}
				},
				getProgressData = function(self, targetTable, taskObject)
					table.insert(targetTable, {
						text = _T("GETTING_STARTED_RESTROOM_CONSTRUCTED", "Restroom constructed"),
						completed = studio:getValidRoomTypeCount(studio.ROOM_TYPES.TOILET) > 0
					})
					table.insert(targetTable, {
						text = _T("GETTING_STARTED_WORKROOM_CONSTRUCTED", "Work room ready"),
						completed = studio:getValidRoomTypeCount(studio.ROOM_TYPES.OFFICE) > 0
					})
				end
			},
			{
				id = "wait_for_event",
				event = studio.expansion.EVENTS.LEAVE_EXPANSION_MODE
			}
		}
	}
})
objectiveHandler:registerNewObjective({
	id = "vroom_vroom",
	icon = "objective_vroom_vroom",
	autoClaim = true,
	name = _T("VROOM_VROOM_NAME", "Vroom Vroom!"),
	description = _T("VROOM_VROOM_DESCRIPTION", "Create a game engine"),
	requirements = {
		completedObjectives = {
			"getting_started"
		}
	},
	failState = {
		id = "time_limit",
		dialogueOnFail = "vroom_vroom_timelimit",
		timeLimit = timeline.DAYS_IN_MONTH * 6
	},
	task = {
		id = "sequence",
		tasks = {
			{
				dialogueID = "vroom_vroom_dialogue_1",
				id = "finish_dialogue",
				startDialogue = "vroom_vroom_dialogue_1"
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
				id = "wait_for_event",
				event = engine.EVENTS.BEGAN_WORK,
				getProgressData = function(self, targetTable, taskObject)
					table.insert(targetTable, {
						text = _T("VROOM_VROOM_BEGIN_WORK_ENGINE", "Begin work on your first engine"),
						completed = taskObject:isFinished()
					})
				end
			},
			{
				id = "wait_for_event",
				disableFailStateOnFinish = true,
				event = engine.EVENTS.FINISHED_ENGINE,
				overrides = {
					allowTimeAdjustment = true,
					lockActions = {
						projectsMenu.OPEN_MENU_ACTION
					}
				},
				getProgressData = function(self, targetTable, taskObject)
					table.insert(targetTable, {
						text = _T("VROOM_VROOM_FINISH_WORK_ENGINE", "Finish your first engine"),
						completed = taskObject:isFinished()
					})
				end
			},
			{
				dialogueID = "vroom_vroom_dialogue_2",
				id = "finish_dialogue",
				startDialogue = "vroom_vroom_dialogue_2",
				overrides = {
					unlockActions = {
						projectsMenu.OPEN_MENU_ACTION
					}
				}
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES
			}
		}
	}
})
objectiveHandler:registerNewObjective({
	id = "the_journey",
	icon = "objective_the_journey",
	autoClaim = true,
	name = _T("THE_JOURNEY_NAME", "The Journey"),
	description = _T("THE_JOURNEY_DESCRIPTION", "Finish and release your first game"),
	requirements = {
		completedObjectives = {
			"vroom_vroom"
		}
	},
	failState = {
		id = "time_limit",
		dialogueOnFail = "the_journey_timelimit",
		timeLimit = timeline.DAYS_IN_YEAR * 3
	},
	task = {
		id = "sequence",
		tasks = {
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
				event = projectsMenu.EVENTS.NEW_GAME_TAB_OPENED,
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
				dialogueID = "the_journey_dialogue_1",
				id = "finish_dialogue",
				startDialogue = "the_journey_dialogue_1",
				overrides = {
					lockActions = {
						projectsMenu.OPEN_MENU_ACTION
					}
				}
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES
			},
			{
				id = "wait_for_event",
				event = gameProject.EVENTS.REACHED_RELEASE_STATE
			},
			{
				dialogueID = "the_journey_dialogue_qa",
				id = "finish_dialogue",
				startDialogue = "the_journey_dialogue_qa",
				overrides = {
					lockActions = {
						projectsMenu.OPEN_MENU_ACTION
					}
				}
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
								if child:getClass() == "ActiveGameProjectElement" then
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
				overrides = {
					allowTimeAdjustment = true
				},
				getProgressData = function(self, targetTable, taskObject)
					table.insert(targetTable, {
						text = _T("THE_JOURNEY_FINISH_GAME", "Finish your first game"),
						completed = taskObject:isFinished()
					})
				end
			},
			{
				dialogueID = "the_journey_dialogue_2",
				id = "finish_dialogue",
				startDialogue = "the_journey_dialogue_2",
				overrides = {
					unlockActions = {
						projectsMenu.OPEN_MENU_ACTION
					}
				}
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES
			},
			{
				id = "give_popularity_to_first_project",
				popularity = 20000,
				overrides = {
					unlockActions = {
						"generic_game_interaction"
					}
				}
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
								if child:getClass() == "ActiveGameProjectElement" then
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
				end
			},
			{
				dialogueID = "the_journey_dialogue_3",
				id = "finish_dialogue",
				startDialogue = "the_journey_dialogue_3"
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES
			},
			{
				id = "wait_for_event",
				event = gameProject.EVENTS.NEW_REVIEW,
				overrides = {
					resumeTime = true
				}
			},
			{
				dialogueID = "the_journey_dialogue_4",
				id = "finish_dialogue",
				startDialogue = "the_journey_dialogue_4"
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
				event = projectReview.EVENTS.CLOSED
			},
			{
				dialogueID = "the_journey_dialogue_5",
				id = "finish_dialogue",
				startDialogue = "the_journey_dialogue_5_1"
			}
		}
	}
})
objectiveHandler:registerNewObjective({
	id = "on_my_own",
	icon = "objective_on_my_own",
	autoClaim = true,
	name = _T("ON_MY_OWN_NAME", "On My Own"),
	description = _T("ON_MY_OWN_DESCRIPTION", "Earn a total of $800,000 in 4 years time"),
	requirements = {
		completedObjectives = {
			"the_journey"
		}
	},
	failState = {
		id = "time_limit",
		dialogueOnFail = "on_my_own_timelimit",
		timeLimit = timeline.DAYS_IN_YEAR * 4
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
						dialogueID = "on_my_own_dialogue_1",
						id = "finish_dialogue",
						startDialogue = "on_my_own_dialogue_1_1",
						overrides = {
							unlockActions = {
								"contract_work",
								"engine_licensing",
								"interviews",
								"generic_project_interaction",
								"game_convention",
								"story_mode_1"
							}
						}
					},
					{
						id = "wait_for_event",
						event = frameController.EVENTS.CLEARED_FRAMES
					},
					{
						id = "get_funds",
						amount = 800000,
						getProgressData = function(self, targetTable, taskObject)
							local accumulated, required = taskObject:getProgressValues()
							
							table.insert(targetTable, {
								text = _format(_T("ON_MY_OWN_CASH_PROGRESS", "$ACC out of $REQ earned"), "ACC", string.comma(math.min(required, accumulated)), "REQ", string.comma(required)),
								completed = taskObject:isFinished()
							})
						end
					}
				}
			},
			{
				tasks = {
					{
						id = "wait_for_specific_events",
						events = {
							[gameProject.EVENTS.REACHED_RELEASE_STATE] = true,
							[advertisement.EVENTS.STARTED_ADVERTISEMENT] = true
						},
						verificationCallback = function(self, taskObject, event, gameProj)
							if event == gameProject.EVENTS.REACHED_RELEASE_STATE and gameProj:getOwner():isPlayer() then
								dialogueHandler:addDialogue("on_my_own_dialogue_2_1_a", game.getInvestorName(), nil, nil)
								
								return true
							elseif event == advertisement.EVENTS.STARTED_ADVERTISEMENT and gameProj:getOwner():isPlayer() and not gameProj:getReleaseDate() then
								dialogueHandler:addDialogue("on_my_own_dialogue_2_1_b", game.getInvestorName(), nil, nil)
								
								return true
							end
							
							return false
						end
					},
					{
						dialogueID = "on_my_own_dialogue_2_1",
						id = "finish_dialogue",
						overrides = {
							quietFunds = 500000
						}
					},
					{
						id = "wait_for_event",
						event = advertisement.EVENTS.STARTED_ADVERTISEMENT,
						getProgressData = function(self, targetTable, taskObject)
							table.insert(targetTable, {
								text = _T("ON_MY_OWN_OPTIONAL_ADVERTISE_GAME", "(OPTIONAL) Advertise your game"),
								completed = taskObject:isFinished()
							})
						end
					}
				}
			},
			{
				tasks = {
					{
						id = "game_off_market"
					},
					{
						dialogueID = "on_my_own_off_market_dialogue_1",
						id = "finish_dialogue",
						startDialogue = "on_my_own_off_market_dialogue_1"
					}
				}
			}
		}
	}
})
objectiveHandler:registerNewObjective({
	id = "climbing_the_ladder",
	icon = "objective_climbing_the_ladder",
	autoClaim = true,
	name = _T("CLIMBING_THE_LADDER_NAME", "Climbing the Ladder"),
	description = _T("CLIMBING_THE_LADDER_DESCRIPTION", "Expand to 15 employees and make $500,000"),
	requirements = {
		completedObjectives = {
			"on_my_own"
		}
	},
	failState = {
		id = "time_limit",
		dialogueOnFail = "climbing_the_ladder_timelimit",
		timeLimit = timeline.DAYS_IN_YEAR * 3
	},
	task = {
		id = "multiple_sequences",
		mainSequences = {
			1,
			2
		},
		sequences = {
			{
				tasks = {
					{
						dialogueID = "climbing_the_ladder_1",
						id = "finish_dialogue",
						startDialogue = "climbing_the_ladder_1_1"
					},
					{
						id = "wait_for_event",
						event = frameController.EVENTS.CLEARED_FRAMES
					},
					{
						id = "get_funds",
						amount = 500000,
						getProgressData = function(self, targetTable, taskObject)
							local accumulated, required = taskObject:getProgressValues()
							
							table.insert(targetTable, {
								text = _format(_T("CLIMBING_THE_LADDER_CASH_PROGRESS", "$ACC out of $REQ earned"), "ACC", string.comma(math.min(required, accumulated)), "REQ", string.comma(required)),
								completed = taskObject:isFinished()
							})
						end
					}
				}
			},
			{
				tasks = {
					{
						id = "have_employees",
						employeeCount = 15,
						getProgressData = function(self, targetTable, taskObject)
							local accumulated, required = taskObject:getProgressValues()
							
							table.insert(targetTable, {
								text = _format(_T("CLIMBING_THE_LADDER_EMPLOYEE_PROGRESS", "ACC out of REQ employees in office"), "ACC", string.comma(math.min(required, accumulated)), "REQ", string.comma(required)),
								completed = taskObject:isFinished()
							})
						end
					}
				}
			}
		}
	}
})
objectiveHandler:registerNewObjective({
	autoClaim = true,
	id = "a_formidable_reputation",
	icon = "objective_formidable_reputation",
	name = _T("A_FORMIDABLE_REPUTATION_NAME", "A Formidable Reputation"),
	description = _T("A_FORMIDABLE_REPUTATION_DESCRIPTION", "Reach 20,000 in reputation points"),
	requirements = {
		completedObjectives = {
			"climbing_the_ladder"
		}
	},
	task = {
		id = "multiple_sequences",
		mainSequences = {
			1,
			2
		},
		sequences = {
			{
				tasks = {
					{
						dialogueID = "climbing_the_ladder_2",
						id = "finish_dialogue",
						startDialogue = "climbing_the_ladder_2_1"
					}
				}
			},
			{
				tasks = {
					{
						id = "reach_reputation",
						requiredReputation = 20000,
						getProgressData = function(self, targetTable, taskObject)
							local accumulated, required = taskObject:getProgressValues()
							
							table.insert(targetTable, {
								text = _format(_T("A_FORMIDABLE_REPUTATION_REPUTATION_PROGRESS", "ACC out of REQ points"), "ACC", string.comma(math.min(required, accumulated)), "REQ", string.comma(required)),
								completed = taskObject:isFinished()
							})
						end
					}
				}
			},
			{
				tasks = {
					{
						id = "wait_for_bad_game"
					},
					{
						dialogueID = "a_formidable_reputation_1",
						id = "finish_dialogue",
						startDialogue = "a_formidable_reputation_1_1"
					}
				}
			}
		}
	}
})
objectiveHandler:registerNewObjective({
	autoClaim = true,
	id = "first_contact_1",
	icon = "objective_first_contact",
	name = _T("FIRST_CONTACT_1", "First Contact"),
	description = _T("FIRST_CONTACT_DESCRIPTION_1", "Continue advancing through the video game industry"),
	requirements = {
		completedObjectives = {
			"a_formidable_reputation"
		}
	},
	task = {
		id = "sequence",
		tasks = {
			{
				dialogueID = "first_contact_1",
				id = "finish_dialogue",
				startDialogue = "first_contact_1_1"
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES,
				overrides = {
					updateRivalPaychecks = true,
					unlockActions = {
						"rival_game_companies"
					}
				}
			}
		}
	}
})
objectiveHandler:registerNewObjective({
	autoClaim = true,
	id = "an_eye_for_an_eye",
	icon = "objective_eye_for_an_eye",
	name = _T("AN_EYE_FOR_AN_EYE_TITLE", "An Eye for an Eye"),
	description = _T("AN_EYE_FOR_AN_EYE_DESCRIPTION_1", "Steal an employee from your rival"),
	descriptionNonDisclosing = _T("AN_EYE_FOR_AN_EYE_DESCRIPTION_2", "Continue building up your studio"),
	getDescription = function(self, objectiveObj)
		local taskObj = objectiveObj:getTask()
		local taskID = taskObj:getProgressValues()
		
		if taskID < 4 then
			return self.descriptionNonDisclosing
		end
		
		return self.description
	end,
	requirements = {
		completedObjectives = {
			"first_contact_1"
		}
	},
	task = {
		id = "sequence",
		tasks = {
			{
				id = "wait_for_specific_events",
				events = {
					[rivalGameCompany.EVENTS.SUCCEED_STEAL] = true,
					[rivalGameCompany.EVENTS.FAIL_STEAL] = true
				},
				overrides = {
					allowRivalSlander = false,
					lockActions = {
						rivalGameCompanies.FULL_RIVAL_DIALOGUES,
						rivalGameCompanies.INSTANT_COURT_BUTTONS
					}
				},
				getProgressData = function(self, targetTable, taskObject)
					local finished = taskObject:isFinished()
					
					if not finished then
						table.insert(targetTable, {
							icon = "objectives",
							text = _T("EYE_FOR_AN_EYE_CONTINUE_PROGRESSING", "Continue progressing your studio"),
							iconColor = game.UI_COLORS.ORANGE
						})
					end
				end
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES
			},
			{
				dialogueID = "an_eye_for_an_eye_1",
				id = "finish_dialogue",
				startDialogue = "an_eye_for_an_eye_1_1"
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES,
				overrides = {
					playerEmployeeStealChanceMult = 10000,
					updateRivalPaychecks = true,
					unlockActions = {
						"player_steal_employees"
					}
				}
			},
			{
				id = "wait_for_event",
				event = hudBottom.EVENTS.SHOWING_PROPERTY_BUTTONS,
				overrides = {
					stopTime = 1,
					clickIDs = {
						hudBottom.PROPERTY_AND_RIVALS_BUTTON_ID
					},
					arrow = {
						heightOffset = -1,
						angle = 180,
						widthOffset = 0.5,
						elementID = hudBottom.PROPERTY_AND_RIVALS_BUTTON_ID,
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
				event = rivalGameCompanies.EVENTS.OPENED_MENU,
				overrides = {
					expandHUD = "property_and_rivals_button",
					stopTime = 1,
					clickIDs = {
						hudBottom.RIVALS_BUTTON_ID
					},
					arrow = {
						heightOffset = 0.5,
						angle = 90,
						widthOffset = -1.5,
						elementID = hudBottom.RIVALS_BUTTON_ID,
						align = gui.SIDES.LEFT,
						offset = {
							0,
							0
						}
					}
				}
			},
			{
				id = "steal_employees",
				amount = 1,
				getProgressData = function(self, targetTable, taskObject)
					if #targetTable == 0 then
						table.insert(targetTable, {
							text = _T("EYE_FOR_AN_EYE_OBJECTIVE_TASK_1", "Steal a rival company employee"),
							completed = taskObject:isFinished()
						})
					end
				end,
				overrides = {
					resumeTime = true
				}
			},
			{
				id = "wait_for_event",
				event = rivalGameCompany.EVENTS.THREATENED_PLAYER
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES
			},
			{
				dialogueID = "an_eye_for_an_eye_2",
				id = "finish_dialogue",
				startDialogue = "an_eye_for_an_eye_2_1"
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES,
				overrides = {
					playerEmployeeStealChanceMult = 1
				}
			},
			{
				id = "steal_employees",
				amount = 2,
				getProgressData = function(self, targetTable, taskObject)
					if not taskObject:hasStarted() then
						return 
					end
					
					local cur, total = taskObject:getProgressValues()
					local finished = taskObject:isFinished()
					
					table.insert(targetTable, {
						text = _format(_T("EYE_FOR_AN_EYE_OBJECTIVE_TASK_2", "CUR out of TOTAL more employees stolen"), "CUR", cur, "TOTAL", total),
						completed = finished,
						stoleTwo = finished
					})
				end
			},
			{
				id = "wait_for_event",
				event = timeline.EVENTS.NEW_WEEK
			},
			{
				dialogueID = "story_mode_call_from_rival_1",
				id = "finish_dialogue",
				startDialogue = "story_mode_call_from_rival_1",
				rival = "rival_company_1"
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES
			},
			{
				dialogueID = "an_eye_for_an_eye_3",
				id = "finish_dialogue",
				startDialogue = "an_eye_for_an_eye_3_1"
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES
			},
			{
				id = "wait_for_event",
				event = timeline.EVENTS.NEW_WEEK
			},
			{
				id = "wait_for_event",
				event = rivalGameCompany.EVENTS.SLANDER_POPUP_CLOSED,
				overrides = {
					playerSlanderDiscoveryChanceMult = 0,
					allowRivalSlander = true
				}
			},
			{
				dialogueID = "an_eye_for_an_eye_4",
				id = "finish_dialogue",
				startDialogue = "an_eye_for_an_eye_4_1",
				overrides = {
					playerSlanderDiscoveryChanceMult = 1
				},
				getProgressData = function(self, targetTable, taskObject)
					if not taskObject:hasStarted() or taskObject:isFinished() then
						return 
					end
					
					local cur, total = taskObject:getProgressValues()
					local finished = taskObject:isFinished()
					
					table.insert(targetTable, {
						icon = "objectives",
						text = _T("EYE_FOR_AN_EYE_OBJECTIVE_TASK_3", "Wait for the rival to make his next move"),
						iconColor = game.UI_COLORS.ORANGE
					})
				end
			},
			{
				id = "wait_for_event",
				event = rivalGameCompany.EVENTS.SLANDER_FOUND_OUT,
				getProgressData = function(self, targetTable, taskObject)
					if not taskObject:hasStarted() then
						return 
					end
					
					local cur, total = taskObject:getProgressValues()
					local finished = taskObject:isFinished()
					
					table.insert(targetTable, {
						text = _T("EYE_FOR_AN_EYE_OBJECTIVE_TASK_4", "Wait for rival to slip up"),
						completed = taskObject:isFinished()
					})
				end
			},
			{
				id = "wait_for_event",
				event = rivalGameCompany.EVENTS.SLANDER_POPUP_CLOSED
			},
			{
				dialogueID = "an_eye_for_an_eye_5",
				id = "finish_dialogue",
				startDialogue = "an_eye_for_an_eye_5_1"
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES,
				overrides = {
					lockActions = {
						"reconsider_court_case"
					}
				}
			},
			{
				id = "wait_for_event",
				event = hudBottom.EVENTS.SHOWING_PROPERTY_BUTTONS,
				overrides = {
					stopTime = 1,
					clickIDs = {
						hudBottom.PROPERTY_AND_RIVALS_BUTTON_ID
					},
					arrow = {
						heightOffset = -1,
						angle = 180,
						widthOffset = 0.5,
						elementID = hudBottom.PROPERTY_AND_RIVALS_BUTTON_ID,
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
				event = rivalGameCompanies.EVENTS.OPENED_MENU,
				overrides = {
					expandHUD = "property_and_rivals_button",
					stopTime = 1,
					clickIDs = {
						hudBottom.RIVALS_BUTTON_ID
					},
					arrow = {
						heightOffset = -1,
						angle = 180,
						widthOffset = 0.5,
						elementID = hudBottom.RIVALS_BUTTON_ID,
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
				event = rivalGameCompany.EVENTS.FINISHED_COURT,
				overrides = {
					resumeTime = true
				},
				getProgressData = function(self, targetTable, taskObject)
					if not taskObject:hasStarted() then
						return 
					end
					
					local cur, total = taskObject:getProgressValues()
					local finished = taskObject:isFinished()
					
					table.insert(targetTable, {
						text = _T("EYE_FOR_AN_EYE_OBJECTIVE_TASK_5", "Call rival CEO and go to court"),
						completed = taskObject:isFinished()
					})
				end
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES
			},
			{
				dialogueID = "an_eye_for_an_eye_6",
				id = "finish_dialogue",
				startDialogue = "an_eye_for_an_eye_6_1"
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES,
				overrides = {
					makeRivalBankrupt = "rival_company_1",
					unlockActions = {
						"reconsider_court_case",
						"player_slander",
						rivalGameCompanies.INSTANT_COURT_BUTTONS,
						"buyout_rivals"
					},
					initRivals = {
						"rival_company_2",
						"rival_company_3"
					},
					setRivalOffices = {
						{
							rival = "rival_company_2",
							officeIDs = {
								"office_medium_8"
							}
						},
						{
							rival = "rival_company_3",
							officeIDs = {
								"office_medium_7"
							}
						}
					}
				}
			}
		}
	}
})
