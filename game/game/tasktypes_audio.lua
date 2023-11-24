taskTypes:registerCategoryTitle("game_audio", _T("GAME_CATEGORY_AUDIO", "Audio"), nil, nil, nil, nil, "category_audio")

local eightBit = {}

eightBit.id = "audio_8bit_sounds"
eightBit.category = "game_audio"
eightBit.display = _T("SOUND_8_BIT_SOUNDS", "8-bit sounds")
eightBit.platformWorkAffector = 0
eightBit.mmoContent = 4
eightBit.multipleEmployees = true
eightBit.workAmount = 30
eightBit.workField = "sound"
eightBit.minimumLevel = 5
eightBit.noIssues = true
eightBit.gameQuality = {
	sound = 20
}
eightBit.specBoost = {
	id = "editing",
	boost = 1.15
}
eightBit.qualityContribution = "sound"
eightBit.optionCategory = "sound_quality"
eightBit.optionalForStandard = false
eightBit.taskID = "game_task"
eightBit.stage = 2
eightBit.cost = 2000

function eightBit:getCost(cost, projectObj)
	return self.baseClass.getCost(self, self.cost * projectObj:getScale(), projectObj)
end

taskTypes:registerNew(eightBit)

local regularSnd = {}

regularSnd.id = "audio_regular_sounds"
regularSnd.category = "game_audio"
regularSnd.display = _T("REGULAR_SOUNDS", "Regular sounds")
regularSnd.platformWorkAffector = 0
regularSnd.mmoContent = 7
regularSnd.multipleEmployees = true
regularSnd.minimumLevel = 20
regularSnd.workAmount = 60
regularSnd.workField = "sound"
regularSnd.noIssues = true
regularSnd.releaseDate = {
	year = 1994,
	month = 4
}
regularSnd.specBoost = {
	id = "editing",
	boost = 1.15
}
regularSnd.gameQuality = {
	sound = 50
}
regularSnd.qualityContribution = "sound"
regularSnd.optionCategory = "sound_quality"
regularSnd.optionalForStandard = false
regularSnd.taskID = "game_task"
regularSnd.stage = 2
regularSnd.cost = 7000

function regularSnd:getCost(cost, projectObj)
	return self.baseClass.getCost(self, self.cost * projectObj:getScale(), projectObj)
end

taskTypes:registerNew(regularSnd)

local chiptune = {}

chiptune.id = "audio_chiptune_soundtrack"
chiptune.category = "game_audio"
chiptune.display = _T("CHIPTUNE_SOUNDTRACK", "Chiptune soundtrack")
chiptune.platformWorkAffector = 0
chiptune.mmoContent = 5
chiptune.multipleEmployees = true
chiptune.minimumLevel = 10
chiptune.workAmount = 70
chiptune.workField = "sound"
chiptune.noIssues = true
chiptune.gameQuality = {
	sound = 20
}
chiptune.specBoost = {
	id = "composition",
	boost = 1.15
}
chiptune.qualityContribution = "sound"
chiptune.optionCategory = "soundtrack"
chiptune.optionalForStandard = false
chiptune.taskID = "game_task"
chiptune.stage = 2
chiptune.cost = 2500

function chiptune:getCost(cost, projectObj)
	return self.baseClass.getCost(self, self.cost * projectObj:getScale(), projectObj)
end

taskTypes:registerNew(chiptune)

local regularSoundtrack = {}

regularSoundtrack.id = "audio_regular_soundtrack"
regularSoundtrack.category = "game_audio"
regularSoundtrack.display = _T("REGULAR_SOUNDTRACK", "Regular soundtrack")
regularSoundtrack.mmoContent = 7
regularSoundtrack.platformWorkAffector = 0
regularSoundtrack.multipleEmployees = true
regularSoundtrack.minimumLevel = 20
regularSoundtrack.workAmount = 100
regularSoundtrack.workField = "sound"
regularSoundtrack.noIssues = true
regularSoundtrack.gameQuality = {
	sound = 50
}
regularSoundtrack.releaseDate = {
	year = 1993,
	month = 5
}
regularSoundtrack.specBoost = {
	id = "composition",
	boost = 1.15
}
regularSoundtrack.qualityContribution = "sound"
regularSoundtrack.optionCategory = "soundtrack"
regularSoundtrack.optionalForStandard = false
regularSoundtrack.taskID = "game_task"
regularSoundtrack.stage = 2
regularSoundtrack.cost = 10000

