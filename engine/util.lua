util = {}
util._lastByRangeEntities = {}
util._lastByClassEntities = {}

local f = "fill"

function util.los(sx, sy, dx, dy, dist, display)
	local nx, ny = math.normal(dx - sx, dy - sy)
	
	dist = dist or 60
	dx, dy = math.round(dx / 20), math.round(dy / 20)
	
	local cx, cy
	
	for i = 1, dist do
		cx, cy = math.round(sx / 20 + nx * i), math.round(sy / 20 + ny * i)
		
		if cx == dx and cy == dy then
			return true
		end
		
		if canCollideWithWorld(cx, cy) then
			return false
		end
	end
	
	return false
end

util.lineOfSight = util.los
util.checkLOS = util.los

function util.collidesWithWorld(startX, startY, sizeX, sizeY, skipPositionConversion, convertSize)
	if not skipPositionConversion then
		startX = math.ceil(startX / 20)
		startY = math.ceil(startY / 20)
	end
	
	if convertSize then
		sizeX = math.ceil(sizeX / 20)
		sizeY = math.ceil(sizeY / 20)
	end
	
	for X = startX, startX + sizeX do
		for Y = startY, startY + sizeY do
			if canCollideWithWorld(X, Y) then
				return X, Y
			end
		end
	end
	
	return false
end

function util.getEntsByClassWithinRange(xStart, xEnd, yStart, yEnd, class, output)
	output = output or util._lastByRangeEntities
	
	table.clear(output)
	
	local totalCount = 1
	local class = ent.isEntityCategorised(class) and class or "misc"
	
	for X = xStart, xEnd do
		for Y = yStart, yEnd do
			local finalTarget = ent.chunks[X * vertChunks + Y]
			
			if finalTarget then
				for key, obj in pairs(finalTarget) do
					if obj.type == class then
						output[totalCount] = obj
						totalCount = totalCount + 1
					end
				end
			end
		end
	end
	
	return output
end

function util.getDynamicEntsByClass(class, output)
	output = output or util._lastByClassEntities
	
	table.clear(output)
	
	local totalCount = 1
	
	for k, v in ipairs(ent.createdEntities) do
		if v.class == class then
			output[totalCount] = v
			totalCount = totalCount + 1
		end
	end
	
	return output
end

function util.pickClosestEntity(startX, startY, entities, range)
	local result, index
	local lastDist = math.huge
	
	range = range or 60
	
	for k, v in pairs(entities) do
		local entX, entY = v:getCenter()
		local distTo = math.distXY(startX, entX, startY, entY)
		
		if distTo <= range and distTo < lastDist then
			lastDist = distTo
			result = v
			index = k
		end
	end
	
	return result, index, lastDist
end

util.getClosestEntity = util.pickClosestEntity
util.chooseClosestEntity = util.pickClosestEntity

local foundEntities = {}

function util.findWithinRange(startX, startY, entities, range, newTable)
	local destination
	
	if newTable then
		destination = {}
	else
		destination = table.clear(foundEntities)
	end
	
	for k, v in pairs(entities) do
		local entX, entY = v:getCenter()
		
		if range >= math.distXY(startX, entX, startY, entY) then
			table.inserti(destination, v)
		end
	end
	
	return destination
end

function util.getDistBetween(ent1, ent2)
	local x1, y1 = ent1:getCenter()
	local x2, y2 = ent2:getCenter()
	
	return math.distXY(x1, x2, y1, y2)
end

function util.dealDamage(attacker, inflictor, x, y, radius, damage, damageType, targets, distanceScaler, excludeTarget, excludeAttacker, callback)
	if excludeAttacker == nil then
		excludeAttacker = true
	end
	
	if distanceScaler == nil then
		distanceScaler = 0
	else
		math.clamp(distanceScaler, 0, 1)
	end
	
	for key, TARGET in ipairs(targets) do
		local canDealDamage = true
		
		if excludeTarget and excludeTarget == TARGET then
			canDealDamage = false
		end
		
		if excludeAttacker and TARGET == attacker then
			canDealDamage = false
		end
		
		if canDealDamage then
			local npcX, npcY = TARGET:getCenter()
			local distToTarget = math.distXY(x, npcX, y, npcY)
			
			if distToTarget <= radius then
				if distanceScaler ~= 0 then
					local distDamageScale = distanceScaler / radius
					local relativeScale = distanceScaler * distDamageScale
					
					damage = damage * (1 - relativeScale)
				end
				
				TARGET:takeDamageType(damageType, damage, attacker)
				
				if callback then
					callback(inflictor, TARGET, distToTarget)
				end
			end
		end
	end
end

function dummyOnSetCallback(object, value)
end

function util.setGetFunctions(object, funcName, varName, onSetCallback)
	onSetCallback = onSetCallback or dummyOnSetCallback
	object["set" .. funcName] = function(self, value)
		self[varName] = value
		
		onSetCallback(self, value)
	end
	object["get" .. funcName] = function(self)
		return self[varName]
	end
end
