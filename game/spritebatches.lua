spriteBatchController:newSpriteBatch("city_decor", "textures/spritesheets/city_decorations.png", 256, "dynamic", 48, false, true)

local waterPuddles = spriteBatchController:newSpriteBatch("water_puddles", "textures/spritesheets/city_decorations.png", 256, "dynamic", 15, false, true)

waterPuddles.NO_AO_SHADER = true

game.addObjectSpritebatch(spriteBatchController:newSpriteBatch("object_atlas_1", "textures/spritesheets/object_spritesheet.png", 768, "dynamic", 20, false, true), false)
game.addObjectSpritebatch(spriteBatchController:newSpriteBatch("object_atlas_2", "textures/spritesheets/object_spritesheet.png", 512, "dynamic", 30, false, true), false)
game.addObjectSpritebatch(spriteBatchController:newSpriteBatch("object_atlas_1_between_walls", "textures/spritesheets/object_spritesheet.png", 768, "dynamic", 19.2, false, true), false)
game.addObjectSpritebatch(spriteBatchController:newSpriteBatch("object_atlas_2_between_walls", "textures/spritesheets/object_spritesheet.png", 512, "dynamic", 19.3, false, true), false)

local thirdSheet = spriteBatchController:newSpriteBatch("object_atlas_3", "textures/spritesheets/object_spritesheet.png", 512, "dynamic", 40, false, true)

thirdSheet.NO_AO_SHADER = true

local fourthSheet = spriteBatchController:newSpriteBatch("object_atlas_4", "textures/spritesheets/object_spritesheet.png", 512, "dynamic", 55, false, true)

fourthSheet.NO_AO_SHADER = true

game.addObjectSpritebatch(fourthSheet, false)

local thirdSheetBetween = spriteBatchController:newSpriteBatch("object_atlas_3_between_walls", "textures/spritesheets/object_spritesheet.png", 512, "dynamic", 19.3, false, true)

thirdSheetBetween.NO_AO_SHADER = true

game.addObjectSpritebatch(thirdSheetBetween, false)

local fourthSheet = spriteBatchController:newSpriteBatch("object_atlas_lamp_glow", "textures/spritesheets/object_spritesheet.png", 512, "dynamic", 39.9, false, true)

fourthSheet.NO_AO_SHADER = true

game.addObjectSpritebatch(fourthSheet, false)

local trunkBatch = spriteBatchController:newSpriteBatch("decorations_under", "textures/spritesheets/world_decorations.png", 256, "dynamic", 44, false, true)

trunkBatch:setShouldSortSprites(false)

local growingSpritebatch = spriteBatchController:newSpriteBatch("growing_decor", "textures/spritesheets/world_decorations.png", 256, "dynamic", 44, false, true)

growingSpritebatch:setShouldSortSprites(false)

growingSpritebatch.shaderTime = 0
growingSpritebatch.SHADOW_SHADER = true

growingSpritebatch:setPostDrawCallback(function(self)
	love.graphics.setShader(nil)
end)

local decorationsSpriteBatch = spriteBatchController:newSpriteBatch("decorations", "textures/spritesheets/world_decorations.png", 256, "dynamic", 45, false, true)

decorationsSpriteBatch:setShouldSortSprites(false)

decorationsSpriteBatch.shaderTime = 0
decorationsSpriteBatch.SHADOW_SHADER = true

decorationsSpriteBatch:setDrawCallback(function(self, x, y, scaleX, scaleY)
	self.shaderTime = self.shaderTime + frameTime * timeline:getRealSpeed() * 3
	
	if self.shaderTime >= math.pi * 2 then
		self.shaderTime = self.shaderTime - math.pi * 2
	end
	
	shaders.treeShader:send("time", self.shaderTime)
	love.graphics.setShader(shaders.treeShader)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.spriteBatch, x, y, 0, scaleX, scaleY)
	
	return true
end)
decorationsSpriteBatch:setPostDrawCallback(function(self)
	love.graphics.setShader(nil)
end)

local workerSpriteBatch = spriteBatchController:newSpriteBatch("worker_shoes", "textures/spritesheets/worker.png", 256, "dynamic", 20.1, false, true)

workerSpriteBatch:setShouldSortSprites(false)

local workerSpriteBatch = spriteBatchController:newSpriteBatch("worker_legs", "textures/spritesheets/worker.png", 256, "dynamic", 20.2, false, true)

workerSpriteBatch:setShouldSortSprites(false)

local workerSpriteBatch = spriteBatchController:newSpriteBatch("worker_trousers", "textures/spritesheets/worker.png", 256, "dynamic", 20.25, false, true)

workerSpriteBatch:setShouldSortSprites(false)

local workerSpriteBatch = spriteBatchController:newSpriteBatch("worker_hands", "textures/spritesheets/worker.png", 256, "dynamic", 30.3, false, true)

workerSpriteBatch:setShouldSortSprites(false)

local workerSpriteBatch = spriteBatchController:newSpriteBatch("worker_hands_2", "textures/spritesheets/worker.png", 256, "dynamic", 30.3, false, true)

workerSpriteBatch:setShouldSortSprites(false)

local workerSpriteBatch = spriteBatchController:newSpriteBatch("worker_torso", "textures/spritesheets/worker.png", 256, "dynamic", 30.4, false, true)

workerSpriteBatch:setShouldSortSprites(false)

local workerSpriteBatch = spriteBatchController:newSpriteBatch("worker_head", "textures/spritesheets/worker.png", 256, "dynamic", 30.5, false, true)

workerSpriteBatch:setShouldSortSprites(false)

local workerSpriteBatch = spriteBatchController:newSpriteBatch("worker_decor", "textures/spritesheets/worker.png", 256, "dynamic", 30.55, false, true)

workerSpriteBatch:setShouldSortSprites(false)

local workerSpriteBatch = spriteBatchController:newSpriteBatch("worker_hair", "textures/spritesheets/worker.png", 256, "dynamic", 30.6, false, true)

workerSpriteBatch:setShouldSortSprites(false)
spriteBatchController:newSpriteBatch("worker_carrying", "textures/spritesheets/object_spritesheet.png", 64, "dynamic", 32, false, true, false, true):setShouldSortSprites(false)

local sb = spriteBatchController:newSpriteBatch("world_ui", "textures/spritesheets/ui_icons.png", 128, "dynamic", 100, false, true, false, true)

sb:setShouldSortSprites(false)

local sb = spriteBatchController:newSpriteBatch("world_ui_2", "textures/spritesheets/ui_icons.png", 128, "dynamic", 101, false, true, false, true)

sb:setShouldSortSprites(false)
require("game/grass_spritebatch")

local roofDecorObjects = spriteBatchController:newSpriteBatch("roof_decor", "textures/spritesheets/roof_decor.png", 128, "dynamic", 61, false, true)

roofDecorObjects.NO_AO_SHADER = true

roofDecorObjects:setDrawCallback(function(self)
	local lightColor = timeOfDay:getLightColor()
	
	love.graphics.setColor(lightColor.r, lightColor.g, lightColor.b, 255)
	
	return false
end)
roofDecorObjects:setPostDrawCallback(function(self)
	love.graphics.setColor(255, 255, 255, 255)
end)
