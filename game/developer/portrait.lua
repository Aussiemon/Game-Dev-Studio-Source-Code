portrait = {}
portrait.mtindex = {
	__index = portrait
}
portrait.registeredData = {}
portrait.registeredDataByID = {}
portrait.registeredDataByPart = {
	male = {},
	female = {}
}
portrait.registeredFaceDatas = {}
portrait.registeredByFaceRequirement = {}
portrait.skinColorsByNationality = {}
portrait.APPEARANCE_PARTS = {
	SKINCOLOR = 4,
	HAIRCUT = 3,
	GLASSES = 9,
	EYEBROWS = 2,
	SHIRT = 10,
	EYE = 6,
	FACE = 1,
	BEARD = 8,
	EYECOLOR = 7,
	HAIRCOLOR = 5
}
portrait.BOTH_GENDER_PARTS = {
	[portrait.APPEARANCE_PARTS.SKINCOLOR] = true,
	[portrait.APPEARANCE_PARTS.HAIRCOLOR] = true,
	[portrait.APPEARANCE_PARTS.EYECOLOR] = true
}
portrait.OPTIONAL_PARTS = {
	[portrait.APPEARANCE_PARTS.HAIRCUT] = 95,
	[portrait.APPEARANCE_PARTS.BEARD] = 40,
	[portrait.APPEARANCE_PARTS.GLASSES] = 30
}
portrait.OPTIONAL_PARTS_FEMALE = {
	[portrait.APPEARANCE_PARTS.BEARD] = 0,
	[portrait.APPEARANCE_PARTS.GLASSES] = 30
}
portrait.EVENTS = {
	APPEARANCE_CHANGED = events:new()
}
portrait.developer = nil
portrait.face = nil
portrait.nose = nil
portrait.haircut = nil
portrait.skinColor = nil
portrait.hairColor = nil
portrait.eyeColor = nil
portrait.faceScale = 4
portrait.leftEyeOffset = {
	11,
	16
}
portrait.leftEyeOffsetUncolored = {
	10,
	17
}
portrait.eyebrowOffset = {
	8,
	12
}
portrait.noseOffset = {
	12,
	9
}
portrait.hairOffset = {
	0,
	-3
}
portrait.shirtOffset = {
	-10,
	34
}
portrait.beardOffset = {
	8,
	20
}
portrait.glassesOffset = {
	1,
	14
}
portrait.UNCOLORED_COLOR = color(255, 255, 255, 255)
portrait.spritebatch = spriteBatchController:newSpriteBatch("portraitSpritebatch", "textures/spritesheets/portrait.png", 8, "static", 5, false, true, false, true)

function portrait.new()
	local new = {}
	
	setmetatable(new, portrait.mtindex)
	new:init()
	
	return new
end

portrait.NO_OFFSET = {
	0,
	0
}

function portrait.register(data)
	table.insert(portrait.registeredData, data)
	
	portrait.registeredDataByID[data.id] = data
	
	local part = data.part
	
	if part then
		if portrait.BOTH_GENDER_PARTS[part] then
			local list = portrait.registeredDataByPart.male
			
			if not list[part] then
				list[part] = {}
			end
			
			table.insert(list[part], data)
			
			list = portrait.registeredDataByPart.female
			
			if not list[part] then
				list[part] = {}
			end
			
			table.insert(list[part], data)
		else
			local list
			
			if data.female then
				list = portrait.registeredDataByPart.female
			else
				list = portrait.registeredDataByPart.male
			end
			
			if not list[part] then
				list[part] = {}
			end
			
			table.insert(list[part], data)
		end
	end
	
	if data.quad then
		data.quadObject = quadLoader:load(data.quad)
	end
	
	data.offset = data.offset or portrait.NO_OFFSET
	
	if data.part then
		if data.faceID and not portrait.registeredFaceDatas[data.faceID] then
			portrait.registeredFaceDatas[data.faceID] = {}
		end
		
		if data.part == portrait.APPEARANCE_PARTS.SKINCOLOR then
			data.eyeColors = {}
			data.hairColors = {}
		elseif data.part == portrait.APPEARANCE_PARTS.EYECOLOR then
			portrait.addColorDataToSkinData("eyeColors", data.skinColor, data.id, data.female)
		elseif data.part == portrait.APPEARANCE_PARTS.HAIRCOLOR then
			portrait.addColorDataToSkinData("hairColors", data.skinColor, data.id, data.female)
		end
		
		if data.faceID and data.part ~= portrait.APPEARANCE_PARTS.FACE then
			if not portrait.registeredFaceDatas[data.faceID][data.part] then
				portrait.registeredFaceDatas[data.faceID][data.part] = {}
			end
			
			table.insert(portrait.registeredFaceDatas[data.faceID][data.part], data)
		end
		
		if data.part == portrait.APPEARANCE_PARTS.SKINCOLOR then
			for key, nationality in ipairs(data.backgrounds) do
				if not portrait.skinColorsByNationality[nationality] then
					portrait.skinColorsByNationality[nationality] = {}
				end
				
				table.insert(portrait.skinColorsByNationality[nationality], data)
			end
		end
	end
