floors = {}
floors.registered = {}
floors.registeredByID = {}
floors.registeredByName = {}
floors.pedestrianTiles = {}
floors.usedTextureMap = {}
floors.allUsedTextures = {}
floors.purchasable = {}
floors.registeredSurfaceTypes = {}
floors.registeredSurfaceTypesByID = {}

if MAIN_THREAD then
	floors.texture = "textures/spritesheets/floors_and_walls.png"
	floors.atlasTexture = cache.getImage(floors.texture)
	floors.MONTHLY_COST_PER_TILE = monthlyCost.new()
	
	floors.MONTHLY_COST_PER_TILE:setCostTypes("water", 0, "electricity", 0, "communal", 2)
	
	floors.floorPeekTexID = cache.getImageID(quadLoader:getQuadTexture("floor_peek_down"))
end

local defaultFloorFuncs = {}

defaultFloorFuncs.mtindex = {
	__index = defaultFloorFuncs
}

function defaultFloorFuncs:getQuadName()
	return self.quadName
end

function defaultFloorFuncs:getQuad()
	return self.quad, self.textureID
end

function defaultFloorFuncs:precalculateRenderData()
	local quad = self:getQuad()
	local qX, qY, qW, qH = quad:getViewport()
	local halfWidth, halfHeight = qW * 0.5, qH * 0.5
	
	self.renderHalfW = halfWidth
	self.renderHalfH = halfHeight
	self.renderOffX, self.renderOffY = halfWidth * math.abs(self.scaleX), halfHeight * self.scaleY
end

