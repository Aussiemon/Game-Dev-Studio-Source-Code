pf = {}
pf.maxSteps = 1000
pf.totalSteps = 0
pf.multiFrame = false
pf.abortStepCount = 5000
pf.states = {
	SUCCESS = 2,
	FAILED = 3,
	IDLE = 0,
	BUSY = 1,
	ABORTED = 4
}
pf.pathfindingOverStates = {
	[pf.states.SUCCESS] = true,
	[pf.states.FAILED] = true
}
pf.state = 0
pf.allPathfinders = {}

local CLOSED, OPEN, CAMEFROM, GSCORE, FSCORE, NEIGHBORS, SUCCESSORS = {}, {}, {}, {}, {}, {}, {}
local clamp = math.clamp

local function defaultEligibleBlockFunc(bx, by)
	if not canCollideWithWorld(i, i2) then
		return true
	end
	
	return false
end

local function defaultScoreAdjust(x, y, score)
	return score
end

function pf.new(multiFrame, maxSteps)
	local new = {}
	
	setmetatable(new, {
		__index = pf
	})
	new:init()
	
	new.multiFrame = multiFrame
	new.maxSteps = maxSteps or pf.maxSteps
	new.eligibleBlockCheck = defaultEligibleBlockFunc
	new.adjustScore = defaultScoreAdjust
	
	table.insert(pf.allPathfinders, new)
	
	return new
end

function pf.removePathfinder(pfObj)
	table.removeObject(pf.allPathfinders, pfObj)
end

function pf.clearAll()
	for key, pathfinder in pairs(pf.allPathfinders) do
		pathfinder:abort()
		
		pf.allPathfinders[key] = nil
	end
end

function pf:init()
	self.CLOSED = {}
	self.OPEN = {}
	self.CAMEFROM = {}
	self.NEIGHBORS = {}
	self.SUCCESSORS = {}
	self.GSCORE = {}
	self.FSCORE = {}
	self.RECONSTRUCTEDPATH = {}
	self.STARTPOS = {}
	self.ENDPOS = {}
	self.curStep = 0
	self.totalSteps = 0
	self.state = self.states.IDLE
	self.separatePathObjects = false
	
	function self._coroutinePathfinderFunction()
		self.state = self.states.BUSY
		
		while true do
			if self:isAborted() then
				self.state = self.states.IDLE
				self.pathfinderCoroutine = nil
				
				return 
			end
			
			self.frame = self.frame + 1
			
			local path = self:_getPath(startX, startY, endX, endY)
			
			if type(path) == "table" then
				self.state = self.states.SUCCESS
				self.result = path
				self.pathfinderCoroutine = nil
				
				return path
			else
				self.state = self.states.FAILED
				self.pathfinderCoroutine = nil
				
				return false
			end
			
			self.state = self.states.FAILED
			
			return false
		end
		
		self.state = self.states.FAILED
		
		return false
	end
end

function pf:setSeparatePathObjects(state)
	self.separatePathObjects = state
end

function pf:setScoreAdjust(func)
	self.adjustScore = func
end

function pf:filterPasses(x, y)
	return true
end

function pf:abort()
	if self.multiFrame then
		if self.pathfinderCoroutine then
			self.state = self.states.ABORTED
		else
			self.state = self.states.IDLE
		end
	else
		self.state = self.states.IDLE
	end
end

function pf:clearVariables()
	self.curStep = 0
	
	for k, v in pairs(self.CLOSED) do
		self.CLOSED[k] = nil
	end
	
	for k, v in pairs(self.OPEN) do
		self.OPEN[k] = nil
	end
	
	for k, v in pairs(self.CAMEFROM) do
		self.CAMEFROM[k] = nil
	end
	
	for k, v in pairs(self.NEIGHBORS) do
		self.NEIGHBORS[k] = nil
	end
	
	for k, v in pairs(self.SUCCESSORS) do
		self.SUCCESSORS[k] = nil
	end
	
	for k, v in pairs(self.GSCORE) do
		self.GSCORE[k] = nil
	end
	
	for k, v in pairs(self.FSCORE) do
		self.FSCORE[k] = nil
	end
	
	if not self.separatePathObjects then
		for k, v in pairs(self.RECONSTRUCTEDPATH) do
			self.RECONSTRUCTEDPATH[k] = nil
		end
	end
end

local mHuge = math.huge
local highestScore, current, score, curGScore, cur, cX, cY, sX, sY, eX, eY
local abs = math.abs
local sqrt = math.sqrt

