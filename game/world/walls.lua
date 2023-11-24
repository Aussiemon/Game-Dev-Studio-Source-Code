walls = {}
walls.registered = {}
walls.registeredByID = {}
walls.penetrationByID = {}
walls.purchasable = {}
walls.wallTypes = {}
walls.wallTypesByValue = {}
walls.wallTypesNumeric = {}
walls.usedTextureMap = {}
walls.allUsedTextures = {}
walls.UP = 1
walls.RIGHT = 2
walls.DOWN = 4
walls.LEFT = 8
walls.ORDER = {
	walls.UP,
	walls.RIGHT,
	walls.DOWN,
	walls.LEFT
}
walls.COUNT = #walls.ORDER
walls.ROTATION_TO_ORDER = {
	[walls.UP] = 1,
	[walls.RIGHT] = 2,
	[walls.DOWN] = 3,
	[walls.LEFT] = 4
}
walls.BORDER_WALL_DIRECTIONS = {
	walls.RIGHT,
	walls.DOWN,
	walls.LEFT
}
walls.VERTICAL_SIDES = {
	[walls.LEFT] = true,
	[walls.RIGHT] = true
}
walls.HORIZONTAL_SIDES = {
	[walls.UP] = true,
	[walls.DOWN] = true
}
walls.INVERSE_RELATION = {
	[0] = 0,
	[walls.UP] = walls.DOWN,
	[walls.DOWN] = walls.UP,
	[walls.RIGHT] = walls.LEFT,
	[walls.LEFT] = walls.RIGHT
}
walls.RIGHT_SIDE = {
	[walls.UP] = walls.RIGHT,
	[walls.RIGHT] = walls.DOWN,
	[walls.DOWN] = walls.LEFT,
	[walls.LEFT] = walls.UP
}
walls.LEFT_SIDE = {
	[walls.UP] = walls.LEFT,
	[walls.RIGHT] = walls.UP,
	[walls.DOWN] = walls.RIGHT,
	[walls.LEFT] = walls.DOWN
}
walls.DIRECTION = {
	[walls.UP] = {
		0,
		-1
	},
	[walls.RIGHT] = {
		1,
		0
	},
	[walls.DOWN] = {
		0,
		1
	},
	[walls.LEFT] = {
		-1,
		0
	}
}
walls.ANGLES = {
	[walls.UP] = 0,
	[walls.RIGHT] = math.rad(90),
	[walls.DOWN] = math.rad(180),
	[walls.LEFT] = math.rad(270)
}
walls.DIAGONAL_EDGE_OFFSETS = {
	[walls.UP] = {
		-1,
		-1
	},
	[walls.RIGHT] = {
		1,
		-1
	},
	[walls.DOWN] = {
		1,
		1
	},
	[walls.LEFT] = {
		-1,
		1
	}
}
walls.T_SHAPE_ROTATION = {
	[walls.UP] = {
		walls.DOWN,
		walls.RIGHT
	},
	[walls.RIGHT] = {
		walls.DOWN,
		walls.LEFT
	},
	[walls.DOWN] = {
		walls.UP,
		walls.LEFT
	},
	[walls.LEFT] = {
		walls.RIGHT,
		walls.UP
	}
}
walls.RAW_ANGLES = {
	[walls.UP] = 0,
	[walls.RIGHT] = 90,
	[walls.DOWN] = 180,
	[walls.LEFT] = 270
}
walls.DEFAULT_UP = {
	rot = 0,
	y = -12,
	scaleX = 1,
	x = 0,
	scaleY = 1
}
walls.DEFAULT_LEFT = {
	y = 0,
	scaleX = 1,
	x = 48,
	scaleY = 1,
	rot = math.rad(90)
}
walls.DEFAULT_DOWN = {
	y = 36,
	scaleX = 1,
	x = 48,
	scaleY = -1,
	rot = math.rad(180)
}
walls.DEFAULT_RIGHT = {
	y = 48,
	scaleX = 1,
	x = 0,
	scaleY = 1,
	rot = math.rad(270)
}
walls.DEFAULT_CORNER_UP = {
	rot = 0,
	y = -8,
	scaleX = 1,
	x = 0,
	scaleY = -1
}
walls.DEFAULT_CORNER_LEFT = {
	y = -8,
	scaleX = 1,
	x = 48,
	scaleY = 1,
	rot = math.rad(90)
}
walls.DEFAULT_CORNER_DOWN = {
	y = 36,
	scaleX = 1,
	x = 48,
	scaleY = 1,
	rot = math.rad(180)
}
walls.DEFAULT_CORNER_RIGHT = {
	y = 36,
	scaleX = 1,
	x = 0,
	scaleY = 1,
	rot = math.rad(270)
}
walls.CORNER_TOP_LEFT = 1
walls.CORNER_TOP_RIGHT = 2
walls.CORNER_BOTTOM_RIGHT = 4
walls.CORNER_BOTTOM_LEFT = 8
walls.CORNER_DIRECTION = {
	[walls.CORNER_TOP_LEFT] = {
		-1,
		-1
	},
	[walls.CORNER_TOP_RIGHT] = {
		1,
		-1
	},
	[walls.CORNER_BOTTOM_RIGHT] = {
		1,
		1
	},
	[walls.CORNER_BOTTOM_LEFT] = {
		-1,
		1
	}
}
walls.ROTATION_TO_ID = {
	[walls.UP] = 0,
	[walls.RIGHT] = 1,
	[walls.DOWN] = 2,
	[walls.LEFT] = 3
}
walls.ID_TO_ROTATION = {
	[0] = walls.UP,
	walls.RIGHT,
	walls.DOWN,
	walls.LEFT
}
walls.ROTATION_NUMBERS = {
	walls.UP,
	walls.RIGHT,
	walls.DOWN,
	walls.LEFT
}
walls.ALL_ROTATIONS = walls.ROTATION_NUMBERS
walls.ROTATIONS = {
	[walls.UP] = walls.DEFAULT_UP,
	[walls.RIGHT] = walls.DEFAULT_LEFT,
	[walls.DOWN] = walls.DEFAULT_DOWN,
	[walls.LEFT] = walls.DEFAULT_RIGHT
}
walls.CORNER_ROTATIONS = {
	[walls.UP] = walls.DEFAULT_CORNER_UP,
	[walls.RIGHT] = walls.DEFAULT_CORNER_LEFT,
	[walls.DOWN] = walls.DEFAULT_CORNER_DOWN,
	[walls.LEFT] = walls.DEFAULT_CORNER_RIGHT
}
walls.FLOOR_WALL_UPDATE = {
	walls.DIRECTION[walls.DOWN],
	walls.DIRECTION[walls.LEFT],
	walls.DIRECTION[walls.RIGHT]
}
walls.DEFAULT_WALL_COMBOS = {}

