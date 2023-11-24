local frame = {}
local topRowY = 171
local midRowY = 152
local lowRowY = 139

frame.ROW_POSITIONS = {
	{
		skinQuad = "ga_row_3_skin",
		depth = 29,
		flip = true,
		viewerPositions = {
			{
				-12,
				topRowY
			},
			{
				23,
				topRowY
			},
			{
				58,
				topRowY
			}
		}
	},
	{
		skinQuad = "ga_row_3_skin",
		depth = 29,
		viewerPositions = {
			{
				235,
				topRowY
			},
			{
				270,
				topRowY
			},
			{
				305,
				topRowY
			}
		}
	},
	{
		skinQuad = "ga_row_2_skin",
		depth = 24,
		flip = true,
		viewerPositions = {
			{
				-12,
				midRowY
			},
			{
				18,
				midRowY
			},
			{
				48,
				midRowY
			},
			{
				78,
				midRowY
			}
		}
	},
	{
		skinQuad = "ga_row_2_skin",
		depth = 24,
		viewerPositions = {
			{
				310,
				midRowY
			},
			{
				280,
				midRowY
			},
			{
				250,
				midRowY
			},
			{
				220,
				midRowY
			}
		}
	},
	{
		skinQuad = "ga_row_1_skin",
		depth = 19,
		flip = true,
		viewerPositions = {
			{
				8,
				lowRowY
			},
			{
				38,
				lowRowY
			},
			{
				68,
				lowRowY
			},
			{
				98,
				lowRowY
			}
		}
	},
	{
		skinQuad = "ga_row_1_skin",
		depth = 19,
		viewerPositions = {
			{
				295,
				lowRowY
			},
			{
				265,
				lowRowY
			},
			{
				235,
				lowRowY
			},
			{
				205,
				lowRowY
			}
		}
	}
}
frame.CATCHABLE_EVENTS = {
	gameAwards.EVENTS.ANNOUNCER_FADED_IN
}
frame.sizeMult = 2

function frame:init()
	self.stageProps = {}
	self.stageFadeProps = {}
	self.stagePropID = 1
	self.stageFadeAlpha = 0
	self.speechEntries = gameAwards:getSpeechEntries()
	self.remainingSpeechEntries = {}
	
	for key, entry in ipairs(self.speechEntries) do
		self.remainingSpeechEntries[key] = entry
	end
	
	self.speechDescbox = gui.create("GenericDescbox", self)
	
	self.speechDescbox:setPos(_S(10), _S(40))
	self.speechDescbox:bringUp()
end

function frame:setDescboxCenterPos(x, y)
	self.descboxX = x
	self.descboxY = y
end

function frame:setAnnouncerPos(x, y)
	self.announcerX = x
	self.announcerY = y
end

function frame:createAnnouncer()
	local ann = gui.create("GameAwardsBackgroundFadeIn", self)
	
	ann:setPos(self.announcerX, self.announcerY)
	ann:setQuad("ga_presenter")
	ann:setSize(44, 130)
	ann:addDepth(19)
	ann:setEventOnFadeIn(gameAwards.EVENTS.ANNOUNCER_FADED_IN)
	
	self.announcer = ann
end

function frame:setBasePosition(x, y)
	self.baseX = x
	self.baseY = y
end

function frame:handleEvent(event)
	if event == gameAwards.EVENTS.ANNOUNCER_FADED_IN then
		self:setStage(gameAwards.STAGES.ANNOUNCER_TALK)
	end
end

frame.ADVANCE_SPEECH_TIME = -0.4

function frame:think()
	if self.stageFadeIn then
		self.stageFadeAlpha = math.min(1, self.stageFadeAlpha + frameTime)
		
		local fadeAlpha = self.stageFadeAlpha
		
		for key, elem in ipairs(self.stageFadeProps) do
			elem:setAlpha(fadeAlpha)
			elem:queueSpriteUpdate()
		end
		
		if fadeAlpha >= 1 then
			self:pickStageFadeProps()
		end
	end
	
	if self.crowdFadeIn then
		self.fadeAlpha = math.min(1, self.fadeAlpha + frameTime)
		
		local fadeAlpha = self.fadeAlpha
		
		for key, elem in ipairs(self.activeFadeElems) do
			elem:setAlpha(fadeAlpha)
			elem:queueSpriteUpdate()
		end
		
		if fadeAlpha >= 1 then
			self:pickFadeCrowd()
		end
	end
	
	if self.curSpeechEntry and self.speechDuration then
		self.speechDuration = self.speechDuration - frameTime
		
		if self.speechDuration <= self.ADVANCE_SPEECH_TIME then
			if #self.remainingSpeechEntries <= 0 then
				if self.stage == gameAwards.STAGES.ANNOUNCER_TALK then
					self:setStage(gameAwards.STAGES.CEO_IN)
				elseif self.stage == gameAwards.STAGES.CEO_TALK then
					self:setStage(gameAwards.STAGES.CEO_OUT)
				end
			end
			
			self.curSpeechEntry = nil
			
			self:advanceSpeech()
		end
		
		if self.speechDuration <= 0 and self.speechDescbox.isVisible then
			self.speechDescbox:removeAllText()
			self.speechDescbox:hide()
		end
	end
	
	if self.panelFade then
		self:queueSpriteUpdate()
		
		if self.panelFadeAlpha == 1 then
			self:kill()
			gameAwards:postFinishGameAwardsWindow()
		end
	end
