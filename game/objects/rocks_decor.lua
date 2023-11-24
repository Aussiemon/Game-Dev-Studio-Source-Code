local testDec = {}

testDec.class = "rocks_decor"
testDec.objectAtlas = "world_decorations"
testDec.quad = quadLoader:load("rocks_1")
testDec.ROOT_DECOR = true
testDec.scaleX = 2
testDec.scaleY = 2

function testDec:getDrawPosition(x, y, quad, rotation, xDirectionalOffset, yDirectionalOffset)
	local x = x or self.x
	local x, y = x, y or self.y
	local quadStruct = quadLoader:getQuadObjectStructure(quad or self:getTextureQuad())
	local w, h = quadStruct.w, quadStruct.h
	
	return x, y, w, h, 0
end

objects.registerNew(testDec, "quadtree_decor_object_base")
require("game/objects/rocks_decor_1")
require("game/objects/rocks_decor_2")
require("game/objects/rocks_decor_3")
