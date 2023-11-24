local mainMenuObject = {}

mainMenuObject.regularSprite = nil
mainMenuObject.hoverSprite = nil
mainMenuObject.regularOffset = {
	0,
	0
}
mainMenuObject.hoverOffset = {
	0,
	0
}
mainMenuObject.regularSize = {
	0,
	0
}
mainMenuObject.hoverSize = {
	0,
	0
}
mainMenuObject.hightlightSpeed = 2
mainMenuObject.hoverText = nil
mainMenuObject.CATCHABLE_EVENTS = {
	frameController.EVENTS.CLEARED_FRAMES,
	frameController.EVENTS.FRAME_PUSHED
}
mainMenuObject.onClickSound = nil

function mainMenuObject:init()
	self.highlightTime = 0
end

function mainMenuObject:handleEvent(event)
	if event == frameController.EVENTS.CLEARED_FRAMES then
		self:makeActive()
	else
		self:makeIdle()
	end
end

function mainMenuObject:onClick(x, y, key)
	if frameController:getFrameCount() == 0 and key == gui.mouseKeys.LEFT then
		gui.leaveCurrentHover()
		self:onClicked(key)
		
		if self.onClickSound then
			sound:play(self.onClickSound, nil, nil, nil)
		end
	end
end

function mainMenuObject:onClicked(key)
end

function mainMenuObject:getDrawData()
	local sprite, offset, size
	
	if self:isMouseOver() then
		return self.hoverSprite, self.hoverOffset, self.hoverSize
	else
		return self.regularSprite, self.regularOffset, self.regularSize
	end
end

function mainMenuObject:getDrawColor()
	return 255, 255, 255, 255
end

function mainMenuObject:updateSprites()
	local sprite, offset, size = self:getDrawData()
	
	self:setNextSpriteColor(self:getDrawColor())
	
	self.spriteID = self:allocateSprite(self.spriteID, sprite, _S(offset[1]), _S(offset[2]), 0, size[1], size[2], 0, 0, -0.5)
end

function mainMenuObject:makeIdle()
	self:setCanHover(false)
	
	self.idle = true
end

function mainMenuObject:makeActive()
	self:setCanHover(true)
	
	self.idle = false
end

function mainMenuObject:onMouseEntered()
	if frameController:getFrameCount() > 0 then
		return 
	end
	
	self:queueSpriteUpdate()
	
	if self.hoverText then
		self.descBox = gui.create("GenericDescbox")
		
		for key, data in ipairs(self.hoverText) do
			self.descBox:addText(data.text, data.font, data.color, data.lineSpace, data.wrapWidth, data.icon, data.iconWidth, data.iconHeight)
		end
		
		self.descBox:bringUp()
		self.descBox:centerToElement(self)
	end
end

function mainMenuObject:onMouseLeft()
	self:killDescBox()
	self:queueSpriteUpdate()
end

function mainMenuObject:draw(w, h)
	if not self.canHover then
		return 
	end
	
	if gui.elementHovered or self.idle then
		self.highlightTime = -math.pi * 0.25
		
		return 
	end
	
	self.highlightTime = self.highlightTime + frameTime * self.hightlightSpeed
	
	if self.highlightTime >= math.pi then
		self.highlightTime = self.highlightTime - math.pi * 2
	end
	
	local alpha = math.sin(math.max(0, self.highlightTime)) * 200
	
	if alpha > 0 then
		local sprite, offset, size = self.hoverSprite, self.hoverOffset, self.hoverSize
		local quadStruct = quadLoader:getQuadStructure(sprite)
		
		love.graphics.setColor(204, 182, 157, alpha)
		love.graphics.setBlendMode("add", "alphamultiply")
		
		local scaleX, scaleY = quadStruct.quad:getSpriteScale(_S(size[1]), _S(size[2]))
		
		love.graphics.draw(quadStruct.texture, quadStruct.quad, _S(offset[1]), _S(offset[2]), 0, scaleX, scaleY)
		love.graphics.setBlendMode("alpha", "alphamultiply")
	end
end

gui.register("MainMenuObject", mainMenuObject)
