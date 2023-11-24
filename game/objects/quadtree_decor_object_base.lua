local quadtreeDecor = {}

quadtreeDecor.class = "quadtree_decor_object_base"
quadtreeDecor.DECOR = true
quadtreeDecor.ROOT_DECOR = true
quadtreeDecor.BASE = true
quadtreeDecor.xOffset = 0
quadtreeDecor.yOffset = 0
quadtreeDecor.addRotation = 0
quadtreeDecor.xDirectionalOffset = 0
quadtreeDecor.yDirectionalOffset = 0

function quadtreeDecor:remove()
	quadtreeDecor.baseClass.remove(self)
	self:leaveVisibilityRange()
	game.worldObject:removeDecorationEntity(self)
end

function quadtreeDecor:addDecorEntity()
	game.worldObject:addDecorEntity(self)
end

function quadtreeDecor:setPos(x, y)
	quadtreeDecor.baseClass.setPos(self, x, y)
	self:addDecorEntity()
end

function quadtreeDecor:setRotation(rotation)
	self.rotation = rotation
end

function quadtreeDecor:getDrawAngles(rotation)
	return walls.RAW_ANGLES[rotation]
end

function quadtreeDecor:getRotation()
	return self.rotation
end

function quadtreeDecor:load(data)
	self:setPos(data.x, data.y)
	self:setRotation(data.rotation)
end

objects.registerNew(quadtreeDecor, "generic_object")
