local gameTypeData = game.getGameTypeData("scenario_pay_denbts")

objectiveHandler:registerNewObjective({
	autoClaim = true,
	id = "pay_denbts",
	icon = "objective_pay_denbts",
	name = _T("PAY_DENBTS", "Pay Debts"),
	description = _format(_T("PAY_DENBTS_DESCRIPTION", "Pay off a debt of $DEBT in TIME"), "DEBT", string.comma(gameTypeData.moneyToPayOff), "TIME", timeline:getTimePeriodText(gameTypeData.yearLimit)),
	failState = {
		id = "time_limit",
		dialogueOnFail = "pay_denbts_timelimit",
		timeLimit = gameTypeData.yearLimit
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
						dialogueID = "pay_denbts_1",
						id = "finish_dialogue",
						startDialogue = "pay_denbts_1_1"
					},
					{
						id = "wait_for_event",
						event = frameController.EVENTS.CLEARED_FRAMES
					},
					{
						id = "get_funds",
						amount = gameTypeData.moneyToPayOff,
						getProgressData = function(self, targetTable, taskObject)
							local accumulated, required = taskObject:getProgressValues()
							
							table.insert(targetTable, {
								text = _format(_T("PAY_DENBTS_PROGRESS", "$ACC out of $REQ earned"), "ACC", string.comma(math.min(required, accumulated)), "REQ", string.comma(required)),
								completed = taskObject:isFinished()
							})
						end
					},
					{
						dialogueID = "pay_denbts_2",
						id = "finish_dialogue",
						startDialogue = "pay_denbts_2_1"
					},
					{
						id = "wait_for_event",
						event = frameController.EVENTS.CLEARED_FRAMES
					}
				}
			}
		}
	}
})
