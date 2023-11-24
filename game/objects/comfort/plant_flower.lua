local flower = {}

flower.tileWidth = 1
flower.tileHeight = 1
flower.class = "plant_flower"
flower.category = "leisure"
flower.objectType = "decor"
flower.roomType = {
	[studio.ROOM_TYPES.OFFICE] = true
}
flower.display = _T("OBJECT_PLANT_FLOWER", "Plant flower")
flower.description = _T("OBJECT_PLANT_FLOWER_DESCRIPTION", "Fill the room with the fragrance of an exotic flower.")
flower.quad = quadLoader:load("plant_flower")
flower.scaleX = 1
flower.scaleY = 1
flower.cost = 60
flower.minimumIllumination = 0
flower.sizeCategory = "unhousable"
flower.requiresEntrance = false
flower.preventsMovement = true
flower.preventsReach = true
flower.affectors = {
	{
		"comfort",
		1
	}
}
flower.addRotation = 0
flower.centerOffsetX = 0
flower.centerOffsetY = 0
flower.icon = "icon_plant_flower"
flower.matchingRequirements = {}

function flower:canRotate()
	return false
end

function flower:selectForPurchase()
	self.rotation = walls.UP
	
	studio.expansion:setRotation(self.rotation)
end

objects.registerNew(flower, "room_checking_object_base")
