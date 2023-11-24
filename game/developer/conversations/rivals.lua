local employeeStolen = {}

employeeStolen.id = "employee_stolen_reaction_convo"
employeeStolen.text = {
	_T("EMPLOYEE_STOLEN_REACTION_1", "Did you hear? NAME left to work at 'RIVAL'.")
}
employeeStolen.invalidEmployeeText = _T("EMPLOYEE_STOLEN_REACTION_INVALID", "I still can't believe one of our rivals managed to lure one of our coworkers away from us.")

function employeeStolen:begin(convoObj)
	employeeStolen.baseClass.begin(self, convoObj)
	conversations:removeTopicToTalkAbout(rivalGameCompany.CONVO_TOPIC_STEAL_EMPLOYEE_SUCCESS_ID)
end

function employeeStolen:pickTalkText()
	local uid = conversations:canTalkAboutTopic(rivalGameCompany.CONVO_TOPIC_STEAL_EMPLOYEE_SUCCESS_ID)
	local employee = rivalGameCompanies:getEmployeeByUniqueID(uid)
	
	if not employee then
		return self.invalidEmployeeText
	end
	
	return _format(employeeStolen.text[math.random(1, #employeeStolen.text)], "NAME", employee:getFullName(true), "RIVAL", employee:getEmployer():getName())
end

function employeeStolen:isTopicValid(initiator, target)
	if initiator:isPlayerCharacter() then
		return false
	end
	
	local uid = conversations:canTalkAboutTopic(rivalGameCompany.CONVO_TOPIC_STEAL_EMPLOYEE_SUCCESS_ID)
	
	if uid and uid ~= initiator:getUniqueID() and uid ~= target:getUniqueID() then
		local employee = rivalGameCompanies:getEmployeeByUniqueID(uid)
		
		if employee and employee:getEmployer() then
			return true
		else
			conversations:removeTopicToTalkAbout(rivalGameCompany.CONVO_TOPIC_STEAL_EMPLOYEE_SUCCESS_ID)
			
			return false
		end
	else
		conversations:removeTopicToTalkAbout(rivalGameCompany.CONVO_TOPIC_STEAL_EMPLOYEE_SUCCESS_ID)
	end
	
	return false
end

conversations:registerTopic(employeeStolen)

local employeeStolenAnswer = {}

employeeStolenAnswer.id = "employee_stolen_reaction_answer"
employeeStolenAnswer.displayText = {
	_T("EMPLOYEE_STOLEN_REACTION_ANSWER_1", "Yeah, it's a shame, they helped keep this place more lively."),
	_T("EMPLOYEE_STOLEN_REACTION_ANSWER_2", "Yep, I think they didn't come to that decision on his own though. I'm fairly sure they offered him better pay."),
	_T("EMPLOYEE_STOLEN_REACTION_ANSWER_3", "Well you can't blame him. In this line of work variety is the key to staying motivated.")
}
employeeStolenAnswer.topicID = "employee_stolen_reaction_convo"

conversations:registerAnswer(employeeStolenAnswer)

local employeeStolen = {}

employeeStolen.id = "employee_not_stolen_reaction_convo"
employeeStolen.text = {
	_T("EMPLOYEE_NOT_STOLEN_REACTION_1", "I heard 'RIVAL' tried getting NAME to switch over to their studio."),
	_T("EMPLOYEE_NOT_STOLEN_REACTION_2", "Word around office is NAME was about to leave to work at 'RIVAL'.")
}

function employeeStolen:begin(convoObj)
	employeeStolen.baseClass.begin(self, convoObj)
	conversations:removeTopicToTalkAbout(rivalGameCompany.CONVO_TOPIC_STEAL_EMPLOYEE_ID)
end

function employeeStolen:pickTalkText()
	local uid = conversations:canTalkAboutTopic(rivalGameCompany.CONVO_TOPIC_STEAL_EMPLOYEE_ID)
	local employee = studio:getEmployeeByUniqueID(uid)
	local companyObject = rivalGameCompanies:getCompanyByID(employee:getLastFailStealStudio())
	
	return _format(employeeStolen.text[math.random(1, #employeeStolen.text)], "NAME", employee:getFullName(true), "RIVAL", companyObject:getName())
end

function employeeStolen:isTopicValid(initiator, target)
	if initiator:isPlayerCharacter() then
		return 
	end
	
	local uid = conversations:canTalkAboutTopic(rivalGameCompany.CONVO_TOPIC_STEAL_EMPLOYEE_ID)
	
	if uid and uid ~= initiator:getUniqueID() and uid ~= target:getUniqueID() then
		local employee = studio:getEmployeeByUniqueID(uid)
		
		if employee and rivalGameCompanies:getCompanyByID(employee:getLastFailStealStudio()) then
			return true
		else
			conversations:removeTopicToTalkAbout(rivalGameCompany.CONVO_TOPIC_STEAL_EMPLOYEE_ID)
			
			return false
		end
	end
end

conversations:registerTopic(employeeStolen)

local employeeStolenAnswer = {}

employeeStolenAnswer.id = "employee_stolen_reaction_answer"
employeeStolenAnswer.displayText = {
	_T("EMPLOYEE_NOT_STOLEN_REACTION_ANSWER_1", "Yeah, they told me before they went to talk to the boss, though I'm more concerned about our rivals trying this again sometime."),
	_T("EMPLOYEE_NOT_STOLEN_REACTION_ANSWER_2", "I wonder why they'd change his mind... Probably monetary reasons."),
	_T("EMPLOYEE_NOT_STOLEN_REACTION_ANSWER_3", "Well it's a good thing they's staying, but this shows that our rivals might try this again.")
}
employeeStolenAnswer.topicID = "employee_not_stolen_reaction_convo"

conversations:registerAnswer(employeeStolenAnswer)

local slanderReaction = {}

slanderReaction.id = "slandered_reaction"
slanderReaction.displayText = {
	_T("SLANDER_REACTION_1", "Well isn't that great, someone just posted fake news about us."),
	_T("SLANDER_REACTION_2", "Slander campaigns? Seriously? Why would anyone try to ruin our reputation like that?"),
	_T("SLANDER_REACTION_3", "Geez, slander campaigns, huh? Someone sure is upset.")
}

function slanderReaction:begin(convoObj)
	slanderReaction.baseClass.begin(self, convoObj)
	conversations:removeTopicToTalkAbout(rivalGameCompany.CONVO_TOPIC_SLANDER_ID)
end

function slanderReaction:isTopicValid(initiator, target)
	if initiator:isPlayerCharacter() or target:isPlayerCharacter() then
		return false
	end
	
	return conversations:canTalkAboutTopic(rivalGameCompany.CONVO_TOPIC_SLANDER_ID)
end

conversations:registerTopic(slanderReaction)

local slanderReactionAnswer = {}

slanderReactionAnswer.id = "slandered_reaction_answer"
slanderReactionAnswer.displayText = {
	_T("SLANDER_REACTION_ANSWER_1", "I hope our boss finds out who it was, then they could take legal action against whoever did that."),
	_T("SLANDER_REACTION_ANSWER_2", "Well that's the last thing I expected from this industry."),
	_T("SLANDER_REACTION_ANSWER_3", "Let's just hope our boss has found out who was behind this, then they'd be able to take legal action.")
}
slanderReactionAnswer.topicID = "slandered_reaction"

conversations:registerAnswer(slanderReactionAnswer)

local playerSlanderReaction = {}

playerSlanderReaction.id = "player_slander_reaction"
playerSlanderReaction.displayText = {
	_T("PLAYER_SLANDER_REACTION_1", "So I guess we're joining the slander club too, huh?"),
	_T("PLAYER_SLANDER_REACTION_2", "I guess we're about to really piss off whoever it is we're going up against with this slander.")
}

function playerSlanderReaction:begin(convoObj)
	playerSlanderReaction.baseClass.begin(self, convoObj)
	conversations:removeTopicToTalkAbout(rivalGameCompany.CONVO_TOPIC_PLAYER_SLANDER_ID)
end

function playerSlanderReaction:isTopicValid(initiator, target)
	if initiator:isPlayerCharacter() or target:isPlayerCharacter() then
		return false
	end
	
	return conversations:canTalkAboutTopic(rivalGameCompany.CONVO_TOPIC_PLAYER_SLANDER_ID)
end

conversations:registerTopic(playerSlanderReaction)

local slanderReactionAnswer = {}

slanderReactionAnswer.id = "player_slander_reaction_answer"
slanderReactionAnswer.displayText = {
	_T("PLAYER_SLANDER_REACTION_ANSWER_1", "Well, you know what they say - fight fire with fire."),
	_T("PLAYER_SLANDER_REACTION_ANSWER_3", "That can't end well, surely if our rivals find out they'll take legal action against us.")
}
slanderReactionAnswer.topicID = "player_slander_reaction"

conversations:registerAnswer(slanderReactionAnswer)
