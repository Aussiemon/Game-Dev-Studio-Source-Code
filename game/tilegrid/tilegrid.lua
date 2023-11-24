local ffi = require("ffi")

tileGrid.CUSTOM_STRUCTURES.FLOOR_STRUCTURE = {
	structureInit = "floor_structure[?]",
	structure = ffi.cdef("typedef struct floor_structure {unsigned short id, adjacentWalls; signed short wallIDs[4];} floor_structure;"),
	ctype = ffi.typeof("floor_structure *"),
	ctypeptr = ffi.typeof("struct floor_structure *"),
	vars = {
		id = 0,
		adjacentWalls = 0,
		wallIDs = {
			length = 3,
			value = 0
		}
	}
}

function tileGrid:getTileID(index)
	return tonumber(self.tiles[index].id)
end

tileGrid.getTileValue = tileGrid.getTileID

function tileGrid:setTileValue(index, value)
	self.tiles[index].id = value
	
	self:onTileValueChanged(index)
end

function tileGrid:onTileValueChanged(index)
	if self.handler then
		self.handler:onTileValueChanged(index)
	end
end

function tileGrid:isTileEmpty(index)
	return self.tiles[index].id == 0
end

function tileGrid:getFloorCount()
	return self.floorCount
end

require("game/tilegrid/floor_tilegrid")
require("game/tilegrid/object_grid")
require("game/tilegrid/floor_object_grid")

if MAIN_THREAD then
	require("game/tilegrid/floor_tilegrid_renderer")
	require("game/tilegrid/object_grid_renderer")
	require("game/tilegrid/tilegrid_visibility_handler")
end
