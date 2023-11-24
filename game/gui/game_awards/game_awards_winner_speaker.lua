local bgSpeak = {}

bgSpeak.sizeMult = 2
bgSpeak.stepSize = 55
bgSpeak.maleQuads = {
	"ga_player_walk_clothes_m_1",
	"ga_player_walk_clothes_m_2"
}
bgSpeak.femaleQuads = {
	"ga_player_walk_clothes_f_1",
	"ga_player_walk_clothes_f_2"
}
bgSpeak.walkSkinQuads = {
	"ga_player_walk_skin_1",
	"ga_player_walk_skin_2"
}
bgSpeak.standEyeQuad = "ga_player_stand_eyes"
bgSpeak.standSkinQuad = "ga_player_stand_skin_1"
bgSpeak.maleStandQuad = "ga_player_stand_clothes_m"
bgSpeak.femaleStandQuad = "ga_player_stand_clothes_f"
bgSpeak.walkEyeQuad = "ga_player_walk_eyes"
bgSpeak.walkSpeed = 4
bgSpeak.spriteOffsets = {
	ga_player_walk_clothes_f_1 = {
		ga_player_walk_skin_1 = {
			1,
			-16.5
		},
		ga_player_walk_hair_f_1 = {
			1,
			-18
		},
		ga_player_walk_hair_f_2 = {
			1,
			-18
		},
		ga_player_walk_eyes = {
			11,
			-9
		}
	},
	ga_player_walk_clothes_f_2 = {
		ga_player_walk_skin_2 = {
			13,
			-16.5
		},
		ga_player_walk_hair_f_1 = {
			13,
			-18
		},
		ga_player_walk_hair_f_2 = {
			13,
			-18
		},
		ga_player_walk_eyes = {
			23,
			-9
		}
	},
	ga_player_walk_clothes_m_1 = {
		ga_player_walk_skin_1 = {
			1,
			-16.5
		},
		ga_player_walk_hair_m_1 = {
			1,
			-18
		},
		ga_player_walk_hair_m_2 = {
			1,
			-18
		},
		ga_player_walk_eyes = {
			11,
			-9
		}
	},
	ga_player_walk_clothes_m_2 = {
		ga_player_walk_skin_2 = {
			13,
			-16.5
		},
		ga_player_walk_hair_m_1 = {
			13,
			-18
		},
		ga_player_walk_hair_m_2 = {
			13,
			-18
		},
		ga_player_walk_eyes = {
			23,
			-9
		}
	},
	ga_player_stand_clothes_f = {
		ga_player_stand_hair_f_1 = {
			7.5,
			-16.5
		},
		ga_player_stand_hair_f_2 = {
			7.5,
			-18
		},
		ga_player_stand_eyes = {
			10.5,
			-9
		},
		ga_player_stand_skin_1 = {
			-1.5,
			-16.5
		}
	},
	ga_player_stand_clothes_m = {
		ga_player_stand_hair_m_1 = {
			10.5,
			-16
		},
		ga_player_stand_hair_m_2 = {
			9,
			-17
		},
		ga_player_stand_eyes = {
			12,
			-8
		},
		ga_player_stand_skin_1 = {
			0,
			-15
		}
	}
}

for a, b in pairs(bgSpeak.spriteOffsets) do
	for c, d in pairs(b) do
		d[1] = d[1] / 1.5
		d[2] = d[2] / 1.5
	end
end

function bgSpeak:init()
	self.curX = 0
	self.curY = 0
	self.progress = 0
	self.animationProgress = 0
	self.multiplier = 0.5
	self.standing = false
end

function bgSpeak:setFinishPos(x, y)
	self.finishX = x
	self.finishY = y
end

function bgSpeak:setStartPos(x, y)
	self.startX = x
	self.startY = y
	self.curX = x
	self.curY = y
	
	self:setPos(x, y)
end

function bgSpeak:setMoveSpeedMult(mult)
	self.multiplier = mult
end

function bgSpeak:step()
	local size = _S(self.stepSize)
	local oldX, oldY = self.curX, self.curY
	local finishX, finishY = self.finishX, self.finishY
	
	self.curX = math.approach(self.curX, finishX, size)
	self.curY = math.approach(self.curY, finishY, size)
	
	self:setPos(self.curX, self.curY)
	
	local curX, curY = self.curX, self.curY
	
	if curX == finishX and curY == finishY and (oldX ~= finishX or oldY ~= finishY) then
		self:finishWalking()
	end
end

function bgSpeak:finishWalking()
	self.standing = true
	
	self:updateHair()
	self:queueSpriteUpdate()
	
	local playerSpeech = gameAwards:getPlayerSpeech()
	local speakerInvalid = false
	
	if self.speaker then
		if not self.speaker:getEmployer() or not self.speaker:getEmployer():isPlayer() then
			speakerInvalid = true
		end
	else
		speakerInvalid = true
	end
	
	if self.fakeAward or speakerInvalid or not playerSpeech or not playerSpeech[1] then
		local speech = {}
		local defSpeech = gameAwards.DEFAULT_TEXT
		
		for key, id in ipairs(gameAwards.SPEECH_ORDER) do
			speech[id] = defSpeech[key]
		end
		
		self.parent:setSpeechText(speech)
	else
		self.parent:setSpeechText(playerSpeech)
	end
	
	self.parent:onFinishedCEOWalking()
