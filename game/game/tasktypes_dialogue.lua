taskTypes:registerCategoryTitle("game_dialogue", _T("CATEGORY_DIALOGUE", "Dialogue"), nil, nil, nil, nil, "category_dialogue")

local conversationSystem = {}

conversationSystem.id = "conversation_system"
conversationSystem.mmoContent = 4
conversationSystem.mmoComplexity = 0.4
conversationSystem.category = "game_dialogue"
conversationSystem.specBoost = {
	id = "algorithms",
	boost = 1.15
}
conversationSystem.platformWorkAffector = 0.2
conversationSystem.display = _T("CONVERSATION_SYSTEM", "Conversation system")
conversationSystem.workAmount = 40
conversationSystem.workField = "software"
conversationSystem.gameQuality = {
	dialogue = 30
}
conversationSystem.minimumLevel = 10
conversationSystem.taskID = "game_task"
conversationSystem.qualityContribution = "dialogue"
conversationSystem.stage = 2

taskTypes:registerNew(conversationSystem)

local partialVoicing = {}

partialVoicing.id = "partially_voiced_characters"
partialVoicing.category = "game_dialogue"
partialVoicing.mmoContent = 5
partialVoicing.platformWorkAffector = 0
partialVoicing.display = _T("PARTIALLY_VOICED_CHARACTERS", "Partially voiced characters")
partialVoicing.workAmount = 50
partialVoicing.workField = "management"
partialVoicing.voicingTypeFact = "voicing_type"
partialVoicing.voicingQualityFact = "voicing_quality"
partialVoicing.gameQuality = {
	dialogue = 25
}
partialVoicing.noIssues = true
partialVoicing.taskID = "game_task"
partialVoicing.optionCategory = "voicing_type"
partialVoicing.qualityContribution = "dialogue"
partialVoicing.stage = 2
partialVoicing.description = {
	{
		font = "pix20",
		text = _T("PARTIALLY_VOICED_CHARACTERS_DESCRIPTION", "Record voice acting for characters that are only vital to the game story.")
	}
}

function partialVoicing:onSelected(projectObject)
	if projectObject:getFact(self.voicingTypeFact) then
		return 
	end
	
	projectObject:addInvalidTask(self.id)
	projectObject:setFact(self.voicingQualityFact, self.id)
end

function partialVoicing:onDeselected(projectObject)
	projectObject:removeInvalidTask(self.id)
end

function partialVoicing:getInvalidityText(projectObject, missingList)
	if not projectObject:getFact(self.voicingTypeFact) then
		table.insert(missingList, _T("NO_VOICEOVER_SELECTED", "No voice-over type selected"))
	end
end

taskTypes:registerNew(partialVoicing)

local fullVoicing = {}

fullVoicing.id = "fully_voiced_characters"
fullVoicing.category = "game_dialogue"
fullVoicing.mmoContent = 7
fullVoicing.platformWorkAffector = 0
fullVoicing.display = _T("FULLY_VOICED_CHARACTERS", "Fully voiced characters")
fullVoicing.workAmount = 100
fullVoicing.workField = "management"
fullVoicing.gameQuality = {
	dialogue = 50
}
fullVoicing.noIssues = true
fullVoicing.taskID = "game_task"
fullVoicing.optionCategory = "voicing_type"
fullVoicing.qualityContribution = "dialogue"
fullVoicing.stage = 2
fullVoicing.description = {
	{
		font = "pix20",
		text = _T("FULLY_VOICED_CHARACTERS_DESCRIPTION1", "Record voice acting for all characters within the game.")
	}
}

taskTypes:registerNew(fullVoicing, nil, "partially_voiced_characters")

local amateurVA = {}

amateurVA.id = "audio_amateur_voice_acting"
amateurVA.category = "game_dialogue"
amateurVA.mmoContent = 3
amateurVA.specBoost = {
	id = "editing",
	boost = 1.15
}
amateurVA.display = _T("AMATEUR_VOICE_ACTING", "Amateur voice acting")
amateurVA.platformWorkAffector = 0
amateurVA.workAmount = 40
amateurVA.cost = 500
amateurVA.description = {
	{
		text = "Gather your friends and team members to voice characters for the game.",
		font = "pix20"
	},
	{
		text = "It doesn't have to be extremely good, just has to provide voices for characters.",
		font = "pix20"
	}
}
amateurVA.workField = "sound"
amateurVA.noIssues = true
amateurVA.gameQuality = {
	sound = 12
}
amateurVA.qualityContribution = "sound"
amateurVA.optionCategory = "voiceacting"
amateurVA.taskID = "game_task"
amateurVA.stage = 2
amateurVA.anyRequirement = true
amateurVA.requirements = {
	partially_voiced_characters = true,
	fully_voiced_characters = true
}

function amateurVA:onSelected(projectObject)
	projectObject:setFact(partialVoicing.voicingTypeFact, self.id)
	
	local fact = projectObject:getFact(partialVoicing.voicingQualityFact)
	
	if fact then
		projectObject:removeInvalidTask(fact)
	end
end

function amateurVA:onDeselected(projectObject)
	projectObject:setFact(partialVoicing.voicingTypeFact, nil)
	
	local fact = projectObject:getFact(partialVoicing.voicingQualityFact)
	
	if fact then
		projectObject:addInvalidTask(fact)
	end
end

function amateurVA:getCost(cost, projectObj)
	if projectObj:hasDesiredFeature("fully_voiced_characters") then
		return amateurVA.baseClass.getCost(self, self.cost * 3 * projectObj:getScale(), projectObj)
	end
	
	return amateurVA.baseClass.getCost(self, self.cost * projectObj:getScale(), projectObj)
end

taskTypes:registerNew(amateurVA)

local professionalVA = {}

professionalVA.id = "audio_professional_voice_acting"
professionalVA.category = "game_dialogue"
professionalVA.mmoContent = 5
professionalVA.specBoost = {
	id = "editing",
	boost = 1.15
}
professionalVA.platformWorkAffector = 0
professionalVA.display = _T("PROFESSIONAL_VOICE_ACTING", "Professional voice acting")
professionalVA.workAmount = 40
professionalVA.cost = 7000
professionalVA.description = {
	{
		text = "Hire professional voice actors to voice characters for the game.",
		font = "pix20"
	}
}
professionalVA.workField = "sound"
professionalVA.noIssues = true
professionalVA.gameQuality = {
	sound = 25
}
professionalVA.releaseDate = {
	year = 1994,
	month = 5
}
professionalVA.qualityContribution = "sound"
professionalVA.optionCategory = "voiceacting"
professionalVA.taskID = "game_task"
professionalVA.stage = 2
professionalVA.anyRequirement = true
professionalVA.requirements = {
	partially_voiced_characters = true,
	fully_voiced_characters = true
}

taskTypes:registerNew(professionalVA, nil, "audio_amateur_voice_acting")
