local function getQuadMethod(self)
	local index = math.random(1, #self.quad)
	
	return self.quad[index], self.textureID[index]
end

local function mapAdjustPlacedTile(self, index, value, grid)
	local left = self:isGrass(grid:getTileValue(grid:offsetIndex(index, -1, 0)))
	local right = self:isGrass(grid:getTileValue(grid:offsetIndex(index, 1, 0)))
	local up = self:isGrass(grid:getTileValue(grid:offsetIndex(index, 0, -1)))
	local down = self:isGrass(grid:getTileValue(grid:offsetIndex(index, 0, 1)))
	
	if up and right and down and left then
		return 411
	end
	
	if up and right and down then
		return 4110
	elseif right and down and left then
		return 4111
	elseif down and left and up then
		return 4112
	elseif left and up and right then
		return 4113
	end
	
	if up and down then
		return 4115
	elseif left and right then
		return 4114
	end
	
	if left and down then
		return 417
	elseif left and up then
		return 418
	elseif up and right then
		return 419
	elseif right and down then
		return 416
	end
	
	if left then
		return 414
	elseif right then
		return 412
	elseif down then
		return 413
	elseif up then
		return 415
	end
	
	return value
end

local function isGrass(self, value)
	return floors.registeredByID[value] and floors.registeredByID[value].type ~= "grassy_dirt"
end

floors:registerNew({
	cost = 0,
	name = "grassy_dirt",
	display = "Grassy dirt",
	type = "grassy_dirt",
	noPurchase = true,
	id = 41,
	quad = {
		"grassy_dirt_1",
		"grassy_dirt_2",
		"grassy_dirt_3"
	},
	getQuad = getQuadMethod,
	isGrass = isGrass,
	mapAdjustPlacedTile = mapAdjustPlacedTile,
	rotation = {
		0,
		90,
		180,
		270
	}
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "grassy_dirt_all_sides",
	type = "grassy_dirt",
	display = "Grassy dirt all sides",
	skipEditor = true,
	id = 411,
	quad = {
		"grassy_dirt_all_sides_1",
		"grassy_dirt_all_sides_2",
		"grassy_dirt_all_sides_3"
	},
	getQuad = getQuadMethod,
	isGrass = isGrass,
	mapAdjustPlacedTile = mapAdjustPlacedTile,
	rotation = {
		0,
		90,
		180,
		270
	}
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "grassy_dirt_one_side",
	type = "grassy_dirt",
	display = "Grassy dirt side",
	skipEditor = true,
	id = 412,
	quad = {
		"grassy_dirt_one_side_1",
		"grassy_dirt_one_side_2",
		"grassy_dirt_one_side_3"
	},
	getQuad = getQuadMethod,
	isGrass = isGrass,
	mapAdjustPlacedTile = mapAdjustPlacedTile
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "dark_grass_one_side_90",
	type = "grassy_dirt",
	display = "Grassy dirt side 90",
	skipEditor = true,
	id = 413,
	quad = {
		"grassy_dirt_one_side_1",
		"grassy_dirt_one_side_2",
		"grassy_dirt_one_side_3"
	},
	getQuad = getQuadMethod,
	isGrass = isGrass,
	mapAdjustPlacedTile = mapAdjustPlacedTile,
	rotation = {
		90
	}
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "dark_grass_one_side_180",
	type = "grassy_dirt",
	display = "Grassy dirt side 180",
	skipEditor = true,
	id = 414,
	quad = {
		"grassy_dirt_one_side_1",
		"grassy_dirt_one_side_2",
		"grassy_dirt_one_side_3"
	},
	getQuad = getQuadMethod,
	isGrass = isGrass,
	mapAdjustPlacedTile = mapAdjustPlacedTile,
	rotation = {
		180
	}
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "dark_grass_one_side_270",
	type = "grassy_dirt",
	display = "Grassy dirt side 270",
	skipEditor = true,
	id = 415,
	quad = {
		"grassy_dirt_one_side_1",
		"grassy_dirt_one_side_2",
		"grassy_dirt_one_side_3"
	},
	getQuad = getQuadMethod,
	isGrass = isGrass,
	mapAdjustPlacedTile = mapAdjustPlacedTile,
	rotation = {
		270
	}
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "dark_grass_corner",
	type = "grassy_dirt",
	display = "Grassy dirt corner",
	skipEditor = true,
	id = 416,
	quad = {
		"grassy_dirt_two_sides_1",
		"grassy_dirt_two_sides_2",
		"grassy_dirt_two_sides_3"
	},
	rotation = {
		90
	},
	getQuad = getQuadMethod,
	isGrass = isGrass,
	mapAdjustPlacedTile = mapAdjustPlacedTile
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "dark_grass_corner_90",
	type = "grassy_dirt",
	display = "Grassy dirt corner 90",
	skipEditor = true,
	id = 417,
	quad = {
		"grassy_dirt_two_sides_1",
		"grassy_dirt_two_sides_2",
		"grassy_dirt_two_sides_3"
	},
	getQuad = getQuadMethod,
	isGrass = isGrass,
	mapAdjustPlacedTile = mapAdjustPlacedTile,
	rotation = {
		180
	}
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "dark_grass_corner_180",
	type = "grassy_dirt",
	display = "Grassy dirt corner 180",
	skipEditor = true,
	id = 418,
	quad = {
		"grassy_dirt_two_sides_1",
		"grassy_dirt_two_sides_2",
		"grassy_dirt_two_sides_3"
	},
	getQuad = getQuadMethod,
	isGrass = isGrass,
	mapAdjustPlacedTile = mapAdjustPlacedTile,
	rotation = {
		270
	}
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "dark_grass_corner_270",
	type = "grassy_dirt",
	display = "Grassy dirt corner",
	skipEditor = true,
	id = 419,
	quad = {
		"grassy_dirt_two_sides_1",
		"grassy_dirt_two_sides_2",
		"grassy_dirt_two_sides_3"
	},
	getQuad = getQuadMethod,
	isGrass = isGrass,
	mapAdjustPlacedTile = mapAdjustPlacedTile
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "dark_grass_cup",
	type = "grassy_dirt",
	display = "Grassy dirt cup",
	skipEditor = true,
	id = 4110,
	quad = {
		"grassy_dirt_three_sides_1",
		"grassy_dirt_three_sides_2",
		"grassy_dirt_three_sides_3"
	},
	getQuad = getQuadMethod,
	isGrass = isGrass,
	mapAdjustPlacedTile = mapAdjustPlacedTile
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "grassy_dirt_cup_90",
	type = "grassy_dirt",
	display = "Grassy dirt cup 90",
	skipEditor = true,
	id = 4111,
	quad = {
		"grassy_dirt_three_sides_1",
		"grassy_dirt_three_sides_2",
		"grassy_dirt_three_sides_3"
	},
	getQuad = getQuadMethod,
	isGrass = isGrass,
	mapAdjustPlacedTile = mapAdjustPlacedTile,
	rotation = {
		90
	}
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "grassy_dirt_cup_180",
	type = "grassy_dirt",
	display = "Grassy dirt cup 180",
	skipEditor = true,
	id = 4112,
	quad = {
		"grassy_dirt_three_sides_1",
		"grassy_dirt_three_sides_2",
		"grassy_dirt_three_sides_3"
	},
	getQuad = getQuadMethod,
	isGrass = isGrass,
	mapAdjustPlacedTile = mapAdjustPlacedTile,
	rotation = {
		180
	}
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "grassy_dirt_cup_270",
	type = "grassy_dirt",
	display = "Grassy dirt cup 270",
	skipEditor = true,
	id = 4113,
	quad = {
		"grassy_dirt_three_sides_1",
		"grassy_dirt_three_sides_2",
		"grassy_dirt_three_sides_3"
	},
	getQuad = getQuadMethod,
	isGrass = isGrass,
	mapAdjustPlacedTile = mapAdjustPlacedTile,
	rotation = {
		270
	}
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "grassy_dirt_enclosed",
	type = "grassy_dirt",
	display = "Grassy dirt enclosed",
	skipEditor = true,
	id = 4114,
	quad = {
		"grassy_dirt_enclosed_1",
		"grassy_dirt_enclosed_2",
		"grassy_dirt_enclosed_3"
	},
	getQuad = getQuadMethod,
	isGrass = isGrass,
	mapAdjustPlacedTile = mapAdjustPlacedTile,
	rotation = {
		0,
		180
	}
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "grassy_dirt_enclosed_180",
	type = "grassy_dirt",
	display = "Grassy dirt enclosed 180",
	skipEditor = true,
	id = 4115,
	quad = {
		"grassy_dirt_enclosed_1",
		"grassy_dirt_enclosed_2",
		"grassy_dirt_enclosed_3"
	},
	getQuad = getQuadMethod,
	isGrass = isGrass,
	mapAdjustPlacedTile = mapAdjustPlacedTile,
	rotation = {
		90,
		270
	}
})
