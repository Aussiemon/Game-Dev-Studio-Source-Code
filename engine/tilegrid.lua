tileGrid = {}
tileGrid.mtindex = {
	__index = tileGrid
}
tileGrid.CUSTOM_STRUCTURES = {}
tileGrid.DATA_TYPES_ENUM = {
	SIGNED_CHAR = 2,
	SIGNED_SHORT = 4,
	UNSIGNED_CHAR = 1,
	UNSIGNED_INT = 5,
	UNSIGNED_FLOAT = 7,
	SIGNED_FLOAT = 8,
	UNSIGNED_SHORT = 3,
	SIGNED_INT = 6
}
tileGrid.DATA_TYPES_STRING = {
	[tileGrid.DATA_TYPES_ENUM.UNSIGNED_CHAR] = "unsigned char [?]",
	[tileGrid.DATA_TYPES_ENUM.SIGNED_CHAR] = "signed char [?]",
	[tileGrid.DATA_TYPES_ENUM.UNSIGNED_SHORT] = "unsigned short [?]",
	[tileGrid.DATA_TYPES_ENUM.SIGNED_SHORT] = "signed short [?]",
	[tileGrid.DATA_TYPES_ENUM.UNSIGNED_INT] = "unsigned int [?]",
	[tileGrid.DATA_TYPES_ENUM.SIGNED_INT] = "signed int [?]",
	[tileGrid.DATA_TYPES_ENUM.UNSIGNED_FLOAT] = "unsigned float [?]",
	[tileGrid.DATA_TYPES_ENUM.SIGNED_FLOAT] = "signed float [?]"
}

local ffi = require("ffi")

function tileGrid.new(xSize, ySize, dataTypeEnum, dataType)
	local new = {}
	
	setmetatable(new, tileGrid.mtindex)
	new:init(xSize, ySize, dataTypeEnum, dataType)
	
	return new
end

function tileGrid:init(sizeX, sizeY, dataTypeEnum, dataType)
	self.overdrawX = 0
	self.overdrawY = 0
	
	if sizeX and sizeY then
		self:initGrid(sizeX, sizeY, dataTypeEnum, dataType)
	end
end

function tileGrid:getIndexMidpoint(index)
	local x, y = self:gridToWorld(self:convertIndexToCoordinates(index))
	
	return x + self.tileWidth * 0.5, y + self.tileHeight * 0.5
end

function tileGrid:setHandler(handler)
	self.handler = handler
end

function tileGrid:getHandler()
	return self.handler
end

function tileGrid:remove()
	self.removed = true
	
	if self.handler then
		self.handler:remove()
	end
	
	self.tiles = nil
end

function tileGrid:setTileSize(w, h)
	self.tileWidth = w or self.tileWidth
	self.tileHeight = h or self.tileHeight
end

function tileGrid:setTileWidth(w)
	self.tileWidth = w or self.tileWidth
end

function tileGrid:setTileHeight(h)
	self.tileHeight = h or self.tileHeight
end

function tileGrid:getTileSize()
	return self.tileWidth, self.tileHeight
end

function tileGrid:getTileWidth()
	return self.tileWidth
end

function tileGrid:getTileHeight()
	return self.tileHeight
end

function tileGrid:getSize()
	return self.gridWidth, self.gridHeight
end

function tileGrid:getTileIndex(x, y)
	return y * (self.gridWidth + 1) + x
end

function tileGrid:convertIndexToCoordinates(index)
	local rem = index % (self.gridWidth + 1)
	
	return rem, math.ceil((index - rem) / (self.gridWidth + 1))
end

tileGrid.getCoordinatesFromIndex = tileGrid.convertIndexToCoordinates

function tileGrid:worldToGrid(x, y)
	return math.ceil(x / self.tileWidth), math.ceil(y / self.tileHeight)
end

function tileGrid:gridToWorld(x, y)
	return x * self.tileWidth, y * self.tileHeight
end

function tileGrid:indexToWorld(index)
	return self:gridToWorld(self:convertIndexToCoordinates(index))
end

function tileGrid:worldToIndex(x, y)
	return self:getTileIndex(self:worldToGrid(x, y))
end

function tileGrid:getDataTypeString(enum)
	return tileGrid.DATA_TYPES_STRING[enum]
end

function tileGrid:setTileValue(index, value)
end

function tileGrid:onTileValueChanged(index)
end

