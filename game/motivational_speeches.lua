motivationalSpeeches = {}
motivationalSpeeches.registeredSpeeches = {}
motivationalSpeeches.registeredSpeechesByID = {}
motivationalSpeeches.CHARISMA_TO_SCORE = 10
motivationalSpeeches.PUBLIC_SPEAKING_TO_SCORE = 0.1
motivationalSpeeches.MINIMUM_DRIVE_GAIN = 5
motivationalSpeeches.SCORE_TO_DRIVE = 0.2
motivationalSpeeches.SCORE_TO_DAYS_WITHOUT_VACATION_DECREASE = 0.15
motivationalSpeeches.COOLDOWN_PERIOD = timeline.DAYS_IN_MONTH * 4
motivationalSpeeches.LAST_SPEECH_FACT = "last_motivational_speech"
motivationalSpeeches.INTER_SPEECH_BREAK = 1
motivationalSpeeches.BASE_SPEECH_DURATION = 1
motivationalSpeeches.EXTRA_SPEECH_DURATION_PER_SYMBOL = 0.06
motivationalSpeeches.RESUME_SPEED = 1
motivationalSpeeches.PUBLIC_SPEAKING_PER_SPEECH = {
	5,
	10
}
motivationalSpeeches.MAX_EMPLOYEES_IN_ROOM = 50
motivationalSpeeches.BASE_MOTIVATION_CHANCE = 90
motivationalSpeeches.MOTIVATION_CHANCE_DECREASE_FROM_VACATION_DENIALS = 10
motivationalSpeeches.MOTIVATION_CHANCE_DECREASE_FROM_RAISE_DENIALS = 40
motivationalSpeeches.validConferenceTables = {}
motivationalSpeeches.validChairs = {}
motivationalSpeeches.participants = {}
motivationalSpeeches.participantPositioning = {}
motivationalSpeeches.validTiles = {}
motivationalSpeeches.validMidTiles = {}
motivationalSpeeches.usedMidTiles = {}
motivationalSpeeches.differentOfficeEmployees = {}
motivationalSpeeches.STAGES = {
	FADE_OUT = 4,
	INACTIVE = 0,
	START = 1,
	SPEECH_PREPARE = 2,
	SPEECH = 3
}

function motivationalSpeeches:register(data)
	table.insert(motivationalSpeeches.registeredSpeeches, data)
	
	motivationalSpeeches.registeredSpeechesByID[data.id] = data
end

function motivationalSpeeches:init()
end

function motivationalSpeeches:remove()
	self:resetSpeechData()
	self:killHintDisplay()
end

