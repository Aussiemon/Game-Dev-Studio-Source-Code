avatar = {}
avatar.mtindex = {
	__index = avatar
}
avatar.baseClass = entity
avatar.ANIM_INTERACT = "interact"
avatar.ANIM_SHIT = "shit"
avatar.ANIM_STAND = "stand"
avatar.ANIM_WORK = "work"
avatar.ANIM_WALK = "walk"
avatar.ANIM_SIT_IDLE = "sit_idle"
avatar.ANIM_DRINK = "drink"
avatar.ANIM_EAT = "eat"
avatar.ANIM_DRINK_COFFEE = "drink_coffee"
avatar.ANIM_WALK_CARRY = "walk_carry"
avatar.WORLD_UI_CONTAINER = spriteBatchController:getContainer("world_ui")
avatar.NO_TASK_QUAD = quadLoader:getQuad("no_task")
avatar.LEVEL_UP_QUAD = quadLoader:getQuad("level_up")
avatar.ICON_SPACING = 4
avatar.TEXT_FONT = fonts.get("pix_world20")
avatar.TEXT_FONT_HEIGHT = avatar.TEXT_FONT:getHeight()
avatar.LAYER_COLLECTIONS = {}
avatar.LAYER_COLLECTIONS_BY_ID = {}

setmetatable(avatar, entity.mtindex)

function avatar.new()
	local new = {}
	
	setmetatable(new, avatar.mtindex)
	new:init()
	
	return new
end

avatar.STOCK_LAYER_COLOR_ORDER = {
	"skinColor",
	"hairColor",
	"torsoColor",
	"skinColor",
	"legColor",
	"shoeColor"
}
avatar.SECTION_IDS = {
	HEAD = 2,
	HANDS = 4,
	SHOES = 6,
	LEGS = 5,
	TORSO = 3,
	HAIR = 1
}
avatar.LAYER_ABSENCE_CHECK = {
	hairColor = "haircut"
}

function avatar.registerLayerCollection(collection)
	collection.spritebatchIDs = {}
	collection.clearings = {}
	collection.layerMap = {}
	
	local curID = collection.id
	
	table.insert(avatar.LAYER_COLLECTIONS, collection)
	
	avatar.LAYER_COLLECTIONS_BY_ID[collection.id] = collection
	
	for key, animID in ipairs(collection.layers) do
		collection.layerMap[animID] = true
		
		local spritebatches = registered.animSpritebatches[animID]
		
		for key, id in ipairs(spritebatches.list) do
			if not table.find(collection.spritebatchIDs, id) then
				table.insert(collection.spritebatchIDs, id)
			end
		end
	end
	
	for i, coll in ipairs(avatar.LAYER_COLLECTIONS) do
		local firstSBs = coll.spritebatchIDs
		local firstID = coll.id
		
		for j, otherColl in ipairs(avatar.LAYER_COLLECTIONS) do
			if coll ~= otherColl then
				local secondID = otherColl.id
				local secondSBs = otherColl.spritebatchIDs
				
				for key, sbID in ipairs(firstSBs) do
					if not table.find(secondSBs, sbID) then
						if not otherColl.clearings[firstID] then
							otherColl.clearings[firstID] = {}
						end
						
						if not coll.clearings[secondID] then
							coll.clearings[secondID] = {}
						end
						
						if not table.find(otherColl.clearings[firstID], sbID) then
							table.insert(otherColl.clearings[firstID], sbID)
							table.insert(coll.clearings[secondID], sbID)
						end
					end
				end
			end
		end
	end
	
	if not collection.colorMap then
		collection.colorMap = avatar.STOCK_LAYER_COLOR_ORDER
	end
end

avatar.hairColor = color(255, 163, 127, 255)
avatar.skinColor = color(255, 183, 165, 255)
avatar.torsoColor = color(255, 244, 245, 255)
avatar.legColor = color(170, 217, 255, 255)
avatar.shoeColor = color(255, 137, 161, 255)

function avatar:init()
	avatar.baseClass.init(self)
	
	self.animations = {}
	self.animObjListBank = {}
	self.animObjList = {}
	self.animsBySection = {}
	self.statusIcons = {}
	self.alpha = 1
	
	self:setDrawOffset(0, 0)
	
	self.spriteIDs = {}
	self.animQueue = {}
end

function avatar:setSkinColor(color)
	self.skinColor = color
end

function avatar:setHairColor(color)
	self.hairColor = color
end

function avatar:setTorsoColor(color)
	self.torsoColor = color
end

function avatar:setLegColor(color)
	self.legColor = color
end

function avatar:setShoeColor(color)
	self.shoeColor = color
end