function regularSoundtrack:getCost(cost, projectObj)
	return self.baseClass.getCost(self, self.cost * projectObj:getScale(), projectObj)
end

taskTypes:registerNew(regularSoundtrack)

local orchestralSoundtrack = {}

orchestralSoundtrack.id = "audio_orchestral_soundtrack"
orchestralSoundtrack.category = "game_audio"
orchestralSoundtrack.display = _T("ORCHESTRAL_SOUNDTRACK", "Orchestral soundtrack")
orchestralSoundtrack.mmoContent = 10
orchestralSoundtrack.platformWorkAffector = 0
orchestralSoundtrack.multipleEmployees = true
orchestralSoundtrack.workAmount = 150
orchestralSoundtrack.minimumLevel = 40
orchestralSoundtrack.workField = "sound"
orchestralSoundtrack.noIssues = true
orchestralSoundtrack.gameQuality = {
	sound = 100
}
orchestralSoundtrack.releaseDate = {
	year = 1996,
	month = 2
}
orchestralSoundtrack.specBoost = {
	id = "composition",
	boost = 1.15
}
orchestralSoundtrack.qualityContribution = "sound"
orchestralSoundtrack.optionCategory = "soundtrack"
orchestralSoundtrack.optionalForStandard = false
orchestralSoundtrack.taskID = "game_task"
orchestralSoundtrack.stage = 2
orchestralSoundtrack.cost = 20000

function orchestralSoundtrack:getCost(cost, projectObj)
	return self.baseClass.getCost(self, self.cost * projectObj:getScale(), projectObj)
end

taskTypes:registerNew(orchestralSoundtrack)

local staticAmbientAudio = {}

staticAmbientAudio.id = "static_ambient_audio"
staticAmbientAudio.platformWorkAffector = 0.2
staticAmbientAudio.mmoContent = 2
staticAmbientAudio.multipleEmployees = true
staticAmbientAudio.category = "game_audio"
staticAmbientAudio.display = _T("STATIC_AMBIENT_AUDIO", "Static ambient audio")
staticAmbientAudio.description = {
	font = "pix20",
	text = _T("STATIC_AMBIENT_AUDIO_DESCRIPTION", "Pre-defined spots in maps for ambient audio to be played")
}
staticAmbientAudio.specBoost = {
	id = "algorithms",
	boost = 1.15
}
staticAmbientAudio.minimumLevel = 10
staticAmbientAudio.workAmount = 80
staticAmbientAudio.workField = "software"
staticAmbientAudio.noIssues = true
staticAmbientAudio.gameQuality = {
	sound = 40
}
staticAmbientAudio.qualityContribution = "sound"
staticAmbientAudio.taskID = "game_task"
staticAmbientAudio.stage = 2

taskTypes:registerNew(staticAmbientAudio)

local proceduralAmbientAudio = {}

proceduralAmbientAudio.id = "procedural_ambient_audio"
proceduralAmbientAudio.platformWorkAffector = 0.2
proceduralAmbientAudio.mmoContent = 2
proceduralAmbientAudio.multipleEmployees = true
proceduralAmbientAudio.category = "game_audio"
proceduralAmbientAudio.display = _T("PROCEDURAL_AMBIENT_AUDIO", "Procedural ambient audio")
proceduralAmbientAudio.description = {
	{
		font = "pix20",
		text = _T("PROCEDURAL_AMBIENT_AUDIO_DESCRIPTION", "Implement a system which will play ambient sounds based on the environment")
	}
}
proceduralAmbientAudio.specBoost = {
	id = "algorithms",
	boost = 1.15
}
proceduralAmbientAudio.minimumLevel = 15
proceduralAmbientAudio.workAmount = 80
proceduralAmbientAudio.workField = "software"
proceduralAmbientAudio.noIssues = true
proceduralAmbientAudio.requiresResearch = true
proceduralAmbientAudio.releaseDate = {
	year = 1995,
	month = 6
}
proceduralAmbientAudio.gameQuality = {
	sound = 40
}
proceduralAmbientAudio.qualityContribution = "sound"
proceduralAmbientAudio.taskID = "game_task"
proceduralAmbientAudio.stage = 2

taskTypes:registerNew(proceduralAmbientAudio)