function defaultFloorFuncs:getRenderData(gridX, gridY)
	local quad, textureID = self:getQuad()
	
	return gridX - self.renderOffX, gridY - self.renderOffY, self.rotation and self.rotation[math.random(1, #self.rotation)] or 0, self.renderHalfW, self.renderHalfH, quad, textureID
end

function defaultFloorFuncs:mapAdjustPlacedTile(index, id, grid, floor)
	return id
end

function floors:registerSurfaceType(data)
	floors.registeredSurfaceTypes[#floors.registeredSurfaceTypes + 1] = data
	floors.registeredSurfaceTypesByID[data.id] = data
	
	if MAIN_THREAD then
		data.stepSoundData = sound.getSoundData(data.stepSound)
	end
end

floors:registerSurfaceType({
	id = "carpet",
	stepSound = "footstep_carpet"
})
floors:registerSurfaceType({
	id = "tile",
	stepSound = "footstep_tile"
})
floors:registerSurfaceType({
	id = "wood",
	stepSound = "footstep_wood"
})
floors:registerSurfaceType({
	id = "asphalt",
	stepSound = "footstep_asphalt"
})

function floors:_logUsedtexture(quad)
	local texture = quadLoader:getQuadTexture(quad)
	local imageID = cache.getImageID(texture)
	
	if not self.usedTextureMap[texture] then
		self.usedTextureMap[texture] = true
		
		table.insert(self.allUsedTextures, texture)
	end
	
	return imageID
end

function floors:registerNew(data)
	table.insert(floors.registered, data)
	
	floors.registeredByID[data.id] = data
	floors.registeredByName[data.name] = data
	
	if data.pedestrianTile then
		floors.pedestrianTiles[data.id] = true
	end
	
	data.index = #floors.registered
	data.pathScore = data.pathScore or 0
	data.surfaceType = data.surfaceType or "carpet"
	data.monthlyCost = data.monthlyCost or floors.MONTHLY_COST_PER_TILE
	
	if data.rotation then
		for key, angle in ipairs(data.rotation) do
			data.rotation[key] = math.rad(angle)
		end
	end
	
	setmetatable(data, defaultFloorFuncs.mtindex)
	
	if MAIN_THREAD then
		local quadType = type(data.quad)
		
		data.rotationLink = data.rotationLink or {
			data.id
		}
		
		for key, id in ipairs(data.rotationLink) do
			if id == data.id then
				data.rotationLinkIndex = key
				
				break
			end
		end
		
		if quadType == "string" then
			data.quadName = data.quad
			data.textureID = self:_logUsedtexture(data.quad)
			data.quad = quadLoader:load(data.quad)
		elseif quadType == "table" then
			data.quadName = table.copyOver(data.quad, {})
			data.textureID = {}
			
			for key, quadString in ipairs(data.quad) do
				data.textureID[key] = self:_logUsedtexture(quadString)
				data.quad[key] = quadLoader:load(quadString)
			end
		end
		
		data.targetW = data.targetW or 48
		data.targetH = data.targetH or 48
		
		local quad = quadType == "string" and data.quad or data.quad[1]
		local w, h = quad:getSize()
		
		data.scaleX = data.scaleX or data.targetW / w
		data.scaleY = data.scaleY or data.targetH / h
		
		data:precalculateRenderData()
		
		if not data.noPurchase then
			floors.purchasable[#floors.purchasable + 1] = data
		end
	end
end

function floors:initializeCollection(collection, baseID, spriteCount, priority)
	for key, textureObject in ipairs(self.allUsedTextures) do
		local sb = spriteBatchController:newSpriteBatch(baseID .. "_" .. tostring(textureObject), textureObject, spriteCount, "dynamic", priority, false, true, true, true)
		
		collection:addSpriteBatch(sb, priority)
	end
end

function floors:initializePeekCollection(collection, baseID, spriteCount, priority)
	local texObj = cache.getImageByID(floors.floorPeekTexID)
	local sb = spriteBatchController:newSpriteBatch(baseID .. "_" .. tostring(texObj), texObj, spriteCount, "dynamic", priority, false, true, true, true)
	
	collection:addSpriteBatch(sb, priority)
end

function floors:getSurfaceTypeForFloor(id)
	return floors.registeredSurfaceTypesByID[floors.registeredByID[id].surfaceType]
end

function floors:getData(id)
	return floors.registeredByID[id] or floors.registeredByName[id]
end

function floors:getCost(id)
	return floors.registeredByID[id].cost
end

floors:registerNew({
	cost = 10,
	quad = "floor_tile",
	pedestrianTile = true,
	id = 1,
	name = "tile_floor",
	surfaceType = "tile",
	display = _T("FLOOR_TILE", "Tile")
})
floors:registerNew({
	cost = 10,
	quad = "wooden_floor_top_down",
	pedestrianTile = true,
	id = 2,
	name = "wood_floor",
	surfaceType = "wood",
	display = _T("FLOOR_WOOD", "Wood")
})
floors:registerNew({
	cost = 10,
	quad = "red_carpet",
	pedestrianTile = true,
	id = 3,
	name = "red_carpet",
	display = _T("RED_CARPET", "Red carpet"),
	rotation = {
		0,
		90,
		180,
		270
	}
})
floors:registerNew({
	cost = 10,
	name = "carpet",
	quad = "carpet",
	scaleY = 1,
	pedestrianTile = true,
	id = 301,
	scaleX = 1,
	display = _T("CARPET", "Carpet"),
	rotation = {
		0,
		90,
		180,
		270
	}
})
floors:registerNew({
	cost = 10,
	quad = "cream_carpet",
	pedestrianTile = true,
	id = 302,
	name = "cream_carpet",
	display = _T("CREAM_CARPET", "Cream carpet"),
	rotation = {
		0,
		90,
		180,
		270
	}
})
floors:registerNew({
	cost = 10,
	quad = "blue_carpet",
	pedestrianTile = true,
	id = 4,
	name = "blue_carpet",
	display = _T("BLUE_CARPET", "Blue carpet"),
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
	name = "grass",
	id = 5,
	display = "Grass",
	quad = {
		"grass_tile_1",
		"grass_tile_2",
		"grass_tile_3",
		"grass_tile_4"
	},
	getQuad = function(self)
		local index = math.random(1, #self.quad)
		
		return self.quad[index], self.textureID[index]
	end
})
floors:registerNew({
	cost = 0,
	display = "Dark grass",
	noPurchase = true,
	name = "dark_grass",
	id = 501,
	quad = {
		"darker_grass_1",
		"darker_grass_2",
		"darker_grass_3"
	},
	getQuad = function(self)
		local index = math.random(1, #self.quad)
		
		return self.quad[index], self.textureID[index]
	end,
	isGrass = function(self, value)
		return floors.registeredByID[value] and floors.registeredByID[value].name == "grass"
	end,
	mapAdjustPlacedTile = function(self, index, value, grid, floor)
		local left = self:isGrass(grid:getTileValue(grid:offsetIndex(index, -1, 0), floor))
		local right = self:isGrass(grid:getTileValue(grid:offsetIndex(index, 1, 0), floor))
		local up = self:isGrass(grid:getTileValue(grid:offsetIndex(index, 0, -1), floor))
		local down = self:isGrass(grid:getTileValue(grid:offsetIndex(index, 0, 1), floor))
		
		if left and down then
			return 508
		elseif left and up then
			return 509
		elseif up and right then
			return 510
		elseif right and down then
			return 507
		end
		
		if left then
			return 505
		elseif right then
			return 503
		elseif down then
			return 504
		elseif up then
			return 506
		end
		
		return value
	end,
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
	name = "dark_grass_no_sides",
	quad = "darker_grass_no_sides",
	id = 502,
	display = "Dark grass",
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
	name = "dark_grass_one_side",
	quad = "darker_grass_side",
	id = 503,
	display = "Dark grass side"
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "dark_grass_one_side_90",
	quad = "darker_grass_side",
	id = 504,
	display = "Dark grass side 90",
	rotation = {
		90
	}
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "dark_grass_one_side_180",
	quad = "darker_grass_side",
	id = 505,
	display = "Dark grass side 180",
	rotation = {
		180
	}
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "dark_grass_one_side_270",
	quad = "darker_grass_side",
	id = 506,
	display = "Dark grass side 270",
	rotation = {
		270
	}
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "dark_grass_corner",
	quad = "darker_grass_corner",
	id = 507,
	display = "Dark grass corner"
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "dark_grass_corner_90",
	quad = "darker_grass_corner",
	id = 508,
	display = "Dark grass corner 90",
	rotation = {
		90
	}
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "dark_grass_corner_180",
	quad = "darker_grass_corner",
	id = 509,
	display = "Dark grass corner 180",
	rotation = {
		180
	}
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "dark_grass_corner_270",
	quad = "darker_grass_corner",
	id = 510,
	display = "Dark grass corner",
	rotation = {
		270
	}
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "dark_grass_cup",
	quad = "darker_grass_cup",
	id = 511,
	display = "Dark grass cup"
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "darker_grass_cup_90",
	quad = "darker_grass_cup",
	id = 512,
	display = "Dark grass cup 90",
	rotation = {
		90
	}
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "darker_grass_cup_180",
	quad = "darker_grass_cup",
	id = 513,
	display = "Dark grass cup 180",
	rotation = {
		180
	}
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "darker_grass_cup_270",
	quad = "darker_grass_cup",
	id = 514,
	display = "Dark grass cup 270",
	rotation = {
		270
	}
})
floors:registerNew({
	cost = 0,
	name = "asphalt_road",
	display = "Asphalt road",
	noPurchase = true,
	surfaceType = "asphalt",
	id = 6,
	quad = {
		"asphalt_1",
		"asphalt_2",
		"asphalt_3"
	},
	getQuad = function(self)
		local index = math.random(1, #self.quad)
		
		return self.quad[index], self.textureID[index]
	end,
	rotation = {
		0,
		90,
		180,
		270
	}
})

local asphaltRotLink = {
	7,
	8
}

floors:registerNew({
	cost = 0,
	name = "asphalt_road_line",
	display = "Asphalt road",
	surfaceType = "asphalt",
	noPurchase = true,
	id = 7,
	quad = {
		"asphalt_1_line",
		"asphalt_2_line",
		"asphalt_3_line"
	},
	getQuad = function(self)
		local index = math.random(1, #self.quad)
		
		return self.quad[index], self.textureID[index]
	end,
	rotation = {
		0,
		180
	},
	rotationLink = asphaltRotLink
})
floors:registerNew({
	cost = 0,
	name = "asphalt_road_line_vert",
	display = "Asphalt road",
	surfaceType = "asphalt",
	noPurchase = true,
	id = 8,
	quad = {
		"asphalt_1_line",
		"asphalt_2_line",
		"asphalt_3_line"
	},
	getQuad = function(self)
		local index = math.random(1, #self.quad)
		
		return self.quad[index], self.textureID[index]
	end,
	rotationLink = asphaltRotLink,
	rotation = {
		90,
		270
	}
})

local sidewalkRotLink = {
	9,
	10,
	11,
	12
}

floors:registerNew({
	cost = 0,
	employeeSpawnable = true,
	noPurchase = true,
	display = "Sidewalk",
	quad = "sidewalk_asphalt_border_bottom",
	pathScore = 2,
	surfaceType = "asphalt",
	name = "sidewalk",
	pedestrianTile = true,
	id = 9,
	rotationLink = sidewalkRotLink
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	employeeSpawnable = true,
	display = "Sidewalk 90",
	quad = "sidewalk_asphalt_border_bottom",
	pathScore = 2,
	surfaceType = "asphalt",
	name = "sidewalk_90",
	pedestrianTile = true,
	id = 10,
	rotation = {
		90
	},
	rotationLink = sidewalkRotLink
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	employeeSpawnable = true,
	display = "Sidewalk 180",
	quad = "sidewalk_asphalt_border_bottom",
	pathScore = 2,
	surfaceType = "asphalt",
	name = "sidewalk_180",
	pedestrianTile = true,
	id = 11,
	rotation = {
		180
	},
	rotationLink = sidewalkRotLink
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	employeeSpawnable = true,
	display = "Sidewalk 270",
	quad = "sidewalk_asphalt_border_bottom",
	pathScore = 2,
	surfaceType = "asphalt",
	name = "sidewalk_270",
	pedestrianTile = true,
	id = 12,
	rotation = {
		270
	},
	rotationLink = sidewalkRotLink
})

local function sidewalkIsGrass(self, value)
	return floors.registeredByID[value] and floors.registeredByID[value].name == "grass"
end

local function sidewalkMapAdjustPlacedTile(self, index, value, grid, floor)
	local left = self:isGrass(grid:getTileValue(grid:offsetIndex(index, -1, 0), floor))
	local right = self:isGrass(grid:getTileValue(grid:offsetIndex(index, 1, 0), floor))
	local up = self:isGrass(grid:getTileValue(grid:offsetIndex(index, 0, -1), floor))
	local down = self:isGrass(grid:getTileValue(grid:offsetIndex(index, 0, 1), floor))
	
	if up and down and left and right then
		return 1323
	end
	
	if left and right then
		return 1322
	elseif up and down then
		return 1321
	end
	
	if left and down then
		return 1311
	elseif left and up then
		return 1312
	elseif up and right then
		return 1313
	elseif right and down then
		return 1314
	end
	
	if left then
		return 132
	elseif right then
		return 134
	elseif down then
		return 131
	elseif up then
		return 133
	end
	
	return value
end

floors:registerNew({
	cost = 0,
	noPurchase = true,
	employeeSpawnable = true,
	display = "Sidewalk (no border)",
	quad = "sidewalk_1",
	name = "sidewalk_no_border",
	surfaceType = "asphalt",
	pedestrianTile = true,
	id = 13,
	rotation = {
		0,
		90,
		180,
		270
	},
	isGrass = sidewalkIsGrass,
	mapAdjustPlacedTile = sidewalkMapAdjustPlacedTile
})
floors:registerNew({
	cost = 0,
	employeeSpawnable = true,
	display = "sidewalk grass bottom side",
	name = "sidewalk_grass_top_side",
	quad = "sidewalk_grass_one_side",
	surfaceType = "asphalt",
	noPurchase = true,
	skipEditor = true,
	pedestrianTile = true,
	id = 131,
	isGrass = sidewalkIsGrass,
	mapAdjustPlacedTile = sidewalkMapAdjustPlacedTile
})
floors:registerNew({
	cost = 0,
	employeeSpawnable = true,
	display = "sidewalk grass left side",
	name = "sidewalk_grass_top_side_90",
	quad = "sidewalk_grass_one_side",
	surfaceType = "asphalt",
	noPurchase = true,
	skipEditor = true,
	pedestrianTile = true,
	id = 132,
	isGrass = sidewalkIsGrass,
	mapAdjustPlacedTile = sidewalkMapAdjustPlacedTile,
	rotation = {
		90
	}
})
floors:registerNew({
	cost = 0,
	employeeSpawnable = true,
	display = "sidewalk grass top side",
	name = "sidewalk_grass_top_side_180",
	quad = "sidewalk_grass_one_side",
	surfaceType = "asphalt",
	noPurchase = true,
	skipEditor = true,
	pedestrianTile = true,
	id = 133,
	isGrass = sidewalkIsGrass,
	mapAdjustPlacedTile = sidewalkMapAdjustPlacedTile,
	rotation = {
		180
	}
})
floors:registerNew({
	cost = 0,
	employeeSpawnable = true,
	display = "sidewalk grass right side",
	name = "sidewalk_grass_top_side_270",
	quad = "sidewalk_grass_one_side",
	surfaceType = "asphalt",
	noPurchase = true,
	skipEditor = true,
	pedestrianTile = true,
	id = 134,
	isGrass = sidewalkIsGrass,
	mapAdjustPlacedTile = sidewalkMapAdjustPlacedTile,
	rotation = {
		270
	}
})
floors:registerNew({
	cost = 0,
	employeeSpawnable = true,
	display = "sidewalk grass bottom side",
	name = "sidewalk_grass_corner",
	quad = "sidewalk_grass_corner",
	surfaceType = "asphalt",
	noPurchase = true,
	skipEditor = true,
	pedestrianTile = true,
	id = 1311,
	isGrass = sidewalkIsGrass,
	mapAdjustPlacedTile = sidewalkMapAdjustPlacedTile
})
floors:registerNew({
	cost = 0,
	employeeSpawnable = true,
	display = "sidewalk grass bottom side",
	name = "sidewalk_grass_corner_90",
	quad = "sidewalk_grass_corner",
	surfaceType = "asphalt",
	noPurchase = true,
	skipEditor = true,
	pedestrianTile = true,
	id = 1312,
	isGrass = sidewalkIsGrass,
	mapAdjustPlacedTile = sidewalkMapAdjustPlacedTile,
	rotation = {
		90
	}
})
floors:registerNew({
	cost = 0,
	employeeSpawnable = true,
	display = "sidewalk grass bottom side",
	name = "sidewalk_grass_corner_180",
	quad = "sidewalk_grass_corner",
	surfaceType = "asphalt",
	noPurchase = true,
	skipEditor = true,
	pedestrianTile = true,
	id = 1313,
	isGrass = sidewalkIsGrass,
	mapAdjustPlacedTile = sidewalkMapAdjustPlacedTile,
	rotation = {
		180
	}
})
floors:registerNew({
	cost = 0,
	employeeSpawnable = true,
	display = "sidewalk grass bottom side",
	name = "sidewalk_grass_corner_270",
	quad = "sidewalk_grass_corner",
	surfaceType = "asphalt",
	noPurchase = true,
	skipEditor = true,
	pedestrianTile = true,
	id = 1314,
	isGrass = sidewalkIsGrass,
	mapAdjustPlacedTile = sidewalkMapAdjustPlacedTile,
	rotation = {
		270
	}
})
floors:registerNew({
	cost = 0,
	employeeSpawnable = true,
	display = "sidewalk grass two sides",
	name = "sidewalk_grass_two_sides",
	quad = "sidewalk_grass_two_sides",
	surfaceType = "asphalt",
	noPurchase = true,
	skipEditor = true,
	pedestrianTile = true,
	id = 1321,
	isGrass = sidewalkIsGrass,
	mapAdjustPlacedTile = sidewalkMapAdjustPlacedTile,
	rotation = {
		0,
		180
	}
})
floors:registerNew({
	cost = 0,
	employeeSpawnable = true,
	display = "sidewalk grass two sides 90",
	name = "sidewalk_grass_two_sides_90",
	quad = "sidewalk_grass_two_sides",
	surfaceType = "asphalt",
	noPurchase = true,
	skipEditor = true,
	pedestrianTile = true,
	id = 1322,
	isGrass = sidewalkIsGrass,
	mapAdjustPlacedTile = sidewalkMapAdjustPlacedTile,
	rotation = {
		90,
		270
	}
})
floors:registerNew({
	cost = 0,
	employeeSpawnable = true,
	display = "sidewalk grass four sides",
	name = "sidewalk_grass_four_sides",
	quad = "sidewalk_grass_four_sides",
	surfaceType = "asphalt",
	noPurchase = true,
	skipEditor = true,
	pedestrianTile = true,
	id = 1323,
	isGrass = sidewalkIsGrass,
	mapAdjustPlacedTile = sidewalkMapAdjustPlacedTile
})

local sidewalkCornerRotLink = {
	14,
	15,
	16,
	17
}

floors:registerNew({
	cost = 0,
	noPurchase = true,
	employeeSpawnable = true,
	display = "Sidewalk corner",
	quad = "sidewalk_asphalt_border_corner",
	surfaceType = "asphalt",
	name = "sidewalk_corner",
	pedestrianTile = true,
	id = 14,
	isGrass = sidewalkIsGrass,
	mapAdjustPlacedTile = sidewalkMapAdjustPlacedTile,
	rotationLink = sidewalkCornerRotLink
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	employeeSpawnable = true,
	display = "Sidewalk corner 90",
	quad = "sidewalk_asphalt_border_corner",
	surfaceType = "asphalt",
	name = "sidewalk_corner_90",
	pedestrianTile = true,
	id = 15,
	isGrass = sidewalkIsGrass,
	mapAdjustPlacedTile = sidewalkMapAdjustPlacedTile,
	rotationLink = sidewalkCornerRotLink,
	rotation = {
		90
	}
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	employeeSpawnable = true,
	display = "Sidewalk corner 180",
	quad = "sidewalk_asphalt_border_corner",
	surfaceType = "asphalt",
	name = "sidewalk_corner_180",
	pedestrianTile = true,
	id = 16,
	isGrass = sidewalkIsGrass,
	mapAdjustPlacedTile = sidewalkMapAdjustPlacedTile,
	rotationLink = sidewalkCornerRotLink,
	rotation = {
		180
	}
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	employeeSpawnable = true,
	display = "Sidewalk corner 270",
	quad = "sidewalk_asphalt_border_corner",
	surfaceType = "asphalt",
	name = "sidewalk_corner_270",
	pedestrianTile = true,
	id = 17,
	isGrass = sidewalkIsGrass,
	mapAdjustPlacedTile = sidewalkMapAdjustPlacedTile,
	rotationLink = sidewalkCornerRotLink,
	rotation = {
		270
	}
})

local sidewalkCornerRotLink = {
	18,
	19,
	20,
	21
}

floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "sidewalk_no_border_corner",
	employeeSpawnable = true,
	quad = "sidewalk_withoutborder_corner_top_down",
	display = "Sidewalk (no border) corner",
	surfaceType = "asphalt",
	pedestrianTile = true,
	id = 18,
	rotationLink = sidewalkCornerRotLink,
	isGrass = sidewalkIsGrass,
	mapAdjustPlacedTile = sidewalkMapAdjustPlacedTile
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "sidewalk_no_border_corner_90",
	employeeSpawnable = true,
	quad = "sidewalk_withoutborder_corner_top_down",
	display = "Sidewalk (no border) corner 90",
	surfaceType = "asphalt",
	pedestrianTile = true,
	id = 19,
	rotationLink = sidewalkCornerRotLink,
	isGrass = sidewalkIsGrass,
	mapAdjustPlacedTile = sidewalkMapAdjustPlacedTile,
	rotation = {
		90
	}
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "sidewalk_no_border_corner_180",
	employeeSpawnable = true,
	quad = "sidewalk_withoutborder_corner_top_down",
	display = "Sidewalk (no border) corner 180",
	surfaceType = "asphalt",
	pedestrianTile = true,
	id = 20,
	rotationLink = sidewalkCornerRotLink,
	isGrass = sidewalkIsGrass,
	mapAdjustPlacedTile = sidewalkMapAdjustPlacedTile,
	rotation = {
		180
	}
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "sidewalk_no_border_corner_270",
	employeeSpawnable = true,
	quad = "sidewalk_withoutborder_corner_top_down",
	display = "Sidewalk (no border) corner 270",
	surfaceType = "asphalt",
	pedestrianTile = true,
	id = 21,
	rotationLink = sidewalkCornerRotLink,
	isGrass = sidewalkIsGrass,
	mapAdjustPlacedTile = sidewalkMapAdjustPlacedTile,
	rotation = {
		270
	}
})
floors:registerNew({
	cost = 0,
	display = "Roof base",
	noPurchase = true,
	id = 22,
	name = "roof_base",
	rotation = {
		0,
		90,
		180,
		270
	},
	quad = {
		"roof_asphalt_middle_1",
		"roof_asphalt_middle_2",
		"roof_asphalt_middle_3"
	},
	getQuad = function(self)
		local index = math.random(1, #self.quad)
		
		return self.quad[index], self.textureID[index]
	end
})

local roofEdgeRotLink = {
	23,
	24,
	25,
	26
}

local function checkTileIndex(grid, index, tileMap, rot)
	local dir = walls.DIRECTION[rot]
	
	return tileMap[grid:offsetIndex(index, dir[1], dir[2])]
end

local function checkTileIndexManual(grid, index, tileMap, xOff, yOff)
	local dir = walls.DIRECTION[rot]
	
	return tileMap[grid:offsetIndex(index, xOff, yOff)]
end

floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "roof_edge",
	quad = "roof_asphalt_edge",
	id = 23,
	display = "Roof edge",
	rotationLink = roofEdgeRotLink,
	roofValidCheck = function(self, grid, index, tileMap)
		return not checkTileIndex(grid, index, tileMap, walls.LEFT)
	end
})
floors:registerNew({
	cost = 0,
	display = "Roof edge 90",
	noPurchase = true,
	name = "roof_edge90",
	quad = "roof_asphalt_edge_perspective",
	id = 24,
	rotation = {
		90
	},
	rotationLink = roofEdgeRotLink,
	roofValidCheck = function(self, grid, index, tileMap)
		return not checkTileIndex(grid, index, tileMap, walls.UP)
	end
})
floors:registerNew({
	cost = 0,
	display = "Roof edge 180",
	noPurchase = true,
	name = "roof_edge180",
	quad = "roof_asphalt_edge",
	id = 25,
	rotation = {
		180
	},
	rotationLink = roofEdgeRotLink,
	roofValidCheck = function(self, grid, index, tileMap)
		return not checkTileIndex(grid, index, tileMap, walls.RIGHT)
	end
})
floors:registerNew({
	cost = 0,
	display = "Roof edge 270",
	noPurchase = true,
	name = "roof_edge270",
	quad = "roof_asphalt_edge",
	id = 26,
	rotation = {
		270
	},
	rotationLink = roofEdgeRotLink,
	roofValidCheck = function(self, grid, index, tileMap)
		return not checkTileIndex(grid, index, tileMap, walls.DOWN)
	end
})

local cornerRotationLink = {
	27,
	28,
	29,
	30
}

floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "roof_corner",
	quad = "roof_asphalt_corner_perspective_2",
	id = 27,
	display = "Roof corner",
	rotationLink = cornerRotationLink,
	roofValidCheck = function(self, grid, index, tileMap)
		return not checkTileIndex(grid, index, tileMap, walls.LEFT) and not checkTileIndex(grid, index, tileMap, walls.UP)
	end
})
floors:registerNew({
	cost = 0,
	display = "Roof corner 90",
	noPurchase = true,
	name = "roof_corner90",
	quad = "roof_asphalt_corner_perspective",
	id = 28,
	rotation = {
		90
	},
	rotationLink = cornerRotationLink,
	roofValidCheck = function(self, grid, index, tileMap)
		return not checkTileIndex(grid, index, tileMap, walls.UP) and not checkTileIndex(grid, index, tileMap, walls.RIGHT)
	end
})
floors:registerNew({
	cost = 0,
	display = "Roof corner 180",
	noPurchase = true,
	name = "roof_corner180",
	quad = "roof_asphalt_corner",
	id = 29,
	rotation = {
		180
	},
	rotationLink = cornerRotationLink,
	roofValidCheck = function(self, grid, index, tileMap)
		return not checkTileIndex(grid, index, tileMap, walls.RIGHT) and not checkTileIndex(grid, index, tileMap, walls.DOWN)
	end
})
floors:registerNew({
	cost = 0,
	display = "Roof corner 270",
	noPurchase = true,
	name = "roof_corner270",
	quad = "roof_asphalt_corner",
	id = 30,
	rotation = {
		270
	},
	rotationLink = cornerRotationLink,
	roofValidCheck = function(self, grid, index, tileMap)
		return not checkTileIndex(grid, index, tileMap, walls.DOWN) and not checkTileIndex(grid, index, tileMap, walls.LEFT)
	end
})

local edgeCornerLink = {
	31,
	32,
	33,
	34
}

floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "roof_corner_edge",
	quad = "roof_asphalt_corner_edge",
	id = 31,
	display = "Roof corner edge",
	rotationLink = edgeCornerLink,
	roofValidCheck = function(self, grid, index, tileMap)
		return checkTileIndex(grid, index, tileMap, walls.LEFT) and checkTileIndex(grid, index, tileMap, walls.DOWN) and not checkTileIndexManual(grid, index, tileMap, -1, 1)
	end
})
floors:registerNew({
	cost = 0,
	display = "Roof corner edge 90",
	noPurchase = true,
	name = "roof_corner_edge90",
	quad = "roof_asphalt_corner_edge_perspective_2",
	id = 32,
	rotation = {
		180
	},
	rotationLink = edgeCornerLink,
	roofValidCheck = function(self, grid, index, tileMap)
		return checkTileIndex(grid, index, tileMap, walls.LEFT) and checkTileIndex(grid, index, tileMap, walls.UP) and not checkTileIndexManual(grid, index, tileMap, -1, -1)
	end
})
floors:registerNew({
	cost = 0,
	display = "Roof corner edge 180",
	noPurchase = true,
	name = "roof_corner_edge180",
	quad = "roof_asphalt_corner_edge_perspective",
	id = 33,
	rotation = {
		180
	},
	rotationLink = edgeCornerLink,
	roofValidCheck = function(self, grid, index, tileMap)
		return checkTileIndex(grid, index, tileMap, walls.UP) and checkTileIndex(grid, index, tileMap, walls.RIGHT) and not checkTileIndexManual(grid, index, tileMap, 1, -1)
	end
})
floors:registerNew({
	cost = 0,
	display = "Roof corner edge 270",
	noPurchase = true,
	name = "roof_corner_edge270",
	quad = "roof_asphalt_corner_edge",
	id = 34,
	rotation = {
		270
	},
	rotationLink = edgeCornerLink,
	roofValidCheck = function(self, grid, index, tileMap)
		return checkTileIndex(grid, index, tileMap, walls.RIGHT) and checkTileIndex(grid, index, tileMap, walls.DOWN) and not checkTileIndexManual(grid, index, tileMap, 1, 1)
	end
})

local edgeRotLink = {
	35,
	351,
	36,
	361
}

floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "roof_edge_line",
	quad = "roof_asphalt_edge_line",
	id = 35,
	display = "Roof corner line",
	rotationLink = edgeRotLink
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "roof_edge_line90",
	quad = "roof_asphalt_edge_line",
	id = 351,
	display = "Roof corner line 90",
	rotation = {
		90
	},
	rotationLink = edgeRotLink
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "roof_edge_line180",
	quad = "roof_asphalt_edge_line",
	id = 36,
	scaleX = -2,
	display = "Roof corner line 180",
	rotationLink = edgeRotLink
})
floors:registerNew({
	cost = 0,
	name = "roof_edge_line270",
	display = "Roof corner line 270",
	noPurchase = true,
	quad = "roof_asphalt_edge_line",
	id = 361,
	scaleX = -2,
	rotation = {
		90
	},
	rotationLink = edgeRotLink
})