end

function portrait.getPartData(partID)
	return portrait.registeredDataByID[partID]
end

function portrait.addColorDataToSkinData(listName, skinColor, eyeColorID, female)
	if skinColor then
		if type(skinColor) == "string" then
			local partData = portrait.registeredDataByID[skinColor]
			
			if not table.hasValue(partData[listName], eyeColorID) then
				table.insert(partData[listName], eyeColorID)
			end
		elseif type(skinColor) == "table" then
			for key, skinColorID in ipairs(skinColor) do
				local partData = portrait.registeredDataByID[skinColorID]
				
				if not table.hasValue(partData[listName], eyeColorID) then
					table.insert(partData[listName], eyeColorID)
				end
			end
		end
	else
		local parts = portrait.registeredDataByPart
		local sc = portrait.APPEARANCE_PARTS.SKINCOLOR
		
		for key, partData in ipairs(parts.male[sc]) do
			if not table.hasValue(partData[listName], eyeColorID) then
				table.insert(partData[listName], eyeColorID)
			end
		end
		
		for key, partData in ipairs(parts.female[sc]) do
			if not table.hasValue(partData[listName], eyeColorID) then
				table.insert(partData[listName], eyeColorID)
			end
		end
	end
end

function portrait.findPartDataIndex(partID, female)
	local parts = portrait.registeredDataByPart
	local type = portrait.registeredDataByID[partID].part
	local list = female and parts.female[type] or parts.male[type]
	
	for key, data in ipairs(list) do
		if data.id == partID then
			return data, key
		end
	end
end

require("game/developer/male_portraits")
require("game/developer/female_portraits")

function portrait:init()
	self.allocatedSpriteIDs = {}
end

local function firePortraitChangedEvent(object, value)
	events:fire(portrait.EVENTS.APPEARANCE_CHANGED, object, value)
end

util.setGetFunctions(portrait, "Face", "face", firePortraitChangedEvent, function(self, newValue)
	if newValue == 0 then
		self:setFace(nil)
	end
end)
util.setGetFunctions(portrait, "Eye", "eye", firePortraitChangedEvent)
util.setGetFunctions(portrait, "Beard", "beard", firePortraitChangedEvent)
util.setGetFunctions(portrait, "Glasses", "glasses", firePortraitChangedEvent)
util.setGetFunctions(portrait, "Eyebrows", "eyebrows", firePortraitChangedEvent)
util.setGetFunctions(portrait, "Haircut", "haircut", firePortraitChangedEvent)
util.setGetFunctions(portrait, "SkinColor", "skinColor", firePortraitChangedEvent)
util.setGetFunctions(portrait, "HairColor", "hairColor", firePortraitChangedEvent)
util.setGetFunctions(portrait, "EyeColor", "eyeColor", firePortraitChangedEvent)
util.setGetFunctions(portrait, "Shirt", "shirt", firePortraitChangedEvent)
util.setGetFunctions(portrait, "Developer", "developer")

function portrait:setupSpritebatch(spriteBatch, isGUI, baseX, baseY, scale, listOfSprites, depthOffset)
	spriteBatch = spriteBatch or portrait.spritebatch
	scale = scale or portrait.faceScale
	
	if not isGUI then
		spriteBatch:resetContainer()
	else
		spriteBatch:clearSpritebatches()
	end
	
	listOfSprites = listOfSprites or self.allocatedSpriteIDs
	
	local spriteID = 1
	
	listOfSprites[spriteID] = self:setPartSprite(listOfSprites[spriteID], self.shirt, portrait.shirtOffset, nil, scale, spriteBatch, isGUI, baseX, baseY, depthOffset)
	spriteID = spriteID + 1
	listOfSprites[spriteID] = self:setPartSprite(listOfSprites[spriteID], self.face, nil, self.skinColor, scale, spriteBatch, isGUI, baseX, baseY, depthOffset)
	spriteID = self:setupEyeSprites(spriteBatch, isGUI, baseX, baseY, scale, listOfSprites, depthOffset, spriteID)
	
	if self.beard then
		spriteID = spriteID + 1
		listOfSprites[spriteID] = self:setPartSprite(listOfSprites[spriteID], self.beard, portrait.beardOffset, self.hairColor, scale, spriteBatch, isGUI, baseX, baseY, depthOffset)
	end
	
	spriteID = self:setupEyeSprites(spriteBatch, isGUI, baseX, baseY, scale, listOfSprites, depthOffset, spriteID)
	spriteID = spriteID + 1
	listOfSprites[spriteID] = self:setPartSprite(listOfSprites[spriteID], self.eyebrows, portrait.eyebrowOffset, self.hairColor, scale, spriteBatch, isGUI, baseX, baseY, depthOffset)
	
	if self.haircut then
		spriteID = spriteID + 1
		listOfSprites[spriteID] = self:setPartSprite(listOfSprites[spriteID], self.haircut, portrait.hairOffset, self.hairColor, scale, spriteBatch, isGUI, baseX, baseY, depthOffset)
	end
	
	if self.glasses then
		spriteID = spriteID + 1
		listOfSprites[spriteID] = self:setPartSprite(listOfSprites[spriteID], self.glasses, portrait.glassesOffset, nil, scale, spriteBatch, isGUI, baseX, baseY, depthOffset)
	end
	
	return listOfSprites
