local gameTypeData = game.getGameTypeData("scenario_ravioli_and_pepperoni")

objectiveHandler:registerNewObjective({
	autoClaim = true,
	id = "ravioli_and_pepperoni",
	icon = "objective_ravioli_and_pepperoni",
	name = _T("RAVIOLI_AND_PEPPERONI_NAME", "Ravioli & Pepperoni"),
	description = _T("RAVIOLI_AND_PEPPERONI_DESCRIPTION", "Buy out/make sure \"Arts of Electrics\" goes bankrupt."),
	task = {
		id = "multiple_sequences",
		mainSequences = {
			1
		},
		sequences = {
			{
				tasks = {
					{
						dialogueID = "ravioli_and_pepperoni_1",
						id = "finish_dialogue",
						startDialogue = "ravioli_and_pepperoni_1_1"
					},
					{
						id = "wait_for_event",
						event = frameController.EVENTS.CLEARED_FRAMES
					},
					{
						id = "rival_stops_existing",
						rivalID = "ravioli_and_pepperoni_1"
					}
				}
			},
			{
				tasks = {
					{
						dialogueID = "ravioli_and_pepperoni_coworker_1_1",
						reputation = 4000,
						id = "receive_coworker",
						refuseQuestionID = "ravioli_and_pepperoni_coworker_1_3",
						employeeConfig = {
							role = "software_engineer",
							level = 7
						}
					},
					{
						dialogueID = "ravioli_and_pepperoni_coworker_2_1",
						reputation = 8000,
						id = "receive_coworker",
						refuseQuestionID = "ravioli_and_pepperoni_coworker_2_3",
						employeeConfig = {
							role = "writer",
							level = 8
						}
					},
					{
						dialogueID = "ravioli_and_pepperoni_coworker_3_1",
						reputation = 15000,
						id = "receive_coworker",
						refuseQuestionID = "ravioli_and_pepperoni_coworker_2_3",
						employeeConfig = {
							role = "artist",
							level = 9
						}
					},
					{
						dialogueID = "ravioli_and_pepperoni_coworker_4_1",
						reputation = 22000,
						id = "receive_coworker",
						refuseQuestionID = "ravioli_and_pepperoni_coworker_4_3",
						employeeConfig = {
							role = "sound_engineer",
							level = 9
						}
					},
					{
						dialogueID = "ravioli_and_pepperoni_coworker_5_1",
						reputation = 30000,
						id = "receive_coworker",
						refuseQuestionID = "ravioli_and_pepperoni_coworker_5_3",
						employeeConfig = {
							role = "designer",
							level = 10
						}
					}
				}
			}
		}
	}
})
objectiveHandler:registerNewObjective({
	autoClaim = true,
	id = "ravioli_and_pepperoni_finish",
	icon = "objective_ravioli_and_pepperoni",
	name = _T("RAVIOLI_AND_PEPPERONI_NAME", "Ravioli & Pepperoni"),
	description = _T("RAVIOLI_AND_PEPPERONI_DESCRIPTION", "Buy out/make sure \"Arts of Electrics\" goes bankrupt."),
	requirements = {
		completedObjectives = {
			"ravioli_and_pepperoni"
		}
	},
	task = {
		id = "sequence",
		tasks = {
			{
				dialogueID = "ravioli_and_pepperoni_2",
				id = "finish_dialogue",
				startDialogue = "ravioli_and_pepperoni_2_1"
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES
			}
		}
	}
})
