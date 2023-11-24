tdas = {}
tdas.DEFAULT_DEPTH = 5
tdas.ANIMATION_TYPES = {
	LOOP = 2,
	RANDOMFRAME = 4,
	PLAYONCE = 1
}
registered.animationFrames = {}
registered.animationImages = {}
registered.animEvents = {}
registered.animSpritebatches = {}

function register.newAnimation(name, frames, events, depth)
	local imageContainer = {}
	local frame = frames[1].frame
	local mainFrame = frame
	local animSpritebatches = {
		list = {},
		map = {}
	}
	
	registered.animSpritebatches[name] = animSpritebatches
	
	local halfOffset = frames.halfOriginOffset
	
	for k, v in ipairs(frames) do
		if not mainFrame and v.frame then
			mainFrame = v.frame
		end
		
		v.offset = v.offset or {
			0,
			0
		}
		v.frame = v.frame or frame
		v.spriteBatch = spriteBatchController:getContainer(v.frame)
		
		if not v.skip then
			if not animSpritebatches.map[v.frame] then
				table.insert(animSpritebatches.list, v.frame)
				
				animSpritebatches.map[v.frame] = true
			end
			
			if v.quad then
				local origOffX, origOffY = 0, 0
				
				if halfOffset then
					local struct = quadLoader:getQuadObjectStructure(v.quad)
					
					origOffX = struct.w * 0.5
					origOffY = struct.h * 0.5
					
					local originOffset = v.originOffset
					
					if originOffset then
						origOffX = origOffX + originOffset[1]
						origOffY = origOffY + originOffset[2]
					end
				end
				
				v.originOff = {
					origOffX,
					origOffY
				}
				
				local quadDataType = type(v.quad)
				
				if v.quad == true then
					local img = cache.getImage(v.frame)
					local width, height = img:getWidth(), img:getHeight()
					local newQuad = love.graphics.newQuad(0, 0, width, height, width, height)
					
					imageContainer[k] = newQuad
				elseif quadDataType == "table" then
					local img = cache.getImage(v.frame)
					local width, height = img:getWidth(), img:getHeight()
					local newQuad = love.graphics.newQuad(v.quad.x, v.quad.y, v.quad.w, v.quad.h, width, height)
					
					imageContainer[k] = newQuad
				elseif quadDataType == "userdata" then
					imageContainer[k] = v.quad
				end
			else
				imageContainer[k] = img
			end
		else
			skipPresent = true
		end
	end
	
	frames.mainFrame = mainFrame
	registered.animationFrames[name] = imageContainer
	registered.animationImages[name] = frames
	registered.animEvents[name] = events
end

tdas.registerNewAnimation = register.newAnimation
tdas.registerAnimationEvents = register.animationEvents

function register.animationEvents(name, events)
	registered.animEvents[name] = events
end

function tdas.getAnimData(name)
	return registered.animationFrames[name], registered.animEvents[name], registered.animationImages[name]
end

function tdas.createNewAnim(name, spriteID)
	local anim = {}
	local animation = registered.animationFrames[name]
	local event = registered.animEvents[name]
	local images = registered.animationImages[name]
	
	anim.name = name
	anim.frames = animation
	anim.events = event
	anim.images = images
	anim.halfOriginOffset = images.halfOriginOffset
	anim.speed = 1
	anim.progress = 0
	anim._frame = 0
	anim.alpha = 1
	anim.frameAmount = #animation
	anim.spriteBatch = images[1].frame
	anim.scaleX, anim.scaleY = 1, 1
	
	setmetatable(anim, {
		__index = tdas
	})
	
	anim.type = 0
	
	anim:setType(tdas.ANIMATION_TYPES.PLAYONCE)
	anim:setFrame(1)
	
	return anim
end

function tdas:remove()
	spriteBatchController:deallocateSlot(self.spriteBatch, self.spriteID)
end

function tdas:setType(t)
	if t == tdas.ANIMATION_TYPES.LOOP and bit.band(self.type, tdas.ANIMATION_TYPES.PLAYONCE) == tdas.ANIMATION_TYPES.PLAYONCE then
		self.type = self.type - tdas.ANIMATION_TYPES.PLAYONCE
	end
	
	if t == tdas.ANIMATION_TYPES.PLAYONCE and bit.band(self.type, tdas.ANIMATION_TYPES.LOOP) == tdas.ANIMATION_TYPES.LOOP then
		self.type = self.type - tdas.ANIMATION_TYPES.LOOP
	end
	
	if bit.band(self.type, t) ~= t then
		self.type = self.type + t
	end
	
	self.looping = bit.band(self.type, tdas.ANIMATION_TYPES.LOOP) == tdas.ANIMATION_TYPES.LOOP
	
	if self.looping then
		self:updateLoopAnimateMethod()
		
		if self.events then
			self.animateMethod = self._animateLoopingEvents
		else
			self.animateMethod = self._animateLooping
		end
	elseif self.events then
		self.animateMethod = self._animateEvents
	else
		self.animateMethod = self._animate
	end
	
	self.random = bit.band(self.type, tdas.ANIMATION_TYPES.RANDOMFRAME) == tdas.ANIMATION_TYPES.RANDOMFRAME
end

function tdas:updateLoopAnimateMethod()
	if self.reverse then
		self._animateMethod = self._animateLoopingReverse
	else
		self._animateMethod = self._animateLoopingRegular
	end
end

function tdas:getName()
	return self.name
end

function tdas:removeType(t)
	if bit.band(self.type, t) == t then
		self.type = self.type - t
	end
end

function tdas:hasType(t)
	return bit.band(self.type, t) == t
end

function tdas:setPlaybackSpeed(s)
	self.speed = s
