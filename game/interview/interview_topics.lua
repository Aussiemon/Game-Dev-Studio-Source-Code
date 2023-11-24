interviewTopics = {}
interviewTopics.registered = {}
interviewTopics.registeredByID = {}
interviewTopics.validTopics = {}
interviewTopics.DEFAULT_FONT = "pix20"

function interviewTopics:onSelectAnswer()
	if self.answerData.answerCallback then
		self.answerData:answerCallback(self.interviewObj, self)
	end
	
	if self.answerData.answerScore then
		self.interviewObj:addScore(self.answerData.answerScore)
	end
	
	self.interviewObj:advanceStep()
end

local baseTopicFuncs = {}

baseTopicFuncs.mtindex = {
	__index = baseTopicFuncs
}

function baseTopicFuncs:init()
	self._answerOptions = {}
	
	table.copyOver(self.answerOptions, self._answerOptions)
end

function baseTopicFuncs:getName(interviewObj)
	return self.display
end

function baseTopicFuncs:applyData(topicInstance)
end

function baseTopicFuncs:getDescription(interviewObj)
	return self.description
end

function baseTopicFuncs:getAnswerOptions(interviewObj)
	return self._answerOptions
end

function baseTopicFuncs:onAddToInterview(interviewObj)
end

function baseTopicFuncs:onNotPicked(interviewObj)
end

function baseTopicFuncs:onAnswered(interviewObj)
	if self.setStudioFacts then
		for key, data in ipairs(self.setStudioFacts) do
			studio:setFact(data.fact, data.state)
		end
	end
end

function interviewTopics:registerNew(data, inherit)
	table.insert(interviewTopics.registered, data)
	
	interviewTopics.registeredByID[data.id] = data
	
	if data.answerOptions then
		for key, answerData in ipairs(data.answerOptions) do
			answerData.font = answerData.font or interviewTopics.DEFAULT_FONT
			answerData.text = answerData.text or "YOU FORGOT TO ADD THE TEXT"
		end
	end
	
	local features = data.features
	
	if features then
		if not platforms.minimumFeatures then
			platforms.minimumFeatures = 1
		end
		
		if not platforms.maximumFeatures then
			platforms.maximumFeatures = math.huge
		end
	end
	
	local platforms = data.platforms
	
	if platforms then
		if not platforms.minimumPlatforms then
			platforms.minimumPlatforms = 1
		end
		
		if not platforms.maximumPlatforms then
			platforms.maximumPlatforms = math.huge
		end
	end
	
	local facts = data.facts
	
	if facts then
		if not facts.minimumFacts then
			facts.minimumFacts = 1
		end
		
		if not facts.maximumFacts then
			facts.maximumFacts = math.huge
		end
	end
	
	data.baseTopicFuncs = baseTopicFuncs
	data.mtindex = {
		__index = data
	}
	
	if inherit then
		local otherData = interviewTopics.registeredByID[inherit]
		
		if otherData then
			setmetatable(data, otherData.mtindex)
			
			data.baseClass = otherData
		else
			setmetatable(data, baseTopicFuncs.mtindex)
			
			data.baseClass = baseTopicFuncs
		end
	else
		setmetatable(data, baseTopicFuncs.mtindex)
		
		data.baseClass = baseTopicFuncs
	end
end

function interviewTopics:instantiate(data)
	local new = {}
	
	setmetatable(new, data.mtindex)
	new:init()
	
	return new
end

function interviewTopics:addToInterview(interviewObj)
	self:getValidInterviewTopics(interviewObj)
	
	for i = 1, interviewObj:getTotalSteps() do
		local randIndex = math.random(1, #self.validTopics)
		local randTopic = self.validTopics[randIndex]
		
		if randTopic then
			local topicInstance = self:instantiate(randTopic)
			
			randTopic:applyData(topicInstance)
			interviewObj:addTopic(topicInstance)
			table.remove(self.validTopics, randIndex)
		end
	end
	
	local data = interviewTopics.registeredByID.hype_counter_question
	
	if data:checkEligibility(interviewObj) then
		interviewObj:addTopic(self:instantiate(data))
	end
	
	for key, topicData in ipairs(self.validTopics) do
		topicData:onNotPicked(interviewObj)
		
		self.validTopics[key] = nil
	end
end

function interviewTopics:getValidInterviewTopics(interviewObj)
	table.clearArray(self.validTopics)
	
	for key, topicData in ipairs(interviewTopics.registered) do
		if self:isTopicValid(topicData, interviewObj) then
			table.insert(self.validTopics, topicData)
		end
	end
end

function interviewTopics:isTopicValid(topicData, interviewObj)
	local projectObj = interviewObj:getTargetProject()
	
	if topicData.invisible then
		return false
	end
	
	if topicData.checkEligibility and not topicData:checkEligibility(interviewObj) then
		return false
	end
	
	if topicData.genre and projectObj:getGenre() ~= topicData.genre then
		return false
	end
	
	if topicData.theme and projectObj:getTheme() ~= topicData.theme then
		return false
	end
	
	local facts = topicData.facts
	
	if facts then
		for key, data in ipairs(facts.factIDs) do
			local found = 0
			
			if studio:getFact(data.fact) then
				found = found + 1
			elseif facts.allFactsInList then
				return false
			end
			
			if found < facts.minimumFacts then
				return false
			elseif found > facts.maximumFacts then
				return false
			end
		end
	end
	
	local pricing = topicData.pricing
	
	if pricing then
		local projectPrice = projectObj:getPrice()
		
		if pricing.type == "greater" then
			if projectPrice < pricing.price then
				return false
			end
		elseif pricing.type == "lesser" and projectPrice > pricing.price then
			return false
		end
	end
	
	local daysWorkedOn = topicData.daysWorkedOn
	
	if daysWorkedOn then
		local projectDays = projectObj:getDaysWorkedOn()
		
		if daysWorkedOn.type == "greater" then
			if projectDays < daysWorkedOn.days then
				return false
			end
		elseif daysWorkedOn.type == "lesser" and projectDays > daysWorkedOn.days then
			return false
		end
	end
	
	if topicData.features then
		local found = 0
		
		for key, featureID in ipairs(topicData.features.featureIDs) do
			if not projectObj:hasFeature(featureID) then
				if topicData.features.allFeaturesInList then
					return false
				end
			else
				found = found + 1
			end
		end
		
		if found < topicData.features.minimumFeatures then
			return false
		elseif found > topicData.features.maximumFeatures then
			return false
		end
	end
	
	if topicData.platforms then
		local found = 0
		
		for key, platformID in ipairs(topicData.platforms.platformIDs) do
			if not projectObj:getPlatformState(platformID) then
				if topicData.platforms.allPlatformsInList then
					return false
				end
			else
				found = found + 1
			end
		end
		
		if found < topicData.platforms.minimumPlatforms then
			return false
		elseif found > topicData.platforms.maximumPlatforms then
			return false
		end
	end
	
	return true
end

require("game/interview/basic_interview_topics")
