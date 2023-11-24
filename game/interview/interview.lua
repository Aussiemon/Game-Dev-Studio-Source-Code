interview = {}
interview.mtindex = {
	__index = interview
}
interview.STEP_AMOUNT = {
	3,
	3
}
interview.HELD_INTERVIEWS_FACT = "interviews_held"
interview.HANDS_ON_BASE_QUALITY_MULTIPLIER = 0.75
interview.SCORE_TO_REPUTATION = 0.5
interview.SCORE_TO_PROJECT_POPULARITY = 3
interview.MINIMUM_REPUTATION_FROM_INTERVIEW = 5
interview.REPUTATION_LOSS_FROM_BRIBE_REVEALED = 30
interview.LAST_BRIBE_TIME_REPUTATION_LOSS_AFFECTOR = 2
interview.CAN_OFFER_HANDS_ON = "can_offer_hands_on"
interview.REQUIRED_INTERVIEWS_FOR_HANDS_ON = 4
interview.RATING_TO_INTERVIEW_SCORE = 15
interview.ISSUE_SCORE_AFFECTOR_MULTIPLIER = 0.4
interview.AUTO_MANAGER_PREFERENCE = "auto_manager"
interview.ALWAYS_HYPE_PREFERENCE = "always_hype"
interview.SCORE_MULTIPLIER_HYPE_COUNTER = {
	4,
	6
}
interview.EVENTS = {
	MANAGER_SET = events:new(),
	FINISHED = events:new()
}
interview.RESULT_TEXT = {
	{
		_T("INTERVIEW_RESULT_LOW_1", "The interview is over, and you can't shake the feeling that it was awful.")
	},
	{
		_T("INTERVIEW_RESULT_MEDIUM_1", "The interview is over, and you think to yourself that it was alright.")
	},
	{
		_T("INTERVIEW_RESULT_HIGH_1", "You end the interview with a smile on your face, confident that it went well.")
	},
	{
		_T("INTERVIEW_RESULT_VERY_HIGH_1", "After ending the interview there is no doubt in your head that it went great.")
	}
}
interview.HANDS_ON_RESULT_TEXT = {
	{
		{
			text = {
				_T("INTERVIEW_HANDS_ON_RESULT_POOR", "We're not sure whether the game is still a work in progress, but we're not impressed with what we saw.")
			},
			answers = {
				{
					score = 10,
					text = _T("INTERVIEW_HANDS_ON_POOR_REPLY1", "It's still a work-in-progress")
				},
				{
					score = 20,
					text = _T("INTERVIEW_HANDS_ON_POOR_REPLY2", "Thank you for your feedback")
				},
				{
					score = -30,
					text = _T("INTERVIEW_HANDS_ON_POOR_REPLY3", "Maybe you just hate video games?")
				}
			}
		}
	},
	{
		{
			text = {
				_T("INTERVIEW_HANDS_ON_RESULT_MEDIUM", "The game is clearly a work in progress, as some places seemed unpolished, buggy or just had some strange design decisions. We're hoping you'll improve the game before release.")
			},
			answers = {
				{
					score = 10,
					text = _T("INTERVIEW_HANDS_ON_MEDIUM_REPLY1", "We will, of course")
				},
				{
					score = -20,
					text = _T("INTERVIEW_HANDS_ON_MEDIUM_REPLY2", "We think this is the final version")
				},
				{
					score = 0,
					text = _T("INTERVIEW_HANDS_ON_MEDIUM_REPLY3", "No comment")
				}
			}
		}
	},
	{
		{
			text = {
				_T("INTERVIEW_HANDS_ON_RESULT_HIGH", "The game you're making, even for a work-in-progress, is great. I'm sure people will love it once you release it.")
			},
			answers = {
				{
					score = 0,
					text = _T("INTERVIEW_HANDS_ON_HIGH_REPLY1", "Thank you for your feedback")
				},
				{
					score = 10,
					text = _T("INTERVIEW_HANDS_ON_HIGH_REPLY2", "We're not done yet!")
				}
			}
		}
	}
}

function interview:HANDS_ON_RESULT_CALLBACK()
	self.interview:addScore(self.answerData.score or 0)
	
	if self.answerData.callback then
		self.answerData:callback(self)
	end
	
	self.interview:advanceStep()
