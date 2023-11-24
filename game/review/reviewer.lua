reviewer = {}
reviewer.mtindex = {
	__index = reviewer
}
reviewer.REFUSED_BRIBE_FACT = "refused_bribe"
reviewer.REFUSED_AND_REVEALED_BRIBE_FACT = "revealed_bribe"
reviewer.REFUSED_FACT_CONVERSATION_TOPIC = "refused_bribe"

local bribeData = advertisement:getData("bribe")

reviewer.REPLY_TO_INTERVIEW_OFFER_TIME = {
	1,
	3
}
reviewer.INTERVIEW_OCCURANCE_TIME = {
	1,
	5
}
reviewer.INTERVIEW_INVITE_COOLDOWN = timeline.DAYS_IN_MONTH
reviewer.BRIBE_SCORE_LOSS_PER_DAY = 400
reviewer.BRIBE_SCORE_TO_INTERVIEW_CHANCE = 0.001
reviewer.CATCHABLE_EVENTS = {
	timeline.EVENTS.NEW_DAY,
	timeline.EVENTS.NEW_MONTH,
	project.EVENTS.SCRAPPED_PROJECT
}

function reviewer.new(data)
	local new = {}
	
	setmetatable(new, reviewer.mtindex)
	new:init(data)
	
	return new
end

function reviewer:init(data)
	self.acceptedBribes = {}
	self.offeredBribes = {}
	self.data = data
	self.interviewInviteCooldown = 0
	self.bribeScore = 0
	
	events:addDirectReceiver(self, reviewer.CATCHABLE_EVENTS)
end

function reviewer:remove()
	events:removeDirectReceiver(self, reviewer.CATCHABLE_EVENTS)
end

function reviewer:getIcon()
	return self.data.icon
end

function reviewer:handleEvent(event, projectObject)
	if event == timeline.EVENTS.NEW_DAY then
		if self.interviewReplyTime and timeline.curTime >= self.interviewReplyTime then
			self.interviewReplyTime = nil
			
			if math.random(1, 100) <= self:getInterviewChance() then
				self.interviewScheduleTime = timeline.curTime + math.random(reviewer.INTERVIEW_OCCURANCE_TIME[1], reviewer.INTERVIEW_OCCURANCE_TIME[2])
			end
			
			self:createInterviewOfferResultPopup()
		elseif self.interviewScheduleTime and timeline.curTime >= self.interviewScheduleTime then
			local interviewObj = interview.new(self.interviewProject, self, true)
			
			interviewObj:createInterviewOfferPopup()
			
			self.interviewScheduleTime = nil
			self.interviewProject = nil
		end
		
		if self.bribeScore > 0 then
			self.bribeScore = math.max(0, self.bribeScore - reviewer.BRIBE_SCORE_LOSS_PER_DAY)
		end
	elseif event == project.EVENTS.SCRAPPED_PROJECT and self.interviewProject and projectObject == self.interviewProject then
		self.interviewScheduleTime = nil
		self.interviewProject = nil
		self.interviewReplyTime = nil
	end
end

function reviewer:createInterviewOfferResultPopup()
	local popup = gui.create("Popup")
	
	popup:setWidth(500)
	popup:setFont(fonts.get("pix24"))
	popup:setTextFont(fonts.get("pix20"))
	popup:setTitle(_T("REPLY_TO_INVITATION_TITLE", "Reply to Invitation"))
	
	local text
	
	if self.interviewScheduleTime then
		text = _format(_T("INTERVIEW_INVITATION_ACCEPTED", "REVIEWER, whom we have invited to an interview, has replied.\n\n'We'll gladly come check 'GAME' out. Expect us in TIME'"), "TIME", timeline:getTimePeriodText(self.interviewScheduleTime - timeline.curTime))
	else
		text = _T("INTERVIEW_INVITATION_DECLINED", "REVIEWER, whom we have invited to an interview, has replied.\n\n'We're sorry, but we won't be able to make it to the interview for your 'GAME' game.'")
	end
	
	text = _format(text, "REVIEWER", self.data.display, "GAME", self.interviewProject:getName())
	
	self.interviewProject:setInterviewCooldown(self.data.id, reviewer.INTERVIEW_INVITE_COOLDOWN)
	self:applyInterviewInviteCooldown()
	popup:setText(text)
	popup:addButton(fonts.get("pix20"), _T("OK", "OK"), nil)
	popup:center()
	frameController:push(popup)
	
	return popup
