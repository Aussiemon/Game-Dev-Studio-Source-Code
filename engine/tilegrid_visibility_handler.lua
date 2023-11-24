tileGridVisibilityHandler = {}
tileGridVisibilityHandler.mtindex = {
	__index = tileGridVisibilityHandler
}

local function sortFunc(a, b)
	return a.depth < b.depth
end

function tileGridVisibilityHandler.new(tileGridObj)
	local new = {}
	
	setmetatable(new, tileGridVisibilityHandler.mtindex)
	new:init(tileGridObj)
	
	return new
end

function tileGridVisibilityHandler:init(tileGridObj)
	self.tileGrid = tileGridObj
	self.visibleTiles = {}
	self.visibleTilesList = {}
	self.renderers = {}
end

function tileGridVisibilityHandler:onTileBecomeVisible(x, y, index)
	for key, renderer in ipairs(self.renderers) do
		renderer:onTileBecomeVisible(x, y, index)
	end
end

function tileGridVisibilityHandler:onTileBecomeInvisible(index)
	for key, renderer in ipairs(self.renderers) do
		renderer:onTileBecomeInvisible(index)
	end
end

function tileGridVisibilityHandler:onTileValueChanged(index)
	for key, renderer in ipairs(self.renderers) do
		renderer:onTileValueChanged(index)
	end
end

function tileGridVisibilityHandler:remove()
	for key, renderer in ipairs(self.renderers) do
		renderer:remove()
		
		self.renderers[key] = nil
	end
	
	for key, index in ipairs(self.visibleTilesList) do
		self.visibleTilesList[key] = nil
		self.visibleTiles[index] = nil
	end
end

function tileGridVisibilityHandler:onObjectAdded(object)
	for key, renderer in ipairs(self.renderers) do
		renderer:onObjectAdded(object)
	end
end

function tileGridVisibilityHandler:onObjectRemoved(object)
	for key, renderer in ipairs(self.renderers) do
		renderer:onObjectRemoved(object)
	end
end

function tileGridVisibilityHandler:addRenderer(renderer)
	renderer:setHandler(self)
	table.insert(self.renderers, renderer)
	self:sortRenderers()
end

function tileGridVisibilityHandler:sortRenderers()
	table.sortl(self.renderers, sortFunc)
end

function tileGridVisibilityHandler:removeRenderer(renderer)
	renderer:setHandler(nil)
	
	for key, otherRenderer in ipairs(self.renderers) do
		if otherRenderer == renderer then
			table.remove(self.renderers, key)
			
			break
		end
	end
end

function tileGridVisibilityHandler:getRenderers()
	return self.renderers
end

function tileGridVisibilityHandler:_makeVisibleTiles(startY, endY, startX, endX)
	local visTiles = self.visibleTiles
	local tileGrid = self.tileGrid
	
	for y = startY, endY do
		for x = startX, endX do
			local index = tileGrid:getTileIndex(x, y)
			
			if not visTiles[index] and tileGrid.tiles[index].id ~= 0 then
				self:onTileBecomeVisible(x, y, index)
				
				visTiles[index] = true
			end
		end
	end
end

function tileGridVisibilityHandler:_makeInvisibleTiles(startY, endY, startX, endX)
	local tileGrid = self.tileGrid
	
	for y = startY, endY do
		for x = startX, endX do
			local index = tileGrid:getTileIndex(x, y)
			
			if tileGrid.tiles[index].id ~= 0 then
				self:onTileBecomeInvisible(x, y, index)
			end
		end
	end
end