end

function interview.new(targetProject, reviewerObj, playerScheduled)
	local new = {}
	
	setmetatable(new, interview.mtindex)
	new:init(targetProject, reviewerObj, playerScheduled)
	
	return new
end

function interview:init(targetProject, reviewerObj, playerScheduled)
	self.targetProject = targetProject
	self.reviewer = reviewerObj
	self.playerScheduled = playerScheduled
	self.score = 0
	self.step = 0
	self.totalSteps = math.random(interview.STEP_AMOUNT[1], interview.STEP_AMOUNT[2])
	self.topics = {}
	self.managerInterview = nil
	self.scoreMultiplier = 1
	
	interviewTopics:addToInterview(self)
	
	local total = 0
	
	for key, topicData in ipairs(self.topics) do
		local highest = 0
		
		for key, answerData in ipairs(topicData:getAnswerOptions()) do
			local score = answerData.answerScore
			
			if highest < score then
				highest = score
			end
		end
		
		total = total + highest
	end
	
	self.highestPossibleScore = total
end

function interview:getHighestPossibleScore()
	return self.highestPossibleScore
end

function interview:getInterviewResultText()
	local resultTextVariations = #interview.RESULT_TEXT
	local segmentValue = 1 / resultTextVariations
	local highestPossibleScore = self.highestPossibleScore + (self.handsOnScore or 0)
	local scorePerSegment = highestPossibleScore * segmentValue
	local segment = math.min(math.max(math.ceil(self.score / scorePerSegment), 1), #interview.RESULT_TEXT)
	local resultText = interview.RESULT_TEXT[segment]
	
	return resultText[math.random(1, #resultText)]
end

function interview:setTargetProject(targetProject)
	self.targetProject = targetProject
end

function interview:getTargetProject()
	return self.targetProject
end

function interview:addTopic(topicData)
	topicData:onAddToInterview(self)
	table.insert(self.topics, topicData)
end

function interview:setStep(step)
	self.step = step
	
	self:createInterviewStepPopup()
end

function interview:getTotalSteps()
	return self.totalSteps
end

function interview:getStep()
	return self.step
end

function interview:isLastStep(step)
	step = step or self.step
	
	return step >= #self.topics
end

function interview:advanceStep()
	local topicData = self.topics[self.step]
	
	if topicData then
		topicData:onAnswered(self)
	end
	
	if self:isLastStep() then
		if self.handsOn then
			self:performHandsOn()
		else
			self:finishInterview()
		end
	else
		self.step = self.step + 1
		
		self:createInterviewStepPopup()
	end
end

local function handleInterviewCallback(self)
	self.interview:beginInterview()
end

local function assignManagerCallback(self)
	self.interview:createManagerAssignMenu()
end

local function refuseOfferCallback(self)
	self.interview:createOfferRefusedPopup()
end

function interview:createInterviewOfferPopup()
	local managers = studio:getManagers()
	
	if preferences:get(interview.AUTO_MANAGER_PREFERENCE) then
		local managerData = attributes.profiler.rolesByID.manager
		local managerObj, score = nil, 0
		
		for key, iterManag in ipairs(managers) do
			if iterManag:isAvailable() then
				local curScore = managerData:getInterviewEfficiency(self, iterManag)
				
				if score < curScore then
					managerObj = iterManag
					curScore = score
				end
			end
		end
		
		if managerObj then
			self.manager = managerObj
			
			self:startManagerInterview(true)
			
			return 
		end
	end
	
	local managersAvailable = #managers > 0
	local frame = gui.create("Popup")
	
	frame:setWidth(500)
	frame:setExtraHeight(50)
	frame:setFont(fonts.get("pix24"))
	frame:setTitle(_T("INTERVIEW_OFFER_TITLE", "Interview Offer"))
	frame:setTextFont(fonts.get("pix20"))
	frame:hideCloseButton()
	
	local text
	
	if self.playerScheduled then
		if managersAvailable then
			text = _T("INTERVIEW_REVIEWER_ARRIVED", "INTERVIEWER is here for an interview regarding 'GAME_NAME'. Would you like to attend the interview or let a manager take care of it?")
		else
			text = _T("INTERVIEW_REVIEWER_ARRIVED_NO_MANAGERS", "INTERVIEWER is here for an interview regarding 'GAME_NAME'.")
		end
	elseif managersAvailable then
		text = _T("INTERVIEW_OFFER_RECEIVED", "You've received an interview offer from INTERVIEWER regarding your 'GAME_NAME' game project, would you like to attend the interview, let a manager take care of it or decline the interview offer?")
	else
		text = _T("INTERVIEW_OFFER_RECEIVED_NO_MANAGERS", "You've received an interview offer from INTERVIEWER regarding your 'GAME_NAME' game project, would you like to attend the interview or decline the interview offer?")
	end
	
	text = string.easyformatbykeys(text, "INTERVIEWER", self.reviewer:getName(), "GAME_NAME", self.targetProject:getName())
	
	frame:setText(text)
	
	local button = frame:addButton(fonts.get("pix20"), _T("INTERVIEW_HANDLE_MYSELF", "Handle the interview"), handleInterviewCallback)
	
	button.interview = self
	
	if managersAvailable then
		local button = frame:addButton(fonts.get("pix20"), _T("INTERVIEW_ASSIGN_MANAGER", "Assign manager"), assignManagerCallback)
		
		button:setSkipKillOnClick(true)
		
		button.interview = self
	end
	
	if not self.playerScheduled then
		local button = frame:addButton(fonts.get("pix20"), _T("INTERVIEW_REFUSE_OFFER", "Refuse offer"), refuseOfferCallback)
		
		button.interview = self
	end
	
	local prefData = preferences:getData(interview.AUTO_MANAGER_PREFERENCE)
	local checkbox = gui.create("PreferenceCheckbox", frame)
	
	checkbox:setSize(32, 32)
	checkbox:setPos(_S(5), frame:getButtons()[1].localY - checkbox.h - _S(5))
	checkbox:setTextAlignment(gui.SIDES.RIGHT)
	checkbox:setPreferenceData(prefData)
	checkbox:setFont("bh22")
	checkbox:setText(prefData.display)
	frame:center()
	frameController:push(frame)
end

function interview:setHandsOnAfterInterview(state)
	self.handsOn = state
end

local function offerToPlayProduct(self)
	self.interview:setHandsOnAfterInterview(true)
	self.interview:startFirstStep()
end

local function doNothingOption(self)
	self.interview:startFirstStep()
end

function interview:createHandsOnOfferPopup()
	local popup = gui.create("Popup")
	
	popup:setWidth(500)
	popup:setFont(fonts.get("pix24"))
	popup:setTitle(_T("INTERVIEW_HANDS_ON_OFFER_TITLE", "Hands-on Offer"))
	popup:setTextFont(fonts.get("pix20"))
	popup:hideCloseButton()
	popup:setAnimated(false)
	popup:setText(_T("INTERVIEW_HANDS_ON_OFFER_DESC", "The game project is currently in a playable state, would you like to offer the interviewer to play the game after the interview?\nLetting the interviewer try the product out can be beneficial for the interview as it can greatly boost the interview score.\n\nHowever it can also be detrimental in the event that the game is not yet polished or has a lot of bugs."))
	
	local button = popup:addButton(fonts.get("pix20"), _T("INTERVIEW_OFFER_TO_PLAY", "Offer to play"), offerToPlayProduct)
	
	button.interview = self
	
	local button = popup:addButton(fonts.get("pix20"), _T("INTERVIEW_DONT_OFFER", "Do nothing"), doNothingOption)
	
	button.interview = self
	
	popup:center()
	frameController:push(popup)
end

function interview:performHandsOn(quiet)
	local rating = review:getCurrentGameVerdict(self.targetProject, self.ISSUE_SCORE_AFFECTOR_MULTIPLIER)
	local resultTextData = self:getHandsOnResultText(rating)
	
	if not quiet then
		local popup = gui.create("Popup")
		
		popup:setWidth(500)
		popup:setFont(fonts.get("pix24"))
		popup:setTitle(_T("INTERVIEW_HANDS_ON_RESULT_TITLE", "Hands-on Result"))
		popup:setTextFont(fonts.get("pix20"))
		popup:setAnimated(false)
		popup:setText(_format(_T("HANDS_ON_RESULT_BASE_LAYOUT", "The interviewer, after having played the game, stated the following:\n\n'TEXT'"), "TEXT", resultTextData.text[math.random(1, #resultTextData.text)]))
		popup:hideCloseButton()
		
		for key, data in ipairs(resultTextData.answers) do
			local button = popup:addButton(fonts.get("pix20"), data.text, interview.HANDS_ON_RESULT_CALLBACK)
			
			button.interview = self
			button.answerData = data
		end
		
		popup:center()
		frameController:push(popup)
	end
	
	self.handsOnScore = rating * interview.RATING_TO_INTERVIEW_SCORE
	
	self:addScore(self.handsOnScore)
	
	self.handsOn = false
end

function interview:getHandsOnResultText(score)
	local possibleTexts = #interview.HANDS_ON_RESULT_TEXT
	local percentage = score / review.maxRating
	local index = math.max(math.min(math.ceil(percentage * possibleTexts), possibleTexts), 1)
	local resultTextData = interview.HANDS_ON_RESULT_TEXT[index]
	
	return resultTextData[math.random(1, #resultTextData)]
end

function interview:increaseProjectInterviewCounter()
	self.targetProject:setFact(interview.HELD_INTERVIEWS_FACT, (self.targetProject:getFact(interview.HELD_INTERVIEWS_FACT) or 0) + 1)
	studio:setFact(interview.HELD_INTERVIEWS_FACT, (studio:getFact(interview.HELD_INTERVIEWS_FACT) or 0) + 1)
	
	if (studio:getFact(interview.HELD_INTERVIEWS_FACT) or 0) >= interview.REQUIRED_INTERVIEWS_FOR_HANDS_ON and not studio:getFact(interview.CAN_OFFER_HANDS_ON) and studio:getRandomNonPlayerEmployee() then
		studio:setFact(interview.CAN_OFFER_HANDS_ON, true)
		
		self.notifyOfHandsOn = true
	end
end

function interview:beginInterview()
	studio:clearManagers()
	
	if studio:getFact(interview.CAN_OFFER_HANDS_ON) then
		self:createHandsOnOfferPopup()
	else
		self:startFirstStep()
	end
end

function interview:startFirstStep()
	self:createInterviewStepPopup()
end

eventBoxText:registerNew({
	id = "auto_interview",
	getText = function(self, data)
		return _format(_T("AUTO_PERFORMED_MANAGER_INTERVIEW", "Auto-performed interview for 'PROJECT'. Gained HYPE Hype points."), "HYPE", string.roundtobignumber(data.hype), "PROJECT", data.project)
	end
})

function interview:finishInterview(quiet)
	local reviewerData = self.reviewer:getData()
	local repIncrease = self:getReputationIncrease(reviewerData)
	local popularityIncrease = repIncrease * interview.SCORE_TO_PROJECT_POPULARITY * self.scoreMultiplier
	
	studio:increaseReputation(repIncrease * interview.SCORE_TO_REPUTATION)
	
	local repGain, realPopGain = self.targetProject:increasePopularity(popularityIncrease)
	
	if quiet then
		local element = game.addToEventBox("auto_interview", {
			hype = realPopGain,
			project = self.targetProject:getName()
		}, 1, nil, "exclamation_point")
		
		element:setFlash(true, true)
	else
		self:createInterviewFinishedPopup(reviewerData, repIncrease, realPopGain)
	end
	
	self:increaseProjectInterviewCounter()
	events:fire(interview.EVENTS.FINISHED, self)
end

function interview:getReputationIncrease(reviewerData)
	local base = self.score * reviewerData.popularity
	local revealedBribes = studio:getFact(studio.REVEALED_BRIBES)
	local lastBribeRevealTime = studio:getFact(studio.LAST_BRIBE_TIME)
	
	if revealedBribes and revealedBribes > 0 then
		local bribeRepLoss = revealedBribes * interview.REPUTATION_LOSS_FROM_BRIBE_REVEALED
		local delta = timeline.curTime - lastBribeRevealTime
		local bribeRepLoss = bribeRepLoss - delta * interview.LAST_BRIBE_TIME_REPUTATION_LOSS_AFFECTOR
		
		if bribeRepLoss > 0 then
			base = base - bribeRepLoss
		end
	end
	
	return math.ceil(math.max(base, interview.MINIMUM_REPUTATION_FROM_INTERVIEW))
end

local function interviewFinishedButtonCallback(self)
	if self.interview.notifyOfHandsOn then
		local frame = gui.create("Popup")
		
		frame:setWidth(500)
		frame:setFont(fonts.get("pix24"))
		frame:setTitle(_T("INTERVIEW_CAN_OFFER_HANDS_ON_TITLE", "Hands-on Availability"))
		frame:setTextFont(fonts.get("pix20"))
		frame:setText(_T("INTERVIEW_CAN_OFFER_HANDS_ON_DESC", "After the interview had finished, one of your employees came to you with an idea - why not let interviewers play the game for some extra coverage?\n\nWith this idea in mind, you can now let interviewers play the game for extra review score."))
		frame:hideCloseButton()
		
		local button = frame:addButton(fonts.get("pix20"), _T("GREAT", "Great"))
		
		frame:center()
		frameController:push(frame)
	end
end

function interview:setScoreMultiplier(mult)
	self.scoreMultiplier = mult
end

function interview:createInterviewFinishedPopup(reviewerData, repIncrease, popularityIncrease)
	local resultText = self:getInterviewResultText()
	local frame = gui.create("DescboxPopup")
	
	frame:setWidth(600)
	frame:setFont(fonts.get("pix24"))
	frame:setTitle(_T("INTERVIEW_FINISHED_TITLE", "Interview Finished"))
	frame:setTextFont(fonts.get("pix20"))
	frame:setText(resultText)
	frame:setAnimated(false)
	
	local wrapWidth = frame.rawW / 2
	local left, right, extra = frame:getDescboxes()
	
	left:addSpaceToNextText(10)
	right:addSpaceToNextText(10)
	right:addText(_format(_T("INTERVIEW_REPUTATION_GAINED", "Reputation gained: GAIN"), "GAIN", string.comma(repIncrease)), "bh22", nil, 3, wrapWidth, "star", 22, 22)
	right:addText(_format(_T("INTERVIEW_POPULARITY_GAINED", "Project popularity gained: GAIN"), "GAIN", string.comma(popularityIncrease)), "bh22", nil, 0, wrapWidth, "star", 22, 22)
	
	if self.handsOnScore then
		left:addText(_format(_T("INTERVIEW_HANDS_ON_SCORE_MODIFIER", "Hands-on score modifier: GAIN"), "GAIN", string.comma(math.floor(self.handsOnScore))), "bh22", nil, 3, wrapWidth, "increase", 22, 22)
	else
		left:addText(_T("INTERVIEW_NO_HANDS_ON", "No hands-on"), "bh22", nil, 3, wrapWidth, "exclamation_point", 22, 22)
	end
	
	left:addText(_format(_T("INTERVIEW_SCORE", "Interview score: SCORE pts."), "SCORE", string.comma(self.score * self.scoreMultiplier)), "bh22", nil, 0, 500, "efficiency", 22, 22)
	
	if self.increasedExpectations then
		extra:addSpaceToNextText(10)
		extra:addTextLine(frame.w - _S(20), game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
		extra:addText(_format(_T("INTERVIEW_INCREASED_EXPECTATIONS", "This interview has increased the expectations for 'GAME'."), "GAME", self.targetProject:getName()), "bh20", nil, 0, frame.rawW - 25, "exclamation_point", 22, 22)
	end
	
	local button = frame:addButton(fonts.get("pix20"), _T("OK", "OK"), interviewFinishedButtonCallback)
	
	button.interview = self
	
	frame:center()
	frameController:push(frame)
end

function interview:performAutoHype()
	local data = interviewTopics.registeredByID.hype_counter_question
	
	if data:checkEligibility(self) then
		print("increasing hype")
		self:increaseHypeCounter()
	end
end

function interview:createManagerAssignMenu()
	local frame = gui.create("Frame")
	
	frame:setSize(400, 600)
	frame:setFont("pix24")
	frame:setTitle(_T("ASSIGN_MANAGER_TITLE", "Assign Manager"))
	
	local scrollBar = gui.create("ScrollbarPanel", frame)
	
	scrollBar:setPos(_S(5), _S(35))
	scrollBar:setSize(390, 530)
	scrollBar:setSpacing(4)
	scrollBar:setPadding(4, 4)
	scrollBar:setAdjustElementPosition(true)
	scrollBar:addDepth(200)
	
	for key, employee in ipairs(studio:getManagers()) do
		local button = gui.create("ManagerAssignmentButton")
		
		button:setManager(employee)
		button:setWidth(390)
		button:setInterview(self)
		scrollBar:addItem(button)
	end
	
	local finishButton = gui.create("FinishAssigningManagerButton", frame)
	
	finishButton:setPos(_S(5), _S(570))
	finishButton:setSize(390, 25)
	finishButton:setFont(fonts.get("pix24"))
	finishButton:setInterview(self)
	finishButton:setText(_T("ASSIGN_MANAGER", "Assign manager"))
	frame:center()
	frameController:push(frame)
end

function interview:increaseHypeCounter()
	if self.targetProject:increaseHypeCounter() then
		self.increasedExpectations = true
		self.scoreMultiplier = math.random(interview.SCORE_MULTIPLIER_HYPE_COUNTER[1], interview.SCORE_MULTIPLIER_HYPE_COUNTER[2])
	end
end

function interview:createInterviewStepPopup()
	local stepTopic = self.topics[self.step]
	
	if not stepTopic then
		self:advanceStep()
		
		return 
	end
	
	local frame = gui.create("Popup")
	
	frame:setWidth(500)
	frame:setFont(fonts.get("pix24"))
	frame:setTitle(stepTopic:getName())
	frame:setTextFont(fonts.get("pix20"))
	frame:setText(stepTopic:getDescription(self))
	frame:setAnimated(false)
	frame:hideCloseButton()
	
	for key, answerData in ipairs(stepTopic:getAnswerOptions()) do
		local button = frame:addButton(answerData.font or interviewTopics.DEFAULT_FONT, answerData.text, interviewTopics.onSelectAnswer)
		
		button.answerData = answerData
		button.interviewObj = self
		
		if answerData.postAddOption then
			answerData:postAddOption(self, button)
		end
	end
	
	frame:center()
	frameController:push(frame)
end

function interview:createOfferRefusedPopup()
	local frame = gui.create("Popup")
	
	frame:setWidth(500)
	frame:setFont(fonts.get("pix24"))
	frame:setTitle(_T("INTERVIEW_REFUSED_TITLE", "Interview Refused"))
	frame:setTextFont(fonts.get("pix20"))
	frame:setAnimated(false)
	
	local text = _T("INTERVIEW_REFUSED_DESC", "You've refused the interview offer, as such no publicity for 'PROJECT_NAME' will be gained, and any other possible interviews may not pop up.")
	
	text = string.easyformatbykeys(text, "PROJECT_NAME", self.targetProject:getName())
	
	frame:setText(text)
	
	local button = frame:addButton(fonts.get("pix20"), _T("OK", "OK"))
	
	frame:center()
	frameController:push(frame)
end

function interview:addScore(amount)
	self.score = math.round(self.score + amount)
end

function interview:isManagerInterview()
	return self.managerInterview
end

function interview:startManagerInterview()
	studio:clearManagers()
	
	self.managerInterview = true
	
	frameController:pop()
	frameController:pop()
	
	local roleData = self.manager:getRoleData()
	
	self:addScore(roleData:getInterviewEfficiency(self))
	
	if preferences:get(interview.ALWAYS_HYPE_PREFERENCE) then
		print("perform hype")
		self:performAutoHype()
	end
	
	if studio:getFact(interview.CAN_OFFER_HANDS_ON) and self.targetProject:getStage() == gameProject.POLISHING_STAGE then
		self:performHandsOn(true)
	end
	
	self:finishInterview(true)
	self:increaseProjectInterviewCounter()
end

function interview:setManager(manager)
	self.manager = manager
	
	events:fire(interview.EVENTS.MANAGER_SET, manager)
end

function interview:getAssignedManager()
	return self.manager
end

require("game/interview/interview_topics")
