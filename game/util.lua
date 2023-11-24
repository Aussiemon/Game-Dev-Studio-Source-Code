util.defaultLOSCheckDist = 50

local function dummyIterationCallback(index, curX, curY, wallSides)
end

local curIterFloor

local function defaultWallCheckCallback(grid, index, wallSide)
	return grid:hasWall(index, curIterFloor, wallSide)
end

function util.los(startX, startY, endX, endY, floorID, dist, noConversion, iterationCallback, wallCheckCallback)
	dist = dist or util.defaultLOSCheckDist
	iterationCallback = iterationCallback or dummyIterationCallback
	wallCheckCallback = wallCheckCallback or defaultWallCheckCallback
	
	local startGridX, startGridY, endGridX, endGridY
	
	curIterFloor = floorID
	
	if noConversion then
		startGridX = startX
		startGridY = startY
		endGridX = endX
		endGridY = endY
	else
		startGridX = math.ceil(startX / game.WORLD_TILE_WIDTH)
		startGridY = math.ceil(startY / game.WORLD_TILE_HEIGHT)
		endGridX = math.ceil(endX / game.WORLD_TILE_WIDTH)
		endGridY = math.ceil(endY / game.WORLD_TILE_HEIGHT)
	end
	
	if startX == endX and endY == startY then
		return true
	end
	
	local floor, lerp, normal, round = math.floor, math.lerp, math.normal, math.round
	local stepX, stepY, stepCount = math.linearDirection(startGridX, startGridY, endGridX, endGridY)
	
	if stepX ~= stepX or stepY ~= stepY then
		return true
	end
	
	local singleX, singleY = round(stepX), round(stepY)
	local wallSides = walls:getSideFromDirection(singleX, singleY)
	local tileGrid = game.worldObject:getFloorTileGrid()
	
	for i = 0, stepCount do
		local curStep = i / stepCount
		local curX, curY = floor(lerp(startGridX, endGridX, curStep)), floor(lerp(startGridY, endGridY, curStep))
		local nextStep = (i + 1) / stepCount
		local nextX, nextY = floor(lerp(startGridX, endGridX, nextStep)), floor(lerp(startGridY, endGridY, nextStep))
		
		if curX ~= nextX or curY ~= nextY then
			local stepX, stepY = normal(nextX - curX, nextY - curY)
			local singleX, singleY = round(stepX), round(stepY)
			local index = tileGrid:getTileIndex(curX, curY)
			
			if iterationCallback(index, curX, curY, wallSides) == false then
				return false
			end
			
			if curX == endGridX and curY == endGridY then
				return true
			end
			
			if tileGrid:outOfBounds(nextX, nextY) then
				return false
			end
			
			local wallSides = walls:getSideFromDirection(singleX, singleY)
			
			for key, wallSide in ipairs(wallSides) do
				if wallCheckCallback(tileGrid, index, wallSide) then
					return false
				end
			end
			
			local wallSides = walls:getSideFromDirection(-singleX, -singleY)
			
			for key, wallSide in ipairs(wallSides) do
				if wallCheckCallback(tileGrid, tileGrid:getTileIndex(nextX, nextY), wallSide) then
					return false
				end
			end
		end
	end
	
	return false
end

local eventlist = {}
local seentable = {}

function util.dumpeventlist()
	util._dumpeventlist(nil, _G)
	
	for key, tbl in pairs(_G) do
		if key ~= "events" and key ~= "love" and key ~= "package" and key ~= "mtindex" and key ~= "MODENV" and type(tbl) == "table" then
			util._dumpeventlist(key, tbl)
		end
	end
	
	local numericList = {}
	
	for key, list in pairs(eventlist) do
		table.insert(numericList, list)
	end
	
	local finalString = ""
	
	for key, list in ipairs(numericList) do
		for key, event in ipairs(list) do
			finalString = finalString .. event .. "\n"
		end
		
		finalString = finalString .. "\n"
	end
	
	love.system.setClipboardText(finalString)
	table.clear(seentable)
	table.clear(eventlist)
	print("copied all found events to clipboard, paste it to a text file somewhere")
end

function util._dumpeventlist(name, tbl)
	if name == "events" or name == "love" or name == "package" or name == "mtindex" or name == "MODENV" then
		return 
	end
	
	local concatName = name
	
	if concatName == "_G" then
		concatName = nil
	end
	
	for key, value in pairs(tbl) do
		if type(value) == "table" then
			if value.EVENTS then
				eventlist[key] = {}
				
				for eventName, value in pairs(value.EVENTS) do
					local text
					
					if concatName then
						text = concatName .. "." .. key .. "." .. "EVENTS" .. "." .. eventName
					else
						text = key .. "." .. "EVENTS" .. "." .. eventName
					end
					
					table.insert(eventlist[key], text)
				end
			elseif not seentable[value] then
				seentable[value] = true
				
				if concatName then
					util._dumpeventlist(concatName .. "." .. tostring(key), value)
				else
					util._dumpeventlist(tostring(key), value)
				end
			end
		end
	end
end