end

function frame:setStage(stage)
	self.stage = stage
	
	if stage == gameAwards.STAGES.FADE_IN then
		self:beginStageFadeIn()
	elseif stage == gameAwards.STAGES.CROWD_IN then
		self.stageFadeIn = false
		
		self:beginCrowdFadeIn()
	elseif stage == gameAwards.STAGES.ANNOUNCER_IN then
		self.crowdFadeIn = false
		self.fadeAlpha = 0
		
		self:createAnnouncer()
	elseif stage == gameAwards.STAGES.ANNOUNCER_TALK then
		self:advanceSpeech()
	elseif stage == gameAwards.STAGES.CEO_IN then
		self.announcer:setTargetAlpha(0)
		self.announcer:setFadeInSpeed(3)
		self.announcer:setEventOnFadeIn(nil)
		self:createWinnerSpeaker()
	elseif stage == gameAwards.STAGES.CEO_TALK then
		self:advanceSpeech()
	elseif stage == gameAwards.STAGES.CEO_OUT then
		self.winnerSpeaker:goTowardsExit()
		
		self.panelFade = true
		self.panelFadeAlpha = 0
		
		for key, obj in ipairs(self.crowdElems) do
			obj:setMagnitude(2)
			obj:setIntensity(10)
		end
	end
end

function frame:onClick(x, y, key)
end

function frame:forceSkipStage()
	local stage = self.stage
	local stages = gameAwards.STAGES
	
	if stage == stages.FADE_IN then
		self:forceAlpha(self.stageFadeProps)
		table.clearArray(self.stageFadeProps)
		
		local stageProps = self.stageProps
		
		while true do
			if stageProps[self.stagePropID] then
				self:forceAlpha(stageProps[self.stagePropID])
				
				self.stagePropID = self.stagePropID + 1
			else
				break
			end
		end
		
		self.stageFadeIn = false
		
		self:setStage(stages.CROWD_IN)
	elseif stage == stages.CROWD_IN then
		self:forceAlpha(self.activeFadeElems)
		table.clearArray(self.activeFadeElems)
		self:forceAlpha(self.remainingFadeElems)
		table.clearArray(self.remainingFadeElems)
		self:setStage(stages.ANNOUNCER_IN)
	elseif stage == stages.ANNOUNCER_IN then
		self.announcer:setEventOnFadeIn(nil)
		self.announcer:setAlpha(1)
		self:setStage(stages.ANNOUNCER_TALK)
	elseif stage == stages.ANNOUNCER_TALK then
		if not self:advanceSpeech(true) then
			self:setStage(stages.CEO_IN)
		end
	elseif stage == stages.CEO_IN then
		self.announcer:setTargetAlpha(0)
		self.announcer:setAlpha(0)
		self.announcer:setFadeInSpeed(3)
		self.winnerSpeaker:moveToFinish()
		self:setStage(stages.CEO_TALK)
	elseif stage == stages.CEO_TALK then
		self:advanceSpeech(true)
	end
end

function frame:forceAlpha(objList)
	for key, obj in ipairs(objList) do
		obj:setAlpha(1)
		obj:queueSpriteUpdate()
	end
end

frame.PANEL_FADE_SPEED = 0.5

function frame:updateSprites()
	frame.baseClass.updateSprites(self)
	
	if self.panelFade then
		self.panelFadeAlpha = math.approach(self.panelFadeAlpha, 1, frameTime * frame.PANEL_FADE_SPEED)
		
		local r, g, b = self.topRectColor:unpack()
		
		self:setNextSpriteColor(r, g, b, 255 * self.panelFadeAlpha)
		
		self.panelFadeSlot = self:allocateSprite(self.panelFadeSlot, "generic_1px", 0, _S(25), 0, self.rawW, self.rawH - 24, 0, 0, 100)
	end
end

function frame:onFinishedCEOWalking()
	if self.stage == gameAwards.STAGES.CEO_IN then
		self:setStage(gameAwards.STAGES.CEO_TALK)
	elseif stage == gameAwards.STAGES.CEO_TALK then
		self:setStage(gameAwards.STAGES.CEO_OUT)
	end
end

