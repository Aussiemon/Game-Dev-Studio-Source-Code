local math = math
local freeCollisionDatas = {}
local maxFreeCollisionDatas = 20

collision = {}
collision.mtindex = {
	__index = collision
}

local function defaultFilterFunc(self, x, y)
	if canCollideWithWorld(x, y) then
		return true
	end
	
	return false
end

function collision.new(width, height)
	width = width or 20
	height = height or 20
	
	local collisionInstance
	
	if #freeCollisionDatas > 0 then
		collisionInstance = freeCollisionDatas[#freeCollisionDatas]
		freeCollisionDatas[#freeCollisionDatas] = nil
	else
		collisionInstance = {}
		
		setmetatable(collisionInstance, collision.mtindex)
	end
	
	collisionInstance.width = width
	collisionInstance.height = height
	
	collisionInstance:initStockVariables()
	
	return collisionInstance
end

function collision:remove()
	if #freeCollisionDatas < maxFreeCollisionDatas then
		freeCollisionDatas[#freeCollisionDatas + 1] = self
	end
end

function collision:setHost(host)
	self.host = host
end

function collision:setFilterFunc(func)
	self.filterFunc = func
end

function collision:initStockVariables()
	self.xVel = 0
	self.yVel = 0
	self.broadPhaseMinX = 0
	self.broadPhaseMaxX = 0
	self.broadPhaseMinY = 0
	self.broadPhaseMaxY = 0
	self.filterFunc = defaultFilterFunc
end

function collision:setFilterFunc(func)
	self.filterFunc = func
end

function collision:setWidth(width)
	width = width or 20
	self.width = 20
end

function collision:setHeight(height)
	height = height or 20
	self.height = height
end

function collision:setupBlockSize()
	self.blockWidth = math.ceil(self.width / self.tileW)
	self.blockHeight = math.ceil(self.height / self.tileH)
end

function collision:setSize(width, height)
	self.width = width
	self.height = height
	
	self:setupBlockSize()
end

function collision:setTileSize(width, height)
	self.tileW = width
	self.tileH = height
end

function collision:setGridSize(gridW, gridH)
	self.gridW = gridW
	self.gridH = gridH
end

function collision:getTargetPosition(xVel, yVel)
end

function collision:setVelocity(xVel, yVel)
	self.xVel = xVel
	self.yVel = yVel
end

function collision:getBroadPhase(startX, startY, stepX, stepY)
	if stepX > 0 then
		self.broadPhaseMinX = startX
		self.broadPhaseMaxX = startX + self.width + stepX
	else
		self.broadPhaseMinX = startX - stepX
		self.broadPhaseMaxX = startX + self.width
	end
	
	if stepY > 0 then
		self.broadPhaseMinY = startY
		self.broadPhaseMaxY = startY + self.height + stepY
	else
		self.broadPhaseMinY = startY - stepY
		self.broadPhaseMaxY = startY + self.height
	end
end

function collision:setObjectSize(width, height)
	self.objWidth = width
	self.objHeight = height
end

function collision:isWithinBroadPhase(x, y, xMax, yMax)
	return math.ccaabb(self.broadPhaseMinX, self.broadPhaseMinY, x, y, self.broadPhaseMaxX, self.broadPhaseMaxY, xMax, yMax)
end

function collision:process(objX, objY, dt)
	return self:iterateWorld(objX, objY, dt)
end

function collision:processObject(obj1, obj2, dt)
	self:setObjectSize(obj2.width, obj2.height)
	
	return self:iterateObject(obj1, obj2, dt)
end

function collision:iterateWorld(objX, objY, dt)
	local tileW, tileH = self.tileW, self.tileH
	
	self:setObjectSize(self.tileW, self.tileH)
	
	local finalEntryTime = 1
	local finalX, finalY = 0, 0
	local finalNormalX, finalNormalY = 0, 0
	local stepX = self.xVel * dt
	local stepY = self.yVel * dt
	
	self:getBroadPhase(objX, objY, stepX, stepY)
	
	local objMaxX = objX + self.width
	local objMaxY = objY + self.height
	local grid_start_x = math.ceil(objX / tileW)
	local grid_start_y = math.ceil(objY / tileH)
	local grid_size_x = self.blockWidth
	local grid_size_y = self.blockHeight
	local vel_x_grid_size
	
	if stepX >= 0 then
		vel_x_grid_size = math.ceil(stepX / tileW)
	else
		vel_x_grid_size = math.floor(stepX / tileW)
	end
	
	local vel_y_grid_size
	
	if stepY >= 0 then
		vel_y_grid_size = math.ceil(stepY / tileH)
	else
		vel_y_grid_size = math.floor(stepY / tileH)
	end
	
	local xStart = math.min(grid_start_x - grid_size_x, grid_start_x - grid_size_x + vel_x_grid_size)
	local yStart = math.min(grid_start_y - grid_size_y, grid_start_y - grid_size_y + vel_y_grid_size)
	local xEnd = math.max(grid_start_x + grid_size_x, grid_start_x + grid_size_x + vel_x_grid_size)
	local yEnd = math.max(grid_start_y + grid_size_y, grid_start_y + grid_size_y + vel_y_grid_size)
	local gridW, gridH = self.gridW, self.gridH
	
	xStart = math.clamp(xStart, 1, gridW)
	xEnd = math.clamp(xEnd, 1, gridW)
	yStart = math.clamp(yStart, 1, gridH)
	yEnd = math.clamp(yEnd, 1, gridH)
	
	for X = xStart, xEnd do
		for Y = yStart, yEnd do
			if self:filterFunc(X, Y) then
				local blockX, blockY = X * tileW - tileW, Y * tileH - tileH
				local blockMaxX = blockX + tileW
				local blockMaxY = blockY + tileH
				
				if self:isWithinBroadPhase(blockX, blockY, blockMaxX, blockMaxY) then
					local normalX, normalY, entryTime = self:performSweep(objX, objY, objMaxX, objMaxY, blockX, blockY, blockMaxX, blockMaxY, stepX, stepY)
					
					if entryTime < finalEntryTime then
						finalEntryTime = entryTime
						finalNormalX = normalX
						finalNormalY = normalY
						finalX = blockX
						finalY = blockY
					end
				end
			end
		end
	end
	
	return finalNormalX, finalNormalY, finalEntryTime, finalX, finalY
end

function collision:performSweep(objX, objY, objMaxX, objMaxY, blockX, blockY, blockMaxX, blockMaxY, stepX, stepY)
	return self:sweep(objX, objY, objMaxX, objMaxY, blockX, blockY, blockMaxX, blockMaxY, stepX, stepY)
end

function collision:iterateObject(obj1, obj2, stepX, stepY, dt, setBroadphase)
	local ourX, ourY = obj1:getCollisionPos()
	local theirX, theirY = obj2:getCollisionPos()
	local ourW, ourH = obj1:getCollisionSize()
	local theirW, theirH = obj2:getCollisionSize()
	local ourMaxX, ourMaxY = ourX + ourW, ourY + ourH
	local theirMaxX, theirMaxY = theirX + theirW, theirY + theirH
	
	stepX = stepX or self.xVel * dt
	stepY = stepY or self.yVel * dt
	
	return self:sweep(ourX, ourY, ourMaxX, ourMaxY, theirX, theirY, theirMaxX, theirMaxY, stepX, stepY)
end

function collision:iterateObjects(obj1, list, dt)
	obj1 = obj1 or self.host
	
	if not obj1 then
		print("no host object")
		
		return 
	end
	
	local stepX = self.xVel * dt
	local stepY = self.yVel * dt
	local finalEntryTime = 1
	local finalNormalX, finalNormalY = 0, 0
	local finalObj
	
	for key, obj2 in ipairs(list) do
		local can = true
		
		if self.host.owner and self.host.owner == obj2 then
			can = false
		end
		
		if can and obj1 ~= obj2 then
			local w, h = obj2:getCollisionSize()
			
			self:setObjectSize(w, h)
			
			local normalX, normalY, entryTime = self:iterateObject(obj1, obj2, stepX, stepY, dt)
			
			if normalX and entryTime < finalEntryTime then
				finalEntryTime = entryTime
				finalNormalX = normalX
				finalNormalY = normalY
				finalObj = obj2
			end
		end
	end
	
	return finalObj, finalEntryTime, finalNormalX, finalNormalY
end

function collision:sweep(objX, objY, objMaxX, objMaxY, blockX, blockY, blockMaxX, blockMaxY, stepX, stepY)
	local xInvEntry, yInvEntry, xInvExit, yInvExit, xEntry, yEntry, xExit, yExit
	local normalX, normalY = 0, 0
	local entryTime, exitTime = 1, 1
	local finalEntryTime, finalExitTime = 1, 1
	
	if stepX > 0 then
		xInvEntry = blockX - objMaxX
		xInvExit = blockMaxX - objX
	else
		xInvEntry = blockMaxX - objX
		xInvExit = blockX - objMaxX
	end
	
	if stepY > 0 then
		yInvEntry = blockY - objMaxY
		yInvExit = blockMaxY - objY
	else
		yInvEntry = blockMaxY - objY
		yInvExit = blockY - objMaxY
	end
	
	if stepX == 0 then
		xEntry = -math.huge
		xExit = math.huge
	else
		xEntry = xInvEntry / stepX
		xExit = xInvExit / stepX
	end
	
	if stepY == 0 then
		yEntry = -math.huge
		yExit = math.huge
	else
		yEntry = yInvEntry / stepY
		yExit = yInvExit / stepY
	end
	
	entryTime = math.max(xEntry, yEntry)
	exitTime = math.min(xExit, yExit)
	
	local can = true
	
	if exitTime < entryTime or xEntry < 0 and yEntry < 0 or xEntry > 1 or yEntry > 1 then
		return 0, 0, 1
	end
	
	if xEntry < 0 and (objMaxX <= blockX or blockMaxX <= objX) then
		return 0, 0, 1
	end
	
	if yEntry < 0 and (objMaxY <= blockY or blockMaxY <= objY) then
		return 0, 0, 1
	end
	
	if can then
		if yEntry < xEntry then
			if xInvEntry < 0 then
				return 1, 0, entryTime
			else
				return -1, 0, entryTime
			end
		elseif yInvEntry < 0 then
			return 0, 1, entryTime
		else
			return 0, -1, entryTime
		end
	end
end