end

function reviewer:applyInterviewInviteCooldown()
	self.interviewInviteCooldown = timeline.curTime + reviewer.INTERVIEW_INVITE_COOLDOWN
end

function reviewer:getInterviewInviteCooldown()
	return self.interviewInviteCooldown
end

function reviewer:getID()
	return self.data.id
end

function reviewer:getName()
	return self.data:getName()
end

function reviewer:getDescription()
	return self.data:getDescription()
end

function reviewer:canReview(gameProj)
	return true
end

function reviewer:getData()
	return self.data
end

function reviewer:getBribeAcceptChance()
	return self.data.bribeAcceptChance
end

function reviewer:getBribeRevealChance()
	return self.data.bribeRevealChance
end

function reviewer:wasBribed(gameProj)
	return self.acceptedBribes[gameProj:getUniqueID()]
end

function reviewer:acceptBribe(amount, gameProj)
	self.acceptedBribes[gameProj:getUniqueID()] = amount
	
	if gameProj:getOwner():isPlayer() then
		self.bribeChancesRevealed = true
	end
	
	self.bribeScore = self.bribeScore + amount
end

function reviewer:revealBribe(amount, gameProj)
	gameProj:setFact(self:getID() .. "_" .. reviewer.REFUSED_AND_REVEALED_BRIBE_FACT, true)
end

function reviewer:refuseBribe(amount, gameProj)
	gameProj:setFact(self:getID() .. "_" .. reviewer.REFUSED_BRIBE_FACT, true)
end

function reviewer:hasRefusedBribe(gameProj)
	return gameProj:getFact(self:getID() .. "_" .. reviewer.REFUSED_BRIBE_FACT)
end

function reviewer:shouldRevealBribe(gameProj)
	return gameProj:getFact(self:getID() .. "_" .. reviewer.REFUSED_AND_REVEALED_BRIBE_FACT)
end

function reviewer:offerBribe(amount, gameProj)
	self.offeredBribes[gameProj:getUniqueID()] = true
	
	local result = self.data:offerBribe(self, amount, gameProj)
	
	events:fire(studio.EVENTS.OFFERED_BRIBE, self, amount, gameProj, result)
	
	if not result then
		conversations:addTopicToTalkAbout(reviewer.REFUSED_FACT_CONVERSATION_TOPIC)
	end
	
	return result
end

function reviewer:canOfferBribeTo(gameProj)
	local uniqueID = gameProj:getUniqueID()
	
	return not self.offeredBribes[uniqueID] and not self.acceptedBribes[uniqueID]
end

function reviewer:calculateScore(curScore, gameProj)
	return curScore
end

function reviewer:calculateRating(curScore, gameProj)
	local bribeSize = self:wasBribed(gameProj)
	local boost = self:getRatingBoostFromBribe(gameProj, bribeSize)
	
	return curScore + boost
end

function reviewer:getRatingBoostFromBribe(gameProj, bribeSize)
	if bribeSize then
		local data = self.data
		
		return bribeSize / data:getScoreBoostPerCashAmount()
	end
	
	return 0
end

function reviewer:canOfferInterview(gameProj)
	return not self.interviewReplyTime and not self.interviewScheduleTime
end

function reviewer:offerInterview(gameProj)
	self.interviewReplyTime = timeline.curTime + math.random(reviewer.REPLY_TO_INTERVIEW_OFFER_TIME[1], reviewer.REPLY_TO_INTERVIEW_OFFER_TIME[2])
	self.interviewProject = gameProj
end