function motivationalSpeeches:canStart(conferenceTable, playerCharacter)
	playerCharacter = playerCharacter or studio:getPlayerCharacter()
	
	if not conferenceTable then
		local list = self:findValidConferenceTables()
		
		conferenceTable = list[math.random(1, #list)]
	end
	
	if conferenceTable and conferenceTable:isPartOfValidRoom() and playerCharacter then
		local lastSpeechTime = playerCharacter:getFact(motivationalSpeeches.LAST_SPEECH_FACT)
		
		if not lastSpeechTime or timeline.curTime > lastSpeechTime + motivationalSpeeches.COOLDOWN_PERIOD then
			return true
		end
	end
	
	return false
end

function motivationalSpeeches:resetSpeechData()
	self.speaker = nil
	self.speechData = nil
	self.speechScore = 0
	self.passedSpeechTime = 0
	self.nextSpeechTime = 0
	self.speechIndex = 0
	self.stage = 0
	self.prevZoomLevel = nil
	
	table.clearArray(self.participants)
	table.clearArray(self.validChairs)
	table.clearArray(self.validConferenceTables)
	table.clear(self.validTiles)
	table.clear(self.validMidTiles)
	table.clear(self.usedMidTiles)
	table.clearArray(self.participantPositioning)
	table.clearArray(self.differentOfficeEmployees)
	inputService:removeHandler(self)
end

function motivationalSpeeches:isActive()
	return self.speaker ~= nil
end

function motivationalSpeeches:start()
	self.speaker = studio:getPlayerCharacter()
	self.speechScore = self:getSpeechScore()
	self.speechData = self:getSpeechData(self.speechScore)
	self.passedSpeechTime = 0
	self.nextSpeechTime = 0
	self.speechIndex = 0
	
	table.clearArray(self.participants)
	table.clearArray(self.validChairs)
	table.clearArray(self.validConferenceTables)
	table.clear(self.validTiles)
	table.clear(self.validMidTiles)
	table.clear(self.usedMidTiles)
	table.clearArray(self.participantPositioning)
	table.clearArray(self.differentOfficeEmployees)
	timeline:pause()
	events:addReceiver(self)
	self:setStage(motivationalSpeeches.STAGES.START)
	camera:blockInputFor(math.huge)
	autosave:addBlocker(self)
	objectSelector:addBlocker(self)
	game.topHUD:disableClicks(true, true)
end

function motivationalSpeeches:killHintDisplay()
	if self.hintDisplay then
		self.hintDisplay:kill()
		
		self.hintDisplay = nil
	end
end

function motivationalSpeeches:finish()
	self.speaker:setFact(motivationalSpeeches.LAST_SPEECH_FACT, timeline.curTime + motivationalSpeeches.COOLDOWN_PERIOD)
	self.speaker:addKnowledge("public_speaking", math.random(motivationalSpeeches.PUBLIC_SPEAKING_PER_SPEECH[1], motivationalSpeeches.PUBLIC_SPEAKING_PER_SPEECH[2]))
	interests:attemptGiveNewInterest(self.speaker, "public_speaking")
	
	if #self.differentOfficeEmployees > 0 then
		self:createsScreenFader()
		
		self.stage = motivationalSpeeches.STAGES.FADE_OUT
	else
		self:leave()
	end
	
	self:killHintDisplay()
end

eventBoxText:registerNew({
	id = "motivational_speech_result",
	getText = function(self, data)
		return _format(_T("MOTIVATION_SPEECH_RESULT_TEXT", "Not bad! Motivational speech increased employee drive levels by DRIVE%"), "DRIVE", data)
	end
})

function motivationalSpeeches:leave()
	timeline:resume()
	timeline:setSpeed(motivationalSpeeches.RESUME_SPEED)
	events:removeReceiver(self)
	camera:blockInputFor(0)
	
	local element = game.addToEventBox("motivational_speech_result", math.round(self.speechScore * motivationalSpeeches.SCORE_TO_DRIVE, 1), 1, nil, "increase")
	
	element:setFlash(true, true)
	game.topHUD:enableClicks(true)
	
	for key, participant in ipairs(self.participants) do
		if participant:getWorkplace() then
			participant:goToWorkplace()
		end
	end
	
	if self.speaker:getWorkplace() then
		self.speaker:goToWorkplace()
	end
	
	self:resetSpeechData()
	autosave:removeBlocker(self)
	objectSelector:removeBlocker(self)
	game.showHUD()
end

function motivationalSpeeches:handleKeyPress()
end

function motivationalSpeeches:handleKeyRelease()
end

function motivationalSpeeches:handleTextInput()
end

function motivationalSpeeches:handleMouseClick(key)
	if key == gui.mouseKeys.LEFT then
		self.passedSpeechTime = self.nextSpeechTime
	end
end

function motivationalSpeeches:handleEvent(event)
	if self.stage ~= motivationalSpeeches.STAGES.INACTIVE then
		if self.stage == motivationalSpeeches.STAGES.START then
			if event == gui.getClassTable("ScreenFader").EVENTS.FADED_IN then
				self:setStage(motivationalSpeeches.STAGES.SPEECH_PREPARE)
			end
		elseif self.stage == motivationalSpeeches.STAGES.SPEECH_PREPARE then
			if event == gui.getClassTable("ScreenFader").EVENTS.FADED_OUT then
				self:setStage(motivationalSpeeches.STAGES.SPEECH)
			end
		elseif self.stage == motivationalSpeeches.STAGES.FADE_OUT then
			local object = gui.getClassTable("ScreenFader")
			
			if event == object.EVENTS.FADED_IN then
				for key, employee in ipairs(self.differentOfficeEmployees) do
					employee:returnToWorkplace()
					
					self.differentOfficeEmployees[key] = nil
				end
				
				camera:setZoomLevel(self.prevZoomLevel)
			elseif event == object.EVENTS.FADED_OUT then
				self:leave()
			end
		end
	end
end

function motivationalSpeeches:createsScreenFader()
	local fadeIn = gui.create("ScreenFader")
	
	fadeIn:bringUp()
	fadeIn:setSize(scrW, scrH)
end

function motivationalSpeeches:setStage(stage)
	self.stage = stage
	
	if stage == motivationalSpeeches.STAGES.START then
		self:createsScreenFader()
	elseif stage == motivationalSpeeches.STAGES.SPEECH_PREPARE then
		game.hideHUD()
		
		local confTables = self:findValidConferenceTables()
		local randTable = confTables[math.random(1, #confTables)]
		local tableFloor = randTable:getFloor()
		local chairs = randTable:getSurroundingChairs()
		
		table.copyOver(chairs, self.validChairs)
		
		local chair = self:pickRandomChair()
		
		self.speaker:setFloor(tableFloor)
		self.speaker:setPos(chair:getPos())
		self.speaker:faceObject(chair, true)
		self.speaker:getAvatar():setAnimation(self.speaker:getSitAnimation(), 1, tdas.ANIMATION_TYPES.LOOP)
		self.speaker:abortConversation()
		
		self.prevZoomLevel = camera:getZoomLevel()
		
		camera:setZoomLevel(camera.defaultZoomLevel + 1)
		camera:setViewFloor(tableFloor)
		
		local x, y = self.speaker:getAvatar():getCenterDrawPosition()
		
		camera:setPosition(x - scrW / camera.scaleX * 0.5, y - scrH / camera.scaleY * 0.5, true)
		
		local grid = game.worldObject:getObjectGrid()
		local tiles = randTable:getSurroundingTiles()
		
		for key, employee in ipairs(studio:getEmployees()) do
			if employee:isAvailable() then
				self.participants[#self.participants + 1] = employee
			end
		end
		
		table.copyOver(tiles, self.validTiles)
		table.copyOver(tiles, self.validMidTiles)
		table.removeObject(self.participants, self.speaker)
		table.copyOver(self.participants, self.participantPositioning)
		self.speaker:abortCurrentAction()
		
		local ourOffice = randTable:getOffice()
		
		if ourOffice ~= self.speaker:getOffice() then
			self.differentOfficeEmployees[#self.differentOfficeEmployees + 1] = self.speaker
		end
		
		for i = 1, math.min(#self.participantPositioning, #self.validTiles + #self.validChairs + #self.validMidTiles * 2) do
			local employeeIndex = math.random(1, #self.participantPositioning)
			local employee = self.participantPositioning[employeeIndex]
			
			if employee then
				employee:abortCurrentAction()
				employee:setIsOnWorkplace(false)
				employee:abortConversation()
				table.remove(self.participantPositioning, employeeIndex)
				
				local chair = self:pickRandomChair()
				
				if chair then
					employee:setFloor(tableFloor)
					employee:setPos(chair:getPos())
					employee:faceObject(chair, true)
					employee:getAvatar():setAnimation(employee:getSitAnimation(), 1, tdas.ANIMATION_TYPES.LOOP)
				else
					local randomIndex = math.random(1, #self.validTiles)
					local randomTile = self.validTiles[randomIndex]
					
					if randomTile then
						local worldX, worldY = grid:indexToWorld(randomTile)
						
						employee:setFloor(tableFloor)
						employee:setPos(worldX, worldY)
						employee:faceEmployee(self.speaker)
						
						local avatar = employee:getAvatar()
						
						avatar:setAnimation(employee:getStandAnimation(), 1)
						avatar:setDrawOffset(0, 0)
					else
						local randomIndex = math.random(1, #self.validMidTiles)
						local randomTile = self.validMidTiles[randomIndex]
						local prevTilePopulation = self.usedMidTiles[randomTile] or 0
						local desiredSide = not self:hasSide(prevTilePopulation, walls.UP) and walls.UP or walls.LEFT
						local direction = walls.DIRECTION[desiredSide]
						local worldX, worldY = grid:indexToWorld(randomTile)
						
						worldX = worldX + game.WORLD_TILE_WIDTH * 0.5 * direction[1]
						worldY = worldY + game.WORLD_TILE_HEIGHT * 0.5 * direction[2]
						
						employee:setFloor(tableFloor)
						employee:setPos(worldX, worldY)
						employee:faceEmployee(self.speaker)
						
						local avatar = employee:getAvatar()
						
						avatar:setAnimation(employee:getStandAnimation(), 1)
						avatar:setDrawOffset(0, 0)
						
						self.usedMidTiles[randomTile] = prevTilePopulation + desiredSide
						
						if self:hasSide(self.usedMidTiles[randomTile], walls.LEFT) then
							table.remove(self.validMidTiles, randomIndex)
						end
					end
				end
				
				if employee:getOffice() ~= ourOffice then
					self.differentOfficeEmployees[#self.differentOfficeEmployees + 1] = employee
				end
			else
				break
			end
		end
		
		table.clear(self.participantPositioning)
	elseif stage == motivationalSpeeches.STAGES.SPEECH then
		inputService:addHandler(self)
		self:advanceSpeech()
		
		self.hintDisplay = gui.create("GenericHintText")
		
		self.hintDisplay:setFont("bh22")
		self.hintDisplay:setText(_T("LMB_TO_SKIP_DIALOGUE", "[LMB] - skip dialogue"))
		self.hintDisplay:center()
		self.hintDisplay:setY(scrH * 0.5 + _S(100))
	end
end

function motivationalSpeeches:hasSide(value, side)
	return bit.band(value, side) == side
end

function motivationalSpeeches:update(dt)
	if self.stage == motivationalSpeeches.STAGES.SPEECH then
		if mainMenu:getInGameMenu() then
			return 
		end
		
		if self:canAdvanceSpeech() then
			self:advanceSpeech()
		elseif not self:shouldShowSpeech() and self.speaker:getTalkText() then
			self.speaker:setTalkText(nil, 1)
		end
		
		self.passedSpeechTime = self.passedSpeechTime + dt
	end
end

function motivationalSpeeches:pickRandomChair()
	local index = math.random(1, #self.validChairs)
	local chair = self.validChairs[index]
	
	if chair then
		table.remove(self.validChairs, index)
		
		return chair
	end
	
	return nil
end

function motivationalSpeeches:findValidConferenceTables()
	table.clear(self.validConferenceTables)
	
	for key, object in ipairs(studio:getOwnedObjects()) do
		if object:getObjectType() == "conference_desk" and object:isPartOfValidRoom() then
			self.validConferenceTables[#self.validConferenceTables + 1] = object
		end
	end
	
	return self.validConferenceTables
end

function motivationalSpeeches:canAdvanceSpeech()
	return self.passedSpeechTime > self.nextSpeechTime
end

function motivationalSpeeches:shouldShowSpeech()
	return self.passedSpeechTime < self.nextSpeechTime - motivationalSpeeches.INTER_SPEECH_BREAK
end

function motivationalSpeeches:advanceSpeech()
	self.speechIndex = self.speechIndex + 1
	
	if self.speechData.parts[self.speechIndex] then
		local listOfText = self.speechData.parts[self.speechIndex]
		
		self.pickedText = listOfText[math.random(1, #listOfText)]
		self.passedSpeechTime = 0
		self.nextSpeechTime = motivationalSpeeches.BASE_SPEECH_DURATION + motivationalSpeeches.EXTRA_SPEECH_DURATION_PER_SYMBOL * #self.pickedText + motivationalSpeeches.INTER_SPEECH_BREAK
		
		self.speaker:setTalkText(self.pickedText, timeline.curTime + 1)
		
		local driveGain = self.speechScore * motivationalSpeeches.SCORE_TO_DRIVE / #self.speechData.parts
		local daysWithoutVacationDecrease = -self.speechScore * motivationalSpeeches.SCORE_TO_DAYS_WITHOUT_VACATION_DECREASE / #self.speechData.parts
		
		for key, dev in ipairs(self.participants) do
			if math.random(1, 100) <= self:getMotivationChance(dev) then
				dev:addDrive(driveGain)
				dev:addDaysWithoutVacation(daysWithoutVacationDecrease)
				dev:displayDriveChange(driveGain)
			end
		end
	else
		self:setStage(motivationalSpeeches.STAGES.INACTIVE)
		self:finish()
	end
end

function motivationalSpeeches:getCharismaScore(level)
	return level * motivationalSpeeches.CHARISMA_TO_SCORE
end

function motivationalSpeeches:getPublicSpeakingScore(level)
	return level * motivationalSpeeches.PUBLIC_SPEAKING_TO_SCORE
end

function motivationalSpeeches:getMaxSpeechScore()
	return self:getCharismaScore(attributes:getData("charisma").maxLevel) + self:getPublicSpeakingScore(knowledge:getData("public_speaking").maximum)
end

function motivationalSpeeches:getSpeechScore()
	local score = math.max(motivationalSpeeches.MINIMUM_DRIVE_GAIN, self:getCharismaScore(self.speaker:getAttribute("charisma")) + self:getPublicSpeakingScore(self.speaker:getKnowledge("public_speaking")))
	
	for key, traitID in ipairs(self.speaker:getTraits()) do
		score = traits:getData(traitID):adjustMotivationalSpeechScore(self.speaker, score)
	end
	
	return score
end

function motivationalSpeeches:getMotivationChance(employee)
	return motivationalSpeeches.BASE_MOTIVATION_CHANCE - employee:getDeniedVacations() * motivationalSpeeches.MOTIVATION_CHANCE_DECREASE_FROM_VACATION_DENIALS - employee:getDeniedRaises() * motivationalSpeeches.MOTIVATION_CHANCE_DECREASE_FROM_RAISE_DENIALS
end

function motivationalSpeeches:getSpeechData(score)
	local closest, mostValid = math.huge
	
	for key, data in ipairs(motivationalSpeeches.registeredSpeeches) do
		local dist = math.dist(data.score, score)
		
		if dist < closest then
			mostValid = data
			closest = dist
		end
	end
	
	return mostValid, closest
end

motivationalSpeeches:register({
	score = 30,
	id = "low_speech_skills",
	parts = {
		{
			_T("LOW_SPEECH_SKILLS_SPEECH_1_A", "Alright fellas, I gathered you all here because I wanted to discuss your efforts on our projects.")
		},
		{
			_T("LOW_SPEECH_SKILLS_SPEECH_2_A", "I understand that some tasks might be tough, but we need to give the projects our best.")
		},
		{
			_T("LOW_SPEECH_SKILLS_SPEECH_3_A", "If we don't give this our all, then we won't get far. I need you guys at your best.")
		}
	}
})
motivationalSpeeches:register({
	score = 70,
	id = "medium_speech_skills",
	parts = {
		{
			_T("MEDIUM_SPEECH_SKILLS_SPEECH_1_A", "Guys, I'm really glad to have you all here. I'm really glad I have a team of people as experienced as you.")
		},
		{
			_T("MEDIUM_SPEECH_SKILLS_SPEECH_2_A", "You guys are like the backbone of the company, without you, I doubt we'd get to where we are right now.")
		},
		{
			_T("MEDIUM_SPEECH_SKILLS_SPEECH_3_A", "If something is not right, let me know and I'll make it right, because we're like a family, so we have to always be at our best."),
			_T("MEDIUM_SPEECH_SKILLS_SPEECH_3_B", "If something is bothering you - come to me. We're like a family and being at our best is very important to each and every one of us.")
		},
		{
			_T("MEDIUM_SPEECH_SKILLS_SPEECH_4_A", "Remember that I consider you guys more than just my employees, so if you ever want to go have some fun - just let me know.")
		}
	}
})
motivationalSpeeches:register({
	score = 110,
	id = "high_speech_skills",
	parts = {
		{
			_T("HIGH_SPEECH_SKILLS_SPEECH_1_A", "Great to have you all here, folks.")
		},
		{
			_T("HIGH_SPEECH_SKILLS_SPEECH_2_A", "I have a dream for this company to grow big, for each of you to become rich and successful.")
		},
		{
			_T("HIGH_SPEECH_SKILLS_SPEECH_3_A", "I know things might seem tough sometimes, but know that I have the back of every one of you.")
		},
		{
			_T("HIGH_SPEECH_SKILLS_SPEECH_4_A", "The entire company is lucky to have such an experienced assortment of people, and it's even made better by the fact that we all get along.")
		},
		{
			_T("HIGH_SPEECH_SKILLS_SPEECH_5_A", "That'll be all for now, let's go make some great games together!")
		}
	}
})
