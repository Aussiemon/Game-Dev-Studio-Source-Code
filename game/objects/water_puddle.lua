local waterPuddle = {}

waterPuddle.class = "water_puddle"
waterPuddle.objectAtlas = "water_puddles"
waterPuddle.quad = quadLoader:load("water_puddle")
waterPuddle.scaleX = 2
waterPuddle.scaleY = 2
waterPuddle.SKIP_MAP_EDITOR = true
waterPuddle.quads = {
	quadLoader:load("water_puddle"),
	quadLoader:load("water_puddle_2"),
	quadLoader:load("water_puddle_3")
}
waterPuddle.INCREASE_PER_SECOND = 0.05
waterPuddle.DECREASE_PER_SECOND = 0.01

function waterPuddle:init()
	waterPuddle.baseClass.init(self)
	weather:addPuddle(self)
	
	self.hp = 0
	self.stamp = timeline.curTime
	self.prevAlpha = 0
	self.alpha = 0
	self.angles = math.random(0, 360)
	
	self:setQuadID(math.random(1, #self.quads))
end

function waterPuddle:setQuadID(id)
	self.quadID = id
	self.quadObject = self.quads[id]
end

function waterPuddle:getTextureQuad()
	return self.quads[self.quadID]
end

function waterPuddle:getDrawAngles(rotation)
	return self.angles
end

function waterPuddle:enterVisibilityRange()
	waterPuddle.baseClass.enterVisibilityRange(self)
	game.addDynamicObject(self)
	self:updateState(weather:isActive())
	self:updateAlpha()
	
	self.stamp = timeline.curTime
end

function waterPuddle:leaveVisibilityRange()
	waterPuddle.baseClass.leaveVisibilityRange(self)
	game.removeDynamicObject(self)
end

function waterPuddle:update(delta, progress)
	if weather:isActive() then
		self.hp = math.min(1, self.hp + progress * waterPuddle.INCREASE_PER_SECOND)
	else
		self.hp = math.max(0, self.hp - progress * waterPuddle.DECREASE_PER_SECOND)
		
		if self.hp == 0 then
			self:remove()
		end
	end
	
	self:updateAlpha()
end

function waterPuddle:updateAlpha()
	self.prevAlpha = self.alpha
	self.alpha = math.floor(self.hp * 255)
	
	if self.alpha ~= self.prevAlpha then
		self:updateSprite()
	end
end

function waterPuddle:getDrawColor()
	return 255, 255, 255, self.alpha
end

function waterPuddle:updateState(weatherActive)
	local diff = timeline.curTime - self.stamp
	
	if weatherActive then
		self.hp = math.min(1, self.hp + diff * waterPuddle.INCREASE_PER_SECOND)
	else
		self.hp = math.max(0, self.hp - diff * waterPuddle.DECREASE_PER_SECOND)
		
		if self.hp == 0 then
			self:remove()
		end
	end
end

function waterPuddle:remove()
	waterPuddle.baseClass.remove(self)
	weather:removePuddle(self)
end

function waterPuddle:save()
	local saved = waterPuddle.baseClass.save(self)
	
	saved.hp = self.hp
	saved.stamp = timeline.curTime
	saved.angles = self.angles
	saved.quadID = self.quadID
	
	return saved
end

function waterPuddle:load(data)
	waterPuddle.baseClass.load(self, data)
	
	self.hp = data.hp
	self.stamp = data.stamp
	self.angles = data.angles
	
	self:setQuadID(data.quadID)
	self:updateAlpha()
end

objects.registerNew(waterPuddle, "quadtree_decor_object_base")