local lineRotLink = {
	37,
	371,
	372,
	373
}

floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "roof_middle_line",
	quad = "roof_asphalt_middle_line",
	id = 37,
	display = "Roof corner line",
	rotationLink = lineRotLink
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "roof_middle_line90",
	quad = "roof_asphalt_middle_line",
	id = 371,
	display = "Roof corner line 90",
	rotation = {
		90
	},
	rotationLink = lineRotLink
})
floors:registerNew({
	cost = 0,
	noPurchase = true,
	name = "roof_middle_line 180",
	quad = "roof_asphalt_middle_line",
	id = 372,
	scaleX = -2,
	display = "Roof corner line 180",
	rotationLink = lineRotLink
})
floors:registerNew({
	cost = 0,
	name = "roof_middle_line 270",
	display = "Roof corner line 270",
	noPurchase = true,
	quad = "roof_asphalt_middle_line",
	id = 373,
	scaleX = -2,
	rotation = {
		90
	},
	rotationLink = lineRotLink
})
floors:registerNew({
	cost = 0,
	name = "road_pedestrian_crossing",
	display = "Pedestrian crossing",
	noPurchase = true,
	surfaceType = "asphalt",
	pedestrianTile = true,
	id = 39,
	quad = {
		"asphalt_1_pedestrian_crossing",
		"asphalt_2_pedestrian_crossing",
		"asphalt_3_pedestrian_crossing"
	},
	getQuad = function(self)
		local index = math.random(1, #self.quad)
		
		return self.quad[index], self.textureID[index]
	end,
	rotation = {
		0,
		180
	}
})
floors:registerNew({
	cost = 0,
	name = "road_pedestrian_crossing_90",
	display = "Pedestrian crossing 90",
	noPurchase = true,
	surfaceType = "asphalt",
	pedestrianTile = true,
	id = 40,
	quad = {
		"asphalt_1_pedestrian_crossing",
		"asphalt_2_pedestrian_crossing",
		"asphalt_3_pedestrian_crossing"
	},
	getQuad = function(self)
		local index = math.random(1, #self.quad)
		
		return self.quad[index], self.textureID[index]
	end,
	rotation = {
		90,
		270
	}
})
require("game/world/floor_dirt")
floors:registerNew({
	cost = 10,
	quad = "floor_linoleum",
	pedestrianTile = true,
	id = 42,
	name = "linoleum",
	surfaceType = "tile",
	display = _T("FLOOR_LINOLEUM", "Linoleum")
})