end

function portrait:draw(x, y, rot, scaleX, scaleY, drawColor)
	local r, g, b, a = 255, 255, 255, 255
	
	if drawColor then
		r, g, b, a = drawColor:unpack()
	end
	
	love.graphics.setColor(r, g, b, a)
	portrait.spritebatch:updateSprites()
	love.graphics.draw(portrait.spritebatch:getSpritebatch(), x, y, rot, scaleX, scaleY)
end

function portrait:setupEyeSprites(spriteBatch, isGUI, baseX, baseY, scale, listOfSprites, depthOffset, spriteID)
	local eyeData = portrait.registeredDataByID[self.eye]
	
	spriteID = spriteID + 1
	
	if eyeData.outerOffset then
		portrait.leftEyeOffsetUncolored[1] = portrait.leftEyeOffsetUncolored[1] + eyeData.outerOffset[1]
		portrait.leftEyeOffsetUncolored[2] = portrait.leftEyeOffsetUncolored[2] + eyeData.outerOffset[2]
	end
	
	listOfSprites[spriteID] = self:setPartSprite(listOfSprites[spriteID], self.eye, portrait.leftEyeOffsetUncolored, portrait.UNCOLORED_COLOR, scale, spriteBatch, isGUI, baseX, baseY, depthOffset, nil, eyeData.quadOuter)
	
	if eyeData.outerOffset then
		portrait.leftEyeOffsetUncolored[1] = portrait.leftEyeOffsetUncolored[1] - eyeData.outerOffset[1]
		portrait.leftEyeOffsetUncolored[2] = portrait.leftEyeOffsetUncolored[2] - eyeData.outerOffset[2]
	end
	
	spriteID = spriteID + 1
	listOfSprites[spriteID] = self:setPartSprite(listOfSprites[spriteID], self.eye, portrait.leftEyeOffset, self.eyeColor, scale, spriteBatch, isGUI, baseX, baseY, depthOffset, nil)
	
	return spriteID
end

function portrait:setPartSprite(spriteID, partID, offset, partColor, scale, spriteBatch, isGUI, baseX, baseY, depthOffset, sizeScale, quad)
	offset = offset or portrait.NO_OFFSET
	scale = scale or portrait.faceScale
	scale = _S(scale)
	sizeScale = sizeScale or scale
	
	if type(partColor) == "string" then
		partColor = portrait.registeredDataByID[partColor].color
	end
	
	local partData = portrait.registeredDataByID[partID]
	
	baseX = baseX and math.floor(baseX) or 0
	baseY = baseY and math.floor(baseY) or 0
	
	local partOffset = partData and partData.offset or portrait.NO_OFFSET
	local x, y = (partOffset[1] + offset[1]) * scale + baseX, (partOffset[2] + offset[2]) * scale + baseY
	
	x = math.round(x)
	y = math.round(y)
	
	if isGUI then
		return self:_setGUIPartSprite(spriteID, quad or partData.quad, partColor, spriteBatch, x, y, sizeScale, depthOffset)
	else
		if type(quad) == "string" then
			quad = quadLoader:getQuad(quad)
		else
			quad = quad or partData.quadObject
		end
		
		return self:_setPartSprite(spriteID, quad, partColor, spriteBatch, x, y, scale)
	end
end