function avatar:addAnimToQueue(anim, speed)
	speed = speed or 1
	
	local prevSize = #self.animQueue
	
	table.insert(self.animQueue, {
		anim,
		speed
	})
	
	if #self.animQueue == 1 then
		for key, animObj in ipairs(self.animObjList) do
			animObj:setCycle(1)
		end
	end
end

function avatar:stopAnimation()
end

function avatar:applyQueueAnim()
	local animData = self.animQueue[1]
	
	table.remove(self.animQueue, 1)
	self:setAnimation(animData[1], animData[2], tdas.ANIMATION_TYPES.PLAYONCE)
	
	self.animQueueObj = self.mainAnimObj
end

function avatar:isAnimQueueEmpty()
	return #self.animQueue == 0 and (not self.animQueueObj or self.animQueueObj:isDone())
end

function avatar:onAnimQueueOver()
	self.animQueueObj = nil
	
	self.owner:onAnimQueueOver()
end

function avatar:remove()
	avatar.baseClass.remove(self)
	self:leaveVisibilityRange()
	table.clearArray(self.animQueue)
	
	self.animQueueObj = nil
	
	self:clearAllSprites()
	
	for key, animObj in ipairs(self.animations) do
		animObj:remove()
		
		self.animations[key] = nil
	end
	
	self.removed = true
	self.animQueue = nil
	self.spriteIDs = nil
	self.animations = nil
	self.curAnims = nil
	self.statusIcons = nil
end

function avatar:updateAnimation()
	self:setAnimation(self.owner:getStandAnimation())
end

function avatar:randomizeAnimationProgress()
	local progress = math.randomf(0, 1)
	
	for key, animObj in ipairs(self.animObjList) do
		animObj:setCycle(progress)
	end
end

function avatar:getCurAnim()
	return self.animationName
end

function avatar:canSetAnimation()
	local employer = self.owner:getEmployer()
	
	if employer and employer:isPlayer() then
		return true
	end
	
	return false
end

function avatar:canHaveLayer(layerName)
	return not layerName or layerName and self.owner.portrait[layerName]
end

