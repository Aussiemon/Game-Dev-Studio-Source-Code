local invalidDisplay = {}

invalidDisplay.class = "invalidity_display"
invalidDisplay.quad = quadLoader:load("attention_red")
invalidDisplay.moveAmount = 4
invalidDisplay.scaleChange = 0.15

local quadW, quadH = invalidDisplay.quad:getSize()
local quartW, quartH = quadW * 0.25, quadH * 0.25

function invalidDisplay:init()
	invalidDisplay.baseClass.init(self)
	
	self.spritebatch = spriteBatchController:getContainer("world_ui")
end

function invalidDisplay:hide()
	self:deallocateSprite()
	game.removeDynamicObject(self)
end

function invalidDisplay:show()
	self:allocateSprite()
	game.addDynamicObject(self)
end

function invalidDisplay:setObject(object)
	self.object = object
end

function invalidDisplay:update()
	local x, y = self.object:getObjectMiddle()
	local expansion = studio.expansion
	local scale = 1 + invalidDisplay.scaleChange * expansion.invalidMove
	
	self.spritebatch:setColor(255, 255, 255, 200)
	self.spritebatch:updateSprite(self.spriteID, invalidDisplay.quad, x + quadW * 0.75 - quadW * 0.5 * scale, y + quadW * 0.75 + invalidDisplay.moveAmount * expansion.invalidMove - quadW * 0.5 * scale, 0, scale, scale)
end

function invalidDisplay:allocateSprite()
	if not self.spriteID then
		self.spriteID = self.spritebatch:allocateSlot()
		
		self.spritebatch:increaseVisibility()
	end
end

function invalidDisplay:deallocateSprite()
	if self.spriteID then
		self.spritebatch:deallocateSlot(self.spriteID)
		self.spritebatch:decreaseVisibility()
		
		self.spriteID = nil
	end
end

function invalidDisplay:remove()
	self:deallocateSprite()
	game.removeDynamicObject(self)
end

objects.registerNew(invalidDisplay)
