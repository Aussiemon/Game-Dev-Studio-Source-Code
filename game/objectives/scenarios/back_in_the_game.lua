local gameTypeData = game.getGameTypeData("scenario_back_in_the_game")

objectiveHandler:registerNewObjective({
	autoClaim = true,
	id = "back_in_the_game",
	icon = "objective_back_in_the_game",
	name = _T("BACK_IN_THE_GAME_NAME", "Back in the Game"),
	description = _format(_T("BACK_IN_THE_GAME_DESCRIPTION", "Hire EMPLOYEES employees and reach REP in reputation"), "EMPLOYEES", gameTypeData.employeeCount, "REP", string.comma(gameTypeData.targetReputation)),
	failState = {
		id = "time_limit",
		dialogueOnFail = "back_in_the_game_timelimit",
		timeLimit = gameTypeData.yearLimit
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
						dialogueID = "back_in_the_game_1",
						id = "finish_dialogue",
						startDialogue = "back_in_the_game_1_1"
					},
					{
						id = "wait_for_event",
						event = frameController.EVENTS.CLEARED_FRAMES
					},
					{
						id = "reach_reputation",
						requiredReputation = gameTypeData.targetReputation,
						getProgressData = function(self, targetTable, taskObject)
							local accumulated, required = taskObject:getProgressValues()
							
							table.insert(targetTable, {
								text = _format(_T("BACK_IN_THE_GAME_REPUTATION_PROGRESS", "ACC out of REQ reputation"), "ACC", string.comma(math.min(required, accumulated)), "REQ", string.comma(required)),
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
						employeeCount = gameTypeData.employeeCount,
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
	id = "back_in_the_game_finish",
	icon = "objective_back_in_the_game",
	name = _T("BACK_IN_THE_GAME_NAME", "Back in the Game"),
	description = _format(_T("BACK_IN_THE_GAME_DESCRIPTION", "Hire EMPLOYEES employees and reach REP in reputation"), "EMPLOYEES", gameTypeData.employeeCount, "REP", string.comma(gameTypeData.targetReputation)),
	requirements = {
		completedObjectives = {
			"back_in_the_game"
		}
	},
	task = {
		id = "sequence",
		tasks = {
			{
				dialogueID = "back_in_the_game_2",
				id = "finish_dialogue",
				startDialogue = "back_in_the_game_2_1"
			},
			{
				id = "wait_for_event",
				event = frameController.EVENTS.CLEARED_FRAMES
			}
		}
	}
})