end

function bgSpeak:think()
	self.progress = math.approach(self.progress, 1, frameTime * self.multiplier)
	self.animationProgress = self.animationProgress + frameTime * self.walkSpeed
	
	if self.animationProgress >= 1 then
		self.animationProgress = self.animationProgress - math.floor(self.animationProgress)
		
		self:step()
	end
	
	self:queueSpriteUpdate()
end

function bgSpeak:setPortrait(ptrt)
	self.portrait = ptrt
	self.skinColor = portrait.registeredDataByID[self.portrait:getSkinColor()].color
	self.hairColor = portrait.registeredDataByID[self.portrait:getHairColor()].color
end

function bgSpeak:rollRandomColors()
	local list = portrait.registeredDataByPart.male[portrait.APPEARANCE_PARTS.SKINCOLOR]
	
	self.skinColorID = list[math.random(1, #list)].id
	self.hairColorID = portrait:rollColorAppearance(self.skinColorID, "hairColors")
	self.skinColor = portrait.registeredDataByID[self.skinColorID].color
	self.hairColor = portrait.registeredDataByID[self.hairColorID].color
end

function bgSpeak:setOuterPos(x, y)
	self.outerX = x
	self.outerY = y
end

function bgSpeak:goTowardsExit()
	self.standing = false
	
	self:updateHair()
	self:setFinishPos(self.outerX, self.outerY)
end

function bgSpeak:setSizeMultiplier(mult)
	self.sizeMult = mult
end

function bgSpeak:setFemale(state)
	self.female = state
	
	if state then
		self.mainQuads = self.maleQuads
	else
		self.mainQuads = self.femaleQuads
	end
end

function bgSpeak:setHairData(data)
	self.hairData = data
	
	self:updateHair()
end

function bgSpeak:updateHair()
	if not self.hairData then
		return 
	end
	
	if self.standing then
		self.hairQuad = self.hairData.gameAwardsStandQuad
	else
		self.hairQuad = self.hairData.gameAwardsWalkQuad
	end
	
	if self.hairQuad then
		local struct = quadLoader:getQuadStructure(self.hairQuad)
		
		self.hairW, self.hairH = struct.w * self.sizeMult, struct.h * self.sizeMult
	end
end

function bgSpeak:moveToFinish()
	self.curX = self.finishX
	self.curY = self.finishY
	
	self:setPos(self.curX, self.curY)
	self:finishWalking()
	self:queueSpriteUpdate()
end

function bgSpeak:getTorsoSprite()
	if self.standing then
		if self.female then
			return self.femaleStandQuad, self.standSkinQuad, self.standEyeQuad
		else
			return self.maleStandQuad, self.standSkinQuad, self.standEyeQuad
		end
	else
		local list
		
		if self.female then
			list = self.femaleQuads
		else
			list = self.maleQuads
		end
		
		local length = #list
		local idx = math.max(1, math.ceil(self.animationProgress * length))
		
		return list[idx], self.walkSkinQuads[idx], self.walkEyeQuad
	end
end

function bgSpeak:setFakeAward(fake)
	self.fakeAward = fake
end

function bgSpeak:setSpeaker(speak)
	self.speaker = speak
end

function bgSpeak:updateSprites()
	local torsoQuad, skinQuad, eyeQuad = self:getTorsoSprite()
	local offsets = self.spriteOffsets[torsoQuad]
	local struct = quadLoader:getQuadStructure(torsoQuad)
	local w, h = struct.w, struct.h
	local mult = self.sizeMult
	
	self.torsoSlot = self:allocateSprite(self.torsoSlot, torsoQuad, 0, 0, 0, w * mult, h * mult, 0, 0, -0.1)
	
	local struct = quadLoader:getQuadStructure(skinQuad)
	local skinW, skinH = struct.w, struct.h
	local skinOff = offsets[skinQuad]
	
	self:setNextSpriteColor(self.skinColor:unpack())
	
	self.skinSlot = self:allocateSprite(self.skinSlot, skinQuad, _S(skinOff[1] * mult), _S(skinOff[2] * mult), 0, skinW * mult, skinH * mult, 0, 0, -0.09)
	
	if self.hairQuad then
		local hairOff = offsets[self.hairQuad]
		
		self:setNextSpriteColor(self.hairColor:unpack())
		
		self.hairSlot = self:allocateSprite(self.hairSlot, self.hairQuad, _S(hairOff[1] * mult), _S(hairOff[2] * mult), 0, self.hairW, self.hairH, 0, 0, -0.08)
	end
	
	local struct = quadLoader:getQuadStructure(eyeQuad)
	local eyeOff = offsets[eyeQuad]
	local eyeW, eyeH = struct.w * mult, struct.h * mult
	
	self.eyeSlot = self:allocateSprite(self.eyeSlot, eyeQuad, _S(eyeOff[1] * mult), _S(eyeOff[2] * mult), 0, eyeW, eyeH, 0, 0, -0.07)
end

gui.register("GameAwardsWinnerSpeaker", bgSpeak, "GameAwardsBackgroundFadeIn")
