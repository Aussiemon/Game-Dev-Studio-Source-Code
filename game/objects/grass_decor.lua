local testDec = {}

testDec.class = "grass_decor"
testDec.objectAtlas = "world_decorations"
testDec.quad = quadLoader:load("trashcan")
testDec.scaleX = 2
testDec.scaleY = 2
testDec.tileWidth = 2
testDec.quadList = {
	"grass_1",
	"grass_2",
	"grass_3",
	"grass_4",
	"grass_5",
	"grass_6",
	"grass_7",
	"grass_8"
}
testDec.quadObjects = {}

for key, quadID in ipairs(testDec.quadList) do
	testDec.quadObjects[key] = quadLoader:load(quadID)
end

testDec.quadListLength = #testDec.quadObjects

function testDec:init()
	testDec.baseClass.init(self)
	
	self.quadTime = math.randomf(0, 0.2)
	self.progressTime = math.randomf(0.29, 0.33)
	self.curQuadIndex = math.ceil(self.quadTime * self.quadListLength)
	self.curQuad = self.quadObjects[self.curQuadIndex]
end

function testDec:getDrawPosition(x, y, quad, rotation, xDirectionalOffset, yDirectionalOffset)
	local x = x or self.x
	local x, y = x, y or self.y
	local quadStruct = quadLoader:getQuadObjectStructure(quad or self:getTextureQuad())
	local w, h = quadStruct.w, quadStruct.h
	
	return x, y, w, h, 0
end

function testDec:update(dt, progress)
	if progress == 0 then
		return 
	end
	
	self.quadTime = self.quadTime + progress
	
	if self.quadTime >= self.progressTime then
		self.quadTime = self.quadTime - self.progressTime
		self.curQuadIndex = self.curQuadIndex + 1
		
		if self.curQuadIndex > self.quadListLength then
			self.curQuadIndex = 1
		end
		
		local newQuad = self.quadObjects[self.curQuadIndex]
		
		if newQuad ~= self.curQuad then
			self.curQuad = newQuad
			
			self:updateSprite()
		end
	end
end

function testDec:getTextureQuad()
	return self.curQuad
end

function testDec:enterVisibilityRange()
	testDec.baseClass.enterVisibilityRange(self)
	game.addDynamicObject(self)
end

function testDec:leaveVisibilityRange()
	testDec.baseClass.leaveVisibilityRange(self)
	game.removeDynamicObject(self)
end

objects.registerNew(testDec, "quadtree_decor_object_base")