function portrait:_setGUIPartSprite(spriteID, quad, partColor, spriteBatch, x, y, sizeScale, depthOffset)
	local r, g, b, a = 255, 255, 255, 255
	
	if partColor then
		r, g, b, a = partColor:unpack()
	end
	
	local quadData = quadLoader:getQuadStructure(quad)
	local sizeX, sizeY = quadData.w, quadData.h
	
	sizeX = _US(sizeX * sizeScale)
	sizeY = _US(sizeY * sizeScale)
	depthOffset = depthOffset or 0.5
	
	spriteBatch:setNextSpriteColor(r, g, b, a)
	
	return spriteBatch:allocateSprite(spriteID, quad, -x, y, 0, -sizeX, sizeY, nil, nil, depthOffset)
end

function portrait:_setPartSprite(spriteID, quad, partColor, spriteBatch, x, y, scale)
	local r, g, b, a = 255, 255, 255, 255
	
	if partColor then
		r, g, b, a = partColor:unpack()
	end
	
	spriteBatch:setColor(r, g, b, a)
	
	return spriteBatch:setSprite(spriteID, quad, -x, y, 0, -scale, scale)
end

function portrait:getPartQuad(partID)
	return portrait.registeredDataByID[partID].quad
end

function portrait:isValidForFace(partData)
	if partData.faceRequirement then
		if partData.faceRequirement[self.face] then
			return true
		end
		
		return false
	end
	
	local faceID = partData.faceID
	
	if partData.part ~= portrait.APPEARANCE_PARTS.FACE and faceID and faceID ~= portrait.registeredDataByID[self.face].faceID then
		return false
	end
	
	return true
end

local validResults = {}

function portrait:rollRandomAppearance(typeID, female)
	local chance = (female and portrait.OPTIONAL_PARTS_FEMALE or portrait.OPTIONAL_PARTS)[typeID]
	
	if chance and chance <= math.random(1, 100) then
		return nil
	end
	
	local list
	
	if female then
		list = portrait.registeredDataByPart.female[typeID]
	else
		list = portrait.registeredDataByPart.male[typeID]
	end
	
	for key, data in ipairs(list) do
		if self:isValidForFace(data) then
			validResults[#validResults + 1] = data
		end
	end
	
	if #validResults == 0 then
		return nil
	end
	
	local randomResult = validResults[math.random(1, #validResults)]
	
	table.clearArray(validResults)
	
	return randomResult.id
end

function portrait:rollColorAppearance(skinColorID, listName)
	local data = portrait.registeredDataByID[skinColorID]
	local list = data[listName]
	
	return list[math.random(1, #list)]
end

local validSkinColors = {}

function portrait:createRandomAppearance(background, female)
	local randomSkin
	
	if background then
		local list = portrait.skinColorsByNationality[background]
		
		randomSkin = list[math.random(1, #list)].id
	else
		local list = portrait.registeredDataByPart.male[portrait.APPEARANCE_PARTS.SKINCOLOR]
		
		randomSkin = list[math.random(1, #list)].id
	end
	
	table.clearArray(validSkinColors)
	self:setSkinColor(randomSkin)
	self:setHairColor(self:rollColorAppearance(self.skinColor, "hairColors"))
	self:setEyeColor(self:rollColorAppearance(self.skinColor, "eyeColors"))
	
	if not female then
		local beard = self:rollRandomAppearance(portrait.APPEARANCE_PARTS.BEARD, female)
		
		if beard then
			self:setBeard(beard)
		end
	end
	
	self:setShirt(self:rollRandomAppearance(portrait.APPEARANCE_PARTS.SHIRT, female))
	self:setFace(self:rollRandomAppearance(portrait.APPEARANCE_PARTS.FACE, female))
	self:setEyebrows(self:rollRandomAppearance(portrait.APPEARANCE_PARTS.EYEBROWS, female))
	self:setHaircut(self:rollRandomAppearance(portrait.APPEARANCE_PARTS.HAIRCUT, female))
	self:setEye(self:rollRandomAppearance(portrait.APPEARANCE_PARTS.EYE, female))
	self:setGlasses(self:rollRandomAppearance(portrait.APPEARANCE_PARTS.GLASSES, female))
end

function portrait:save()
	return {
		face = self.face,
		haircut = self.haircut,
		skinColor = self.skinColor,
		hairColor = self.hairColor,
		eyeColor = self.eyeColor,
		eye = self.eye,
		eyebrows = self.eyebrows,
		beard = self.beard,
		glasses = self.glasses,
		shirt = self.shirt
	}
end

function portrait:load(data)
	self.face = data.face
	self.nose = data.nose
	self.haircut = data.haircut
	self.skinColor = data.skinColor
	self.hairColor = data.hairColor
	self.eyeColor = data.eyeColor
	self.eye = data.eye
	self.eyebrows = data.eyebrows
	self.beard = data.beard
	self.glasses = data.glasses
	self.shirt = data.shirt
	
	if not self.face then
		self:createRandomAppearance()
	end
end
