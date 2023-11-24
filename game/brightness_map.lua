brightnessMap = {}
brightnessMap.mtindex = {
	__index = brightnessMap
}
brightnessMap.MISSING_INDEX_BRIGHTNESS = 0
brightnessMap.LUMEN_MULTIPLIER = 500

function brightnessMap.new()
	local new = {}
	
	setmetatable(new, brightnessMap.mtindex)
	new:init()
	
	return new
end

function brightnessMap.brightnessToLumen(value)
	return math.round(value * brightnessMap.LUMEN_MULTIPLIER)
end

function brightnessMap:init()
	self.removed = false
	self.tiles = self.tiles or {}
	self.lightSourceMap = self.lightSourceMap or {}
end

function brightnessMap:remove()
	self.removed = true
	
	table.clear(self.tiles)
	table.clear(self.lightSourceMap)
end

function brightnessMap:setupFloor(index)
	self.tiles[index] = {}
	self.lightSourceMap[index] = {}
end

function brightnessMap:setFloorTileGrid(grid)
	self.floorGrid = grid
end

function brightnessMap:setTileBrightness(index, brightness, lightCaster)
	local floor = lightCaster:getFloor()
	local tileMap = self.tiles[floor]
	
	tileMap[index] = math.max(tileMap[index] or 0, brightness)
	
	local casterMap = self.lightSourceMap[floor]
	
	casterMap[index] = casterMap[index] or {}
	casterMap[index][lightCaster] = true
end

function brightnessMap:isIlluminatingTile(index, lightCaster)
	local floor = lightCaster:getFloor()
	local floorMap = self.lightSourceMap[floor][index]
	
	return floorMap and floorMap[lightCaster]
end

function brightnessMap:getTileBrightness(index, floor)
	return self.tiles[floor][index] or 0
end

function brightnessMap:resetTileBrightness(index, caster, floor)
	local casters = self.lightSourceMap[floor][index]
	
	if casters then
		casters[caster] = nil
		
		local brightestSource = 0
		
		for otherObject, state in pairs(casters) do
			brightestSource = math.max(self.tiles[floor][index], brightestSource)
		end
		
		self.tiles[floor][index] = brightestSource
	else
		self.tiles[floor][index] = nil
	end
end

local foundOtherCasters = {}

function brightnessMap:updateLightSourcesOnIndex(index, floor)
	local x, y = self.floorGrid:convertIndexToCoordinates(index)
	
	self:updateCasterList(index)
	self:updateCasterList(self.floorGrid:getTileIndex(x - 1, y), floor)
	self:updateCasterList(self.floorGrid:getTileIndex(x + 1, y), floor)
	self:updateCasterList(self.floorGrid:getTileIndex(x, y - 1), floor)
	self:updateCasterList(self.floorGrid:getTileIndex(x, y + 1), floor)
	
	for key, casterObject in ipairs(foundOtherCasters) do
		casterObject:resetTileIllumination()
	end
	
	for key, casterObject in ipairs(foundOtherCasters) do
		casterObject:illuminateNearbyTiles()
		
		foundOtherCasters[key] = nil
	end
end

function brightnessMap:updateCasterList(index)
	local casters = self.lightSourceMap[index]
	
	if casters then
		for caster, state in pairs(casters) do
			table.insert(foundOtherCasters, caster)
		end
	end
end

function brightnessMap:removeLightSource(object, floor)
	if self.removed then
		return 
	end
	
	local tileList = object:getIlluminatedTiles()
	
	for key, tile in ipairs(tileList) do
		local tileContents = self.lightSourceMap[floor][tile]
		
		if tileContents then
			tileContents[object] = nil
			
			local brightestSource = 0
			
			for otherObject, state in pairs(tileContents) do
				brightestSource = math.max(otherObject:getTileBrightness(tile, floor), brightestSource)
			end
			
			self.tiles[floor][tile] = brightestSource
		end
	end
end