function avatar:setAnimation(anim, speed, animType)
	if not self:canSetAnimation() then
		return 
	end
	
	if anim == self.animationName then
		return self.curAnims, self.animations
	end
	
	self.animQueueObj = nil
	
	local oldAnim = self.animationName
	
	self.animationName = anim
	speed = speed or 1
	animType = animType or tdas.ANIMATION_TYPES.LOOP
	
	local layerCol = avatar.LAYER_COLLECTIONS_BY_ID[anim]
	
	if oldAnim then
		local clearings = layerCol.clearings[oldAnim]
		
		if clearings and #clearings > 0 then
			self:clearPreviousAnimSprites(clearings)
		end
	end
	
	self.curAnims = layerCol.layers
	self.mainAnim = self.curAnims[1]
	
	local colorMap = layerCol.colorMap
	local absenseCheck = avatar.LAYER_ABSENCE_CHECK
	local bank, newBank = self.animObjListBank[anim]
	
	if not bank then
		newBank = {}
		self.animObjListBank[anim] = newBank
	end
	
	self.animObjList = self.animObjListBank[anim]
	
	for key, animID in ipairs(self.curAnims) do
		local animObj
		local colorVarName = colorMap[key]
		
		if self:canHaveLayer(absenseCheck[colorVarName]) then
			local animObj = self:initAnimation(animID, colorVarName, animType, speed)
			
			if newBank then
				newBank[#newBank + 1] = animObj
			end
		end
		
		local bank = self.animObjListBank
		
		if not bank then
			local newList = {}
			
			self.animObjListBank[anim] = newList
		else
			self.animObjList = self.animObjListBank[anim]
		end
	end
	
	self.animCount = #self.animObjList
	self.mainAnimObj = self.animObjList[1]
	
	return self.curAnims, self.animations
end

function avatar:clearPreviousAnimSprites(clearList)
	local spriteIDs = self.spriteIDs
	
	for key, sbID in ipairs(clearList) do
		local id = spriteIDs[sbID]
		
		if id then
			spriteIDs[sbID] = nil
			
			spriteBatchController:deallocateSlot(sbID, id)
			spriteBatchController:getContainer(sbID):decreaseVisibility()
		end
	end
end

function avatar:initAnimation(id, colorVarName, animType, speed)
	local animObj
	
	if not self.animations[id] then
		animObj = tdas.createNewAnim(id)
		self.animations[id] = animObj
		
		animObj:setOwner(self.owner)
	else
		animObj = self.animations[id]
		
		animObj:resetAnimation()
	end
	
	local sectID = animObj.images.sectionID
	
	if sectID then
		self.animsBySection[sectID] = animObj
	end
	
	if colorVarName then
		animObj:setColor(self[colorVarName])
	end
	
	if self.visible then
		local animData = registered.animationImages[id]
		local atlasName = animData.mainFrame
		local spriteIDs = self.spriteIDs
		
		if atlasName then
			if not spriteIDs[atlasName] then
				local id = spriteBatchController:allocateSlot(atlasName)
				
				spriteBatchController:getContainer(atlasName):increaseVisibility()
				
				spriteIDs[atlasName] = id
				
				animObj:setSpriteID(id)
			else
				animObj:setSpriteID(spriteIDs[atlasName])
				spriteBatchController:getContainer(atlasName):increaseVisibility()
			end
		end
	end
	
	animObj:setType(animType)
	animObj:setPlaybackSpeed(speed)
	animObj:setAlpha(self.alpha)
	
	return animObj
end

function avatar:setAnimSpeed(speed)
	for key, animObj in ipairs(self.animObjList) do
		animObj:setPlaybackSpeed(speed)
	end
end

function avatar:setOwner(dev)
	self.owner = dev
	self.halfW, self.halfH = dev.width * 0.5, dev.height * 0.5
end

function avatar:isAnimationOver(animList)
	return self.animations[animList[1]]:isDone()
end

function avatar:update(dt)
	local animQueue = #self.animQueue
	
	if animQueue > 0 and self.mainAnimObj:isDone() then
		self:applyQueueAnim()
		
		animQueue = animQueue - 1
	end
	
	self.mainAnimObj:advanceAnim(dt)
	
	if self.animQueueObj and animQueue == 0 and self.animQueueObj:isDone() then
		self:onAnimQueueOver()
	end
end

function avatar:setDrawOffset(x, y)
	self.drawOffX = x + 24
	self.drawOffY = y + 24
end

function avatar:getDrawPosition()
	return self.owner.x + self.drawOffX - 24, self.owner.y + self.drawOffY - 24
end

avatar.getCenterDrawPosition = avatar.getDrawPosition

function avatar:getRealDrawPosition(x, y)
	local w, h = self.owner.width * 0.5, self.owner.height * 0.5
	local drawW, drawH = x + w * 0.5, y + h * 0.5
	
	x = x + self.drawOffX
	y = y + self.drawOffY
	
	return x, y
end

function avatar:onSetTask(taskObject)
	if taskObject then
		self:removeStatusIcon("no_task")
	else
		self:addStatusIcon("no_task")
	end
end

function avatar:addStatusIcon(statusID)
	if self:getStatusIcon(statusID) then
		return 
	end
	
	local data = statusIcons.registeredByID[statusID]
	local icon = data.quad
	local w, h = icon:getSize()
	local struct = self:initStatusIcon()
	
	struct:setData(statusID)
	
	self.statusIconsActive = true
	
	table.insert(self.statusIcons, struct)
end

local statusIconDataMethods = {}

statusIconDataMethods.mtindex = {
	__index = statusIconDataMethods
}

function statusIconDataMethods:init()
	self.x, self.y = 0, 0
end

function statusIconDataMethods:setData(id)
	self.id = id
	self.data = statusIcons.registeredByID[id]
	self.quad = self.data.quad
	self.slot = avatar.WORLD_UI_CONTAINER:allocateSlot()
	
	avatar.WORLD_UI_CONTAINER:increaseVisibility()
	
	self.quadW, self.quadH = self.quad:getSize()
end

function statusIconDataMethods:onMouseLeft()
	self.data:onMouseLeft(self)
end

function statusIconDataMethods:handleClick(x, y, key)
	self.data:handleClick(x, y, key)
end

function statusIconDataMethods:onMouseEntered(employee)
	self.data:onMouseEntered(self, employee)
end

function statusIconDataMethods:drawMouseOver()
	self.data:drawMouseOver(self)
end

function avatar:initStatusIcon()
	local statusIcon = {}
	
	setmetatable(statusIcon, statusIconDataMethods.mtindex)
	statusIcon:init()
	
	return statusIcon
end

function avatar:getStatusIcon(statusID)
	for key, data in ipairs(self.statusIcons) do
		if data.id == statusID then
			return data
		end
	end
end

function avatar:removeStatusIcon(statusID)
	for key, data in ipairs(self.statusIcons) do
		if data.id == statusID then
			avatar.WORLD_UI_CONTAINER:deallocateSlot(data.slot)
			avatar.WORLD_UI_CONTAINER:decreaseVisibility()
			table.remove(self.statusIcons, key)
			
			return data
		end
	end
	
	self.statusIconsActive = #self.statusIcons > 0
end

function avatar:hideStatusIcons()
	for key, data in ipairs(self.statusIcons) do
		avatar.WORLD_UI_CONTAINER:updateSprite(data.slot, 0, 0, 0, 0, 0)
	end
end

function avatar:clearStatusIcons()
	for key, data in ipairs(self.statusIcons) do
		avatar.WORLD_UI_CONTAINER:deallocateSlot(data.slot)
		avatar.WORLD_UI_CONTAINER:decreaseVisibility()
		
		self.statusIcons[key] = nil
	end
	
	self.statusIconsActive = false
end

function avatar:enterVisibilityRange()
	self.visible = true
	
	self:showProps()
	
	if not self.animationName then
		self:setAnimation(self.owner:getStandAnimation())
	end
	
	for key, animObj in ipairs(self.animObjList) do
		local animData = animObj:getQuadList()
		local atlasName = animData.mainFrame
		
		if not self.spriteIDs[atlasName] then
			local sb = animObj:getSpriteBatch()
			local id = sb:allocateSlot()
			
			sb:increaseVisibility()
			
			self.spriteIDs[atlasName] = id
			
			animObj:setSpriteID(id)
		end
	end
end

function avatar:leaveVisibilityRange()
	self.visible = false
	
	self:clearPropSprites()
	
	if self.curAnims then
		self:_clearAnimSprites()
	end
	
	self:hideStatusIcons()
end

function avatar:clearAllSprites()
	if self.curAnims then
		self:_clearAnimSprites()
	end
	
	self:clearStatusIcons()
end

function avatar:_clearAnimSprites()
	for key, animObj in ipairs(self.animObjList) do
		local atlasName = animObj:getQuadList().mainFrame
		local id = self.spriteIDs[atlasName]
		
		if id then
			self.spriteIDs[atlasName] = nil
			
			local sb = animObj:getSpriteBatch()
			
			sb:deallocateSlot(id)
			sb:decreaseVisibility()
		end
	end
	
	self.lastX, self.lastY, self.lastRot, self.lastFrame = nil
end

function avatar:isMouseOverStatusIcon(mouseX, mouseY)
	for key, data in ipairs(self.statusIcons) do
		if mouseX > data.x and mouseX < data.x + data.quadW and mouseY > data.y and mouseY < data.y + data.quadH then
			if not data.text then
				data.text = data.data:setupText(self.owner)
				data.textWidth = avatar.TEXT_FONT:getWidth(data.text)
				data.textHeight = avatar.TEXT_FONT:getTextHeight(data.text)
			end
			
			return data, self.owner
		else
			data.text = nil
		end
	end
	
	return false
end

function avatar:advanceAnimations(x, y, rot)
	local firstObj = self.mainAnimObj
	
	firstObj:pickFrame()
	
	local frameID = firstObj:getCurFrameID()
	
	if x ~= self.lastX or y ~= self.lastY or rot ~= self.lastRot or frameID ~= self.lastFrame then
		self.frameUpdate = true
		
		firstObj:drawAnimation(x, y, rot)
		
		local animObjs = self.animObjList
		
		for i = 2, self.animCount do
			local animObj = animObjs[i]
			
			animObj:setFrame(frameID)
			animObj:drawAnimation(x, y, rot)
		end
		
		self.lastX, self.lastY, self.lastRot, self.lastFrame = x, y, rot, frameID
	end
end

function avatar:setAlpha(a)
	self.alpha = a
	
	for key, animObj in ipairs(self.animObjList) do
		animObj:setAlpha(a)
	end
end

function avatar:getDrawPos(x, y)
	local owner = self.owner
	
	x = x + self.drawOffX
	y = y + self.drawOffY
	
	return x, y, owner.angleRotationRad
end

function avatar:draw(x, y)
	local owner = self.owner
	local x, y, rot = x + self.drawOffX, y + self.drawOffY, owner.angleRotationRad
	
	self:advanceAnimations(x, y, rot)
	
	if self.frameUpdate then
		self.frameUpdate = false
		
		if self.statusIconsActive then
			local drawX, drawY = x + 17, y - 6
			local space = avatar.ICON_SPACING
			local uiContainer = avatar.WORLD_UI_CONTAINER
			local icons = self.statusIcons
			
			for key, iconData in ipairs(icons) do
				iconData.x = drawX
				iconData.y = drawY
				
				uiContainer:updateSprite(iconData.slot, iconData.quad, drawX, drawY)
				
				drawY = drawY + space + iconData.quadH
			end
		end
		
		local carryData = owner.carryObjectData
		
		if carryData then
			local offX, offY = carryObjects:attemptPickOffset(carryData, owner.carryOffsets, self.mainAnimObj, self.animationName)
			
			if offX then
				self:drawProp(carryData.id, x, y, rot, 1, 1, offX, offY)
			else
				self:makePropInvis(carryData.id)
			end
		end
	end
end

function avatar:getAnimBySection(id)
	return self.animsBySection[id]
end

function avatar:rawDrawSection(id, x, y)
	local animObj = self.animsBySection[id]
	
	if animObj then
		local x, y, rot = self:getDrawPos(x, y)
		
		animObj:rawDraw(x, y, rot)
	end
end

function avatar:rawDraw(x, y)
	local x, y, rot = self:getDrawPos(x, y)
	
	for key, animObj in ipairs(self.animObjList) do
		animObj:rawDraw(x, y, rot)
	end
end

function avatar:postDraw(x, y)
end

require("game/developer/status_icons")

local function playFootstep(animObj, animObjOwner)
	animObjOwner:playFootstep()
end

local walkAnimEvents = {
	[2] = playFootstep,
	[7] = playFootstep
}
local hairAnim = avatar.ANIM_WALK .. "_hair"
local hairOffset = {
	0,
	-1
}

register.newAnimation(hairAnim, {
	sectionID = avatar.SECTION_IDS.HAIR,
	{
		frame = "worker_hair",
		quad = quadLoader:load("employee_walk_hair_1"),
		originOffset = hairOffset
	},
	{
		quad = quadLoader:load("employee_walk_hair_2"),
		originOffset = hairOffset
	},
	{
		quad = quadLoader:load("employee_walk_hair_3"),
		originOffset = hairOffset
	},
	{
		quad = quadLoader:load("employee_walk_hair_4"),
		originOffset = hairOffset
	},
	{
		quad = quadLoader:load("employee_walk_hair_5"),
		originOffset = hairOffset
	},
	{
		quad = quadLoader:load("employee_walk_hair_6"),
		originOffset = hairOffset
	},
	{
		quad = quadLoader:load("employee_walk_hair_7"),
		originOffset = hairOffset
	},
	{
		quad = quadLoader:load("employee_walk_hair_8"),
		originOffset = hairOffset
	},
	{
		quad = quadLoader:load("employee_walk_hair_9"),
		originOffset = hairOffset
	},
	{
		quad = quadLoader:load("employee_walk_hair_10"),
		originOffset = hairOffset
	},
	halfOriginOffset = true
})

local headAnim = avatar.ANIM_WALK .. "_head"

register.newAnimation(headAnim, {
	sectionID = avatar.SECTION_IDS.HEAD,
	{
		frame = "worker_head",
		quad = quadLoader:load("employee_walk_head_1")
	},
	{
		quad = quadLoader:load("employee_walk_head_2")
	},
	{
		quad = quadLoader:load("employee_walk_head_3")
	},
	{
		quad = quadLoader:load("employee_walk_head_4")
	},
	{
		quad = quadLoader:load("employee_walk_head_5")
	},
	{
		quad = quadLoader:load("employee_walk_head_6")
	},
	{
		quad = quadLoader:load("employee_walk_head_7")
	},
	{
		quad = quadLoader:load("employee_walk_head_8")
	},
	{
		quad = quadLoader:load("employee_walk_head_9")
	},
	{
		quad = quadLoader:load("employee_walk_head_10")
	},
	halfOriginOffset = true
})

local torsoAnim = avatar.ANIM_WALK .. "_torso"

register.newAnimation(torsoAnim, {
	sectionID = avatar.SECTION_IDS.TORSO,
	{
		frame = "worker_torso",
		quad = quadLoader:load("employee_walk_torso_1")
	},
	{
		quad = quadLoader:load("employee_walk_torso_2")
	},
	{
		quad = quadLoader:load("employee_walk_torso_3")
	},
	{
		quad = quadLoader:load("employee_walk_torso_4")
	},
	{
		quad = quadLoader:load("employee_walk_torso_5")
	},
	{
		quad = quadLoader:load("employee_walk_torso_6")
	},
	{
		quad = quadLoader:load("employee_walk_torso_7")
	},
	{
		quad = quadLoader:load("employee_walk_torso_8")
	},
	{
		quad = quadLoader:load("employee_walk_torso_9")
	},
	{
		quad = quadLoader:load("employee_walk_torso_10")
	},
	halfOriginOffset = true
})

local legsAnim = avatar.ANIM_WALK .. "_legs"

register.newAnimation(legsAnim, {
	sectionID = avatar.SECTION_IDS.LEGS,
	{
		frame = "worker_legs",
		quad = quadLoader:load("employee_walk_legs_1")
	},
	{
		quad = quadLoader:load("employee_walk_legs_2")
	},
	{
		quad = quadLoader:load("employee_walk_legs_3")
	},
	{
		quad = quadLoader:load("employee_walk_legs_4")
	},
	{
		quad = quadLoader:load("employee_walk_legs_5")
	},
	{
		quad = quadLoader:load("employee_walk_legs_6")
	},
	{
		quad = quadLoader:load("employee_walk_legs_7")
	},
	{
		quad = quadLoader:load("employee_walk_legs_8")
	},
	{
		quad = quadLoader:load("employee_walk_legs_9")
	},
	{
		quad = quadLoader:load("employee_walk_legs_10")
	},
	halfOriginOffset = true
}, walkAnimEvents)

local shoesAnim = avatar.ANIM_WALK .. "_shoes"

register.newAnimation(shoesAnim, {
	sectionID = avatar.SECTION_IDS.SHOES,
	{
		frame = "worker_shoes",
		quad = quadLoader:load("employee_walk_shoes_1")
	},
	{
		quad = quadLoader:load("employee_walk_shoes_2")
	},
	{
		quad = quadLoader:load("employee_walk_shoes_3")
	},
	{
		quad = quadLoader:load("employee_walk_shoes_4")
	},
	{
		quad = quadLoader:load("employee_walk_shoes_5")
	},
	{
		quad = quadLoader:load("employee_walk_shoes_6")
	},
	{
		quad = quadLoader:load("employee_walk_shoes_7")
	},
	{
		quad = quadLoader:load("employee_walk_shoes_8")
	},
	{
		quad = quadLoader:load("employee_walk_shoes_9")
	},
	{
		quad = quadLoader:load("employee_walk_shoes_10")
	},
	halfOriginOffset = true
})

local handsAnim = avatar.ANIM_WALK .. "_hands"
local handOffset = {
	0,
	5
}

register.newAnimation(handsAnim, {
	sectionID = avatar.SECTION_IDS.HANDS,
	{
		frame = "worker_hands",
		quad = quadLoader:load("employee_walk_hands_1"),
		originOffset = handOffset
	},
	{
		quad = quadLoader:load("employee_walk_hands_2"),
		originOffset = handOffset
	},
	{
		quad = quadLoader:load("employee_walk_hands_3"),
		originOffset = handOffset
	},
	{
		quad = quadLoader:load("employee_walk_hands_4"),
		originOffset = handOffset
	},
	{
		quad = quadLoader:load("employee_walk_hands_5"),
		originOffset = handOffset
	},
	{
		quad = quadLoader:load("employee_walk_hands_6"),
		originOffset = handOffset
	},
	{
		quad = quadLoader:load("employee_walk_hands_7"),
		originOffset = handOffset
	},
	{
		quad = quadLoader:load("employee_walk_hands_8"),
		originOffset = handOffset
	},
	{
		quad = quadLoader:load("employee_walk_hands_9"),
		originOffset = handOffset
	},
	{
		quad = quadLoader:load("employee_walk_hands_10"),
		originOffset = handOffset
	},
	halfOriginOffset = true
})
avatar.registerLayerCollection({
	id = avatar.ANIM_WALK,
	layers = {
		legsAnim,
		hairAnim,
		headAnim,
		torsoAnim,
		handsAnim,
		shoesAnim
	},
	colorMap = {
		"legColor",
		"hairColor",
		"skinColor",
		"torsoColor",
		"skinColor",
		"shoeColor"
	}
})

local hairAnim = avatar.ANIM_STAND .. "_hair"

register.newAnimation(hairAnim, {
	sectionID = avatar.SECTION_IDS.HAIR,
	{
		frame = "worker_hair",
		quad = quadLoader:load("employee_walk_hair_5"),
		originOffset = hairOffset
	},
	halfOriginOffset = true
})

local headAnim = avatar.ANIM_STAND .. "_head"

register.newAnimation(headAnim, {
	sectionID = avatar.SECTION_IDS.HEAD,
	{
		frame = "worker_head",
		quad = quadLoader:load("employee_walk_head_5")
	},
	halfOriginOffset = true
})

local torsoAnim = avatar.ANIM_STAND .. "_torso"

register.newAnimation(torsoAnim, {
	sectionID = avatar.SECTION_IDS.TORSO,
	{
		frame = "worker_torso",
		quad = quadLoader:load("employee_walk_torso_5")
	},
	halfOriginOffset = true
})

local legsAnim = avatar.ANIM_STAND .. "_legs"

register.newAnimation(legsAnim, {
	sectionID = avatar.SECTION_IDS.LEGS,
	{
		frame = "worker_legs",
		quad = quadLoader:load("employee_walk_legs_5")
	},
	halfOriginOffset = true
})

local shoesAnim = avatar.ANIM_STAND .. "_shoes"

register.newAnimation(shoesAnim, {
	sectionID = avatar.SECTION_IDS.SHOES,
	{
		frame = "worker_shoes",
		quad = quadLoader:load("employee_walk_shoes_5")
	},
	halfOriginOffset = true
})

local handsAnim = avatar.ANIM_STAND .. "_hands"
local handOffset = {
	0,
	5
}

register.newAnimation(handsAnim, {
	sectionID = avatar.SECTION_IDS.HANDS,
	{
		frame = "worker_hands",
		quad = quadLoader:load("employee_walk_hands_5"),
		originOffset = handOffset
	},
	halfOriginOffset = true
})
avatar.registerLayerCollection({
	id = avatar.ANIM_STAND,
	layers = {
		headAnim,
		hairAnim,
		torsoAnim,
		handsAnim,
		legsAnim,
		shoesAnim
	}
})

local hairAnim = avatar.ANIM_WORK .. "_hair"
local hairConfig = {
	frame = "worker_hair",
	quad = quadLoader:load("employee_sit_hair"),
	originOffset = {
		0,
		-9
	}
}

register.newAnimation(hairAnim, {
	sectionID = avatar.SECTION_IDS.HAIR,
	hairConfig,
	hairConfig,
	hairConfig,
	hairConfig,
	hairConfig,
	hairConfig,
	hairConfig,
	hairConfig,
	hairConfig,
	hairConfig,
	hairConfig,
	hairConfig,
	halfOriginOffset = true
})

local headAnim = avatar.ANIM_WORK .. "_head"
local headConfig = {
	frame = "worker_head",
	quad = quadLoader:load("employee_sit_head"),
	originOffset = {
		0,
		-8
	}
}

register.newAnimation(headAnim, {
	sectionID = avatar.SECTION_IDS.HEAD,
	headConfig,
	headConfig,
	headConfig,
	headConfig,
	headConfig,
	headConfig,
	headConfig,
	headConfig,
	headConfig,
	headConfig,
	headConfig,
	headConfig,
	halfOriginOffset = true
})

local torsoAnim = avatar.ANIM_WORK .. "_torso"
local torsoConfig1 = {
	frame = "worker_torso",
	quad = quadLoader:load("employee_work_torso_1")
}
local torsoConfig2 = {
	frame = "worker_torso",
	quad = quadLoader:load("employee_work_torso_2")
}
local torsoConfig3 = {
	frame = "worker_torso",
	quad = quadLoader:load("employee_work_torso_3")
}
local torsoConfig4 = {
	frame = "worker_torso",
	quad = quadLoader:load("employee_work_torso_4")
}

register.newAnimation(torsoAnim, {
	sectionID = avatar.SECTION_IDS.TORSO,
	torsoConfig1,
	torsoConfig1,
	torsoConfig1,
	torsoConfig2,
	torsoConfig2,
	torsoConfig2,
	torsoConfig3,
	torsoConfig3,
	torsoConfig3,
	torsoConfig4,
	torsoConfig4,
	torsoConfig4,
	halfOriginOffset = true
})

local legsAnim = avatar.ANIM_WORK .. "_legs"
local legsConfig = {
	frame = "worker_legs",
	quad = quadLoader:load("employee_sit_legs")
}

register.newAnimation(legsAnim, {
	sectionID = avatar.SECTION_IDS.LEGS,
	legsConfig,
	legsConfig,
	legsConfig,
	legsConfig,
	legsConfig,
	legsConfig,
	legsConfig,
	legsConfig,
	legsConfig,
	legsConfig,
	legsConfig,
	legsConfig,
	halfOriginOffset = true
})

local shoesAnim = avatar.ANIM_WORK .. "_shoes"
local shoesConfig = {
	frame = "worker_shoes",
	quad = quadLoader:load("employee_sit_shoes")
}

register.newAnimation(shoesAnim, {
	sectionID = avatar.SECTION_IDS.SHOES,
	shoesConfig,
	shoesConfig,
	shoesConfig,
	shoesConfig,
	shoesConfig,
	shoesConfig,
	shoesConfig,
	shoesConfig,
	shoesConfig,
	shoesConfig,
	shoesConfig,
	shoesConfig,
	halfOriginOffset = true
})

local handsAnim = avatar.ANIM_WORK .. "_hands"
local handOffset = {
	0,
	16
}

register.newAnimation(handsAnim, {
	sectionID = avatar.SECTION_IDS.HANDS,
	{
		frame = "worker_hands",
		quad = quadLoader:load("employee_work_hands_1"),
		originOffset = handOffset
	},
	{
		quad = quadLoader:load("employee_work_hands_2"),
		originOffset = handOffset
	},
	{
		quad = quadLoader:load("employee_work_hands_3"),
		originOffset = handOffset
	},
	{
		quad = quadLoader:load("employee_work_hands_4"),
		originOffset = handOffset
	},
	{
		quad = quadLoader:load("employee_work_hands_5"),
		originOffset = handOffset
	},
	{
		quad = quadLoader:load("employee_work_hands_6"),
		originOffset = handOffset
	},
	{
		quad = quadLoader:load("employee_work_hands_7"),
		originOffset = handOffset
	},
	{
		quad = quadLoader:load("employee_work_hands_8"),
		originOffset = handOffset
	},
	{
		quad = quadLoader:load("employee_work_hands_9"),
		originOffset = handOffset
	},
	{
		quad = quadLoader:load("employee_work_hands_10"),
		originOffset = handOffset
	},
	{
		quad = quadLoader:load("employee_work_hands_11"),
		originOffset = handOffset
	},
	{
		quad = quadLoader:load("employee_work_hands_12"),
		originOffset = handOffset
	},
	halfOriginOffset = true
})

local frames = tdas.getAnimData(handsAnim)

local function playKeyboard(animObj, animObjOwner)
	animObjOwner:playKeyboardClicks()
end

local workAnimEvents = {}

for i = 1, #frames do
	workAnimEvents[i] = playKeyboard
end

register.animationEvents(handsAnim, workAnimEvents)
avatar.registerLayerCollection({
	id = avatar.ANIM_WORK,
	layers = {
		handsAnim,
		hairAnim,
		headAnim,
		torsoAnim,
		legsAnim,
		shoesAnim
	},
	colorMap = {
		"skinColor",
		"hairColor",
		"skinColor",
		"torsoColor",
		"legColor",
		"shoeColor"
	}
})

local hairAnim = avatar.ANIM_SIT_IDLE .. "_hair"

register.newAnimation(hairAnim, {
	sectionID = avatar.SECTION_IDS.HAIR,
	{
		frame = "worker_hair",
		quad = quadLoader:load("employee_sit_hair"),
		originOffset = {
			0,
			-12
		}
	},
	halfOriginOffset = true
})

local headAnim = avatar.ANIM_SIT_IDLE .. "_head"

register.newAnimation(headAnim, {
	sectionID = avatar.SECTION_IDS.HEAD,
	{
		frame = "worker_head",
		quad = quadLoader:load("employee_sit_head"),
		originOffset = {
			0,
			-11
		}
	},
	halfOriginOffset = true
})

local torsoAnim = avatar.ANIM_SIT_IDLE .. "_torso"

register.newAnimation(torsoAnim, {
	sectionID = avatar.SECTION_IDS.TORSO,
	{
		frame = "worker_torso",
		quad = quadLoader:load("employee_sit_torso"),
		originOffset = {
			0,
			-6
		}
	},
	halfOriginOffset = true
})

local legsAnim = avatar.ANIM_SIT_IDLE .. "_legs"

register.newAnimation(legsAnim, {
	sectionID = avatar.SECTION_IDS.LEGS,
	{
		frame = "worker_legs",
		quad = quadLoader:load("employee_sit_legs"),
		originOffset = {
			0,
			0
		}
	},
	halfOriginOffset = true
})

local shoesAnim = avatar.ANIM_SIT_IDLE .. "_shoes"

register.newAnimation(shoesAnim, {
	sectionID = avatar.SECTION_IDS.SHOES,
	{
		frame = "worker_shoes",
		quad = quadLoader:load("employee_sit_shoes"),
		originOffset = {
			0,
			0
		}
	},
	halfOriginOffset = true
})

local handsAnim = avatar.ANIM_SIT_IDLE .. "_hands"
local handOffset = {
	0,
	4
}

register.newAnimation(handsAnim, {
	sectionID = avatar.SECTION_IDS.HANDS,
	{
		frame = "worker_hands",
		quad = quadLoader:load("employee_sit_hands"),
		originOffset = handOffset
	},
	halfOriginOffset = true
})
avatar.registerLayerCollection({
	id = avatar.ANIM_SIT_IDLE,
	layers = {
		headAnim,
		hairAnim,
		torsoAnim,
		handsAnim,
		legsAnim,
		shoesAnim
	}
})
require("game/developer/avatar_anim_use")
require("game/developer/avatar_anim_drink")
require("game/developer/avatar_anim_eat")
require("game/developer/avatar_anim_toilet")
require("game/developer/avatar_anim_walk_carry")
require("game/developer/avatar_anim_sit_drink")
require("game/developer/avatar_anim_f")
