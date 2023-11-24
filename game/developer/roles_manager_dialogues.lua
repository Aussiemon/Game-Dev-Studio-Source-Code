dialogueHandler.registerQuestion({
	id = "manager_lots_of_people_in_room",
	text = _T("DEVELOPER_MANAGER_LOTS_OF_PEOPLE_IN_ROOM", "I could manage a lot more people if I was in a room with less folks in it."),
	answers = {
		"developer_inquire_about_workplace_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "manager_team_drive_report_inquire",
	text = _T("MANAGER_TEAM_DRIVE_REPORT", "No problem, which team do you wish to find out about?"),
	answers = {},
	getAnswers = function(self, dialogueObject)
		table.clearArray(self.answers)
		
		local manager = dialogueObject:getEmployee()
		local managedTeams = manager:getManagedTeams()
		
		for i = 1, #managedTeams do
			table.insert(self.answers, "manager_select_team_drive_ask")
		end
		
		table.insert(self.answers, "generic_nevermind")
		
		return self.answers
	end
})
dialogueHandler.registerQuestion({
	id = "manager_team_drive_report",
	answers = {
		"generic_thanks_for_info"
	},
	answersWithHint = {
		"manager_ask_for_activity_hints",
		"generic_thanks_for_info"
	},
	allDriveLevels = {
		high = {
			_T("ALL_DRIVE_HIGH", "Motivation is good.")
		},
		medium = {
			_T("ALL_DRIVE_MEDIUM", "Motivation is OK.")
		},
		low = {
			_T("ALL_DRIVE_LOW", "Motivation could be better.")
		}
	},
	majorityDriveLevels = {
		high = {
			_T("MAJORITY_DRIVE_HIGH", "Motivation is mostly good.")
		},
		medium = {
			_T("MAJORITY_DRIVE_MEDIUM", "Motivation is mostly average.")
		},
		low = {
			_T("MAJORITY_DRIVE_LOW", "Motivation is mostly low.")
		}
	},
	somePeople = {
		high = {
			_T("SOME_PEOPLE_DRIVE_HIGH", "Some people are highly motivated.")
		},
		medium = {
			_T("SOME_PEOPLE_DRIVE_MEDIUM", "Some people are moderately motivated. If you want to raise their motivation a bit, you could organize a team-building activity.")
		},
		low = {
			_T("SOME_PEOPLE_DRIVE_LOW", "Some people are low on motivation. Organizing a team-building activity could help with that. Also, send them on vacation if they recently asked for one.")
		}
	},
	concatTable = {},
	getText = function(self, dialogueObject)
		local manager = dialogueObject:getEmployee()
		local teamObj = manager:getManagedTeams()[dialogueObject:getFact("team_to_report")]
		local teamMembers = teamObj:getMembers()
		local totalDrive, lowDrive, mediumDrive, highDrive = 0, 0, 0, 0
		
		for key, member in ipairs(teamMembers) do
			if member ~= self and not member:isPlayerCharacter() then
				local drive = member:getDrive()
				
				if drive <= developer.MEDIUM_DRIVE_LEVEL then
					mediumDrive = mediumDrive + 1
				elseif drive <= developer.LOW_DRIVE_LEVEL then
					lowDrive = lowDrive + 1
				else
					highDrive = highDrive + 1
				end
				
				totalDrive = totalDrive + 1
			end
		end
		
		local baseText, someText
		
		if highDrive == totalDrive then
			baseText = self.allDriveLevels.high
		elseif mediumDrive == totalDrive then
			baseText = self.allDriveLevels.medium
		elseif lowDrive == totalDrive then
			baseText = self.allDriveLevels.low
		elseif mediumDrive <= highDrive and lowDrive <= highDrive then
			baseText = baseText or self.majorityDriveLevels.high
		elseif highDrive <= mediumDrive and lowDrive <= mediumDrive then
			baseText = baseText or self.majorityDriveLevels.medium
		elseif mediumDrive <= lowDrive and highDrive <= lowDrive then
			baseText = baseText or self.majorityDriveLevels.low
		end
		
		table.insert(self.concatTable, baseText[math.random(1, #baseText)])
		
		local highest = math.max(lowDrive, mediumDrive, highDrive)
		
		if lowDrive > 0 and lowDrive ~= highest then
			someText = self.somePeople.low
		elseif mediumDrive > 0 and mediumDrive ~= highest then
			someText = self.somePeople.medium
			
			dialogueObject:setFact("show_extra_hints", true)
		elseif highDrive > 0 and highDrive ~= highest then
			someText = self.somePeople.high
			
			dialogueObject:setFact("show_extra_hints", true)
		end
		
		if someText then
			table.insert(self.concatTable, someText[math.random(1, #someText)])
		else
			table.insert(self.concatTable, _T("DRIVE_LEVELS_REPORT_NOT_MUCH_TO_SAY", "Not much to say aside from that. There doesn't seem to be a situation where one person is highly motivated while another is burned out."))
		end
		
		local result = table.concat(self.concatTable, " ")
		
		table.clearArray(self.concatTable)
		
		return result
	end,
	getAnswers = function(self, dialogueObject)
		if dialogueObject:getFact("show_extra_hints") then
			return self.answersWithHint
		end
		
		return self.answers
	end
})
dialogueHandler.registerQuestion({
	id = "manager_mention_activity_hint",
	text = _T("MANAGER_MENTION_ACTIVITY_HINT_NO_IDEA", "Frankly, I don't know what particular activity folks around the office would like. Though I'm certain that if you'd organize a team-building activity, people would go and they'd enjoy it."),
	answers = {
		"generic_thanks_for_info"
	},
	activityList = {},
	mentionableEmployees = {},
	getText = function(self, dialogueObject)
		local manager = dialogueObject:getEmployee()
		local teamObj = manager:getManagedTeams()[dialogueObject:getFact("team_to_report")]
		local teamMembers = teamObj:getMembers()
		local playerCharacter = studio:getPlayerCharacter()
		local activityList = self.activityList
		
		for key, member in ipairs(teamMembers) do
			if member ~= manager and member ~= playerCharacter then
				for key, interest in ipairs(member:getInterests()) do
					local activitiesByInterest = activities.registeredByInterest[interest]
					
					if activitiesByInterest and not table.find(activityList, activitiesByInterest) then
						activityList[#activityList + 1] = activitiesByInterest
					end
				end
			end
		end
		
		if #activityList > 0 then
			local randomIndex = math.random(1, #activityList)
			local randomActList = activityList[randomIndex]
			local randomActivityData = randomActList[math.random(1, #randomActList)]
			local mentionableEmployees = self.mentionableEmployees
			
			for key, member in ipairs(teamMembers) do
				if member ~= manager and member ~= playerCharacter then
					for key, data in ipairs(randomActivityData.contributingInterestsNumeric) do
						if data.contribution > 1 and member:hasInterest(data.interest) then
							mentionableEmployees[#mentionableEmployees + 1] = member
							
							break
						end
					end
				end
			end
			
			local randomEmployee = mentionableEmployees[math.random(1, #mentionableEmployees)]
			
			table.clearArray(activityList)
			table.clearArray(mentionableEmployees)
			
			return randomActivityData:formatMentionHintText(randomEmployee)
		end
		
		return self.text
	end
})
dialogueHandler.registerAnswer({
	id = "manager_ask_about_team_drive",
	question = "manager_team_drive_report_inquire",
	text = _T("MANAGER_ASK_ABOUT_TEAM_DRIVE", "Let's talk about the morale of teams you're managing.")
})
dialogueHandler.registerAnswer({
	question = "manager_team_drive_report",
	id = "manager_select_team_drive_ask",
	text = _T("TEAM_NAME", "'TEAM'"),
	getText = function(self, dialogueObject, key)
		return _format(self.text, "TEAM", dialogueObject:getEmployee():getManagedTeams()[key]:getName())
	end,
	onPick = function(self, dialogueObject, prevQuestionID, key)
		dialogueObject:setFact("team_to_report", key)
	end
})
dialogueHandler.registerAnswer({
	id = "manager_ask_for_activity_hints",
	question = "manager_mention_activity_hint",
	text = _T("MANAGER_ASK_FOR_ACTIVITY_HINTS", "What activity can you suggest?")
})
dialogueHandler.registerQuestion({
	id = "manager_game_pricing_inquire",
	text = _T("MANAGER_GAME_PRICING_INQUIRE", "No problem, which game would you like me to do research for?"),
	textNoWorkplace = _T("CANT_PRICE_RESEARCH_NO_WORKPLACE", "Boss, I can't research a price for any game if I'm without a workplace."),
	answers = {},
	priceResearchList = {},
	getText = function(self, dialogueObject)
		if not dialogueObject:getEmployee():getWorkplace() then
			return self.textNoWorkplace
		end
		
		return self.text
	end,
	getAnswers = function(self, dialogueObject)
		table.clearArray(self.answers)
		
		if dialogueObject:getEmployee():getWorkplace() then
			local gameList = {}
			
			dialogueObject:setFact("linked_games", gameList)
			
			local priceResearchList = self.priceResearchList
			
			for key, employee in ipairs(studio:getEmployees()) do
				local task = employee:getTask()
				
				if task and task:getID() == "price_research_task" then
					local researchProj = task:getProject()
					
					if not table.find(self.priceResearchList, researchProj) then
						table.insert(priceResearchList, researchProj)
					end
				end
			end
			
			for key, gameObj in ipairs(studio:getGames()) do
				if not gameObj:getReleaseDate() and not gameObj:getContractor() and not gameObj:isIdealPriceKnown() and not table.find(priceResearchList, gameObj) then
					table.insert(self.answers, "manager_select_game_pricing_ask")
					
					gameList[#gameList + 1] = gameObj
				end
			end
			
			table.clearArray(priceResearchList)
		end
		
		table.insert(self.answers, "generic_nevermind")
		
		return self.answers
	end
})
dialogueHandler.registerQuestion({
	id = "manager_begin_game_pricing_research",
	text = _T("manager_begin_game_pricing_research", "Alright, I'll get on it right away."),
	answers = {
		"generic_return_to_conversation"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "manager_game_pricing_finished_2",
	id = "manager_game_pricing_finished_1",
	text = _T("MANAGER_GAME_PRICING_FINISHED_1", "Hey boss, I'm done with my research on what the best price for 'GAME' is."),
	answers = {
		"generic_continue"
	},
	getText = function(self, dialogueObject)
		return _format(self.text, "GAME", dialogueObject:getFact("game"):getName())
	end
})
dialogueHandler.registerQuestion({
	id = "manager_game_pricing_finished_2",
	textRegular = _T("MANAGER_GAME_PRICING_FINISHED_2", "Judging by the current trends and on-market platforms, a game with a scale factor of xSCALE is best suited with a price of $PRICE."),
	textMMO = _T("MANAGER_GAME_PRICING_FINISHED_2_MMO_PROFIT", "Judging by the current trends and on-market platforms, a MMO with a scale factor of xSCALE is best suited with a price of $PRICE. A monthly subscription fee of $PROFIT_FEE will ensure us profit, whereas a fee of $IDEAL_FEE is considered ideal. I recommend going with the $PROFIT_FEE, and reducing it to $IDEAL_FEE only if it's near impossible to keep a stable playerbase with a fee of $PROFIT_FEE."),
	textMMOIdealOnly = _T("MANAGER_GAME_PRICING_FINISHED_2_MMO", "Judging by the current trends and on-market platforms, a MMO with a scale factor of xSCALE is best suited with a price of $PRICE, and a monthly subscription fee of $FEE."),
	answers = {
		"generic_thanks_for_info_2"
	},
	getText = function(self, dialogueObject)
		local gameProj = dialogueObject:getFact("game")
		
		gameProj:setKnownIdealPrice(true)
		
		if gameProj:getGameType() == gameProject.DEVELOPMENT_TYPE.MMO then
			local logic = logicPieces:getData(gameProject.MMO_SUBSCRIPTIONS_LOGIC_PIECE_ID)
			local profitFee, idealFee = logic:getBestFee(gameProj)
			
			if profitFee == idealFee then
				return _format(self.textMMOIdealOnly, "SCALE", gameProj:getScale(), "PRICE", gameProj:calculateIdealPriceForScale(), "FEE", profitFee)
			end
			
			return _format(self.textMMO, "SCALE", gameProj:getScale(), "PRICE", gameProj:calculateIdealPriceForScale(), "PROFIT_FEE", profitFee, "IDEAL_FEE", idealFee)
		end
		
		return _format(self.textRegular, "SCALE", gameProj:getScale(), "PRICE", gameProj:calculateIdealPriceForScale())
	end
})
dialogueHandler.registerAnswer({
	id = "manager_ask_about_game_pricing",
	question = "manager_game_pricing_inquire",
	text = _T("MANAGER_ASK_ABOUT_GAME_PRICING", "Let's talk about game pricing.")
})
dialogueHandler.registerAnswer({
	question = "manager_begin_game_pricing_research",
	id = "manager_select_game_pricing_ask",
	text = _T("GAME_NAME", "'GAME'"),
	getText = function(self, dialogueObject, key)
		return _format(self.text, "GAME", dialogueObject:getFact("linked_games")[key]:getName())
	end,
	onPick = function(self, dialogueObject, prevQuestionID, key)
		local employee = dialogueObject:getEmployee()
		
		employee:getRoleData():beginPricingResearch(employee, dialogueObject:getFact("linked_games")[key])
	end
})
dialogueHandler.registerQuestion({
	nextQuestion = "manager_game_price_consult",
	id = "manager_game_high_price_1",
	text = _T("MANAGER_GAME_HIGH_PRICE_1", "Hey boss, are you sure you want to release 'GAME' priced as it is? If you ask me it's priced too high for its' scale."),
	answers = {
		"generic_continue"
	},
	getText = function(self, dialogueObject)
		return _format(self.text, "GAME", dialogueObject:getFact("game"):getName())
	end
})
dialogueHandler.registerQuestion({
	nextQuestion = "manager_game_price_consult",
	id = "manager_game_low_price_1",
	text = _T("MANAGER_GAME_LOW_PRICE_1", "Hey boss, are you sure you want to release 'GAME' priced as it is? If you ask me it's priced too low for its' scale."),
	answers = {
		"generic_continue"
	},
	getText = function(self, dialogueObject)
		return _format(self.text, "GAME", dialogueObject:getFact("game"):getName())
	end
})
dialogueHandler.registerQuestion({
	id = "manager_game_price_consult",
	text = _T("MANAGER_GAME_PRICE_CONSULT", "If you ever need help in regard to setting a good price for a game, be sure to consult with me, or any Manager in the office first. We can do research on this topic and get back to you on a price we think will be most fair for any game we make."),
	textKnown = _T("MANAGER_GAME_PRICE_CONSULT_KNOWN", "We've already done research on the best price for this game, and we think a pricetag of $PRICE is ideal. Consider changing the price to that before you release the game."),
	answers = {
		"manager_start_price_research",
		"manager_game_high_price_finish"
	},
	answersKnown = {
		"manager_game_high_price_finish"
	},
	getText = function(self, dialogueObject)
		local gameProj = dialogueObject:getFact("game")
		
		if gameProj:isIdealPriceKnown() then
			return _format(self.textKnown, "PRICE", gameProj:calculateIdealPriceForScale())
		end
		
		return self.text
	end,
	getAnswers = function(self, dialogueObject)
		local gameProj = dialogueObject:getFact("game")
		
		if gameProj:isIdealPriceKnown() then
			return self.answersKnown
		end
		
		return self.answers
	end
})
dialogueHandler.registerAnswer({
	question = "manager_begin_game_pricing_research",
	id = "manager_start_price_research",
	text = _T("MANAGER_START_PRICE_RESEARCH", "In that case, find out what the best price is for 'GAME' and report back to me when you're done."),
	getText = function(self, dialogueObject)
		return _format(self.text, "GAME", dialogueObject:getFact("game"):getName())
	end,
	onPick = function(self, dialogueObject)
		local employee = dialogueObject:getEmployee()
		
		employee:getRoleData():beginPricingResearch(employee, dialogueObject:getFact("game"))
	end
})
dialogueHandler.registerAnswer({
	id = "manager_game_high_price_finish",
	text = _T("MANAGER_GAME_HIGH_PRICE_FINISH", "Alright, thanks for the heads-up.")
})
dialogueHandler.registerQuestion({
	id = "cant_price_research_no_workplace",
	text = _T("CANT_PRICE_RESEARCH_NO_WORKPLACE", "Boss, I can't research a price for any game if I'm without a workplace."),
	answers = {
		"end_conversation_ok"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "manager_finished_feedback_analysis_result",
	nextQuestionNothingNew = "manager_finished_feedback_analysis_no_result",
	id = "manager_finished_feedback_analysis",
	text = _T("MANAGER_FINISHED_FEEDBACK_ANALYSIS", "Hey boss, I'm done reading feedback from the players of our 'GAME' MMO."),
	answers = {
		"generic_continue"
	},
	getNextQuestion = function(self, dialogueObject)
		if not dialogueObject:getFact("task") then
			local gameObj = dialogueObject:getFact("game")
			local logic = gameObj:getLogicPiece(gameProject.MMO_SUBSCRIPTIONS_LOGIC_PIECE_ID)
			local miscText = logic:getMiscAnalysisText(self, gameObj)
			
			if miscText then
				dialogueObject:setFact("misc_info", miscText)
				
				return self.nextQuestion
			end
			
			return self.nextQuestionNothingNew
		end
		
		return self.nextQuestion
	end,
	getText = function(self, dialogueObject)
		return _format(self.text, "GAME", dialogueObject:getFact("game"):getName())
	end
})
dialogueHandler.registerQuestion({
	id = "manager_finished_feedback_analysis_result",
	textGoodMatch = _T("MANAGER_FINISHED_FEEDBACK_ANALYSIS_GOOD_MATCH", "I've focused on reading what people thought of 'FEATURE', and judging by what people are saying, it's a good match for MMOs of the GENRE genre."),
	textBadMatch = _T("MANAGER_FINISHED_FEEDBACK_ANALYSIS_BAD_MATCH", "I've focused on reading what people thought of 'FEATURE', and judging by what people are saying, it's a bad match for MMOs of the GENRE genre."),
	textNeutralMatch = _T("MANAGER_FINISHED_FEEDBACK_ANALYSIS_NEUTRAL_MATCH", "I've focused on reading what people thought of 'FEATURE', and judging by what people are saying, it works just fine for MMOs of the GENRE genre. It makes the experience neither worse nor any better. Can't go wrong with this combination."),
	answers = {
		"manager_feedback_analysis_finish"
	},
	answersRepeat = {
		"generic_continue"
	},
	getNextQuestion = function(self, dialogueObject)
		local misc = dialogueObject:getFact("misc_info")
		
		if misc and #misc > 0 then
			return self.id
		end
		
		return nil
	end,
	getAnswers = function(self, dialogueObject)
		local misc = dialogueObject:getFact("misc_info")
		
		if misc and #misc > 0 then
			return self.answersRepeat
		end
		
		return self.answers
	end,
	getText = function(self, dialogueObject)
		local gameObj = dialogueObject:getFact("game")
		local taskID = dialogueObject:getFact("task")
		
		if taskID then
			local data = taskTypes.registeredByID[taskID]
			local genreID = gameObj:getGenre()
			local match = data.mmoMatch[genreID]
			local text
			
			if match < 1 then
				text = self.textBadMatch
			elseif match > 1 then
				text = self.textGoodMatch
			else
				text = self.textNeutralMatch
			end
			
			return _format(text, "FEATURE", data.displayResearch or data.display, "GENRE", genres.registeredByID[genreID].display)
		end
		
		local misc = dialogueObject:getFact("misc_info")
		
		if misc then
			local picked = misc[1]
			
			table.remove(misc, 1)
			
			return picked
		end
	end
})
dialogueHandler.registerQuestion({
	id = "manager_finished_feedback_analysis_no_result",
	textNothing = _T("MANAGER_FINISHED_FEEDBACK_ANALYSIS_NO_RESULT", "Unfortunately, I've discovered nothing new. Seems like we already know everything there is to know about making a MMO with the gameplay features we have."),
	textNothingCooldown = _T("MANAGER_FINISHED_FEEDBACK_ANALYSIS_NO_RESULT_COOLDOWN", "Unfortunately, I've discovered nothing new. There didn't seem to be that much new feedback since I last took a look at what people were saying. If we want to learn something new, then I think we'll have to wait a bit for more feedback to appear first."),
	answers = {
		"manager_feedback_analysis_finish_no_result"
	},
	getText = function(self, dialogueObject)
		local gameObj = dialogueObject:getFact("game")
		
		if gameObj:getLogicPiece(gameProject.MMO_SUBSCRIPTIONS_LOGIC_PIECE_ID):isFeedbackCooldownOver() then
			return self.textNothing
		end
		
		return self.textNothingCooldown
	end
})
dialogueHandler.registerAnswer({
	id = "manager_feedback_analysis_finish",
	text = _T("MANAGER_FEEDBACK_ANALYSIS_FINISH", "Great work.")
})
dialogueHandler.registerAnswer({
	id = "manager_feedback_analysis_finish_no_result",
	text = _T("MANAGER_FEEDBACK_ANALYSIS_FINISH_NO_RESULT", "That's a shame.")
})
dialogueHandler.registerQuestion({
	nextQuestion = "manager_subs_loss_content_2",
	id = "manager_subs_loss_content",
	text = _T("MANAGER_SUBS_LOSS_CONTENT", "Hey boss, people are starting to unsubscribe from our 'GAME' MMO."),
	answers = {
		"manager_subs_loss_content_continue_1"
	},
	getText = function(self, dialogueObject)
		return _format(self.text, "GAME", dialogueObject:getFact("game"):getName())
	end
})
dialogueHandler.registerQuestion({
	nextQuestion = "manager_subs_loss_content_3",
	id = "manager_subs_loss_content_2",
	text = _T("MANAGER_SUBS_LOSS_CONTENT_2", "This can happen due to a number of reasons, but the most common one is that people run out of content to play with."),
	textPrice = _T("MANAGER_SUBS_LOSS_PRICE", "I've seen people complain that the monthly subscription fee is too high. Lowering it would help with making them happier, but if our server running costs exceed that, then we'll be operating at a loss."),
	textServer = _T("MANAGER_SUBS_LOSS_SERVER_USE", "Our servers are working at excess capacity, meaning that players can experience things like lengthy log-in times, laggy gameplay, and other various issues related to high ping, leading to players getting frustrated with the game. Setting up more servers would help with this."),
	answers = {
		"generic_continue"
	},
	getNextQuestion = function(self, dialogueObject)
		local reasons = dialogueObject:getFact("reasons")
		
		if #reasons > 0 then
			local reason = table.remove(reasons, #reasons)
			
			dialogueObject:setFact("reason", reason)
			
			return self.id
		end
		
		dialogueObject:setFact("reason", nil)
		
		return self.nextQuestion
	end,
	getText = function(self, dialogueObject)
		local reason = dialogueObject:getFact("reason")
		
		if reason then
			if reason == "price" then
				return self.textPrice
			elseif reason == "server" then
				return self.textServer
			end
		end
		
		return _format(self.text, "GAME", dialogueObject:getFact("game"):getName())
	end
})
dialogueHandler.registerQuestion({
	id = "manager_subs_loss_content_3",
	text = _T("MANAGER_SUBS_LOSS_CONTENT_3_A", "Releasing an expansion pack would be a good idea, since it would take care of people not having content to play with. But we'll need to make sure not to release too many expansion packs at once, otherwise people will be frustrated with them, because to them it'll feel like nickel-and-diming."),
	textReasons = _T("MANAGER_SUBS_LOSS_CONTENT_3_B", "Well, that's all I can think of. It would be a good idea to take care of those problems I mentioned as soon as possible, since that will help us maintain a healthy subscriber-base. Aside from that, if we're low on content, releasing an expansion pack would help, too. But we'll need to make sure not to release too many expansion packs at once, otherwise people will be frustrated with them, because to them it'll feel like nickel-and-diming."),
	getText = function(self, dialogueObject)
		if dialogueObject:getFact("had_reasons") then
			return self.textReasons
		end
		
		return self.text
	end,
	answers = {
		"manager_subs_loss_content_finish"
	}
})
dialogueHandler.registerAnswer({
	id = "manager_subs_loss_content_continue_1",
	text = _T("MANAGER_SUBS_LOSS_CONTENT_CONTINUE_1", "Really? Tell me more.")
})
dialogueHandler.registerAnswer({
	id = "manager_subs_loss_content_finish",
	text = _T("MANAGER_SUBS_LOSS_CONTENT_FINISH", "Alright, thanks for the info.")
})
dialogueHandler.registerQuestion({
	nextQuestion = "manager_mmo_shutdown_consult_2",
	id = "manager_mmo_shutdown_consult",
	text = _T("MANAGER_MMO_SHUTDOWN_CONSULT", "Hey boss, let's talk about shutting down MMO game servers..."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "manager_mmo_shutdown_consult_2",
	nextQuestion = "manager_mmo_shutdown_consult_3",
	text = _T("MANAGER_MMO_SHUTDOWN_CONSULT_2", "Shutting down MMO game servers out of the blue is a bad idea unless you have a very small amount of players. I'm talking somewhere about CUTOFF people. Anything more and you can expect your reputation to take a hit."),
	mentionShutdownAnnouncement = _T("MANAGER_MMO_SHUTDOWN_ANNOUNCE_CONSULT", "It would be a good idea to announce the shutdown in advance, so that people can mentally prepare themselves, as well as let people unsubscribe in advance. That way people will know that the game servers will be shutting down soon, so when it comes to that, it's not going to be such a huge shock to them."),
	textAnnounced = _T("MANAGER_MMO_SHUTDOWN_ANNOUNCED", "We've already announced a server shutdown, so once we have CUTOFF or less people playing, we can safely shut down the servers. By that time most people will already know there isn't much time left, so there won't be any disappointment."),
	answers = {
		"generic_continue"
	},
	getNextQuestion = function(self, dialogueObject)
		local data = dialogueObject:getFact("mmo")
		local announced = data:wasShutdownAnnounced()
		
		if announced then
			return self.nextQuestion
		end
		
		if not announced and not dialogueObject:getFact("mentioned_shutdown_announce") then
			dialogueObject:setFact("mentioned_shutdown_announce", true)
			
			return self.id
		end
		
		return self.nextQuestion
	end,
	getText = function(self, dialogueObject)
		local data = dialogueObject:getFact("mmo")
		local announced = data:wasShutdownAnnounced()
		
		if announced then
			return _format(self.textAnnounced, "CUTOFF", string.comma(data.SHUTDOWN_NO_PENALTY_CUTOFF_ANNOUNCED))
		end
		
		if dialogueObject:getFact("mentioned_shutdown_announce") then
			return self.mentionShutdownAnnouncement
		end
		
		return _format(self.text, "CUTOFF", string.comma(data.SHUTDOWN_NO_PENALTY_CUTOFF))
	end
})
dialogueHandler.registerQuestion({
	id = "manager_mmo_shutdown_consult_3",
	text = _T("MANAGER_MMO_SHUTDOWN_CONSULT_3", "I hope this helped, shutting down MMO servers is not easy neither for us nor the players, so you'll need to plan this through."),
	answers = {
		"manager_subs_loss_content_finish"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "manager_mmo_longevity_2",
	id = "manager_mmo_longevity_1",
	text = _T("MANAGER_MMO_LONGEVITY_1", "Hey boss, just wanted to let you know that MMOs don't last forever. Doesn't matter whether we make a masterpiece, doesn't matter how much content we pack into it at release, or after the fact via expansion packs, they'll end up dying off over time regardless of what we do, because people move on to newer games."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "manager_mmo_longevity_3",
	id = "manager_mmo_longevity_2",
	text = _T("MANAGER_MMO_LONGEVITY_2", "So don't be surprised if the sales for it just come to what seems to be a dead end, and people don't re-subscribe even if we release new content. Better to shut down servers at that point, and to move on to a new game project when it comes to that."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "manager_mmo_longevity_3",
	text = _T("MANAGER_MMO_LONGEVITY_3", "A reasonable subscription fee, and a good genre-feature match can help prolong the project's lifetime, but there's nothing we can do to make it last forever."),
	answers = {
		"manager_subs_loss_content_finish"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "manager_mmo_customer_support_2",
	id = "manager_mmo_customer_support_1",
	text = _T("MANAGER_MMO_CUSTOMER_SUPPORT_1", "Boss, people are complaining that our customer support services are taking too much time to respond and handle support tickets."),
	answers = {
		"manager_mmo_customer_support_1"
	}
})
dialogueHandler.registerQuestion({
	id = "manager_mmo_customer_support_2",
	text = _T("MANAGER_MMO_CUSTOMER_SUPPORT_2", "The only thing we can do is expand our customer support services. The alternative would be to treat our customers badly enough so that they end up unsubscribing, and reduce the load on customer support services, but that's not really in our best interest."),
	answers = {
		"manager_mmo_customer_support_finish"
	}
})
dialogueHandler.registerAnswer({
	id = "manager_mmo_customer_support_1",
	text = _T("MANAGER_MMO_CUSTOMER_SUPPORT_ANSWER_1", "What can we do to fix this?")
})
dialogueHandler.registerAnswer({
	id = "manager_mmo_customer_support_finish",
	text = _T("MANAGER_MMO_CUSTOMER_SUPPORT_ANSWER_FINISH", "Alright, thanks for the heads-up.")
})
dialogueHandler.registerQuestion({
	nextQuestion = "manager_mmo_setup_dialogue_2",
	id = "manager_mmo_setup_dialogue_1",
	text = _T("MANAGER_MMO_SETUP_DIALOGUE_1", "Hey boss, before we get on with starting work on a MMO game project, I thought I'd clue you in on just how big of a time and money investment it is."),
	answers = {
		"manager_mmo_setup_dialogue_1"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "manager_mmo_setup_dialogue_3",
	id = "manager_mmo_setup_dialogue_2",
	text = _T("MANAGER_MMO_SETUP_DIALOGUE_2", "Unlike regular game projects, MMOs will require us to run game servers, which means we'll have to spend extra money to keep them running, and the higher the server complexity is, the more money we'll need to spend. There are two ways we can go about this: buy our own hardware and place it in our offices somewhere, or rent servers out."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "manager_mmo_setup_dialogue_4",
	id = "manager_mmo_setup_dialogue_3",
	text = _T("MANAGER_MMO_SETUP_DIALOGUE_3", "The former means we'll need to sacrifice office space to have our own servers. The latter allows us to get around that, but we'll have to pay a rent fee each month. We can do both at the same time, so in case something goes wrong we can momentarily rent out extra servers."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "manager_mmo_setup_dialogue_5",
	id = "manager_mmo_setup_dialogue_4",
	text = _T("MANAGER_MMO_SETUP_DIALOGUE_4", "Aside from that, we'll also need to have enough customer support, which means even more expenses for us. If we don't have enough customer support, then people will start getting unhappy with the game, since our services won't be able to keep up with the support tickets."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "manager_mmo_setup_dialogue_5",
	text = _T("MANAGER_MMO_SETUP_DIALOGUE_5", "It's a tough task to balance everything out, so you'll need to make sure you have a large capital and a large enough team before we think of working on a MMO."),
	answers = {
		"manager_mmo_setup_dialogue_2"
	}
})
dialogueHandler.registerAnswer({
	id = "manager_mmo_setup_dialogue_1",
	text = _T("MANAGER_MMO_SETUP_DIALOGUE_ANSWER_1", "Sure, go ahead.")
})
dialogueHandler.registerAnswer({
	id = "manager_mmo_setup_dialogue_2",
	text = _T("MANAGER_MMO_SETUP_DIALOGUE_ANSWER_2", "Thanks for the info.")
})
dialogueHandler.registerQuestion({
	nextQuestion = "manager_platform_discontinue_consult_2",
	id = "manager_platform_discontinue_consult_1",
	text = _T("MANAGER_PLATFORM_DISCONTINUE_CONSULT_1", "Hey boss, let's talk about discontinuing a platform..."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "manager_platform_discontinue_consult_3",
	nextQuestionAnnounced = "manager_platform_discontinue_consult_4",
	id = "manager_platform_discontinue_consult_2",
	textNoPenalty = _T("MANAGER_PLATFORM_DISCONTINUE_CONSULT_2_NO_PENALTY", "We've announced the drop of support for the platform, and I believe enough time has passed for us to discontinue it. If we do it now, there shouldn't be a backlash of any kind."),
	text = _T("MANAGER_PLATFORM_DISCONTINUE_CONSULT_2", "I was going to mention announcing the drop of support for a platform, but we've already done that, so now all we need to do is wait TIME. We need to wait that much because people might need repairs, and if we stop everything right now, it'll lead to a lot of unsatisfied customers."),
	textUnannounced = _T("MANAGER_PLATFORM_DISCONTINUE_CONSULT_2_UNANNOUNCED", "If we want to make sure people don't get angry at us, we'll have to announce the drop of support for the platform first. If we don't do that and just go straight to discontinuing a platform, people will be very angry."),
	getText = function(self, dialogueObject)
		local plat = dialogueObject:getFact("platform")
		
		if plat:wasSupportDropAnnounced() then
			local time = plat:getDiscontinuePenaltyTime()
			
			if time == 0 then
				return self.textNoPenalty
			else
				return _format(self.text, "TIME", timeline:getTimePeriodText(time))
			end
		end
		
		return self.textUnannounced
	end,
	getNextQuestion = function(self, dialogueObject)
		local plat = dialogueObject:getFact("platform")
		
		if plat:wasSupportDropAnnounced() then
			return self.nextQuestionAnnounced
		end
		
		return self.nextQuestion
	end,
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "manager_platform_discontinue_consult_4",
	id = "manager_platform_discontinue_consult_3",
	text = _T("MANAGER_PLATFORM_DISCONTINUE_CONSULT_3", "Once you announce the drop of support for the platform, you'll need to wait for a bit. The sales will drop, but repairs won't. I think a waiting period of TIME would suffice. After that, we can discontinue the platform and go further from there."),
	answers = {
		"generic_continue"
	},
	getText = function(self, dialogueObject)
		local plat = dialogueObject:getFact("platform")
		
		return _format(self.text, "TIME", timeline:getTimePeriodText(plat:getDiscontinuePenaltyTime()))
	end
})
dialogueHandler.registerQuestion({
	id = "manager_platform_discontinue_consult_4",
	text = _T("MANAGER_PLATFORM_DISCONTINUE_CONSULT_4", "So, that's all. I hope this has made things clearer as to what needs to be done to ensure a smooth discontinuation."),
	answers = {
		"manager_mmo_setup_dialogue_2"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "manager_platform_support_drop_consult_2",
	id = "manager_platform_support_drop_consult_1",
	text = _T("MANAGER_PLATFORM_SUPPORT_DROP_CONSULT_1", "Hey boss, let's talk about ending support for a platform..."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "manager_platform_support_drop_consult_3",
	id = "manager_platform_support_drop_consult_2",
	nextQuestionNoPenalty = "manager_platform_support_drop_consult_4",
	textNoPenalty = _T("MANAGER_PLATFORM_SUPPORT_DROP_CONSULT_2_NO_PENALTY", "The platform in question has been released for a long enough time, so we don't have to worry about people getting angry about the drop of support for it."),
	text = _T("MANAGER_PLATFORM_SUPPORT_DROP_CONSULT_2", "The most important thing we have to keep in mind is the amount of time the platform has spent on the market. We should wait at least TIME before we announce the drop of support, because people that have just bought their new console will be in for a nasty surprise."),
	getText = function(self, dialogueObject)
		local plat = dialogueObject:getFact("platform")
		
		if plat:isEarlyDiscontinuation() then
			return _format(self.text, "TIME", timeline:getTimePeriodText(plat:getTimeUntilNormalDiscontinuation() * timeline.DAYS_IN_MONTH))
		end
		
		return self.textNoPenalty
	end,
	getNextQuestion = function(self, dialogueObject)
		local plat = dialogueObject:getFact("platform")
		
		if plat:isEarlyDiscontinuation() then
			return self.nextQuestion
		end
		
		return self.nextQuestionNoPenalty
	end,
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "manager_platform_support_drop_consult_4",
	id = "manager_platform_support_drop_consult_3",
	text = _T("MANAGER_PLATFORM_SUPPORT_DROP_CONSULT_3", "Of course, if it's not possible to make a proper profit on this platform, then you should probably disregard waiting in general. People will be angry about it, no doubt, but at least you won't be burning through money."),
	answers = {
		"generic_continue"
	},
	getText = function(self, dialogueObject)
		local plat = dialogueObject:getFact("platform")
		
		return _format(self.text, "TIME", timeline:getTimePeriodText(plat:getDiscontinuePenaltyTime()))
	end
})
dialogueHandler.registerQuestion({
	nextQuestion = "manager_platform_support_drop_consult_5",
	id = "manager_platform_support_drop_consult_4",
	text = _T("MANAGER_PLATFORM_SUPPORT_DROP_CONSULT_4", "Once we announce the drop of support for any platform, you can expect people to stop purchasing them in the same quantities as they are now. Aside from that, the amount of developers willing to make new games will also decrease. You have to be 100% sure this is something you want to announce."),
	answers = {
		"generic_continue"
	},
	getText = function(self, dialogueObject)
		local plat = dialogueObject:getFact("platform")
		
		return _format(self.text, "TIME", timeline:getTimePeriodText(plat:getDiscontinuePenaltyTime()))
	end
})
dialogueHandler.registerQuestion({
	id = "manager_platform_support_drop_consult_5",
	text = _T("MANAGER_PLATFORM_SUPPORT_DROP_CONSULT_5", "I hope this has cleared some things up in regard to announcing the drop of support for a platform."),
	answers = {
		"manager_mmo_setup_dialogue_2"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "manager_not_enough_repairs_2",
	id = "manager_not_enough_repairs_1",
	text = _T("MANAGER_NOT_ENOUGH_REPAIRS_1", "Boss, we're getting complaints from people regarding our 'CONSOLE' console. They're complaining that we're taking too much time to repair malfunctioning units."),
	getText = function(self, dialogueObject)
		return _format(self.text, "CONSOLE", dialogueObject:getFact("platform"):getName())
	end,
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "manager_not_enough_repairs_3",
	id = "manager_not_enough_repairs_2",
	text = _T("MANAGER_NOT_ENOUGH_REPAIRS_2", "If we don't have enough customer support to carry through with repairing such units, then people will begin getting more and more dissatisfied with the console, which means less units sold, and less game sales."),
	answers = {
		"manager_mmo_customer_support_1"
	}
})
dialogueHandler.registerQuestion({
	id = "manager_not_enough_repairs_3",
	text = _T("MANAGER_NOT_ENOUGH_REPAIRS_3", "Simple, just increase the customer support services. There isn't anything we can do, since some units will always be malfunctioning and will need repairs."),
	answers = {
		"manager_mmo_setup_dialogue_2"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "manager_not_enough_production_2",
	id = "manager_not_enough_production_1",
	text = _T("MANAGER_NOT_ENOUGH_PRODUCTION_1", "Boss, the demand for our 'CONSOLE' platform exceeds our supply. This means that we're losing potential sales."),
	getText = function(self, dialogueObject)
		return _format(self.text, "CONSOLE", dialogueObject:getFact("platform"):getName())
	end,
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "manager_not_enough_production_3",
	id = "manager_not_enough_production_2",
	text = _T("MANAGER_NOT_ENOUGH_PRODUCTION_2", "If our goal is to sell as many units of the console as possible, then we need to increase our production capacity."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "manager_not_enough_production_3",
	text = _T("MANAGER_NOT_ENOUGH_PRODUCTION_3", "Just keep in mind that going overboard with the capacity is not a good idea either, since the people that assemble and test them need to be paid."),
	answers = {
		"manager_mmo_setup_dialogue_2"
	}
})
