local animatedGrassSpritebatch = spriteBatchController:newSpriteBatch("world_decorations", "textures/spritesheets/world_decorations.png", 1024, "dynamic", 19, false, true)

animatedGrassSpritebatch:setShouldSortSprites(false)

animatedGrassSpritebatch.SHADOW_SHADER = true

local animatedGrassSpritebatch = spriteBatchController:newSpriteBatch("world_decorations_no_shadow", "textures/spritesheets/world_decorations.png", 256, "dynamic", 44.5, false, true)

animatedGrassSpritebatch:setShouldSortSprites(false)
