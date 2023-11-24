camera.defaultZoomLevel = 5
camera.viewFloor = 0
camera.zoomLevel = camera.defaultZoomLevel
camera.zoomLevels = {
	0.2,
	0.4,
	0.6,
	0.8,
	1,
	2,
	4
}
camera.maxZoomDimensions = {
	3840,
	2160
}
camera.EVENTS = {
	FLOOR_VIEW_CHANGED = events:new()
}

function camera:save()
	return {
		x = self.midX,
		y = self.midY,
		viewFloor = self.viewFloor
	}
end

function camera:load(data)
	self:setPosition(data.x - halfScrW, data.y - halfScrH, true)
	self:setViewFloor(data.viewFloor or 1)
end

function camera:reset()
	self.viewFloor = 0
	
	self:setZoomLevel(self.defaultZoomLevel)
end

function camera:setViewFloor(floor)
	if self.viewFloor == floor then
		return 
	end
	
	self.viewFloor = floor
	
	game.worldObject:onFloorViewChanged()
	events:fire(camera.EVENTS.FLOOR_VIEW_CHANGED)
end

function camera:changeFloor(direction)
	local floors = studio:getViewableFloors()
	local nextLevel = math.max(1, math.min(floors, self.viewFloor + direction))
	
	if nextLevel ~= self.viewFloor then
		if direction > 0 then
			sound:play("floor_up")
		else
			sound:play("floor_down")
		end
		
		self:setViewFloor(nextLevel)
		
		return true
	end
	
	return false
end

function camera:getViewFloor()
	return self.viewFloor
end

function camera:onSetScale()
	shadowShader:sendZoomScale(self.scaleX, self.scaleY)
	lightingManager:createImageData()
	lightingManager:forceUpdate()
	game.updateCameraBounds()
	weather:onZoomLevelChanged()
	sound.manager:setGlobalVolumeModifier(math.min(1, self.scaleX * self.scaleX))
end

function camera:adjustScale()
	local curScale = self.zoomLevels[self.zoomLevel]
	
	if scrW / curScale < self.maxZoomDimensions[1] and scrH / curScale < self.maxZoomDimensions[2] then
		return 
	end
	
	local level = self.defaultZoomLevel
	
	while true do
		local nextScale = self.zoomLevels[level]
		local w, h = scrW / nextScale, scrH / nextScale
		
		if w <= self.maxZoomDimensions[1] and h <= self.maxZoomDimensions[2] then
			break
		else
			level = level + 1
			
			if level == #self.zoomLevels then
				break
			end
		end
	end
	
	self:setZoomLevel(level)
end

function camera:setZoomLevel(level)
	self.zoomLevel = level
	
	local scaleValue = self.zoomLevels[level]
	
	self:setScale(scaleValue, scaleValue)
end

function camera:changeZoomLevel(direction)
	local nextLevel = math.max(1, math.min(#self.zoomLevels, self.zoomLevel + direction))
	
	if self.zoomLevel == nextLevel then
		return false
	end
	
	local scaleValue = self.zoomLevels[nextLevel]
	
	if scrW / scaleValue > camera.maxZoomDimensions[1] or scrH / scaleValue > camera.maxZoomDimensions[2] then
		return false
	end
	
	self.zoomLevel = nextLevel
	
	self:setScale(scaleValue, scaleValue)
	
	return true
end

function camera:getZoomLevel()
	return self.zoomLevel
end
