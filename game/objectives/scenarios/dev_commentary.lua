local gameTypeData = game.getGameTypeData("scenario_console_domination")
local hudBottom = gui.getClassTable("HUDBottom")

objectiveHandler:registerNewObjective({
	autoClaim = true,
	id = "scenario_developer_commentary",
	icon = "objective_eye_for_an_eye",
	name = _T("SCENARIO_DEV_COMMENTARY_NAME", "Developer Commentary"),
	description = _T("SCENARIO_DEV_COMMENTARY_DESC_1", "Play and interact with various systems to trigger developer commentary."),
	task = {
		id = "multiple_sequences",
		mainSequences = {
			1,
			2,
			3,
			4,
			5,
			6,
			7,
			8,
			9,
			10,
			11,
			12,
			13,
			14,
			15,
			16,
			17,
			18,
			19,
			20,
			21
		},
		sequences = {
			{
				tasks = {
					{
						id = "wait_for_event",
						event = studio.EVENTS.CONFIRM_STUDIO_NAME
					},
					{
						dialogueID = "dev_commentary_intro",
						id = "finish_dialogue",
						startDialogue = "dev_commentary_intro_1"
					}
				}
			},
			{
				tasks = {
					{
						id = "wait_for_event",
						event = studio.expansion.EVENTS.ENTER_EXPANSION_MODE
					},
					{
						dialogueID = "dev_commentary_building",
						id = "finish_dialogue",
						startDialogue = "dev_commentary_building_1",
						getProgressData = function(self, targetTable, taskObject)
							table.insert(targetTable, {
								text = _T("DEV_COMMENTARY_CONSTRUCTION", "Construction"),
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
							[studio.expansion.EVENTS.EXPANDED_OFFICE] = true,
							[officeBuilding.EVENTS.PURCHASED] = true,
							[officeBuilding.EVENTS.FLOOR_PURCHASED] = true
						}
					},
					{
						dialogueID = "dev_commentary_expansion",
						id = "finish_dialogue",
						startDialogue = "dev_commentary_expansion_1",
						getProgressData = function(self, targetTable, taskObject)
							table.insert(targetTable, {
								text = _T("DEV_COMMENTARY_EXPANSION", "Expansion"),
								completed = taskObject:isFinished()
							})
						end
					}
				}
			},
			{
				tasks = {
					{
						id = "wait_for_event",
						event = activities.EVENTS.ACTIVITY_FINISHED
					},
					{
						id = "wait_for_event",
						event = frameController.EVENTS.CLEARED_FRAMES
					},
					{
						dialogueID = "dev_commentary_activities",
						id = "finish_dialogue",
						startDialogue = "dev_commentary_activities_1",
						getProgressData = function(self, targetTable, taskObject)
							table.insert(targetTable, {
								text = _T("DEV_COMMENTARY_ACTIVITIES", "Activities"),
								completed = taskObject:isFinished()
							})
						end
					}
				}
			},
			{
				tasks = {
					{
						id = "wait_for_event",
						event = developer.EVENTS.INFO_MENU_OPENED
					},
					{
						id = "wait_for_event",
						event = frameController.EVENTS.CLEARED_FRAMES
					},
					{
						dialogueID = "dev_commentary_employees",
						id = "finish_dialogue",
						startDialogue = "dev_commentary_employees_1",
						getProgressData = function(self, targetTable, taskObject)
							table.insert(targetTable, {
								text = _T("DEV_COMMENTARY_EMPLOYEES", "Employees"),
								completed = taskObject:isFinished()
							})
						end
					}
				}
			},
			{
				tasks = {
					{
						id = "wait_for_event",
						event = employeeCirculation.EVENTS.OPENED_MENU
					},
					{
						id = "wait_for_event",
						event = frameController.EVENTS.CLEARED_FRAMES
					},
					{
						dialogueID = "dev_commentary_jobs",
						id = "finish_dialogue",
						startDialogue = "dev_commentary_jobs_1",
						getProgressData = function(self, targetTable, taskObject)
							table.insert(targetTable, {
								text = _T("DEV_COMMENTARY_JOB_OFFERS", "Job offers"),
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
							[gameProject.EVENTS.BEGAN_WORK] = true
						},
						verificationCallback = function(self, taskObj, event, proj)
							if proj:getOwner():isPlayer() then
								return true
							end
							
							return false
						end
					},
					{
						dialogueID = "dev_commentary_games",
						id = "finish_dialogue",
						startDialogue = "dev_commentary_games_1",
						getProgressData = function(self, targetTable, taskObject)
							table.insert(targetTable, {
								text = _T("DEV_COMMENTARY_GAME_CREATION", "Game Creation"),
								completed = taskObject:isFinished()
							})
						end
					}
				}
			},
			{
				tasks = {
					{
						id = "wait_for_event",
						event = gameEditions.EVENTS.MENU_OPENED
					},
					{
						id = "wait_for_event",
						event = frameController.EVENTS.CLEARED_FRAMES
					},
					{
						dialogueID = "dev_commentary_game_editions",
						id = "finish_dialogue",
						startDialogue = "dev_commentary_game_editions_1",
						getProgressData = function(self, targetTable, taskObject)
							table.insert(targetTable, {
								text = _T("DEV_COMMENTARY_GAME_EDITIONS", "Game Editions"),
								completed = taskObject:isFinished()
							})
						end
					}
				}
			},
			{
				tasks = {
					{
						id = "wait_for_event",
						event = projectsMenu.EVENTS.ENGINES_TAB_OPENED
					},
					{
						dialogueID = "dev_commentary_engines",
						id = "finish_dialogue",
						startDialogue = "dev_commentary_engines_1",
						getProgressData = function(self, targetTable, taskObject)
							table.insert(targetTable, {
								text = _T("DEV_COMMENTARY_ENGINES", "Engines"),
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
							[rivalGameCompany.EVENTS.FILL_INTERACTION] = true,
							[rivalGameCompany.EVENTS.ATTEMPT_STEAL] = true,
							[rivalGameCompany.EVENTS.FAIL_STEAL] = true,
							[rivalGameCompany.EVENTS.SUCCEED_STEAL] = true,
							[rivalGameCompany.EVENTS.PLAYER_FAIL_STEAL] = true,
							[rivalGameCompany.EVENTS.PLAYER_SUCCEED_STEAL] = true,
							[rivalGameCompany.EVENTS.THREATENED_PLAYER] = true
						}
					},
					{
						id = "wait_for_event",
						event = frameController.EVENTS.CLEARED_FRAMES
					},
					{
						dialogueID = "dev_commentary_rivals_interaction",
						id = "finish_dialogue",
						startDialogue = "dev_commentary_rivals_interaction_1",
						getProgressData = function(self, targetTable, taskObject)
							table.insert(targetTable, {
								text = _T("DEV_COMMENTARY_RIVALS_INTERACTION", "Rivals - interaction"),
								completed = taskObject:isFinished()
							})
						end
					}
				}
			},
			{
				tasks = {
					{
						id = "wait_for_event",
						event = rivalGameCompany.EVENTS.PERFORMED_SLANDER
					},
					{
						id = "wait_for_event",
						event = frameController.EVENTS.CLEARED_FRAMES
					},
					{
						dialogueID = "dev_commentary_rivals_slander",
						id = "finish_dialogue",
						startDialogue = "dev_commentary_rivals_slander_1",
						getProgressData = function(self, targetTable, taskObject)
							table.insert(targetTable, {
								text = _T("DEV_COMMENTARY_RIVALS_SLANDER", "Rivals - slander"),
								completed = taskObject:isFinished()
							})
						end
					}
				}
			},
			{
				tasks = {
					{
						id = "wait_for_event",
						event = rivalGameCompany.EVENTS.FINISHED_COURT
					},
					{
						id = "wait_for_event",
						event = frameController.EVENTS.CLEARED_FRAMES
					},
					{
						dialogueID = "dev_commentary_rivals_court",
						id = "finish_dialogue",
						startDialogue = "dev_commentary_rivals_court_1",
						getProgressData = function(self, targetTable, taskObject)
							table.insert(targetTable, {
								text = _T("DEV_COMMENTARY_RIVALS_COURT", "Rivals - court"),
								completed = taskObject:isFinished()
							})
						end
					}
				}
			},
			{
				tasks = {
					{
						id = "wait_for_event",
						event = rivalGameCompany.EVENTS.ASKED_ABOUT_BRIBE
					},
					{
						id = "wait_for_event",
						event = frameController.EVENTS.CLEARED_FRAMES
					},
					{
						dialogueID = "dev_commentary_rivals_bribes",
						id = "finish_dialogue",
						startDialogue = "dev_commentary_rivals_bribes_1",
						getProgressData = function(self, targetTable, taskObject)
							table.insert(targetTable, {
								text = _T("DEV_COMMENTARY_RIVALS_BRIBES", "Rivals - bribe inquiry"),
								completed = taskObject:isFinished()
							})
						end
					}
				}
			},
			{
				tasks = {
					{
						id = "wait_for_event",
						event = projectsMenu.EVENTS.PLATFORMS_TAB_OPENED
					},
					{
						id = "wait_for_event",
						event = frameController.EVENTS.CLEARED_FRAMES
					},
					{
						dialogueID = "dev_commentary_platforms",
						id = "finish_dialogue",
						startDialogue = "dev_commentary_platforms_1",
						getProgressData = function(self, targetTable, taskObject)
							table.insert(targetTable, {
								text = _T("DEV_COMMENTARY_PLATFORMS", "Platforms"),
								completed = taskObject:isFinished()
							})
						end
					}
				}
			},
			{
				tasks = {
					{
						id = "wait_for_event",
						event = platformParts.EVENTS.MENU_OPENED
					},
					{
						id = "wait_for_event",
						event = frameController.EVENTS.CLEARED_FRAMES
					},
					{
						dialogueID = "dev_commentary_platform_creation",
						id = "finish_dialogue",
						startDialogue = "dev_commentary_platform_creation_1",
						getProgressData = function(self, targetTable, taskObject)
							table.insert(targetTable, {
								text = _T("DEV_COMMENTARY_PLATFORM_CREATION", "Platform creation"),
								completed = taskObject:isFinished()
							})
						end
					}
				}
			},
			{
				tasks = {
					{
						id = "wait_for_event",
						event = studio.EVENTS.CHANGED_LOAN
					},
					{
						id = "wait_for_event",
						event = frameController.EVENTS.CLEARED_FRAMES
					},
					{
						dialogueID = "dev_commentary_loans",
						id = "finish_dialogue",
						startDialogue = "dev_commentary_loans_1",
						getProgressData = function(self, targetTable, taskObject)
							table.insert(targetTable, {
								text = _T("DEV_COMMENTARY_LOANS", "Loans"),
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
							[gameProject.EVENTS.DEVELOPMENT_TYPE_CHANGED] = true
						},
						verificationCallback = function(self, taskObj, event, proj, gameType)
							if proj:getOwner():isPlayer() and gameType == gameProject.DEVELOPMENT_TYPE.MMO then
								return true
							end
							
							return false
						end
					},
					{
						id = "wait_for_event",
						event = frameController.EVENTS.CLEARED_FRAMES
					},
					{
						dialogueID = "dev_commentary_mmos",
						id = "finish_dialogue",
						startDialogue = "dev_commentary_mmos_1",
						getProgressData = function(self, targetTable, taskObject)
							table.insert(targetTable, {
								text = _T("DEV_COMMENTARY_MMOS", "MMOS"),
								completed = taskObject:isFinished()
							})
						end
					}
				}
			},
			{
				tasks = {
					{
						id = "wait_for_event",
						event = interview.EVENTS.FINISHED
					},
					{
						id = "wait_for_event",
						event = frameController.EVENTS.CLEARED_FRAMES
					},
					{
						dialogueID = "dev_commentary_interviews",
						id = "finish_dialogue",
						startDialogue = "dev_commentary_interviews_1",
						getProgressData = function(self, targetTable, taskObject)
							table.insert(targetTable, {
								text = _T("DEV_COMMENTARY_INTERVIEWS", "Interviews"),
								completed = taskObject:isFinished()
							})
						end
					}
				}
			},
			{
				tasks = {
					{
						id = "wait_for_event",
						event = projectReview.EVENTS.OPENED
					},
					{
						id = "wait_for_event",
						event = frameController.EVENTS.CLEARED_FRAMES
					},
					{
						dialogueID = "dev_commentary_reviews",
						id = "finish_dialogue",
						startDialogue = "dev_commentary_reviews_1",
						getProgressData = function(self, targetTable, taskObject)
							table.insert(targetTable, {
								text = _T("DEV_COMMENTARY_REVIEWS", "Reviews"),
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
							[studio.EVENTS.OFFERED_BRIBE] = true
						},
						verificationCallback = function(self, taskObj, event, reviewerObj, bribeSize, gameProj, result)
							if gameProj:getOwner():isPlayer() then
								return true
							end
							
							return false
						end
					},
					{
						id = "wait_for_event",
						event = frameController.EVENTS.CLEARED_FRAMES
					},
					{
						dialogueID = "dev_commentary_bribes",
						id = "finish_dialogue",
						startDialogue = "dev_commentary_bribes_1",
						getProgressData = function(self, targetTable, taskObject)
							table.insert(targetTable, {
								text = _T("DEV_COMMENTARY_BRIBES", "Bribes"),
								completed = taskObject:isFinished()
							})
						end
					}
				}
			},
			{
				tasks = {
					{
						id = "wait_for_event",
						event = gameProject.EVENTS.ADVERT_MENU_OPENED,
						verificationCallback = function(self, taskObj, event, reviewerObj, bribeSize, gameProj, result)
							if gameProj:getOwner():isPlayer() then
								return true
							end
							
							return false
						end
					},
					{
						id = "wait_for_event",
						event = frameController.EVENTS.CLEARED_FRAMES
					},
					{
						dialogueID = "dev_commentary_adverts",
						id = "finish_dialogue",
						startDialogue = "dev_commentary_adverts_1",
						getProgressData = function(self, targetTable, taskObject)
							table.insert(targetTable, {
								text = _T("DEV_COMMENTARY_ADVERTISEMENTS", "Advertisements"),
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
	id = "scenario_developer_commentary_outro",
	icon = "objective_eye_for_an_eye",
	name = _T("SCENARIO_DEV_COMMENTARY_NAME", "Developer Commentary"),
	description = _T("SCENARIO_DEV_COMMENTARY_DESC_1", "Play and interact with various systems to trigger developer commentary."),
	requirements = {
		completedObjectives = {
			"scenario_developer_commentary"
		}
	},
	task = {
		id = "sequence",
		tasks = {
			{
				dialogueID = "dev_commentary_outro",
				id = "finish_dialogue",
				startDialogue = "dev_commentary_outro_1"
			}
		}
	}
})
require("game/dialogue/scenarios/developer_commentary")
