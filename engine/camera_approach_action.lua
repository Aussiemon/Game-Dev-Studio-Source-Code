cameraApproachAction = {}
cameraApproachAction.mtindex = {
	__index = cameraApproachAction
}

function cameraApproachAction.new()
	local new = {}
	
	setmetatable(new, cameraApproachAction.mtindex)
	new:init()
	
	return new
end

function cameraApproachAction:init()
	self.startX = camera.midX
	self.startY = camera.midY
	self.progress = 0
	self.approachRate = 1
end

function cameraApproachAction:setApproachRate(rate)
	self.approachRate = rate
end

function cameraApproachAction:setTargetPosition(x, y)
	self.targetX = x
	self.targetY = y
end

function cameraApproachAction:update(dt)
	self.progress = math.min(1, self.progress + self.approachRate * dt)
	
	local x, y = math.lerp(self.startX, self.targetX, self.progress), math.lerp(self.startY, self.targetY, self.progress)
	
	camera:setPosition(x, y, true, true)
	
	if self.progress >= 1 then
		events:fire(camera.EVENTS.APPROACH_FINISHED, self)
		
		return true
	end
	
	return false
end
