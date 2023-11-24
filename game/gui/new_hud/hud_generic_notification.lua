local notif = {}

notif.moveSpeed = 2
notif.canHover = false

function notif:init()
	self.scale = 0
end

function notif:think()
	if self.scale >= math.tau then
		self.scale = self.scale - math.tau
	end
	
	self.scale = self.scale + frameTime * self.moveSpeed
	
	self:queueSpriteUpdate()
end

function notif:updateSprites()
	local extra = math.max(0, math.cos(self.scale) * 0.1)
	local sizeMul = 0.6 + extra
	local size = 44 * sizeMul
	local halfSize = size * 0.5
	
	self.sprite = self:allocateSprite(self.sprite, "hud_new_important", -halfSize, -halfSize, 0, size, size, 0, 0, -0.3)
end

gui.register("HUDGenericNotification", notif)
