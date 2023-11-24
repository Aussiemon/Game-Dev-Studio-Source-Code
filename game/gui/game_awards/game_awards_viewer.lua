local bgViewer = {}

bgViewer.sizeMult = 2
bgViewer.skinConfigs = {
	ga_row_1_skin = {
		magnitude = 0.1,
		clothingQuad = "ga_row_1_shirt",
		clothingOffset = {
			0,
			18
		},
		hairQuads = {
			male = {
				{
					"ga_row_1_hair_m_1",
					4,
					6
				},
				{
					"ga_row_1_hair_m_2",
					3,
					5
				},
				{
					"ga_row_1_hair_m_3",
					3,
					4
				}
			},
			female = {
				{
					"ga_row_1_hair_f_1",
					3,
					5
				},
				{
					"ga_row_1_hair_f_2",
					3,
					5
				},
				{
					"ga_row_1_hair_f_3",
					3,
					5
				}
			}
		}
	},
	ga_row_2_skin = {
		magnitude = 0.2,
		clothingQuad = "ga_row_2_shirt",
		clothingOffset = {
			0,
			24
		},
		hairQuads = {
			male = {
				{
					"ga_row_2_hair_m_1",
					5,
					8
				},
				{
					"ga_row_2_hair_m_2",
					4,
					8
				},
				{
					"ga_row_2_hair_m_3",
					4,
					7
				}
			},
			female = {
				{
					"ga_row_2_hair_f_1",
					5,
					7
				},
				{
					"ga_row_2_hair_f_2",
					4,
					7
				},
				{
					"ga_row_2_hair_f_3",
					4,
					7
				}
			}
		}
	},
	ga_row_3_skin = {
		magnitude = 0.3,
		clothingQuad = "ga_row_3_shirt",
		clothingOffset = {
			0,
			33
		},
		hairQuads = {
			male = {
				{
					"ga_row_3_hair_m_1",
					6,
					11
				},
				{
					"ga_row_3_hair_m_2",
					5,
					11
				},
				{
					"ga_row_3_hair_m_3",
					5,
					11
				}
			},
			female = {
				{
					"ga_row_3_hair_f_1",
					6,
					11
				},
				{
					"ga_row_3_hair_f_2",
					5,
					10
				},
				{
					"ga_row_3_hair_f_3",
					5,
					10
				}
			}
		}
	}
}

function bgViewer:init()
	self.female = math.random(1, 2) == 1
	self.intensity = 1
	self.magnitude = 1
	self.yOffset = 0
	self.curIntensity = 1
	self.curMagnitude = 1
	self.yTime = math.randomf(0, math.pi)
	self.yTimeSpeed = math.randomf(0.9, 1.15)
	self.scaledSizeMult = _S(self.sizeMult)
end

local piVal = math.pi * 2

function bgViewer:think()
	self.curIntensity = math.approach(self.curIntensity, self.intensity, frameTime * 10)
	self.curMagnitude = math.approach(self.curMagnitude, self.magnitude, frameTime * 10)
	self.yTime = self.yTime + frameTime * 0.8 * self.curIntensity * self.yTimeSpeed
	
	if self.yTime > piVal then
		self.yTime = self.yTime - piVal
		self.yTimeSpeed = math.randomf(0.9, 1.15)
	end
	
	self.yOffset = math.floor(math.cos(self.yTime) * self.curMagnitude) * self.scaledSizeMult
	
	self:queueSpriteUpdate()
end

function bgViewer:setSkinQuad(quad)
	self.skinQuad = quad
	
	local quadStruct = quadLoader:getQuadStructure(quad)
	
	self.skinW, self.skinH = quadStruct.w, quadStruct.h
	
	local skinCfg = self.skinConfigs[quad]
	
	self:setClothingQuad(skinCfg)
	self:pickHair(skinCfg)
	
	self.clothingColor = developer.pickRandomClothingColor(developer.CLOTHING_TYPE.TORSO)
	
	local id = portrait:rollRandomAppearance(portrait.APPEARANCE_PARTS.HAIRCOLOR, self.female)
	
	self.hairColor = portrait.registeredDataByID[id].color
end

function bgViewer:setClothingQuad(data)
	self.clothingQuad = data.clothingQuad
	self.clothingOffset = data.clothingOffset
	
	local quadStruct = quadLoader:getQuadStructure(data.clothingQuad)
	
	self.clothingW, self.clothingH = quadStruct.w, quadStruct.h
end

function bgViewer:setMagnitude(mag)
	self.magnitude = mag
end

function bgViewer:pickHair(skinCfg)
	local list = self.female and skinCfg.hairQuads.female or skinCfg.hairQuads.male
	local hairData = list[math.random(1, #list)]
	local struct = quadLoader:getQuadStructure(hairData[1])
	
	self.hairQuad = hairData[1]
	self.hairW = struct.w
	self.hairH = struct.h
	self.hairX = _S(hairData[2] * self.sizeMult)
	self.hairY = _S(hairData[3] * self.sizeMult)
	self.hairXOff = 0
	
	if self.flip then
		self.hairXOff = _S(self.skinW * self.sizeMult)
	end
	
	local colorID = portrait:rollRandomAppearance(portrait.APPEARANCE_PARTS.SKINCOLOR, self.female)
	
	self.skinColor = portrait.registeredDataByID[colorID].color
end

function bgViewer:setIntensity(int)
	self.intensity = int
end

function bgViewer:setHairColor(clr)
	self.hairColor = clr
end

function bgViewer:setSkinColor(clr)
	self.skinColor = clr
end

function bgViewer:setFlip(flip)
	self.flip = flip
end

function bgViewer:getQuadCoords(quad)
	if self.flip then
		local qData = quadLoader:getQuadStructure(quad)
		
		return qData.w, 0
	end
	
	return 0, 0
end

function bgViewer:updateSprites()
	local mult = self.sizeMult
	local x, y = self:getQuadCoords(self.skinQuad)
	local xScale = self.flip and -1 or 1
	local cOff = self.clothingOffset
	local alpha = self.alpha
	local r, g, b, a = self.skinColor:unpack()
	
	self:setNextSpriteColor(r, g, b, a * alpha)
	
	self.skinSprite = self:allocateSprite(self.skinSprite, self.skinQuad, _S(x * mult), cOff[2] + self.yOffset, 0, self.skinW * mult * xScale, self.skinH * mult, 0, 0, -0.1)
	
	local x, y = self:getQuadCoords(self.clothingQuad)
	local r, g, b, a = self.clothingColor:unpack()
	
	self:setNextSpriteColor(r, g, b, a * alpha)
	
	self.clothingSprite = self:allocateSprite(self.clothingSprite, self.clothingQuad, _S((x + cOff[1]) * mult), _S(cOff[2] * mult) + self.yOffset, 0, self.clothingW * mult * xScale, self.clothingH * mult, 0, 0, -0.09)
	
	local r, g, b, a = self.hairColor:unpack()
	
	self:setNextSpriteColor(r, g, b, a * alpha)
	
	self.hairSprite = self:allocateSprite(self.hairSprite, self.hairQuad, self.hairXOff + self.hairX * xScale, self.hairY + self.yOffset, 0, self.hairW * mult * xScale, self.hairH * mult, 0, 0, -0.08)
end

gui.register("GameAwardsViewer", bgViewer, "GameAwardsBackgroundFadeIn")