function reviewer:getAutoAddInterviewChance(projectObject)
	local data = self.data
	
	return math.min(data.interviewBaseAcceptChance + (studio:getReputation() - data.interviewReputationCutoff) * data.interviewAcceptChancePerReputation, gameProject.MAX_AUTO_ADD_INTERVIEW_CHANCE + math.max(0, projectObject:getLastInterviewTime() - timeline.curTime + data.recentReviewTimeCutoff * data.recentInterviewTimeAffector)) * data.autoInterviewChanceMultiplier
end

function reviewer:getInterviewChance()
	local data = self.data
	
	return math.min(data.maxInterviewChance, math.max(data.interviewBaseAcceptChance, data.interviewBaseAcceptChance + (studio:getReputation() - data.interviewReputationCutoff) * data.interviewAcceptChancePerReputation) + self.bribeScore * reviewer.BRIBE_SCORE_TO_INTERVIEW_CHANCE)
end

function reviewer:attemptRevealFakeBribe(rival)
	if self.data.bribeRevealChanceMonthly > math.randomf(0, 100) then
		self:revealFakeBribeAttempt(rival)
		
		return true
	end
	
	return false
end

function reviewer:revealFakeBribeAttempt(rival)
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(600)
	popup:setFont("pix24")
	popup:setTextFont("pix20")
	popup:setTitle(_T("RIVAL_BRIBE_REVEALED_TITLE", "Bribe revealed"))
	
	local rivalName = rival:getName()
	
	popup:getExtraInfoDescbox():addText(_format(_T("CAN_ASK_RIVAL_ABOUT_CHANCES", "Can now discover bribe accept & reveal chances for 'REVIEWER' by asking 'RIVAL' CEO!"), "REVIEWER", self.data.display, "RIVAL", rivalName), "bh22", nil, 0, 580, "question_mark", 24, 24)
	
	local game = rival:getCurrentProject()
	
	popup:setText(_format(_T("RIVAL_BRIBE_REVEALED_DESC", "'REVIEWER' just revealed that 'RIVAL' had offered them a bribe to try and increase the score of their upcoming THEME GENRE game."), "REVIEWER", self.data.display, "RIVAL", rivalName, "THEME", themes.registeredByID[game:getTheme()].display, "GENRE", genres.registeredByID[game:getGenre()].display))
	popup:addOKButton()
	popup:center()
	frameController:push(popup)
end

function reviewer:setBribeChancesRevealed(state)
	self.bribeChancesRevealed = state
end

function reviewer:getBribeChancesRevealed()
	return self.bribeChancesRevealed
end

function reviewer:save()
	local saved = {}
	
	saved.id = self.data.id
	saved.acceptedBribes = self.acceptedBribes
	saved.interviewProject = self.interviewProject and self.interviewProject:getUniqueID() or nil
	saved.interviewReplyTime = self.interviewReplyTime
	saved.userBase = self.userBase
	saved.offeredBribes = self.offeredBribes
	saved.bribeChancesRevealed = self.bribeChancesRevealed
	saved.interviewInviteCooldown = self.interviewInviteCooldown
	saved.interviewScheduleTime = self.interviewScheduleTime
	saved.bribeScore = self.bribeScore
	
	if self.interviewProject then
		saved.interviewProject = self.interviewProject:getUniqueID()
	end
	
	return saved
end

function reviewer:load(data)
	self.acceptedBribes = data.acceptedBribes
	self.interviewProject = studio:getProjectByUniqueID(data.interviewProject)
	self.interviewReplyTime = data.interviewReplyTime
	self.userBase = data.userBase
	self.offeredBribes = data.offeredBribes or self.offeredBribes
	self.bribeChancesRevealed = data.bribeChancesRevealed
	self.interviewInviteCooldown = data.interviewInviteCooldown or self.interviewInviteCooldown
	self.interviewScheduleTime = data.interviewScheduleTime or self.interviewScheduleTime
	self.interviewProject = data.interviewProject
	self.bribeScore = data.bribeScore or self.bribeScore
end

function reviewer:postLoad()
	if self.interviewProject then
		self.interviewProject = studio:getProjectByUniqueID(self.interviewProject)
	end
end
