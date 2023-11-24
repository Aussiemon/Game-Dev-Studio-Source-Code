camera = {}
camera.x = 0
camera.y = 0
camera.mouseX = 0
camera.mouseY = 0
camera.scaleX = 1
camera.scaleY = 1
camera.midX = 0
camera.midY = 0
camera.rotation = 0
camera.xMin = 0
camera.xMax = 0
camera.yMin = 0
camera.yMax = 0
camera.panX = 0
camera.panY = 0
camera.height = 500
camera.xVel = 0
camera.yVel = 0
camera.velocityLife = 0
camera.blockedInput = 0
camera.velocityFade = 5
camera.positionLerpSpeed = 10
camera.minimumApproachAmount = 5
camera.targetX = 0
camera.targetY = 0
camera.maxMovementSpeed = 1000
camera.smoothMovement = true
camera.useIntertia = true
camera.touchSamples = {}
camera.maxTouchSamples = 4
camera.realMaxTouchSamples = camera.maxTouchSamples * 2
camera.cameraApproachActions = {}
camera.EVENTS = {
	APPROACH_FINISHED = "camera_approach_finished"
}

function camera:canMove()
	return true
end

function camera:getPanDistance()
	return self.x - self.touchWorldX, self.y - self.touchWorldY
end

function camera:getPanMagnitude()
	return math.magnitude(math.abs(self.x - self.touchWorldX), math.abs(self.y - self.touchWorldX))
end

function camera:getTraveledDistance()
	return self.panX, self.panY
end

function camera:getTraveledMagnitude()
	return math.magnitude(self.panX, self.panY)
end

function camera:set(xMult, yMult, scaleX, scaleY, xOff, yOff)
	xMult, yMult = xMult or 1, yMult or 1
	
	local xOff = xOff or 0
	local xOff, yOff = xOff, yOff or 0
	local x, y = math.round(self.x + xOff), math.round(self.y + yOff)
	
	love.graphics.push()
	love.graphics.rotate(-self.rotation)
	love.graphics.scale(scaleX or self.scaleX, scaleY or self.scaleY)
	love.graphics.translate(-x * xMult, -y * yMult)
end

function camera:unset()
	love.graphics.pop()
end

function camera:move(dx, dy)
	dx = dx or 0
	dy = dy or 0
	
	if self.smoothMovement then
		self.targetX = self.targetX + dx
		self.targetY = self.targetY + dy
	else
		self.x = self.x + dx
		self.y = self.y + dy
	end
end

function camera:addCameraApproach(action)
	table.insert(self.cameraApproachActions, action)
	
	self.touchX, self.touchY = nil
end

function camera:update(dt)
	local actions = self.cameraApproachActions
	
	if #actions > 0 then
		local realIndex = 1
		
		for i = 1, #actions do
			local obj = actions[realIndex]
			
			if obj:update(dt) then
				table.remove(actions, realIndex)
			else
				realIndex = realIndex + 1
			end
		end
		
		return 
	end
	
	self.mouseX, self.mouseY = love.mouse.getX(), love.mouse.getY()
	self.absMouseX, self.absMouseY = self.mouseX / self.scaleX + self.targetX, self.mouseY / self.scaleY + self.targetY
	
	if self.smoothMovement then
		local approachRateVel = frameTime * self.velocityFade
		
		self.targetX = self.targetX + self.xVel * self.velocityLife
		self.targetY = self.targetY + self.yVel * self.velocityLife
		self.velocityLife = math.approach(self.velocityLife, 0, math.clampedLerp(self.velocityLife, 0, approachRateVel, 1 * frameTime))
		self.targetX, self.targetY = self:clampToBoundaries(self.targetX, self.targetY)
		
		local minApproach = camera.minimumApproachAmount * frameTime
		local approachRate = frameTime * self.positionLerpSpeed
		local newX = math.clampedLerp(self.x, self.targetX, approachRate, minApproach)
		local newY = math.clampedLerp(self.y, self.targetY, approachRate, minApproach)
		local oldX, oldY = self.x, self.y
		
		self.x = math.approach(self.x, self.targetX, newX)
		self.y = math.approach(self.y, self.targetY, newY)
		self.midX = self.x + halfScrW / self.scaleX
		self.midY = self.y + halfScrH / self.scaleY
		
		if oldX ~= self.x or oldY ~= self.y then
			love.audio.setPosition(self.midX, self.midY, camera.height / math.max(camera.scaleX, camera.scaleY))
			
			camera.updatedCamera = true
		else
			camera.updatedCamera = false
		end
		
		local realX, realY = self.lastMouseX, self.lastMouseY
		
		self.lastMouseX = self.mouseX
		self.lastMouseY = self.mouseY
		
		if self.touchX then
			self.panX, self.panY = self.panX + math.abs(self.x - oldX), self.panY + math.abs(self.y - oldY)
			
			self:insertTouchSample(self.lastMouseX, self.lastMouseY)
		else
			self.panX, self.panY = 0, 0
		end
	elseif oldX ~= self.x or oldY ~= self.y then
		love.audio.setPosition(self.midX, self.midY, camera.height / math.max(camera.scaleX, camera.scaleY))
		
		camera.updatedCamera = true
	else
		camera.updatedCamera = false
	end