function pf:countIn(tbl)
	self.amt = 0
	self.current = nil
	self.highestScore = math.huge
	
	for k, v in pairs(tbl) do
		self.amt = self.amt + 1
		score = self.FSCORE[v]
		
		if score < self.highestScore then
			self.current = v
			self.highestScore = score
		end
	end
	
	return self.amt
end

function pf:countPathLength()
	self.PATHLENGTH = #self.RECONSTRUCTEDPATH
end

function pf:getPathLength()
	return self.PATHLENGTH
end

function pf:setFilterFunc(func)
	self.filterPasses = func
end

function pf:setToIndexConversionFunc(func)
	self.toIndexConversionFunc = func
end

function pf:setIndexToCoordinatesFunc(func)
	self.indexToCoordinatesFunc = func
end

function pf:setEligibleBlockCheck(func)
	self.eligibleBlockCheck = func
end

function pf:setMultiFrame(state)
	self.multiFrame = state
end

function pf:isMultiFrame()
	return self.multiFrame
end

function pf:setMaxSteps(steps)
	steps = steps or 1000
	self.maxSteps = steps
end

pf.setMaxStep = pf.setMaxSteps

function pf:setAbortStepCount(count)
	count = count or 5000
	self.abortStepCount = count
end

function pf:isIdle()
	return self.state == self.states.IDLE
end

function pf:isBusy()
	return self.state == self.states.BUSY
end

function pf:isAborted()
	return self.state == self.states.ABORTED
end

function pf:hasFinished()
	if not self.multiFrame then
		return true
	end
	
	return self.pathfindingOverStates[self.state]
end

pf.isFinished = pf.hasFinished

function pf:hasFailed()
	return self.state == self.states.FAILED
end

function pf:hasSucceeded()
	return self.state == self.states.SUCCESS
end

function pf:getResult()
	self.state = self.states.IDLE
	
	return self.result
end

function pf:clearResult()
	self.state = self.states.IDLE
	self.result = nil
end

pf:init()

pf.setFilterFunction = pf.setFilterFunc
pf.setFilter = pf.setFilterFunc

function pf:getPath(startX, startY, endX, endY)
	if self.state ~= self.states.IDLE then
		return 
	end
	
	self:clearVariables()
	
	self.STARTPOS[1] = startX
	self.STARTPOS[2] = startY
	self.ENDPOS[1] = endX
	self.ENDPOS[2] = endY
	self.startInd = self.toIndexConversionFunc(self.STARTPOS[1], self.STARTPOS[2])
	self.endInd = self.toIndexConversionFunc(self.ENDPOS[1], self.ENDPOS[2])
	self.OPEN[self.startInd] = self.startInd
	self.GSCORE[self.startInd] = 0
	self.FSCORE[self.startInd] = self.GSCORE[self.startInd] + self:estimateCost(self.startInd, self.endInd)
	self.endX, self.endY = self.indexToCoordinatesFunc(self.endInd)
	
	if self.multiFrame then
		if self.state ~= self.states.BUSY then
			self.totalSteps = 0
			self.frame = 0
			self.pathfinderCoroutine = coroutineManager:add(tostring(self) .. "_pathfinder", 0, 0, self._coroutinePathfinderFunction)
		end
	else
		self.state = self.states.IDLE
		self.result = self:_getPath(startX, startY, endX, endY)
		
		if self.result then
			self.state = self.states.SUCCESS
		else
			self.state = self.states.FAILED
		end
		
		return self.result
	end
end

