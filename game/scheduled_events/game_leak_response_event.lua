local gameLeak = {}

gameLeak.id = "game_leak_response_event"
gameLeak.inactive = true

function gameLeak:activate()
	if not self.project or self.project:isScrapped() then
		return 
	end
	
	local gameLeakEventData = randomEvents:getData("game_leak")
	local validEmployee = gameLeakEventData:getValidEmployeeForDialogue()
	
	if not validEmployee then
		return 
	end
	
	local dialogueObject = dialogueHandler:addDialogue("game_leak_question_community_response_start", nil, validEmployee)
	
	dialogueObject:setFact("response_event", self)
end

function gameLeak:validateEvent()
	return true
end

util.setGetFunctions(gameLeak, "PlayerResponse", "playerResponse")
util.setGetFunctions(gameLeak, "ResponseType", "responseType")
util.setGetFunctions(gameLeak, "PopularityLoss", "popularityLoss")
util.setGetFunctions(gameLeak, "Project", "project")

function gameLeak:save()
	local saved = gameLeak.baseClass.save(self)
	
	saved.responseType = self.responseType
	saved.popularityLoss = self.popularityLoss
	saved.project = self.project:getUniqueID()
	saved.playerResponse = self.playerResponse
	
	return saved
end

function gameLeak:load(data)
	self.responseType = data.responseType
	self.popularityLoss = data.popularityLoss
	self.project = studio:getProjectByUniqueID(data.project)
	self.playerResponse = data.playerResponse
end

scheduledEvents:registerNew(gameLeak)