end

function camera:getLastMouseCoords()
	return self.lastMouseX, self.lastMouseY
end

function camera:insertTouchSample(x, y)
	table.insert(camera.touchSamples, 1, y)
	table.insert(camera.touchSamples, 1, x)
	
	local touchCount = #camera.touchSamples
	
	if touchCount > camera.realMaxTouchSamples then
		camera.touchSamples[touchCount] = nil
		camera.touchSamples[touchCount - 1] = nil
	end
end

function camera:getAverageMouseMovement()
	local curPos = 1
	local avgX, avgY = 0, 0
	
	for i = 1, camera.maxTouchSamples do
		local x = camera.touchSamples[curPos]
		local y = camera.touchSamples[curPos + 1]
		
		curPos = curPos + 2
		
		if x and y then
			avgX = avgX + x
			avgY = avgY + y
		else
			break
		end
	end
	
	return avgX / (#camera.touchSamples / 2), avgY / (#camera.touchSamples / 2)
end

function camera:rotate(dr)
	self.rotation = self.rotation + dr
end

function camera:scale(sx, sy)
	sx = sx or 1
	self.scaleX = self.scaleX * sx
	self.scaleY = self.scaleY * (sy or sx)
end

function camera:clampToBoundaries(x, y)
	return math.clamp(x, self.xMin, self.xMax), math.clamp(y, self.yMin, self.yMax)
end

function camera:setBlockTouches(state)
	self.blockedTouches = state
end

function camera:blockInputFor(time)
	self.blockedInput = curTime + time
end

function camera:isInputAvailable()
	return curTime > self.blockedInput and self:canMove()
end

function camera:setPosition(x, y, snap, center)
	if center then
		x = x - halfScrW / self.scaleX
		y = y - halfScrH / self.scaleY
	end
	
	if snap then
		self.targetX = x
		self.targetY = y
		self.x = x
		self.y = y
		self.midX = x + halfScrW / self.scaleX
		self.midY = y + halfScrH / self.scaleY
		
		love.audio.setPosition(self.midX, self.midY, camera.height)
		
		return 
	end
	
	local targetX, targetY
	
	targetX = x
	targetY = y
	targetX, targetY = self:clampToBoundaries(targetX, targetY)
	self.midX = self.x + halfScrW / self.scaleX
	self.midY = self.y + halfScrH / self.scaleY
	
	love.audio.setPosition(self.midX, self.midY, camera.height)
	
	camera.updatedCamera = true
	
	if self.smoothMovement then
		self.targetX = targetX
		self.targetY = targetY
	else
		self.x = targetX
		self.y = targetY
	end
end

function camera:scroll(dx, dy)
	local x, y
	
	if self.smoothMovement then
		x = self.targetX
		y = self.targetY
	else
		x = self.x
		y = self.y
	end
	
	self:setPosition(x + dx / camera.scaleX, y + dy / camera.scaleY)
end

function camera:setBounds(xMin, xMax, yMin, yMax)
	self.xMin = xMin
	self.xMax = xMax
	self.yMin = yMin
	self.yMax = yMax
	self.midX = self.x
	self.midY = self.y
end

function camera:removeTouch(x, y)
	if self.useIntertia and x and y then
		local lastX, lastY = self.touchSamples[1], self.touchSamples[2]
		
		if lastX then
			local avgX, avgY = self:getAverageMouseMovement()
			local deltaX, deltaY = (avgX - lastX) / self.scaleX, (avgY - lastY) / self.scaleY
			
			self.xVel = deltaX
			self.yVel = deltaY
			self.velocityLife = 1
		else
			self.velocityLife = 0
			self.xVel = 0
			self.yVel = 0
		end
	end
	
	self.touchX = nil
	self.touchY = nil
	
	table.clearArray(self.touchSamples)
end

function camera:setTouchPosition(x, y)
	if self.blockedTouches then
		return 
	end
	
	if #self.cameraApproachActions > 0 then
		return 
	end
	
	self.touchX = x
	self.touchY = y
	self.panX = 0
	self.panY = 0
	self.touchWorldX = self.x + x
	self.touchWorldY = self.y + y
	self.targetX = self.x
	self.targetY = self.y
	self.xVel = 0
	self.yVel = 0
	self.velocityLife = 0
end

function camera:resetVelocities()
	self.xVel = 0
	self.yVel = 0
end

function camera:getTouchPosition()
	return self.touchX, self.touchY
end

function camera:getPosition()
	return self.x, self.y
end

function camera:getMid()
	return self.midX, self.midY
end

camera.getCenter = camera.getMid

function camera:setScale(sx, sy)
	local oldW, oldH = halfScrW / self.scaleX, halfScrH / self.scaleY
	
	self.scaleX = sx or self.scaleX
	self.scaleY = sy or self.scaleY
	
	local newW, newH = halfScrW / self.scaleX, halfScrH / self.scaleY
	local deltaW, deltaH = newW - oldW, newH - oldH
	
	self:setPosition(self.x - deltaW, self.y - deltaH, true)
	self:onSetScale()
end

function camera:adjustScale(changeX, changeY)
	local oldW, oldH = halfScrW / self.scaleX, halfScrH / self.scaleY
	
	self.scaleX = self.scaleX + changeX
	self.scaleY = self.scaleY + changeY
	
	local newW, newH = halfScrW / self.scaleX, halfScrH / self.scaleY
	local deltaW, deltaH = newW - oldW, newH - oldH
	
	self:setPosition(self.x - deltaW, self.y - deltaH, true)
	self:onSetScale()
end

function camera:onSetScale()
end

function camera:convertToScreen(x, y)
	return (x - self.x) * self.scaleX, (y - self.y) * self.scaleY
end

function camera:getLocalMousePosition(x, y)
	local x2, y2 = self.x, self.y
	
	return (x - x2) * self.scaleY, (y - y2) * self.scaleY
end

function camera:mousePosition()
	return self.mouseX / self.scaleX + self.x, self.mouseY / self.scaleY + self.y
end

function camera:absoluteMousePosition(x, y)
	return self.mouseX / self.scaleX + self.targetX, self.mouseY / self.scaleY + self.targetY
end

function camera:isObjectInView(obj, widthMod, heightMod)
	widthMod = widthMod or 0
	heightMod = heightMod or 0
	
	return math.ccaabb(self.x - widthMod * 0.5, self.y - heightMod * 0.5, obj.x, obj.y, scrW + widthMod, scrH + heightMod, obj.width, obj.height)
end

function camera:updateMousePosition()
	self.mouseX, self.mouseY = self:mousePosition()
end

function camera:getViewRange()
	return self.x, self.y, self.x + scrW / self.scaleX, self.y + scrH / self.scaleY
end

function camera:getOffsetToCenterScale()
	if self.scaleX == 1 then
		return 0, 0
	end
	
	return scrW * 0.5 - scrW / self.scaleX * 0.5, scrH * 0.5 - scrH / self.scaleY * 0.5
end

require("engine/camera_approach_action")
