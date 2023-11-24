local platReleasedConvo = {}

platReleasedConvo.id = playerPlatform.CONVERSATION_RELEASE
platReleasedConvo.displayText = {
	_T("PLATFORM_RELEASED_CONVO_1", "There goes 'CONSOLE'. Here's hoping it all works out."),
	_T("PLATFORM_RELEASED_CONVO_2", "'CONSOLE' launched, fingers crossed we didn't miss anything.")
}

function platReleasedConvo:isTopicValid(initiator, target)
	if initiator:isPlayerCharacter() or target:isPlayerCharacter() then
		return false
	end
	
	return conversations:canTalkAboutTopic(playerPlatform.CONVERSATION_RELEASE) ~= nil
end

function platReleasedConvo:pickTalkText()
	local id = playerPlatform.CONVERSATION_RELEASE
	local platID = conversations:canTalkAboutTopic(id)
	
	conversations:removeTopicToTalkAbout(id)
	
	local plat = studio:getPlatformByID(platID)
	local text = platReleasedConvo.baseClass.pickTalkText(self)
	
	return _format(text, "CONSOLE", plat:getName())
end

conversations:registerTopic(platReleasedConvo)

local platRelAnswer = {}

platRelAnswer.id = "platform_released_answer"
platRelAnswer.displayText = {
	_T("PLATFORM_RELEASED_CONVO_ANSWER_1", "Who feels like throwing a celebration party?!"),
	_T("PLATFORM_RELEASED_CONVO_ANSWER_2", "Get the champagne, folks!")
}
platRelAnswer.topicID = playerPlatform.CONVERSATION_RELEASE

conversations:registerAnswer(platRelAnswer)

local platDiscontinuedConvo = {}

platDiscontinuedConvo.id = playerPlatform.CONVERSATION_DISCONTINUED
platDiscontinuedConvo.lateDelta = 0.2
platDiscontinuedConvo.displayText = {
	early = {
		_T("PLATFORM_DISCONTINUED_CONVO_EARLY_1", "There goes 'CONSOLE'... A little early, but what can you do?")
	},
	normal = {
		_T("PLATFORM_DISCONTINUED_CONVO_NORMAL_1", "Did you hear? 'CONSOLE' is discontinued now."),
		_T("PLATFORM_DISCONTINUED_CONVO_NORMAL_2", "'CONSOLE' is now discontinued. Hope we make another one.")
	},
	late = {
		_T("PLATFORM_DISCONTINUED_CONVO_LATE_1", "Man, 'CONSOLE' sure lasted a while, eh?"),
		_T("PLATFORM_DISCONTINUED_CONVO_LATE_2", "'CONSOLE' is off-market, but it sure sold for a long while.")
	}
}

function platDiscontinuedConvo:isTopicValid(initiator, target)
	if initiator:isPlayerCharacter() or target:isPlayerCharacter() then
		return false
	end
	
	local id = conversations:canTalkAboutTopic(playerPlatform.CONVERSATION_DISCONTINUED)
	
	if not id then
		return false
	elseif not studio:getPlatformByID(id) then
		conversations:removeTopicToTalkAbout(playerPlatform.CONVERSATION_DISCONTINUED)
		
		return false
	end
	
	initiator:setFact(playerPlatform.CONVERSATION_DISCONTINUED, id)
	
	return true
end

