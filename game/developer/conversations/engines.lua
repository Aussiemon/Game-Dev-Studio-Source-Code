local engineConvo = {}

engineConvo.id = "new_engine_convo"
engineConvo.text = {
	good = {
		_T("NEW_ENGINE_CONVERSATION_GOOD_1", "I'm really impressed by the new 'ENGINE_NAME' engine that came out recently.")
	},
	bad = {
		_T("NEW_ENGINE_CONVERSATION_BAD_1", "Have you seen the 'ENGINE_NAME' engine that came out recently? It's kind of lacking in features.")
	}
}
engineConvo.engineToDiscussFact = "engine_to_discuss"
engineConvo.discussedEnginesFact = "discussed_engines"
engineConvo.validDiscussTimePeriod = timeline.DAYS_IN_MONTH * 3
engineConvo.validEngines = {}
engineConvo.positiveImpressionTaskPercentage = 0.6

function engineConvo:isTopicValid(target)
	if target:isPlayerCharacter() then
		return false
	end
	
	local discussedEngines = studio:getFact(engineConvo.discussedEnginesFact) or {}
	
	for key, data in ipairs(engineLicensing.onMarketEngines) do
		local time = data.time
		local timeDelta = timeline.curTime - time
		
		if timeDelta <= engineConvo.validDiscussTimePeriod and not discussedEngines[data.engine:getUniqueID()] then
			table.insert(engineConvo.validEngines, data.engine)
		end
	end
	
	local canPick = #engineConvo.validEngines > 0
	local randomEngine = engineConvo.validEngines[math.random(1, #engineConvo.validEngines)]
	
	if not randomEngine then
		return false
	end
	
	target:setFact(engineConvo.engineToDiscussFact, {
		engine = randomEngine:getUniqueID()
	})
	
	discussedEngines[randomEngine:getUniqueID()] = true
	
	studio:setFact(engineConvo.discussedEnginesFact, discussedEngines)
	table.clear(engineConvo.validEngines)
	
	return canPick
end

function engineConvo:pickTalkText(target)
	local discussEngineData = target:getFact(engineConvo.engineToDiscussFact)
	local discussEngine = engineLicensing:getEngineByUniqueID(discussEngineData.engine)
	local featureCount = table.count(discussEngine:getFeatures())
	local totalAvailableFeatures = taskTypes:getTotalAvailableTasks(engine.DEVELOPMENT_CATEGORIES, discussEngine)
	local difference = featureCount / totalAvailableFeatures
	local text
	
	if difference >= engineConvo.positiveImpressionTaskPercentage then
		discussEngineData.positive = true
		text = string.easyformatbykeys(engineConvo.text.good[math.random(1, #engineConvo.text.good)], "ENGINE_NAME", discussEngine:getName())
	else
		discussEngineData.positive = false
		text = string.easyformatbykeys(engineConvo.text.bad[math.random(1, #engineConvo.text.bad)], "ENGINE_NAME", discussEngine:getName())
	end
	
	return text
end

conversations:registerTopic(engineConvo)

local engineAnswer = {}

engineAnswer.id = "new_engine_answer1"
engineAnswer.displayText = {
	good = {
		paid = {
			_T("NEW_ENGINE_ANSWER_GOOD_PAID1", "Yeah, the amount of features it has makes it a really good deal."),
			_T("NEW_ENGINE_ANSWER_GOOD_PAID2", "Looking over it's features, I think we should get our boss to purchase a license as soon as possible.")
		},
		free = {
			_T("NEW_ENGINE_ANSWER_GOOD_FREE1", "It's packed with features, and it's absolutely free! We have to try it sometime."),
			_T("NEW_ENGINE_ANSWER_GOOD_FREE2", "You forgot to mention the best part - it's free.")
		}
	},
	bad = {
		paid = {
			_T("NEW_ENGINE_ANSWER_BAD_PAID1", "Yeah, I'm not very impressed by it either."),
			_T("NEW_ENGINE_ANSWER_BAD_PAID2", "Well, it might be lacking in features, but it might be a pleasure to work with, who knows.")
		},
		free = {
			_T("NEW_ENGINE_ANSWER_BAD_FREE1", "At least it's free, so any time investment will have some kind of yields."),
			_T("NEW_ENGINE_ANSWER_BAD_FREE2", "It's not rich in features for sure, but it's free, and I'm sure you can make a decent game with it.")
		}
	}
}
engineAnswer.topicID = "new_engine_convo"

function engineAnswer:pickTalkText(target)
	local discussEngineData = target:getConversation():getListener():getFact(engineConvo.engineToDiscussFact)
	
	discussEngine = engineLicensing:getEngineByUniqueID(discussEngineData.engine)
	
	local baseTextTable = engineAnswer.displayText
	
	if discussEngineData.positive then
		baseTextTable = baseTextTable.good
	else
		baseTextTable = baseTextTable.bad
	end
	
	if discussEngine:getCost() > 0 then
		baseTextTable = baseTextTable.paid
	else
		baseTextTable = baseTextTable.free
	end
	
	return baseTextTable[math.random(1, #baseTextTable)]
end

conversations:registerAnswer(engineAnswer)
