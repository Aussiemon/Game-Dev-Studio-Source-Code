objectGridRenderer = {}
objectGridRenderer.mtindex = {
	__index = objectGridRenderer
}
objectGridRenderer.depth = 2

function objectGridRenderer.new(tileGridObj)
	local new = {}
	
	setmetatable(new, objectGridRenderer.mtindex)
	new:init(tileGridObj)
	
	return new
end

function objectGridRenderer:init(objectGridObj)
	self.objectGrid = objectGridObj
	self.visibleObjects = {}
	self.visibleObjectList = {}
	self.officeObjects = {}
	self.objectVis = {}
end

function objectGridRenderer:setupOfficeData()
	self.ownedTiles = studio:getBoughtTiles()
end

function objectGridRenderer:remove()
	table.clear(self.visibleObjects)
	table.clearArray(self.visibleObjectList)
	table.clear(self.objectVis)
	
	self.visibleObjects = nil
	self.visibilityHandler = nil
	self.objectGrid = nil
end

function objectGridRenderer:setHandler(handler)
	self.visibilityHandler = handler
end

function objectGridRenderer:onFloorViewChanged()
	local list = self.visibleObjectList
	
	if #list > 0 then
		local map, vis = self.visibleObjects, self.objectVis
		local rIdx = #list
		
		for i = #list, 1, -1 do
			local obj = list[rIdx]
			
			if obj:getOffice() then
				map[obj] = nil
				vis[obj] = nil
				
				table.remove(list, rIdx)
				obj:leaveVisibilityRange()
			end
			
			rIdx = rIdx - 1
		end
	end
end

function objectGridRenderer:onTileBecomeVisible(x, y, index)
	local camFloor = camera:getViewFloor()
	
	self:_attemptShow(x, y, camFloor)
	
	if camFloor ~= 1 and not self.ownedTiles[index] then
		self:_attemptShow(x, y, 1)
	end
end

function objectGridRenderer:_attemptShow(x, y, floor)
	local objects = self.objectGrid:getObjects(x, y, floor)
	
	if objects then
		for key, object in ipairs(objects) do
			local amt = self.objectVis[object]
			
			if not amt then
				amt = 0
				self.objectVis[object] = 1
			else
				self.objectVis[object] = amt + 1
			end
			
			if amt == 0 then
				self:makeVisible(object)
			end
		end
	end
end

function objectGridRenderer:onTileBecomeInvisible(index)
	local x, y = self.objectGrid:convertIndexToCoordinates(index)
	local camFloor = camera:getViewFloor()
	
	self:_attemptHide(x, y, camFloor)
	
	if camFloor ~= 1 and not self.ownedTiles[index] then
		self:_attemptHide(x, y, 1)
	end
end

function objectGridRenderer:_attemptHide(x, y, floor)
	local objects = self.objectGrid:getObjects(x, y, floor)
	
	if objects then
		for key, object in ipairs(objects) do
			local amt = self.objectVis[object]
			
			if not amt then
				self:updateObjectVisibility(object)
			else
				self.objectVis[object] = amt - 1
				
				if amt <= 1 then
					self:makeInvisible(object)
				end
			end
		end
	end
end

function objectGridRenderer:updateObjectVisibility(object)
	local xStart, yStart, xEnd, yEnd = object:getGridCoords()
	local grid = self.objectGrid
	local vis = 0
	
	for y = yStart, yEnd do
		for x = xStart, xEnd do
			if self.objectGrid:canSeeTile(x, y) then
				vis = vis + 1
			end
		end
	end
	
	self.objectVis[object] = vis
	
	if vis > 0 then
		self:makeVisible(object)
	else
		self:makeInvisible(object)
	end
end

function objectGridRenderer:makeVisible(object)
	if not self.visibleObjects[object] then
		self.visibleObjects[object] = true
		self.visibleObjectList[#self.visibleObjectList + 1] = object
		
		object:enterVisibilityRange()
	end
end

function objectGridRenderer:makeInvisible(object)
	if self.visibleObjects[object] then
		self.visibleObjects[object] = nil
		
		table.removeObject(self.visibleObjectList, object)
		object:leaveVisibilityRange()
	end
end

function objectGridRenderer:getVisibleObjects()
	return self.visibleObjects
end

function objectGridRenderer:getVisibleObjectList()
	return self.visibleObjectList
end

function objectGridRenderer:onObjectAdded(object)
	self:updateObjectVisibility(object)
end

function objectGridRenderer:onObjectRemoved(object)
	self.objectVis[object] = nil
	self.visibleObjects[object] = nil
	
	table.removeObject(self.visibleObjectList, object)
end

function objectGridRenderer:onTileValueChanged(index)
end

function objectGridRenderer:draw()
	local objList = self.visibleObjectList
	
	for i = 1, #objList do
		objList[i]:draw()
	end
end

function objectGridRenderer:postDraw()
	for key, object in ipairs(self.visibleObjectList) do
		object:postDraw()
	end
end