function platDiscontinuedConvo:pickTalkText()
	local id = playerPlatform.CONVERSATION_DISCONTINUED
	local platID = conversations:canTalkAboutTopic(id)
	
	conversations:removeTopicToTalkAbout(id)
	
	local plat = studio:getPlatformByID(platID)
	local life = plat:getLife()
	local delta = life / playerPlatform.LIFETIME_VALUE
	local text
	
	if delta >= playerPlatform.LIFE_SHUTDOWN_PENALTY then
		text = self.displayText.early[math.random(1, #self.displayText.early)]
	elseif delta <= self.lateDelta then
		text = self.displayText.late[math.random(1, #self.displayText.late)]
	else
		text = self.displayText.normal[math.random(1, #self.displayText.normal)]
	end
	
	return _format(text, "CONSOLE", plat:getName())
end

conversations:registerTopic(platDiscontinuedConvo)

local platDiscAnswer = {}

platDiscAnswer.id = "platform_discontinued_answer"
platDiscAnswer.displayText = {
	loss = {
		_T("PLATFORM_DISCONTINUED_FINANCIAL_LOSS_ANSWER_1", "Considering that we were operating at a loss, it's no surprise."),
		_T("PLATFORM_DISCONTINUED_FINANCIAL_LOSS_ANSWER_2", "No point in running a console if we're operating at a loss.")
	},
	normal = {
		_T("PLATFORM_DISCONTINUED_REGULAR_ANSWER_1", "Here's hoping we make another platform."),
		_T("PLATFORM_DISCONTINUED_REGULAR_ANSWER_2", "It was pretty fun, I hope our boss decides to develope another one.")
	}
}

function platDiscAnswer:pickTalkText(target)
	local platID = target:getConversation():getListener():getFact(playerPlatform.CONVERSATION_DISCONTINUED)
	local plat = studio:getPlatformByID(platID)
	local change = plat:getFundChange()
	
	if change < 0 then
		return self.displayText.loss[math.random(1, #self.displayText.loss)]
	else
		return self.displayText.normal[math.random(1, #self.displayText.normal)]
	end
end

platDiscAnswer.topicID = playerPlatform.CONVERSATION_DISCONTINUED

conversations:registerAnswer(platDiscAnswer)

local archProblemsConvo = {}

archProblemsConvo.id = playerPlatform.CONVERSATION_ARCHITECTURE_PROBLEMS
archProblemsConvo.displayText = {
	_T("PLATFORM_ARCHITECTURE_PROBLEMS_CONVO_1", "Did you hear? The development team for 'CONSOLE' ran into some problems with the architecture."),
	_T("PLATFORM_ARCHITECTURE_PROBLEMS_CONVO_2", "I heard the dev team for 'CONSOLE' ran into problems with the architecture they designed.")
}

function archProblemsConvo:isTopicValid(initiator, target)
	if target:isPlayerCharacter() then
		return false
	end
	
	local id = conversations:canTalkAboutTopic(playerPlatform.CONVERSATION_ARCHITECTURE_PROBLEMS)
	
	if not id then
		return false
	elseif not studio:getPlatformByID(id) then
		conversations:removeTopicToTalkAbout(playerPlatform.CONVERSATION_ARCHITECTURE_PROBLEMS)
		
		return false
	end
	
	initiator:setFact(playerPlatform.CONVERSATION_ARCHITECTURE_PROBLEMS, id)
	
	return true
end

function archProblemsConvo:pickTalkText()
	local id = playerPlatform.CONVERSATION_ARCHITECTURE_PROBLEMS
	local platID = conversations:canTalkAboutTopic(id)
	
	conversations:removeTopicToTalkAbout(id)
	
	local plat = studio:getPlatformByID(platID)
	local text = archProblemsConvo.baseClass.pickTalkText(self)
	
	return _format(text, "CONSOLE", plat:getName())
end

conversations:registerTopic(archProblemsConvo)

local archProblemsAnswer = {}

archProblemsAnswer.id = "platform_discontinued_answer"
archProblemsAnswer.displayText = {
	_T("PLATFORM_ARCHITECTURE_PROBLEMS_ANSWER_1", "Yeah, an unfortunate setback."),
	_T("PLATFORM_ARCHITECTURE_PROBLEMS_ANSWER_2", "Really? Well that is sure to set the progress back.")
}
archProblemsAnswer.topicID = playerPlatform.CONVERSATION_ARCHITECTURE_PROBLEMS

conversations:registerAnswer(archProblemsAnswer)

local rivalDevBuyout = {}

rivalDevBuyout.id = playerPlatform.CONVERSATION_RIVAL_DEV_BUYOUT
rivalDevBuyout.displayText = {
	_T("PLATFORM_RIVAL_DEV_BUYOUT_CONVO_1", "Apparently devs get better deals working with our competitors, so they're avoiding our 'CONSOLE' console."),
	_T("PLATFORM_RIVAL_DEV_BUYOUT_CONVO_2", "I heard devs get better deals from our competitors, that leaves our 'CONSOLE' console in the dust.")
}

function rivalDevBuyout:isTopicValid(initiator, target)
	local id = conversations:canTalkAboutTopic(playerPlatform.CONVERSATION_RIVAL_DEV_BUYOUT)
	
	if not id then
		return false
	elseif not studio:getPlatformByID(id) then
		conversations:removeTopicToTalkAbout(playerPlatform.CONVERSATION_RIVAL_DEV_BUYOUT)
		
		return false
	end
	
	initiator:setFact(playerPlatform.CONVERSATION_RIVAL_DEV_BUYOUT, id)
	
	return true
end

function rivalDevBuyout:pickTalkText()
	local id = playerPlatform.CONVERSATION_RIVAL_DEV_BUYOUT
	local platID = conversations:canTalkAboutTopic(id)
	
	conversations:removeTopicToTalkAbout(id)
	
	local plat = studio:getPlatformByID(platID)
	local text = rivalDevBuyout.baseClass.pickTalkText(self)
	
	return _format(text, "CONSOLE", plat:getName())
end

conversations:registerTopic(rivalDevBuyout)

local rivalBuyoutAnswer = {}

rivalBuyoutAnswer.id = "platform_discontinued_answer"
rivalBuyoutAnswer.displayText = {
	_T("PLATFORM_RIVAL_DEV_BUYOUT_ANSWER_1", "Got to have an advantage over your competitors, so they'll take whatever they can get."),
	_T("PLATFORM_RIVAL_DEV_BUYOUT_ANSWER_2", "It's just business, no reason to get upset.")
}
rivalBuyoutAnswer.topicID = playerPlatform.CONVERSATION_RIVAL_DEV_BUYOUT

conversations:registerAnswer(rivalBuyoutAnswer)

local memShort = {}

memShort.id = playerPlatform.CONVERSATION_MEMORY_SHORTAGE
memShort.displayText = {
	_T("PLATFORM_MEMORY_SHORTAGE_CONVO_1", "So the cost of memory modules just went up...")
}

function memShort:isTopicValid(initiator, target)
	local id = conversations:canTalkAboutTopic(playerPlatform.CONVERSATION_MEMORY_SHORTAGE)
	
	if not id then
		return false
	elseif not studio:getPlatformByID(id) then
		conversations:removeTopicToTalkAbout(playerPlatform.CONVERSATION_MEMORY_SHORTAGE)
		
		return false
	end
	
	initiator:setFact(playerPlatform.CONVERSATION_MEMORY_SHORTAGE, id)
	
	return true
end

conversations:registerTopic(memShort)

local memShortAnswer = {}

memShortAnswer.id = "platform_discontinued_answer"
memShortAnswer.displayText = {
	_T("PLATFORM_MEMORY_SHORTAGE_ANSWER_1", "That can't be good for manufacturing costs."),
	_T("PLATFORM_MEMORY_SHORTAGE_ANSWER_2", "Here's hoping we have enough games to offset the extra manufacturing costs.")
}
memShortAnswer.topicID = playerPlatform.CONVERSATION_MEMORY_SHORTAGE

conversations:registerAnswer(memShortAnswer)

local firmwareCrack = {}

firmwareCrack.id = playerPlatform.CONVERSATION_FIRMWARE_CRACK
firmwareCrack.displayText = {
	_T("PLATFORM_FIRMWARE_CRACK_CONVO_1", "Oh dear, the firmware of our 'CONSOLE' console has been cracked..."),
	_T("PLATFORM_FIRMWARE_CRACK_CONVO_2", "Say goodbye to game sales, folks, firmware of our 'CONSOLE' console just got cracked.")
}

function firmwareCrack:isTopicValid(initiator, target)
	local id = conversations:canTalkAboutTopic(playerPlatform.CONVERSATION_FIRMWARE_CRACK)
	
	if not id then
		return false
	elseif not studio:getPlatformByID(id) then
		conversations:removeTopicToTalkAbout(playerPlatform.CONVERSATION_FIRMWARE_CRACK)
		
		return false
	end
	
	initiator:setFact(playerPlatform.CONVERSATION_FIRMWARE_CRACK, id)
	
	return true
end

function firmwareCrack:pickTalkText()
	local id = playerPlatform.CONVERSATION_FIRMWARE_CRACK
	local platID = conversations:canTalkAboutTopic(id)
	
	conversations:removeTopicToTalkAbout(id)
	
	local plat = studio:getPlatformByID(platID)
	local text = firmwareCrack.baseClass.pickTalkText(self)
	
	return _format(text, "CONSOLE", plat:getName())
end

conversations:registerTopic(firmwareCrack)

local firmwareCrackAnswer = {}

firmwareCrackAnswer.id = "platform_discontinued_answer"
firmwareCrackAnswer.displayText = {
	_T("PLATFORM_FIRMWARE_CRACK_ANSWER_1", "We can fix it, though. Just have to update the firmware."),
	_T("PLATFORM_FIRMWARE_CRACK_ANSWER_2", "Just patch it up and we're good to go, at least for a while, until it gets cracked again.")
}
firmwareCrackAnswer.topicID = playerPlatform.CONVERSATION_FIRMWARE_CRACK

conversations:registerAnswer(firmwareCrackAnswer)

local powerOutage = {}

powerOutage.id = playerPlatform.CONVERSATION_POWER_OUTAGE
powerOutage.displayText = {
	_T("PLATFORM_POWER_OUTAGE_CONVO_1", "A manufacturing facility power outage?")
}

function powerOutage:isTopicValid(initiator, target)
	local id = conversations:canTalkAboutTopic(playerPlatform.CONVERSATION_POWER_OUTAGE)
	
	if not id then
		return false
	elseif not studio:getPlatformByID(id) then
		conversations:removeTopicToTalkAbout(playerPlatform.CONVERSATION_POWER_OUTAGE)
		
		return false
	end
	
	initiator:setFact(playerPlatform.CONVERSATION_POWER_OUTAGE, id)
	
	return true
end

function powerOutage:pickTalkText()
	local id = playerPlatform.CONVERSATION_POWER_OUTAGE
	local platID = conversations:canTalkAboutTopic(id)
	
	conversations:removeTopicToTalkAbout(id)
	
	local plat = studio:getPlatformByID(platID)
	local text = powerOutage.baseClass.pickTalkText(self)
	
	return _format(text, "CONSOLE", plat:getName())
end

conversations:registerTopic(powerOutage)

local powerOutageAnswer = {}

powerOutageAnswer.id = "platform_discontinued_answer"
powerOutageAnswer.displayText = {
	_T("PLATFORM_POWER_OUTAGE_ANSWER_1", "Just a stroke of bad luck."),
	_T("PLATFORM_POWER_OUTAGE_ANSWER_2", "Such things are out of our hands, better luck next time."),
	_T("PLATFORM_POWER_OUTAGE_ANSWER_3", "Hey, at least it's not something we have any control over."),
	_T("PLATFORM_POWER_OUTAGE_ANSWER_4", "Could have been worse.")
}
powerOutageAnswer.topicID = playerPlatform.CONVERSATION_POWER_OUTAGE

conversations:registerAnswer(powerOutageAnswer)