function pf:_getPath(startX, startY, endX, endY)
	curGScore = math.huge
	
	while self:countIn(self.OPEN) > 0 do
		local can = true
		
		if self.multiFrame then
			if self.totalSteps >= self.abortStepCount then
				return nil
			end
		elseif self.curStep >= self.maxSteps then
			return nil
		end
		
		if self.curStep < self.maxSteps then
			if self.current == self.endInd then
				local path = self:reconstructPath(self.CAMEFROM, self.endInd, self.separatePathObjects and {} or self.RECONSTRUCTEDPATH, 1)
				
				self.RECONSTRUCTEDPATH = path
				
				self:countPathLength()
				
				return path
			end
			
			self.OPEN[self.current] = nil
			self.CLOSED[self.current] = self.current
			sX, sY = self.indexToCoordinatesFunc(self.current)
			self.NEIGHBORS = self:getNeighbors(sX, sY)
			
			for k, v in ipairs(self.NEIGHBORS) do
				cX, cY = self.indexToCoordinatesFunc(v)
				
				local filterResult = self:filterPasses(cX, cY, sX, sY)
				
				if filterResult then
					curGScore = self.GSCORE[self.current] + sqrt((sX - cX)^2 + (sY - cY)^2)
					curGScore = self.adjustScore(cX, cY, curGScore)
					cur = self.OPEN[v]
					
					if not cur or curGScore < self.GSCORE[v] then
						self.CAMEFROM[v] = self.current
						self.GSCORE[v] = curGScore
						self.FSCORE[v] = curGScore + abs(cX - self.endX) + abs(cY - self.endY)
						
						if not cur then
							self.OPEN[v] = v
						end
					end
				elseif filterResult == false then
					self.CLOSED[v] = v
					self.GSCORE[v] = curGScore
					self.FSCORE[v] = curGScore + abs(cX - self.endX) + abs(cY - self.endY)
				end
				
				self.NEIGHBORS[k] = nil
			end
			
			self.curStep = self.curStep + 1
			self.totalSteps = self.totalSteps + 1
		elseif self.multiFrame then
			self.curStep = 0
			self.frame = self.frame + 1
			
			coroutine.yield()
		end
	end
	
	return nil
end

local f = "fill"

function pf:drawPath()
	if #self.RECONSTRUCTEDPATH > 0 then
		if not self.r then
			self.r = math.random(0, 255)
			self.g = math.random(0, 255)
			self.b = math.random(0, 255)
		end
		
		love.graphics.setColor(self.r, self.g, self.b, 200)
		
		for k, v in ipairs(self.RECONSTRUCTEDPATH) do
			local x, y = self.indexToCoordinatesFunc(v)
			
			love.graphics.rectangle(f, x * 20, y * 20, 20, 20)
		end
	end
end

function pf:countConsequentHeight(horizontalSpan)
	horizontalSpan = horizontalSpan or 0
	
	local count = #self.RECONSTRUCTEDPATH
	
	if count <= 1 then
		return 0
	end
	
	local lastHorizontal, lastHeight = self.indexToCoordinatesFunc(self.RECONSTRUCTEDPATH[1])
	local totalHeight = 0
	local unchangedHorizontal = 0
	
	for i = 2, count do
		local v = self.RECONSTRUCTEDPATH[i]
		local x, y = self.indexToCoordinatesFunc(v)
		
		if y < lastHeight then
			lastHeight = y
			totalHeight = totalHeight + 20
			
			if horizontalSpan > 0 then
				if x ~= lastHorizontal then
					unchangedHorizontal = unchangedHorizontal + 1
					lastHorizontal = x
				end
				
				if horizontalSpan <= unchangedHorizontal then
					return 0
				end
			end
		else
			return 0
		end
	end
	
	return totalHeight
end

function pf:convertCoordinates(startX, startY, endX, endY)
	startX = math.floor(startX / 20)
	startY = math.floor(startY / 20)
	endX = math.floor(endX / 20)
	endY = math.floor(endY / 20)
	
	return startX, startY, endX, endY
end

function pf:estimateCost(startPos, endPos)
	sX, sY = self.indexToCoordinatesFunc(startPos)
	eX, eY = self.indexToCoordinatesFunc(endPos)
	
	return math.abs(sX - eX) + math.abs(sY - eY)
end

function pf:getDistance(startPos, endPos)
	sX, sY = self.indexToCoordinatesFunc(startPos)
	eX, eY = self.indexToCoordinatesFunc(endPos)
	
	return math.sqrt((sX - eX)^2 + (sY - eY)^2)
end

function pf:getPrunedNeighbors(x, y, dX, dY)
end

function pf:setGridBoundaries(w, h)
	self.gridW, self.gridH = w, h
end

function pf:getNeighbors(x, y)
	for i = x - 1, x + 1 do
		for i2 = y - 1, y + 1 do
			if i > 0 and i2 > 0 and i <= self.gridW and i2 <= self.gridH then
				local ind = self.toIndexConversionFunc(i, i2)
				
				if not self.CLOSED[ind] and self.eligibleBlockCheck(i, i2, ind) then
					self.NEIGHBORS[#self.NEIGHBORS + 1] = ind
				end
			end
		end
	end
	
	return self.NEIGHBORS
end

function pf:reconstructPath(startPos, endPos, pathTbl, cur)
	pathTbl = pathTbl or {}
	
	if startPos[endPos] then
		self:reconstructPath(startPos, startPos[endPos], pathTbl, cur)
		
		cur = cur + 1
	end
	
	pathTbl[#pathTbl + 1] = endPos
	
	return pathTbl
end