function tileGridVisibilityHandler:_update()
	local tileGrid = self.tileGrid
	local oldStartX, oldStartY, oldEndX, oldEndY = self.visStartX, self.visStartY, self.visEndX, self.visEndY
	local startX, startY, endX, endY = tileGrid:getVisibleTiles()
	local visTiles = self.visibleTiles
	
	if endX < oldEndX then
		local xOff = math.min(oldEndX - oldStartX, oldEndX - endX - 1)
		
		for y = oldStartY, oldEndY do
			for x = oldEndX - xOff, oldEndX do
				local index = tileGrid:getTileIndex(x, y)
				
				if visTiles[index] and tileGrid.tiles[index].id ~= 0 then
					self:onTileBecomeInvisible(index)
					
					visTiles[index] = nil
				end
			end
		end
	end
	
	if oldStartX < startX then
		local xOff = math.min(oldEndX - oldStartX, startX - oldStartX - 1)
		
		for y = oldStartY, oldEndY do
			for x = oldStartX, oldStartX + xOff do
				local index = tileGrid:getTileIndex(x, y)
				
				if visTiles[index] and tileGrid.tiles[index].id ~= 0 then
					self:onTileBecomeInvisible(index)
					
					visTiles[index] = nil
				end
			end
		end
	end
	
	if endY < oldEndY then
		local yOff = math.min(oldEndY - oldStartY, oldEndY - endY - 1)
		
		for y = oldEndY, oldEndY + yOff do
			for x = oldStartX, oldEndX do
				local index = tileGrid:getTileIndex(x, y)
				
				if visTiles[index] and tileGrid.tiles[index].id ~= 0 then
					self:onTileBecomeInvisible(index)
					
					visTiles[index] = nil
				end
			end
		end
	end
	
	if oldStartY < startY then
		local yOff = math.min(oldEndY - oldStartY, startY - oldStartY - 1)
		
		for y = oldStartY, oldStartY + yOff do
			for x = oldStartX, oldEndX do
				local index = tileGrid:getTileIndex(x, y)
				
				if visTiles[index] and tileGrid.tiles[index].id ~= 0 then
					self:onTileBecomeInvisible(index)
					
					visTiles[index] = nil
				end
			end
		end
	end
	
	if startX < oldStartX then
		local xOff = oldStartX - startX - 1
		
		self:_makeVisibleTiles(startY, endY, startX, startX + xOff)
	end
	
	if oldEndX < endX then
		local xOff = endX - oldEndX - 1
		
		self:_makeVisibleTiles(startY, endY, endX - xOff, endX)
	end
	
	if startY < oldStartY then
		local yOff = oldStartY - startY - 1
		
		self:_makeVisibleTiles(startY, startY + yOff, startX, endX)
	end
	
	if oldEndY < endY then
		local yOff = endY - oldEndY - 1
		
		self:_makeVisibleTiles(endY - yOff, endY, startX, endX)
	end
	
	self.visStartX, self.visEndX, self.visStartY, self.visEndY = startX, endX, startY, endY
end

function tileGridVisibilityHandler:_fullUpdate()
	local tileGrid = self.tileGrid
	local startX, startY, endX, endY = tileGrid:getVisibleTiles()
	
	self.visStartX, self.visEndX, self.visStartY, self.visEndY = startX, endX, startY, endY
	
	local list = self.visibleTilesList
	local visTiles = self.visibleTiles
	
	for y = startY, endY do
		for x = startX, endX do
			local index = tileGrid:getTileIndex(x, y)
			
			if tileGrid.tiles[index].id ~= 0 then
				if not visTiles[index] then
					self:onTileBecomeVisible(x, y, index)
					
					list[#list + 1] = index
				end
				
				visTiles[index] = 2
			end
		end
	end
	
	local curKey = 1
	
	for i = 1, #list do
		local tileIndex = list[curKey]
		local value = visTiles[tileIndex] - 1
		
		if value == 0 then
			self:onTileBecomeInvisible(tileIndex)
			
			visTiles[tileIndex] = nil
			
			table.remove(list, curKey)
		else
			visTiles[tileIndex] = value
			curKey = curKey + 1
		end
	end
end

function tileGridVisibilityHandler:update()
	if not self.visStartX then
		self:_fullUpdate()
	else
		self:_update()
	end
	
	for key, renderer in ipairs(self.renderers) do
		renderer:draw()
	end
end

function tileGridVisibilityHandler:postDraw()
	for key, renderer in ipairs(self.renderers) do
		renderer:postDraw()
	end
end
