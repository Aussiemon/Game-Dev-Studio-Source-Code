local newTechConvo = {}

newTechConvo.id = "new_tech_convo"
newTechConvo.text = {
	_T("NEW_TECH_CONVO_1", "I recently read a report on new tech called 'TECH_NAME' that came out very recently."),
	_T("NEW_TECH_CONVO_2", "Hey, have you heard about this new 'TECH_NAME' tech that a guy posted an article about?"),
	_T("NEW_TECH_CONVO_3", "Have you watched a presentation on the new 'TECH_NAME' technology?")
}
newTechConvo.techToDiscussFact = "tech_to_discuss"
newTechConvo.discussedTechFact = "discussed_tech"
newTechConvo.targetFeatureList = "engine_task"
newTechConvo.validDiscussTimePeriod = timeline.DAYS_IN_MONTH * 3
newTechConvo.validTech = {}

function newTechConvo:isTopicValid(target)
	local implementedFeatures = studio:getImplementedEngineFeatures()
	local discussedTech = studio:getFact(newTechConvo.discussedTechFact) or {}
	
	for key, data in ipairs(taskTypes.registeredByTaskID[self.targetFeatureList]) do
		if data.isEngineTask and data:wasReleasedRecently() and not discussedTech[data.id] then
			newTechConvo.validTech[#newTechConvo.validTech + 1] = data
		end
	end
	
	if #newTechConvo.validTech == 0 then
		return false
	end
	
	local randomIndex = math.random(1, #newTechConvo.validTech)
	local randomTech = table.remove(newTechConvo.validTech, randomIndex)
	
	randomTech = randomTech.id
	
	target:setFact(newTechConvo.techToDiscussFact, {
		techID = randomTech
	})
	table.clearArray(newTechConvo.validTech)
	
	discussedTech[randomTech] = true
	
	studio:setFact(newTechConvo.discussedTechFact, discussedTech)
	
	return true
end

function newTechConvo:pickTalkText(target)
	local discussTechFactData = target:getFact(newTechConvo.techToDiscussFact)
	local discussTechData = taskTypes.registeredByID[discussTechFactData.techID]
	local text
	
	if discussTechData.discussText then
		local target = discussTechData.discussText.start
		
		if type(target) == "string" then
			text = target
		elseif type(target) == "table" then
			text = target[math.random(1, #target)]
		end
	else
		text = string.easyformatbykeys(newTechConvo.text[math.random(1, #newTechConvo.text)], "TECH_NAME", discussTechData.display)
	end
	
	text = text or string.easyformatbykeys(newTechConvo.text[math.random(1, #newTechConvo.text)], "TECH_NAME", discussTechData.display)
	
	return text
end

conversations:registerTopic(newTechConvo)

local techAnswer = {}

techAnswer.id = "new_tech_answer1"
techAnswer.displayText = {
	_T("NEW_TECH_CONVO_ANSWER_1", "Yeah, I've read that too, it sounds like something we could make use of."),
	_T("NEW_TECH_CONVO_ANSWER_2", "I have, we should implement it into our game engine when we have the time."),
	_T("NEW_TECH_CONVO_ANSWER_3", "No, but I've read about it, it sounds like some good stuff.")
}
techAnswer.topicID = "new_tech_convo"

function techAnswer:pickTalkText(target)
	local discussTechFactData = target:getConversation():getListener():getFact(newTechConvo.techToDiscussFact)
	local discussTechData = taskTypes.registeredByID[discussTechFactData.techID]
	local text
	
	if discussTechData.discussText then
		local target = discussTechData.discussText.finish
		
		if type(target) == "string" then
			text = target
		elseif type(target) == "table" then
			text = target[math.random(1, #target)]
		end
	end
	
	text = text or techAnswer.displayText[math.random(1, #techAnswer.displayText)]
	
	return text
end

conversations:registerAnswer(techAnswer)
