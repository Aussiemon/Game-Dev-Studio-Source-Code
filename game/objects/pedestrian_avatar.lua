pedestrianAvatar = {}
pedestrianAvatar.mtindex = {
	__index = pedestrianAvatar
}
pedestrianAvatar.SKIN_COLORS = {
	color(255, 163, 127, 255),
	color(255, 198, 178, 255),
	color(104, 78, 0, 255)
}

setmetatable(pedestrianAvatar, avatar.mtindex)

function pedestrianAvatar.new()
	local new = {}
	
	setmetatable(new, pedestrianAvatar.mtindex)
	new:init()
	new:pickRandomClothingColors()
	
	return new
end

function pedestrianAvatar:pickRandomClothingColors()
	self:setTorsoColor(developer.pickRandomClothingColor(developer.CLOTHING_TYPE.TORSO))
	self:setLegColor(developer.pickRandomClothingColor(developer.CLOTHING_TYPE.TROUSERS))
	self:setShoeColor(developer.pickRandomClothingColor(developer.CLOTHING_TYPE.SHOES))
	
	local skinColors = pedestrianAvatar.SKIN_COLORS
	
	self:setSkinColor(skinColors[math.random(1, #skinColors)])
end

function pedestrianAvatar:canHaveLayer(layerName)
	return true
end

function pedestrianAvatar:canSetAnimation()
	return true
end

function pedestrianAvatar:leaveVisibilityRange()
	self.visible = false
	
	if self.curAnims then
		self:_clearAnimSprites()
	end
end

function pedestrianAvatar:update(dt)
	for key, id in ipairs(self.curAnims) do
		self.animations[id]:advanceAnim(dt)
	end
end

function pedestrianAvatar:draw(x, y)
	x = x + self.drawOffX
	y = y + self.drawOffY
	
	local rot = math.rad(self.owner.angleRotation - 90)
	
	self:advanceAnimations(x, y, rot)
end
