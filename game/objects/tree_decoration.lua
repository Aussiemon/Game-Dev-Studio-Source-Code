local treeDecor = {}

treeDecor.class = "tree_decoration"
treeDecor.tileWidth = 3
treeDecor.tileHeight = 3
treeDecor.scaleX = 1.25
treeDecor.scaleY = 1.25
treeDecor.spriteList = {
	"tree_1",
	"tree_2",
	"tree_3",
	"tree_4"
}
treeDecor.display = _T("TREE", "A tree")
treeDecor.xOffset = 25
treeDecor.placeOn = floors:getData("grass").id
treeDecor.trunkAtlas = "decorations_under"
treeDecor.TREE = true
treeDecor.trunkQuad = quadLoader:load("tree_trunk")
treeDecor.quad = quadLoader:load("tree_leaves_1")
treeDecor.curQuad = treeDecor.quad
treeDecor.quadList = {
	"tree_leaves_1",
	"tree_leaves_2",
	"tree_leaves_3",
	"tree_leaves_4",
	"tree_leaves_5",
	"tree_leaves_6"
}
treeDecor.quadObjects = {}

for key, quadID in ipairs(treeDecor.quadList) do
	treeDecor.quadObjects[key] = quadLoader:load(quadID)
end

treeDecor.quadListLength = #treeDecor.quadObjects

function treeDecor:init()
	treeDecor.baseClass.init(self)
	
	self.reachable = true
	self.quadTime = math.randomf(0, 0.2)
	self.progressTime = math.randomf(0.2, 0.29)
	self.curQuadIndex = math.ceil(self.quadTime * self.quadListLength)
	self.curQuad = self.quadObjects[self.curQuadIndex]
	self.scaleOffset = math.randomf(0.8, 1)
	self.realXScale = self.scaleOffset * self.scaleX
	self.realYScale = self.scaleOffset * self.scaleY
end

function treeDecor:setupSpritebatches()
	self.trunkSpriteBatch = spriteBatchController:getContainer(self.trunkAtlas)
	
	treeDecor.baseClass.setupSpritebatches(self)
end

function treeDecor:referenceSpritebatches()
	table.insert(self.spriteBatches, self.spriteBatch)
	table.insert(self.spriteBatches, self.trunkSpriteBatch)
end

function treeDecor:getDrawPosition(x, y, quad, rotation, xDirectionalOffset, yDirectionalOffset)
	local x = x or self.x
	local x, y = x, y or self.y
	local quadStruct = quadLoader:getQuadObjectStructure(quad or self:getTextureQuad())
	local w, h = quadStruct.w, quadStruct.h
	
	return x + self.xOffset, y, w, h, 0
end

function treeDecor:update(dt, progress)
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
			
			self:updateSprite(true)
		end
	end
end

function treeDecor:getTextureQuad()
	return self.curQuad
end

function treeDecor:enterVisibilityRange()
	treeDecor.baseClass.enterVisibilityRange(self)
	game.addDynamicObject(self)
end

function treeDecor:leaveVisibilityRange()
	treeDecor.baseClass.leaveVisibilityRange(self)
	game.removeDynamicObject(self)
end

function treeDecor:getScale()
	return self.realXScale, self.realYScale
end

function treeDecor:updateSprite(leavesOnly)
	if self.visible then
		self.trunkSprite = self.trunkSprite or self.trunkSpriteBatch:allocateSlot()
		self.leavesSprite = self.leavesSprite or self.spriteBatch:allocateSlot()
		
		if not leavesOnly then
			local trunkQuad = self.trunkQuad
			local x, y, xOff, yOff, rotation = self:getDrawPosition(nil, nil, trunkQuad, nil, 20, -20)
			
			self.trunkSpriteBatch:updateSprite(self.trunkSprite, trunkQuad, math.round(x), math.round(y + 30), rotation, self.realXScale, self.realYScale, math.round(xOff * 0.5), math.round(yOff * 0.5))
		end
		
		local leavesQuad = self.curQuad
		local x, y, xOff, yOff, rotation = self:getDrawPosition(nil, nil, leavesQuad, walls.INVERSE_RELATION[self.rotation], 20, -20)
		
		self.spriteBatch:updateSprite(self.leavesSprite, leavesQuad, math.round(x), math.round(y), rotation, self.realXScale, self.realYScale, math.round(xOff * 0.5), math.round(yOff * 0.5))
	end
end

function treeDecor:clearSprite()
	if self.trunkSprite then
		self.trunkSpriteBatch:deallocateSlot(self.trunkSprite)
		
		self.trunkSprite = nil
		
		self.spriteBatch:deallocateSlot(self.leavesSprite)
		
		self.leavesSprite = nil
	end
end

objects.registerNew(treeDecor, "decoration_object_base")