for i = 1, 15 do
	walls.DEFAULT_WALL_COMBOS[i] = {}
	
	for rotation, config in pairs(walls.ROTATIONS) do
		if bit.band(i, rotation) == rotation then
			config.direction = rotation
			
			table.insert(walls.DEFAULT_WALL_COMBOS[i], config)
		end
	end
end

local defaultWallConfig = {}

defaultWallConfig.mtindex = {
	__index = defaultWallConfig
}
defaultWallConfig.wallCombinations = walls.DEFAULT_WALL_COMBOS
defaultWallConfig.canPassThrough = false
defaultWallConfig.bothSides = false
defaultWallConfig.visible = true
defaultWallConfig.enclosesTile = false
defaultWallConfig.stopsLight = true
defaultWallConfig.canSell = true

function defaultWallConfig:canPlace(x, y, floor, rotation)
	return true
end

function walls:registerWallType(name)
	local count = table.count(walls.wallTypes) + 1
	
	walls.wallTypes[name] = count
	walls.wallTypesByValue[count] = name
	walls.wallTypesNumeric[#walls.wallTypesNumeric + 1] = count
end

function walls:_logUsedtexture(quad)
	local texture = quadLoader:getQuadTexture(quad)
	local imageID = cache.getImageID(texture)
	
	if not self.usedTextureMap[texture] then
		self.usedTextureMap[texture] = true
		
		table.insert(self.allUsedTextures, texture)
	end
	
	return imageID
end

walls:registerWallType("NONE")
walls:registerWallType("WALL")
walls:registerWallType("WINDOW")

if MAIN_THREAD then
	local peekTexID = cache.getImageID(quadLoader:getQuadTexture("floor_peek_down"))
	
	floors.peekPositions = {
		{
			h = 4,
			w = 52,
			y = -2,
			x = -2,
			side = walls.UP,
			offset = walls.DIRECTION[walls.UP],
			quad = quadLoader:load("floor_peek_down"),
			quadBack = quadLoader:load("floor_peek_down_continuous"),
			quadFront = quadLoader:load("floor_peek_down_front"),
			textureID = peekTexID
		},
		{
			h = 52,
			w = 4,
			y = 0,
			x = 42,
			side = walls.RIGHT,
			offset = walls.DIRECTION[walls.RIGHT],
			quad = quadLoader:load("floor_peek_left"),
			quadBack = quadLoader:load("floor_peek_left_continuous"),
			textureID = peekTexID
		},
		{
			x = -2,
			h = 4,
			y = 46,
			w = 52,
			side = walls.DOWN,
			offset = walls.DIRECTION[walls.DOWN],
			quad = quadLoader:load("floor_peek_up"),
			textureID = peekTexID
		},
		{
			w = 2,
			y = 0,
			h = 48,
			x = -2,
			side = walls.LEFT,
			offset = walls.DIRECTION[walls.LEFT],
			quad = quadLoader:load("floor_peek_right"),
			textureID = peekTexID,
			quadLoader:load("floor_peek_right_continuous")
		}
	}
end

function walls:registerNew(data)
	table.insert(walls.registered, data)
	
	walls.registeredByID[data.id] = data
	data.lightPenetration = data.lightPenetration or 0
	walls.penetrationByID[data.id] = data.lightPenetration
	data.type = data.type or walls.wallTypes.WALL
	
	if MAIN_THREAD then
		data.quadName = data.quad
		
		if data.quad then
			data.quadTexID = self:_logUsedtexture(data.quad)
			data.quad = quadLoader:load(data.quad)
			data.southernWall = data.southernWall or "brick_wall_southern"
			data.southernQuadTexID = self:_logUsedtexture(data.southernWall)
			data.southernQuad = quadLoader:load(data.southernWall)
			data.southernWallCorner = data.southernWallCorner or "brick_wall_southern_corner"
			data.southernWallCornerQuadTexID = self:_logUsedtexture(data.southernWallCorner)
			data.southernWallCornerQuad = quadLoader:load(data.southernWallCorner)
		end
		
		if data.cornerQuad then
			data.cornerTexID = self:_logUsedtexture(data.cornerQuad)
			data.cornerQuad = quadLoader:load(data.cornerQuad)
			data.cornerW, data.cornerH = data.cornerQuad:getSize()
		end
		
		if data.horizontalTopSide then
			data.horTopTexID = self:_logUsedtexture(data.horizontalTopSide)
			data.horizontalTopSide = quadLoader:load(data.horizontalTopSide)
		end
		
		if data.horizontalVaryingSide then
			data.horVarTexID = self:_logUsedtexture(data.horizontalVaryingSide)
			data.horizontalVaryingSide = quadLoader:load(data.horizontalVaryingSide)
		end
		
		if not data.noPurchase then
			walls.purchasable[#walls.purchasable + 1] = data
		end
	end
	
	setmetatable(data, defaultWallConfig.mtindex)
end

function walls:initializeCollection(collection, baseID, spriteCount, priority)
	for key, textureObject in ipairs(self.allUsedTextures) do
		local sb = spriteBatchController:newSpriteBatch(baseID .. "_" .. tostring(textureObject), textureObject, spriteCount, "dynamic", priority, false, true, true, true)
		
		collection:addSpriteBatch(sb, priority)
	end
end

function walls:getRenderPosition(gridX, gridY, rotation)
	local offsetData = self.ROTATIONS[rotation]
	
	return math.round(gridX * game.WORLD_TILE_WIDTH + offsetData.x - game.WORLD_TILE_WIDTH), gridY * game.WORLD_TILE_HEIGHT + offsetData.y - game.WORLD_TILE_HEIGHT, offsetData.rot
end

walls.DIRECTION_TO_WALL_SIDE = {
	[-1] = {
		[-1] = {
			walls.LEFT,
			walls.UP
		},
		[0] = {
			walls.LEFT
		},
		{
			walls.LEFT,
			walls.DOWN
		}
	},
	[0] = {
		[-1] = {
			walls.UP
		},
		{
			walls.DOWN
		}
	},
	{
		[-1] = {
			walls.UP,
			walls.RIGHT
		},
		[0] = {
			walls.RIGHT
		},
		{
			walls.RIGHT,
			walls.DOWN
		}
	}
}

function walls:getSideFromDirection(xDir, yDir)
	if not walls.DIRECTION_TO_WALL_SIDE[xDir] or not walls.DIRECTION_TO_WALL_SIDE[xDir][yDir] then
		print(xDir, yDir, debug.traceback())
	end
	
	return walls.DIRECTION_TO_WALL_SIDE[xDir][yDir]
end

function walls:getSideFromAngle(angle)
	if angle > 45 and angle <= 135 then
		return walls.RIGHT
	elseif angle > 135 and angle <= 225 then
		return walls.UP
	elseif angle > 225 and angle <= 315 then
		return walls.LEFT
	else
		return walls.DOWN
	end
end

local rotations = {}

function walls:getRotations(wallContents)
	table.clearArray(rotations)
	
	for key, rotation in ipairs(walls.ORDER) do
		if bit.band(wallContents, rotation) == rotation then
			rotations[#rotations + 1] = rotation
		end
	end
	
	return rotations
end

function walls:canPassThrough(id)
	return walls.registeredByID[id].canPassThrough
end

function walls:enclosesTile(id)
	return walls.registeredByID[id].enclosesTile
end

function walls:stopsLight(id)
	return walls.registeredByID[id].stopsLight
end

function walls:canSell(id)
	return walls.registeredByID[id].canSell
end

function walls:canPlace(id, x, y, floor, rotation)
	return walls.registeredByID[id]:canPlace(x, y, floor, rotation)
end

function walls:getData(id)
	return walls.registeredByID[id]
end

function walls:getWallType(id)
	return walls.registeredByID[id].type
end

walls:registerNew({
	cost = 100,
	name = "brick_wall",
	horizontalTopSide = "brick_wall_top_side",
	quad = "brick_wall",
	menuDisplayQuad = "brick_wall_menu_view",
	cornerQuad = "brick_corner",
	id = 1,
	horizontalVaryingSide = "brick_wall_southern_varying_sides",
	display = _T("BRICK_WALL", "Brick wall"),
	cornerRotations = {
		[walls.CORNER_TOP_RIGHT] = {
			rot = 0,
			x = 48,
			y = -8
		},
		[walls.CORNER_BOTTOM_RIGHT] = {
			x = 56,
			y = 48,
			rot = math.rad(90)
		},
		[walls.CORNER_BOTTOM_LEFT] = {
			x = 0,
			y = 56,
			rot = math.rad(180)
		},
		[walls.CORNER_TOP_LEFT] = {
			x = -8,
			y = 0,
			rot = math.rad(270)
		}
	}
})
walls:registerNew({
	cost = 100,
	name = "plaster_wall",
	southernWall = "wall_plaster_southern",
	quad = "wall_plaster",
	horizontalTopSide = "plaster_wall_top_side",
	southernWallCorner = "plaster_wall_southern_corner",
	menuDisplayQuad = "plaster_wall_menu_view",
	cornerQuad = "plaster_corner",
	id = 2,
	horizontalVaryingSide = "plaster_wall_southern_varying_sides",
	display = _T("PLASTER_WALL", "Plaster wall"),
	cornerRotations = {
		[walls.CORNER_TOP_RIGHT] = {
			rot = 0,
			x = 48,
			y = -8
		},
		[walls.CORNER_BOTTOM_RIGHT] = {
			x = 56,
			y = 48,
			rot = math.rad(90)
		},
		[walls.CORNER_BOTTOM_LEFT] = {
			x = 0,
			y = 56,
			rot = math.rad(180)
		},
		[walls.CORNER_TOP_LEFT] = {
			x = -8,
			y = 0,
			rot = math.rad(270)
		}
	}
})
walls:registerNew({
	cost = 100,
	name = "window",
	southernWall = "wall_window_southern",
	quad = "wall_window",
	id = 3,
	southernWallCorner = "wall_window_southern_corner",
	cornerQuad = "window_corner",
	bothSides = true,
	noGrass = true,
	lightPenetration = 0.95,
	menuDisplayQuad = "glass_wall_menu_view",
	type = walls.wallTypes.WINDOW,
	display = _T("WINDOW", "Window"),
	cornerRotations = {
		[walls.CORNER_TOP_RIGHT] = {
			rot = 0,
			x = 48,
			y = -8
		},
		[walls.CORNER_BOTTOM_RIGHT] = {
			x = 56,
			y = 48,
			rot = math.rad(90)
		},
		[walls.CORNER_BOTTOM_LEFT] = {
			x = 0,
			y = 56,
			rot = math.rad(180)
		},
		[walls.CORNER_TOP_LEFT] = {
			x = -8,
			y = 0,
			rot = math.rad(270)
		}
	}
})
walls:registerNew({
	cost = 100,
	noPurchase = true,
	canSell = false,
	canPassThrough = true,
	display = "no wall",
	id = 0,
	name = "no_wall",
	stopsLight = false,
	visible = false,
	lightPenetration = 1,
	type = walls.wallTypes.NONE
})
walls:registerNew({
	cost = 100,
	noPurchase = true,
	southernWall = "invisible_wall_southern",
	id = 1000,
	quad = "invisible_wall",
	canPassThrough = true,
	name = "door_wall",
	enclosesTile = true,
	display = "door wall",
	canSell = false,
	lightPenetration = 0.6,
	noCorners = true
})
walls:registerNew({
	cost = 100,
	noPurchase = true,
	canSell = false,
	name = "door_wall_l1",
	quad = "invisible_wall",
	canPassThrough = true,
	display = "door wall l1",
	enclosesTile = true,
	id = 1001,
	lightPenetration = 0.7,
	noCorners = true
})
walls:registerNew({
	cost = 100,
	noPurchase = true,
	canSell = false,
	name = "door_wall_l2",
	quad = "invisible_wall",
	canPassThrough = true,
	display = "door wall l2",
	enclosesTile = true,
	id = 1002,
	lightPenetration = 0.8,
	noCorners = true
})
walls:registerNew({
	cost = 100,
	noPurchase = true,
	canSell = false,
	name = "door_wall_l3",
	quad = "invisible_wall",
	canPassThrough = true,
	display = "door wall l3",
	enclosesTile = true,
	id = 1003,
	lightPenetration = 0.9,
	noCorners = true
})
walls:registerNew({
	cost = 100,
	noPurchase = true,
	southernWall = "invisible_wall_southern",
	id = 1004,
	quad = "invisible_wall",
	canPassThrough = true,
	name = "door_wall_l4",
	enclosesTile = true,
	display = "door wall l4",
	canSell = false,
	lightPenetration = 1,
	noCorners = true
})

walls.MOVING_DOOR_TILES = {
	1001,
	1002,
	1003,
	1004
}