function tileGrid:initGrid(sizeX, sizeY, dataTypeEnum, dataType)
	local dataStructType
	
	if not dataType then
		dataTypeEnum = dataTypeEnum or tileGrid.DATA_TYPES_ENUM.UNSIGNED_CHAR
		dataStructType = self:getDataTypeString(dataTypeEnum)
	else
		dataStructType = dataType.structureInit
	end
	
	self.gridWidth = sizeX
	self.gridHeight = sizeY
	self.gridDataType = dataTypeEnum
	self.gridDataTypeConfig = dataType
	
	self:_initGrid(sizeX, sizeY, dataType, dataStructType)
end

function tileGrid:_initGrid(sizeX, sizeY, dataType, dataStructType)
	self.tiles = ffi.new(dataStructType, (sizeX + 2) * (sizeY + 2))
	
	if dataType and dataType.vars then
		for varType, value in pairs(dataType.vars) do
			for y = 0, sizeY do
				for x = 0, sizeX do
					if type(value) == "table" then
						local index = self:getTileIndex(x, y)
						local data = self.tiles[index]
						
						for i = 0, value.length do
							data[varType][i] = value.value
						end
					else
						local index = self:getTileIndex(x, y)
						local data = self.tiles[index]
						
						data[varType] = value
					end
				end
			end
		end
	else
		for y = 0, sizeY do
			for x = 0, sizeX do
				local index = self:getTileIndex(x, y)
				
				self.tiles[index] = 0
			end
		end
	end
end

function tileGrid:fillWithTile(tileID)
	for y = 1, self.gridHeight do
		for x = 1, self.gridWidth do
			self:setTileValue(self:getTileIndex(x, y), tileID)
		end
	end
end

function tileGrid:outOfBounds(x, y)
	if x < 1 or x > self.gridWidth or y < 1 or y > self.gridHeight then
		return true
	end
	
	return false
end

function tileGrid:canSeeTile(x, y)
	local startX, startY, endX, endY = self:getVisibleTiles()
	
	if x < startX or endX < x or y < startY or endY < y then
		return false
	end
	
	return true
end

function tileGrid:getTile(x, y)
	return self.tiles[self:getTileIndex(x, y)]
end

function tileGrid:getTileFromIndex(index)
	return self.tiles[index]
end

function tileGrid:getTileFromWorldSpace(x, y)
	return self:getTile(self:worldToGrid(x, y))
end

function tileGrid:tileToScreen(x, y)
	return (x * self.tileWidth - camera.x) * camera.scaleX, (y * self.tileHeight - camera.y) * camera.scaleY
end

function tileGrid:getVisibleScreenTiles()
	return math.ceil(scrW / self.tileWidth / camera.scaleX), math.ceil(scrH / self.tileHeight / camera.scaleY)
end

function tileGrid:getCameraStartTile()
	local camX, camY = camera:getPosition()
	
	return math.ceil(camX / self.tileWidth), math.ceil(camY / self.tileHeight)
end

function tileGrid:setOverdraw(x, y)
	self.overdrawX = x
	self.overdrawY = y
end

function tileGrid:getVisibleTiles()
	local startX, startY = self:getCameraStartTile()
	local visX, visY = self:getVisibleScreenTiles()
	
	return math.max(startX - 1 - self.overdrawX, 1), math.max(startY - 1 - self.overdrawY, 1), math.min(startX + visX + self.overdrawX, self.gridWidth), math.min(startY + visY + self.overdrawY, self.gridHeight)
end

function tileGrid:getRealMouseTileCoordinates()
	local mouseX, mouseY = camera:mousePosition()
	
	return math.ceil(mouseX / self.tileWidth), math.ceil(mouseY / self.tileHeight)
end

function tileGrid:getMouseTileCoordinates()
	local mouseX, mouseY = camera:absoluteMousePosition()
	
	return math.ceil(mouseX / self.tileWidth), math.ceil(mouseY / self.tileHeight)
end

function tileGrid:getTileIndexOnMouse()
	return self:getTileIndex(self:getMouseTileCoordinates())
end

function tileGrid:offsetIndex(index, x, y)
	return index + (y * (self.gridWidth + 1) + x)
end

function tileGrid:draw()
	if self.handler then
		self.handler:update()
	end
end

function tileGrid:save()
end

function tileGrid:load()
end
