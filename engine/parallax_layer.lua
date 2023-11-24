parallaxLayer = {}
parallaxLayer.mtindex = {
	__index = parallaxLayer
}

local mCeil, mFloor = math.ceil, math.floor
local gDraw = love.graphics.draw

function parallaxLayer.new(layer)
	if not layer then
		return nil
	end
	
	local newLayer = {}
	
	setmetatable(newLayer, layer.mtindex)
	newLayer:initialize()
	
	if newLayer.initFunc then
		newLayer:initFunc()
	end
	
	return newLayer
end

function parallaxLayer:initialize()
	self:calculateVisibleAmount()
	self:setupQuad()
end

function parallaxLayer:setupQuad()
	self.quad = love.graphics.newQuad(0, 0, self.drawAmountW * self.renderW, self.drawAmountH * self.renderH, self.w, self.h)
end

function parallaxLayer:calculateVisibleAmount()
	self.drawAmountW = mCeil(scrW / self.w / self.scaleX) + 1
	
	if self.vert_Single then
		self.drawAmountH = 1
	else
		self.drawAmountH = mCeil(scrH / self.h / self.scaleY) + 1
	end
end

function parallaxLayer:setSpriteBatch(container, spriteID)
	self.spriteBatchContainer = container
	self.spriteBatch = container.spritebatch
	self.spriteID = spriteID
end

function parallaxLayer:freeSpriteSlot()
	parallax:deallocateSlot(self.spriteBatchContainer.textureName, self.spriteID)
end

function parallaxLayer:process()
	if self.logicFunc then
		self:logicFunc()
	end
	
	local camMidX = camera.midX
	local camMidY = camera.midY
	local baseX = mFloor(camMidX * self.scrollSpeedX / self.renderW) * self.renderW
	local baseY
	
	baseY = self.vert_DontAdaptToPlayer and 0 or mFloor(camMidY * self.scrollSpeedY / self.renderH) * self.renderH
	
	local x = math.ceil(baseX - halfScrW + camMidX * -self.scrollSpeedX + self.baseOffsetX)
	local y = math.ceil(baseY - halfScrH + camMidY * -self.scrollSpeedY + self.baseOffsetY)
	
	self.spriteBatch:set(self.spriteID, self.quad, x, y, 0, self.scaleX, self.scaleY)
end