end

tdas.setPlaybackRate = tdas.setPlaybackSpeed

function tdas:setCycle(c)
	self.progress = math.clamp(c, 0, 1)
end

function tdas:setOwner(owner)
	self.owner = owner
end

function tdas:getOwner()
	return self.owner
end

function tdas:getCycle()
	return self.progress
end

function tdas:freeze()
	self._speed = self.speed
	self.speed = 0
end

function tdas:unFreeze()
	if self._speed then
		self.speed = self._speed
		self._speed = nil
	else
		self.speed = 1
	end
end

function tdas:resetAnim()
	self.progress = 0
end

tdas.resetAnimation = tdas.resetAnim

function tdas:setReverse(r)
	self.reverse = r
	
	self:updateLoopAnimateMethod()
end

function tdas:setId(id)
	self.id = id
end

function tdas:_animateLoopingEvents(delta)
	self:_animateMethod(delta)
	self:_handleEvents()
end

function tdas:_animateLooping(delta)
	self:_animateMethod(delta)
end

function tdas:_animateLoopingReverse(delta)
	self.progress = self.progress + self.speed * delta
	
	if self.progress >= 1 then
		self.progress = self.progress - math.floor(self.progress)
	end
end

function tdas:_animateLoopingRegular(delta)
	if self.progress <= 0 then
		self.progress = self.progress + self.speed * delta
		self.progress = math.clamp(1 + self.progress, 0, 1)
	else
		self.progress = math.clamp(self.progress - self.speed * delta, 0, 1)
	end
end

function tdas:_animateEvents(delta)
	self.progress = math.clamp(self.progress + self.speed * delta, 0, 1)
	
	self:_handleEvents()
end

function tdas:_animate(delta)
	self.progress = math.clamp(self.progress + self.speed * delta, 0, 1)
end

function tdas:_handleEvents()
	local f = math.ceil(self.frameAmount * self.progress)
	
	if f ~= self._frame then
		local ev = self.events[f]
		
		if ev then
			ev(self, self.owner)
			
			self.eventPlayed = true
		end
		
		self._frame = f
	end
end

function tdas:advanceAnim(delta)
	self:animateMethod(delta)
end

function tdas:isDone()
	return self.progress >= 1
end

function tdas:setFrame(frameID)
	self.lastFrameID = self.curFrameID
	self.curFrameID = frameID
	
	self:updateRenderData()
	
	self.progress = math.clamp(frameID / self.frameAmount, 0, 1)
end

function tdas:getQuadList()
	return self.images
end

function tdas:updateRenderData()
	local frameID = self.curFrameID
	
	self.curImage = self.images[frameID]
	self.skip = self.curImage.skip
	
	if self.spriteBatch and self.skip then
		self.spriteBatch:updateSprite(self.spriteID, 0, 0, 0, 0, 0, 0, 0)
	end
	
	self.curFrame = self.frames[frameID]
	self.spriteBatch = self.curImage.spriteBatch
	
	local offset = self.curImage.offset
	
	self.xOff, self.yOff = offset[1] * self.scaleX, offset[2] * self.scaleY
	
	local originOff = self.curImage.originOff
	
	if originOff then
		self.origOffX, self.origOffY = originOff[1], originOff[2]
	else
		self.origOffX, self.origOffY = 0, 0
	end
end

function tdas:pickFrame()
	local frameID = math.ceil(self.frameAmount * self.progress)
	
	if self.random then
		if self.lastFrameID ~= frameID then
			self.curFrameID = math.random(1, #self.images)
			
			self:updateRenderData()
		end
		
		self.lastFrameID = frameID
	else
		local lastFrame = self.curFrameID
		
		if lastFrame ~= frameID then
			self.curFrameID = math.max(frameID, 1)
			
			self:updateRenderData()
		end
	end
end

function tdas:getCurFrameID()
	return self.curFrameID
end

function tdas:setSpriteID(id)
	self.spriteID = id
end

function tdas:clearSprite()
	spriteBatchController:clearSprite(self.spriteBatch, self.spriteID)
end

function tdas:getSpriteBatch()
	return self.spriteBatch
end

function tdas:removeSprite()
	if self.spriteID then
		spriteBatchController:clearSprite(self.spriteBatch, self.spriteID)
		
		self.spriteID = nil
	end
end

function tdas:setColor(clr)
	self.color = clr
end

function tdas:setAlpha(alpha)
	self.alpha = alpha
end

function tdas:getQuad()
	return self.frames[self.curFrameID]
end

function tdas:setScale(x, y)
	self.scaleX, self.scaleY = sx, sy
end

function tdas:setOriginOffset(ox, oy)
	self.origOffX, self.origOffY = ox, oy
end

function tdas:drawAnimation(x, y, r)
	if self.skip then
		return 
	end
	
	ox, oy = self.origOffX, self.origOffY
	x = x + self.xOff
	y = y + self.yOff
	
	local clr = self.color
	local sb = self.spriteBatch
	
	if clr then
		sb:setColor(clr.r, clr.g, clr.b, clr.a * self.alpha)
	end
	
	sb:updateSprite(self.spriteID, self.curFrame, math.round(x), math.round(y), r, 1, 1, ox, oy)
end

function tdas:markAsActive()
	self.spriteBatch:markAsActive()
end

function tdas:rawDraw(x, y, r)
	local image = self.curImage
	local quad = self.curFrame
	local texture = image.spriteBatch:getTexture()
	
	ox, oy = self.origOffX, self.origOffY
	x = x + self.xOff
	y = y + self.yOff
	
	love.graphics.draw(texture, quad, math.round(x), math.round(y), r, 1, 1, ox, oy)
end
