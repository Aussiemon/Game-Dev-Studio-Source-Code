local hudBottom = gui.getClassTable("HUDBottom")

objectiveHandler:registerNewObjective({
	id = "tutorial_construction_1",
	icon = "objective_getting_started",
	autoClaim = true,
	name = _T("TUTORIAL_CONSTRUCTION_1", "Construction Basics"),
	description = _T("TUTORIAL_CONSTRUCTION_1_DESCRIPTION", "Learn the basics of construction"),
	task = {
		id = "sequence",
		tasks = {
			{
				id = "wait_for_event",
				event = studio.EVENTS.CONFIRM_STUDIO_NAME
			},
			{
				dialogueID = "tutorial_construction_1",
				id = "finish_dialogue",
				startDialogue = "tutorial_construction_1_1"
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
					disableBuildingPurchases = true,
					stopTime = 1,
					disableExpansion = true,
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
				dialogueID = "tutorial_construction_2",
				id = "finish_dialogue",
				startDialogue = "tutorial_construction_2_1"
			},
			{
				id = "wait_for_event",
				event = studio.expansion.EVENTS.CONSTRUCTION_MODE_CHANGED,
				overrides = {
					disableBuildingPurchases = true,
					stopTime = 1,
					disableExpansion = true,
					clickIDs = {
						studio.expansion:getObjectTabID("office")
					},
					arrow = {
						heightOffset = -1,
						angle = 180,
						widthOffset = 0.5,
						elementID = studio.expansion:getObjectTabID("office"),
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
				event = studio.expansion.EVENTS.CLICKED_OBJECT_OPTION,
				overrides = {
					clickIDs = {
						"workplace_icon"
					},
					arrow = {
						heightOffset = -0.25,
						angle = 180,
						widthOffset = 0.5,
						elementID = "workplace_icon",
						align = gui.SIDES.TOP,
						offset = {
							0,
							0
						}
					}
				}
			},
			{
				id = "have_workplaces",
				amount = 7,
				getProgressData = function(self, targetTable, taskObject)
					if taskObject:hasStarted() and not taskObject:isFinished() then
						local cur, req = taskObject:getProgressValues()
						
						table.insert(targetTable, {
							text = _format(_T("TUTORIAL_WORKPLACES_PLACED_VALID", "CUR/REQ valid workplaces"), "CUR", math.min(req, cur), "REQ", req),
							completed = taskObject:isFinished()
						})
					end
				end,
				progressTracking = {
					class = "ObjectiveTaskHUDDisplay"
				}
			},
			{
				dialogueID = "tutorial_construction_3",
				id = "finish_dialogue",
				startDialogue = "tutorial_construction_3_1"
			},
			{
				id = "wait_for_event",
				event = studio.expansion.EVENTS.CONSTRUCTION_MODE_CHANGED,
				overrides = {
					disableBuildingPurchases = true,
					stopTime = 1,
					disableExpansion = true,
					clickIDs = {
						studio.expansion:getObjectTabID("sanitary")
					},
					arrow = {
						heightOffset = -1,
						angle = 180,
						widthOffset = 0.5,
						elementID = studio.expansion:getObjectTabID("sanitary"),
						align = gui.SIDES.TOP,
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
					[studio.ROOM_TYPES.TOILET] = 1
				},
				getProgressData = function(self, targetTable, taskObject)
					if taskObject:hasStarted() and not taskObject:isFinished() then
						table.insert(targetTable, {
							text = _T("GETTING_STARTED_RESTROOM_CONSTRUCTED", "Restroom constructed"),
							completed = studio:getValidRoomTypeCount(studio.ROOM_TYPES.TOILET) > 0
						})
					end
				end,
				progressTracking = {
					class = "ObjectiveTaskHUDDisplay"
				}
			},
			{
				dialogueID = "tutorial_construction_4",
				id = "finish_dialogue",
				startDialogue = "tutorial_construction_4_1"
			},
			{
				id = "wait_for_event",
				event = studio.expansion.EVENTS.CONSTRUCTION_MODE_CHANGED,
				overrides = {
					disableBuildingPurchases = true,
					stopTime = 1,
					disableExpansion = true,
					clickIDs = {
						studio.expansion:getObjectTabID("food")
					},
					arrow = {
						heightOffset = -1,
						angle = 180,
						widthOffset = 0.5,
						elementID = studio.expansion:getObjectTabID("food"),
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
				event = studio.expansion.EVENTS.CLICKED_OBJECT_OPTION,
				overrides = {
					clickIDs = {
						"water_dispenser_icon"
					},
					arrow = {
						heightOffset = -0.25,
						angle = 180,
						widthOffset = 0.5,
						elementID = "water_dispenser_icon",
						align = gui.SIDES.TOP,
						offset = {
							0,
							0
						}
					}
				}
			},
			{
				objectClass = "water_dispenser",
				id = "have_objects",
				amount = 1,
				getProgressData = function(self, targetTable, taskObject)
					if taskObject:hasStarted() and not taskObject:isFinished() then
						table.insert(targetTable, {
							text = _T("TUTORIAL_WATER_DISPENSER_PLACED", "Water dispenser placed"),
							completed = taskObject:isFinished()
						})
					end
				end,
				progressTracking = {
					class = "ObjectiveTaskHUDDisplay"
				}
			},
			{
				dialogueID = "tutorial_construction_5",
				id = "finish_dialogue",
				startDialogue = "tutorial_construction_5_1"
			},
			{
				expansions = 3,
				id = "expand_office",
				overrides = {
					enableExpansion = true
				},
				getProgressData = function(self, targetTable, taskObject)
					if taskObject:hasStarted() and not taskObject:isFinished() then
						local cur, req = taskObject:getProgressValues()
						
						table.insert(targetTable, {
							text = _format(_T("TUTORIAL_OFFICE_EXPANDED", "Office expanded CUR/REQ"), "CUR", cur, "REQ", req),
							completed = taskObject:isFinished()
						})
					end
				end,
				progressTracking = {
					class = "ObjectiveTaskHUDDisplay"
				}
			},
			{
				dialogueID = "tutorial_construction_6",
				id = "finish_dialogue",
				startDialogue = "tutorial_construction_6_1"
			},
			{
				id = "wait_for_event",
				event = camera.EVENTS.APPROACH_FINISHED,
				overrides = {
					lockUI = true,
					moveCameraToBuilding = "office_medium_4"
				}
			},
			{
				id = "wait_for_event",
				event = officeBuilding.EVENTS.PURCHASED,
				overrides = {
					enableBuildingPurchases = true
				},
				getProgressData = function(self, targetTable, taskObject)
					if taskObject:hasStarted() and not taskObject:isFinished() then
						local cur, req = taskObject:getProgressValues()
						
						table.insert(targetTable, {
							text = _T("TUTORIAL_NEW_OFFICE_PURCHASED", "New office purchased"),
							completed = taskObject:isFinished()
						})
					end
				end,
				progressTracking = {
					class = "ObjectiveTaskHUDDisplay"
				}
			},
			{
				dialogueID = "tutorial_construction_7",
				id = "finish_dialogue",
				startDialogue = "tutorial_construction_7_1"
			},
			{
				id = "wait_for_event",
				event = studio.expansion.EVENTS.LEAVE_EXPANSION_MODE,
				overrides = {
					arrow = {
						heightOffset = 0.5,
						angle = 270,
						widthOffset = 2,
						skipBackgroundFade = true,
						elementID = studio.expansion.EXIT_EXPANSION_BUTTON_ID,
						align = gui.SIDES.LEFT,
						offset = {
							0,
							0
						}
					}
				}
			}
		}
	},
	onFinish = function(self)
		game.curGametype:setHUDVisibility(2)
	end
})
