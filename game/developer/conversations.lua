conversations = {}
conversations.registeredTopics = {}
conversations.registeredTopicsByID = {}
conversations.lastConversation = 0
conversations.validTopics = {}
conversations.validAnswers = {}
conversations.topicsToTalkAbout = {}
conversations.activeConvos = {}
conversations.registeredAnswers = {}
conversations.registeredAnswersByID = {}
conversations.CONVERSATION_DELAY = 20
conversations.CONVERSATION_DELAY_NONE = 5
conversations.CONVERSATION_DATA_FACT = "conversation_data"

local defaultConversationFuncs = {}

defaultConversationFuncs.mtindex = {
	__index = defaultConversationFuncs
}
defaultConversationFuncs.weight = 0

function defaultConversationFuncs:pickTalkText()
	if type(self.displayText) == "table" then
		local randomIndex = math.random(1, #self.displayText)
		
		return self.displayText[randomIndex], randomIndex
	end
	
	return self.displayText, nil
end

function defaultConversationFuncs:getWeight()
	return self.weight
end

function defaultConversationFuncs:canPick(target)
	return true
end

function defaultConversationFuncs:pickBestAnswer(target)
	local answers = self.answers
	local bestAnswer, prevWeight = nil, 0
	
	for key, answer in ipairs(answers) do
		if answer:canPick(target) then
			local curWeight = answer:getWeight()
			
			if prevWeight < curWeight then
				prevWeight = curWeight
				bestAnswer = answer
			end
		end
	end
	
	bestAnswer = bestAnswer or answers[math.random(1, #answers)]
	
	return bestAnswer
end

function defaultConversationFuncs:begin(conversationObj)
	local talker = conversationObj:getTalker()
	local listener = conversationObj:getListener()
	local talkText = self:pickTalkText(talker)
	local talkTime, rawTime = talker:setTalkText(talkText)
	
	listener:setTalkText(nil)
	conversationObj:setConversationDelay(rawTime + 0.5)
	
	if self.nextAnswer then
		conversationObj:setAnswer(conversations:getAnswerData(self.nextAnswer))
	elseif self.nextTopic then
		conversationObj:setAnswer(conversations:getTopicData(self.nextTopic))
	elseif self:isTopic() then
		conversationObj:setAnswer(self:pickBestAnswer(conversationTarget))
	end
end

local defaultTopicFuncs = {}

defaultTopicFuncs.mtindex = {
	__index = defaultTopicFuncs
}

setmetatable(defaultTopicFuncs, defaultConversationFuncs.mtindex)

function defaultTopicFuncs:isTopic()
	return true
end

function defaultTopicFuncs:isAnswer()
	return false
end

local defaultAnswerFuncs = {}

defaultAnswerFuncs.mtindex = {
	__index = defaultAnswerFuncs
}

setmetatable(defaultAnswerFuncs, defaultConversationFuncs.mtindex)

function defaultAnswerFuncs:isTopic()
	return false
end

function defaultAnswerFuncs:isAnswer()
	return true
end

local conversationClass = {}

conversationClass.mtindex = {
	__index = conversationClass
}

function conversationClass:init(initiator, target, topic)
	self.initiator = initiator
	self.target = target
	self.talker = initiator
	self.listener = target
	self.topic = topic
	self.answer = topic
	
	initiator:setConversation(self)
	target:setConversation(self)
	print("started conversation; talkers: ", initiator:getFullName(true), target:getFullName(true))
end

function conversationClass:setConversationDelay(time)
	self.conversationDelay = time
end

function conversationClass:setAnswer(answer)
	self.answer = answer
end

function conversationClass:getTalker()
	return self.talker
end

function conversationClass:getListener()
	return self.listener
end

function conversationClass:getInitiator()
	return self.initiator
end

function conversationClass:getTarget()
	return self.target
end

function conversationClass:getTopic()
	return self.topic
end

function conversationClass:isOver()
	return not self.answer
end

function conversationClass:abort()
	self.initiator:removeConversation()
	self.target:removeConversation()
	conversations:removeConversation(self)
end

function conversationClass:_start()
	local oldAnswer = self.answer
	
	self.answer = nil
	
	oldAnswer:begin(self)
	
	self.talker, self.listener = self.listener, self.talker
end

function conversationClass:advance()
	self:_start()
end

function conversationClass:abort()
	self.initiator:setTalkText(nil)
	self.target:setTalkText(nil)
	self:_finish()
end

function conversationClass:_finish()
	self.initiator:finishConversation()
	self.target:finishConversation()
	conversations:removeConversation(self)
end

function conversationClass:update(dt)
	self.conversationDelay = self.conversationDelay - dt
	
	if self.conversationDelay <= 0 then
		if self:isOver() then
			self:_finish()
			
			return false
		else
			self:advance()
			
			if self:isOver() then
				self:_finish()
				
				return false
			end
		end
	end
	
	return true
end

function conversations:init()
	self:clearData()
end

function conversations.new(initiator, target, topic)
	local new = {}
	
	setmetatable(new, conversationClass.mtindex)
	new:init(initiator, target, topic)
	new:advance()
	
	return new
end

function conversations:remove()
	self:clearData()
end

function conversations:clearData()
	table.clear(self.validTopics)
	table.clear(self.validAnswers)
	table.clear(self.topicsToTalkAbout)
	table.clearArray(self.activeConvos)
	
	self.lastConversation = 0
end

function conversations:registerTopic(data, inherit)
	table.insert(conversations.registeredTopics, data)
	
	conversations.registeredTopicsByID[data.id] = data
	data.answers = {}
	data.mtindex = {
		__index = data
	}
	
	if inherit then
		setmetatable(data, conversations.registeredTopicsByID[data.id].mtindex)
		
		data.baseClass = conversations.registeredTopicsByID[data.id]
	else
		setmetatable(data, defaultTopicFuncs.mtindex)
		
		data.baseClass = defaultTopicFuncs
	end
end

function conversations:registerAnswer(data)
	table.insert(conversations.registeredAnswers, data)
	
	conversations.registeredAnswersByID[data.id] = data
	
	if data.topicID then
		data.answerTo = conversations.registeredTopicsByID[data.topicID]
		
		table.insert(conversations.registeredTopicsByID[data.topicID].answers, data)
	end
	
	data.mtindex = {
		__index = data
	}
	
	if inherit then
		setmetatable(data, conversations.registeredAnswersByID[data.id].mtindex)
		
		data.baseClass = conversations.registeredAnswersByID[data.id]
	else
		setmetatable(data, defaultAnswerFuncs.mtindex)
		
		data.baseClass = defaultAnswerFuncs
	end
end

function conversations:getTopicData(id)
	return conversations.registeredTopicsByID[id]
end

function conversations:getAnswerData(id)
	return conversations.registeredAnswersByID[id]
end

local officesWithPeople = {}

function conversations:update(dt, simDelta)
	if self.lastConversation <= 0 then
		for key, officeObject in ipairs(studio:getOwnedBuildings()) do
			local employeeList = officeObject:getEmployees()
			
			if #employeeList > 1 then
				officesWithPeople[#officesWithPeople + 1] = employeeList
			end
		end
		
		local employees = studio:getEmployeesWithWorkplaces(officesWithPeople[math.random(1, #officesWithPeople)])
		
		if #employees > 0 then
			local randomEmployee = employees[math.random(1, #employees)]
			
			if not self:attemptBeginConversation(randomEmployee) then
				self.lastConversation = conversations.CONVERSATION_DELAY_NONE
			else
				self.lastConversation = conversations.CONVERSATION_DELAY
			end
		else
			self.lastConversation = conversations.CONVERSATION_DELAY_NONE
		end
		
		table.clearArray(officesWithPeople)
		table.clearArray(employees)
	else
		self.lastConversation = self.lastConversation - simDelta
	end
	
	if #self.activeConvos > 0 then
		local rIdx = 1
		
		for i = 1, #self.activeConvos do
			local convo = self.activeConvos[rIdx]
			
			if convo:update(simDelta) then
				rIdx = rIdx + 1
			end
		end
	end
end

function conversations:addConversation(initiator, target, topic)
	local convo = conversations.new(initiator, target, topic)
	
	table.insert(self.activeConvos, convo)
end

function conversations:removeConversation(convo)
	table.removeObject(self.activeConvos, convo)
end

function conversations:_genericValidityCheck(data, employee)
	if data.employeeDrive and employee:getDrive() < data.employeeDrive then
		return false
	end
	
	if data.studioFact and (not studio:getFact(data.studioFact.id) or data.studioFact.inverse and studio:getFact(data.studioFact.id)) then
		return false
	end
	
	if data.projectFact then
		local project = employee:getTeam():getProject()
		
		if project and (not project:getFact(data.projectFact.id) or data.projectFact.inverse and project:getFact(data.projectFact.id)) then
			return false
		end
	end
	
	return true
end

function conversations:isTopicValid(data, employee, target)
	if data.isTopicValid and not data:isTopicValid(employee, target) then
		return false
	end
	
	if not self:_genericValidityCheck(data, employee) then
		return false
	end
	
	return true
end

function conversations:isAnswerValid(data, employee)
	if data.isAnswerValid and not data:isAnswerValid(employee) then
		return false
	end
	
	if not self:_genericValidityCheck(data, employee) then
		return false
	end
	
	return true
end

function conversations:attemptBeginConversation(employee)
	if not employee:isVisible() then
		return 
	end
	
	local targets = studio:findClosestEmployees(employee, nil, employee:getOffice():getEmployees())
	local target
	
	for key, otherEmployee in ipairs(targets) do
		if otherEmployee ~= employee and otherEmployee:canBeginConversation() and util.los(employee.x, employee.y, otherEmployee.x, otherEmployee.y, employee:getFloor(), 10) then
			target = otherEmployee
			
			break
		end
	end
	
	table.clearArray(targets)
	
	if target then
		local validTopic = self:getRandomValidTopic(employee, target)
		
		if validTopic then
			self:addConversation(employee, target, validTopic)
			
			return true
		end
	end
	
	return false
end

function conversations:getRandomValidTopic(employee, target)
	local validTopics = self:getValidTopics(employee, target)
	local topic
	
	if #validTopics > 0 then
		topic = validTopics[math.random(1, #validTopics)]
	end
	
	table.clear(self.validTopics)
	
	return topic
end

function conversations:getValidTopics(employee, target)
	for key, data in ipairs(conversations.registeredTopics) do
		if self:isTopicValid(data, employee, target) then
			table.insert(self.validTopics, data)
		end
	end
	
	return self.validTopics
end

function conversations:getValidAnswers(topic, employee)
	local possibleAnswers = conversations.registeredTopicsByID[topic.id].answers
	
	for key, answer in ipairs(possibleAnswers) do
		if self:isAnswerValid(answer, employee) then
			table.insert(self.validAnswers, answer)
		end
	end
	
	return self.validAnswers
end

function conversations:getRandomValidAnswer(topic, employee)
	local answers = self:getValidAnswers(topic, employee)
	local result
	
	if #answers > 0 then
		result = answers[math.random(1, #answers)]
	end
	
	table.clear(self.validAnswers)
	
	return result
end

function conversations:addTopicToTalkAbout(id, data)
	if data == nil then
		data = true
	end
	
	self.topicsToTalkAbout[id] = data
end

function conversations:removeTopicToTalkAbout(id)
	self.topicsToTalkAbout[id] = nil
end

function conversations:canTalkAboutTopic(id)
	return self.topicsToTalkAbout[id]
end

function conversations:save()
	return {
		topicsToTalkAbout = self.topicsToTalkAbout
	}
end

function conversations:load(data)
	if data then
		self.topicsToTalkAbout = data.topicsToTalkAbout
	end
end

require("game/developer/conversations/engines")
require("game/developer/conversations/tech")
require("game/developer/conversations/shittalking")
require("game/developer/conversations/bribe_reactions")
require("game/developer/conversations/rivals")
require("game/developer/conversations/generic")