function frame:pickFadeCrowd()
	local elem = self.activeFadeElems
	
	if #elem > 0 then
		table.clearArray(elem)
	end
	
	if #self.remainingFadeElems == 0 then
		self:setStage(gameAwards.STAGES.ANNOUNCER_IN)
	end
	
	for i = 1, math.min(math.ceil(#self.crowdElems * 0.34), #self.remainingFadeElems) do
		elem[#elem + 1] = table.remove(self.remainingFadeElems, math.random(1, #self.remainingFadeElems))
	end
	
	self.fadeAlpha = 0
end

function frame:beginCrowdFadeIn()
	self.crowdFadeIn = true
	
	self:pickFadeCrowd()
end

function frame:createCrowd()
	self.crowdElems = {}
	self.remainingFadeElems = {}
	self.activeFadeElems = {}
	
	local sizeMult = self.sizeMult
	
	for key, data in ipairs(frame.ROW_POSITIONS) do
		local skinQuad = data.skinQuad
		local flip = data.flip
		local depthOff = data.depth
		
		for key, posData in ipairs(data.viewerPositions) do
			local elem = gui.create("GameAwardsViewer", self)
			
			elem:setFlip(flip)
			elem:setSkinQuad(skinQuad)
			elem:setPos(_S(posData[1] * sizeMult), _S(posData[2] * sizeMult))
			elem:setAlpha(0)
			elem:addDepth(10 + depthOff)
			table.insert(self.crowdElems, elem)
			
			self.remainingFadeElems[#self.remainingFadeElems + 1] = elem
		end
	end
end

function frame:advanceSpeech(force)
	local entry = table.remove(self.remainingSpeechEntries, 1)
	
	if not entry then
		if force then
			self.speechDuration = self.ADVANCE_SPEECH_TIME
		end
		
		return false
	end
	
	if force then
		self.speechDescbox:removeAllText()
	end
	
	local text
	
	if type(entry) == "string" then
		text = entry
		
		for key, obj in ipairs(self.crowdElems) do
			obj:setMagnitude(1)
			obj:setIntensity(1)
		end
	else
		text = entry.text
		
		for key, obj in ipairs(self.crowdElems) do
			if entry.crowdMagnitude then
				obj:setMagnitude(entry.crowdMagnitude)
			else
				obj:setMagnitude(1)
			end
			
			if entry.crowdIntensity then
				obj:setIntensity(entry.crowdIntensity)
			else
				obj:setIntensity(1)
			end
		end
		
		if entry.sound then
			sound:play(entry.sound)
		end
	end
	
	self.curSpeechEntry = text
	self.speechDuration = 0.3 + #text * 0.07
	
	self.speechDescbox:show()
	self.speechDescbox:addText(text, "bh16", nil, 0, 280)
	self.speechDescbox:setPos(self.descboxX - self.speechDescbox.w, self.descboxY - self.speechDescbox.h * 0.5)
	
	return true
end

function frame:finishSpeech()
	self.curSpeechEntry = nil
	
	self.speechDescbox:removeAllText()
	self.speechDescbox:hide()
end

function frame:setSpeaker(speaker)
	self.speaker = speaker
end

function frame:setFakeAward(state)
	self.fakeAward = state
end

function frame:createWinnerSpeaker()
	local ws = gui.create("GameAwardsWinnerSpeaker", self)
	
	ws:addDepth(19)
	ws:setSizeMultiplier(2)
	ws:setSpeaker(self.speaker)
	ws:setFakeAward(self.fakeAward)
	
	if self.speaker then
		local ptrt = self.speaker:getPortrait()
		
		ws:setPortrait(ptrt)
		ws:setFemale(self.speaker:isFemale())
		
		local hair = ptrt:getHaircut()
		
		if hair then
			ws:setHairData(portrait.getPartData(hair))
		end
	else
		local female = math.random(1, 2) == 2
		local list
		
		ws:setFemale(female)
		
		if female then
			list = portrait.registeredDataByPart.female
		else
			list = portrait.registeredDataByPart.male
		end
		
		list = list[portrait.APPEARANCE_PARTS.HAIRCUT]
		
		local hairData = list[math.random(1, #list)]
		
		ws:setHairData(hairData)
		ws:rollRandomColors()
	end
	
	ws:setStartPos(-_S(50), _S(135))
	ws:setFinishPos(_S(298), _S(135))
	ws:setOuterPos(self.w, _S(135))
	
	self.winnerSpeaker = ws
end

function frame:setSpeechText(textList)
	local activeText = self.remainingSpeechEntries
	
	for key, text in ipairs(textList) do
		activeText[key] = text
	end
end

function frame:addStageProp(stageID, element)
	if not self.stageProps[stageID] then
		self.stageProps[stageID] = {}
	end
	
	table.insert(self.stageProps[stageID], element)
end

function frame:pickStageFadeProps()
	local stageFadeProps = self.stageFadeProps
	local stageProps = self.stageProps
	
	if #stageFadeProps > 0 then
		table.clearArray(stageFadeProps)
	end
	
	if not stageProps[self.stagePropID] then
		self:setStage(gameAwards.STAGES.CROWD_IN)
		
		return 
	end
	
	for key, obj in ipairs(stageProps[self.stagePropID]) do
		stageFadeProps[#stageFadeProps + 1] = obj
	end
	
	self.stagePropID = self.stagePropID + 1
	self.stageFadeAlpha = 0
end

function frame:beginStageFadeIn()
	self:pickStageFadeProps()
	
	self.stageFadeIn = true
end

gui.register("GameAwardsFrame", frame, "Frame")
