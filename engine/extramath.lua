math.tau = math.pi * 2
math.hpi = math.pi * 0.5

function math.clamp(val, min, max)
	return math.max(math.min(val, max), min)
end

function math.approach(val, target, amt)
	amt = math.abs(amt)
	
	if val < target then
		return math.clamp(val + amt, val, target)
	elseif target < val then
		return math.clamp(val - amt, target, val)
	end
	
	return target
end

function math.normalizeAngle(ang)
	while ang <= -180 do
		ang = ang + 360
	end
	
	while ang > 180 do
		ang = ang - 360
	end
	
	return ang
end

function math.clampAngle(val, target)
	if math.abs(val - target) > 180 then
		val = val + (val < 0 and 360 or -360)
	end
	
	return val
end

function math.approachAngle(val, target, amt)
	val = math.normalizeAngle(val)
	target = math.normalizeAngle(target)
	val = math.clampAngle(val, target)
	
	return math.approach(val, target, amt)
end

function math.indexfrompercentage(percentage, maxIndexes)
	return math.min(math.ceil(maxIndexes * percentage), maxIndexes)
end

function math.rollBool(chance, outOf)
	outOf = outOf or 100
	
	if chance >= math.random(1, outOf) then
		return true
	end
	
	return false
end

function math.randsign()
	return math.random(1, 2) == 1 and 1 or -1
end

function math.ismiddleof(current, max)
	if max % 2 == 0 then
		return false
	end
	
	return max - math.floor(max / 2) == current
end

math.isMiddleOf = math.ismiddleof

function math.lerp(from, to, dt)
	return from + dt * (to - from)
end

function math.lerpAngle(from, to, dt)
	from = math.normalizeAngle(from)
	to = math.normalizeAngle(to)
	from = math.clampAngle(from, to)
	
	return from + dt * (to - from)
end

function math.lerpColor(from, to, dt)
	from.r = from.r + dt * (to.r - from.r)
	from.g = from.g + dt * (to.g - from.g)
	from.b = from.b + dt * (to.b - from.b)
	
	return from
end

function math.mouseToWorld()
	return convertToWorldArray(camera:mousePosition())
end

function math.getBlockAtMousePos()
	local bX, bY = math.mouseToWorld()
	
	return world.blocks[bX * worldYLimit + bY]
end

function math.getBlockPosAtMousePos()
	local bX, bY = math.mouseToWorld()
	
	return bX, bY
end

function math.convertToIndex(tbl)
	return tbl[1] * worldYLimit + tbl[2]
end

function math.convertToIndexNonTbl(x, y)
	return x * worldYLimit + y
end

local rem

function math.getPositionFromIndex(index)
	rem = index % worldYLimit
	
	return math.ceil((index - rem) / worldYLimit), rem
end

function math.getHeightFromIndex(index)
	return index % worldYLimit
end

function math.linearChange(from, to, mul)
	local x, y = from, to
	
	return x + (y - x) * mul
end

local clr = {}

function math.linearChangeColor(from, to, mul)
	local r1, g1, b1, r2, g2, b2 = from.r, from.g, from.b, to.r, to.g, to.b
	
	clr.r = r1 + (r2 - r1) * mul
	clr.g = g1 + (g2 - g1) * mul
	clr.b = b1 + (b2 - b1) * mul
	
	return {
		r = clr.r,
		g = clr.g,
		b = clr.b,
		a = clr.a
	}
end

function math.linearScaleColor(c, mul)
	local cl = {}
	local r, g, b = c.r, c.g, c.b
	
	cl.r = r * mul
	cl.g = g * mul
	cl.b = b * mul
	
	return cl
end

function math.lerpLight(from, to, dt)
	local final = from + dt * (to - from)
	
	final = final * math.min(1, math.max(math.floor(final / 5), 0))
	
	return final
end

function math.rotateAroundCenter(x, y, a)
	local s, c = math.sin(a), math.cos(a)
	local nx = x * c - y * s
	local ny = x * s + y * c
	
	return nx, ny
end

function math.rotateQuadAroundCenter(quad, a, scaleX, scaleY)
	a = math.rad(a)
	
	local x, y, w, h = quad:getViewport()
	
	w, h = w * scaleX, h * scaleY
	
	local s, c = math.sin(a), math.cos(a)
	local nx = w * c - h * s
	local ny = w * s + h * c
	
	return nx, ny, a
end

function math.length(t)
	local total = 0
	local len = 0
	
	for k, v in pairs(t) do
		len = len + v
		total = total + 1
	end
	
	return len / total
end

function math.round(val, dec)
	local mul = 10^(dec or 0)
	
	return math.floor(val * mul + 0.5) / mul
end

function math.flash(value, flashSpeed)
	value = value * flashSpeed
	
	local flash = math.ceil(value) - value
	local dist = math.abs(0.5 - flash) * 2
	
	return dist
end

function math.reverseround(val, dec)
	local r = math.round(val, dec)
	
	if val < r then
		return r - 1
	else
		return r + 1
	end
end

function math.isWithinRange(value, min, max)
	if min <= value or value <= max then
		return true
	end
	
	return false
end

local snoise = love.math.noise

function math.octavedNoiseX(x, iterations, persistence, scale, low, high)
	local maxAmp = 0
	local amp = 1
	local frequency = scale
	local noise = 0
	
	for i = 1, iterations do
		noise = noise + snoise(x * frequency) * amp
		maxAmp = maxAmp + amp
		amp = amp * persistence
		frequency = frequency * 2
	end
	
	noise = noise / maxAmp
	noise = noise * (high - low) * 0.5 + (high + low) * 0.5
	
	return noise
end

function math.octavedNoiseXY(x, y, iterations, persistence, scale, low, high)
	local maxAmp = 0
	local amp = 1
	local frequency = scale
	local noise = 0
	
	for i = 1, iterations do
		noise = noise + snoise(x * frequency, y * frequency) * amp
		maxAmp = maxAmp + amp
		amp = amp * persistence
		frequency = frequency * 2
	end
	
	noise = noise / maxAmp
	noise = noise * (high - low) * 0.5 + (high + low) * 0.5
	
	return noise
end

function math.ccaabb(x1, y1, x2, y2, w1, h1, w2, h2)
	if x2 > x1 + w1 or y2 > y1 + h1 or x1 > x2 + w2 or y1 > y2 + h2 then
		return false
	end
	
	return true
end

math.ccaabb2 = math.ccaabb

function math.getOverlapAmount(x1, y1, x2, y2, w1, h1, w2, h2)
	local xMaxUs = x1 + w1
	local yMaxUs = y1 + h1
	local xMaxThey = x2 + w2
	local yMaxThey = y2 + h2
	local xOverlap, yOverlap = 0, 0
	
	if x1 < xMaxThey and x2 < xMaxUs then
		xOverlap = math.abs(x2 - xMaxUs)
	end
	
	if y1 < yMaxThey and y2 < yMaxUs then
		yOverlap = math.abs(y2 - yMaxUs)
	end
	
	return math.min(xOverlap, w2), math.min(yOverlap, h2)
end

function math.normalfromrad(rad)
	return math.cos(rad), math.sin(rad)
end

function math.normalfromdeg(deg)
	return math.normalfromrad(math.rad(deg))
end

function math.directiontodeg(x, y)
	local degrees = math.deg(math.atan2(x, y))
	
	if degrees < 0 then
		return degrees + 360
	end
	
	return degrees
end

function math.ccaabbEnts(ent1, ent2)
	local x1, y1 = ent1:getPos()
	local w1, h1 = ent1:getDimensions()
	local x2, y2 = ent2:getPos()
	local w2, h2 = ent2:getDimensions()
	
	return math.ccaabb(x1, y1, x2, y2, w1, h1, w2, h2)
end

function math.sameDirection(a, b)
	if a < 0 and b < 0 or a > 0 and b > 0 then
		return true
	end
	
	return false
end

function math.facingTowards(direction, xStart, xDest)
	if direction < 0 then
		if xDest < xStart then
			return true
		end
		
		return false
	end
	
	if direction > 0 then
		if xStart < xDest then
			return true
		end
		
		return false
	end
	
	return false
end

function math.movingTowards(pointStart, pointGoal, velocity)
	if pointGoal < pointStart then
		if velocity < 0 then
			return true
		end
	elseif pointStart < pointGoal and velocity > 0 then
		return true
	end
	
	return false
end

function math.objectIntersects(obj1, obj2)
	return math.ccaabb(obj1.x, obj1.y, obj2.x, obj2.y, obj1.width, obj1.height, obj2.width, obj2.height)
end

function math.dist(a, b)
	return math.abs(a - b)
end

math.distance = math.dist

function math.predisposedsign(chance)
	if chance >= math.random(1, 100) then
		return -1
	else
		return math.random(0, 1)
	end
end

function math.predisposedzero(chance)
	if chance >= math.random(1, 100) then
		return 0
	elseif math.random(1, 2) == 1 then
		return -1
	else
		return 1
	end
end

function math.magnitude(x, y)
	return math.sqrt(x * x + y * y)
end

function math.normal(x, y)
	local len = math.sqrt(x * x + y * y)
	
	return x / len, y / len, len
end

function math.linearDirection(x1, y1, x2, y2)
	local distX = x2 - x1
	local distY = y2 - y1
	local largest = math.max(math.abs(distX), math.abs(distY))
	
	return distX / largest, distY / largest, largest
end

function math.dotproduct(x1, y1, x2, y2)
	return x1 * x2 + y1 * y2
end

function math.getDirectionTo(a, b)
	if a < b then
		return 1
	elseif b < a then
		return -1
	end
	
	return 0
end

function math.minimumtranslation(x1, y1, x2, y2, w1, h1, w2, h2)
	local mtd = {}
	local left = x2 - (x1 + w1)
	local right = x2 + w2 - x1
	local up = y2 - (y1 + h1)
	local down = y2 + h2 - y1
	
	if left > 0 or right < 0 then
		return 
	end
	
	if up > 0 or down < 0 then
		return 
	end
	
	mtd.x = right > math.abs(left) and left or right
	mtd.y = down > math.abs(up) and up or down
	
	if math.abs(mtd.x) < math.abs(mtd.y) then
		mtd.y = 0
	else
		mtd.x = 0
	end
	
	return mtd
end

local dist = math.dist

function math.dist2(x1, x2, y1, y2)
	return dist(x1, x2) + dist(y1, y2)
end

math.distXY = math.dist2
math.distanceXY = math.dist2

function math.distToObject(obj1, obj2)
	local centerX, centerY = obj1:getCenter()
	local centerX2, centerY2 = obj2:getCenter()
	
	return math.distXY(centerX, centerX2, centerY, centerY2)
end

function math.next(val, addVal, min, max)
	val = val + addVal
	
	if max < val then
		return min
	elseif val < min then
		return max
	else
		return val
	end
end

function math.torad(deg)
	return deg * (math.pi / 180)
end

function math.todeg(rad)
	return rad * (180 / math.pi)
end

function math.randomf(min, max)
	return min + (max - min) * math.random()
end

function math.mouseToDir(px, py)
	local x, y = camera:mousePosition()
	local nx, ny = math.normal(x - px, y - py)
	
	return nx, ny
end

function math.clampedLerp(start, finish, delta, minValue)
	local newPos = math.lerp(start, finish, delta)
	local difference = newPos - start
	
	return difference < 0 and math.min(difference, -minValue) or math.max(difference, minValue)
end

local function counterClockWise(AX, AY, BX, BY, CX, CY)
	return (CY - AY) * (BX - AX) > (BY - AY) * (CX - AX)
end

function math.lineSegmentIntersects(AX, AY, BX, BY, CX, CY, DX, DY)
	return counterClockWise(AX, AY, CX, CY, DX, DY) ~= counterClockWise(BX, BY, CX, CY, DX, DY) and counterClockWise(AX, AY, BX, BY, CX, CY) ~= counterClockWise(AX, AY, BX, BY, DX, DY)
end

function math.lineSegmentIntersectsObject(AX, AY, BX, BY, object)
	local objX, objY, objW, objH = object.x, object.y, object.x + object.width, object.y
	
	return math.lineSegmentIntersects(AX, AY, BX, BY, objX, objY, objX + objW, objY) or math.lineSegmentIntersects(AX, AY, BX, BY, objX, objY, objX, objY + objH) or math.lineSegmentIntersects(AX, AY, BX, BY, objX + objW, objY, objX + objW, objY + objH) or math.lineSegmentIntersects(AX, AY, BX, BY, objX, objY + objH, objX + objW, objY + objH)
end

function math.getLineIntersection(p0_x, p0_y, p1_x, p1_y, p2_x, p2_y, p3_x, p3_y)
	local s1_x, s1_y, s2_x, s2_y
	
	s1_x = p1_x - p0_x
	s1_y = p1_y - p0_y
	s2_x = p3_x - p2_x
	s2_y = p3_y - p2_y
	
	local s, t
	
	s = (-s1_y * (p0_x - p2_x) + s1_x * (p0_y - p2_y)) / (-s2_x * s1_y + s1_x * s2_y)
	t = (s2_x * (p0_y - p2_y) - s2_y * (p0_x - p2_x)) / (-s2_x * s1_y + s1_x * s2_y)
	
	if s >= 0 and s <= 1 and t >= 0 and t <= 1 then
		return p0_x + t * s1_x, p0_y + t * s1_y
	end
	
	return false
end

function math.getLineIntersectionObject(p0_x, p0_y, p1_x, p1_y, object)
	local objX, objY = object:getCollisionPos()
	local objW, objH = object:getCollisionSize()
	local shortestDist = math.huge
	local magnitude = math.magnitude(p0_x, p0_y)
	local firstX, firstY
	local topX, topY = math.getLineIntersection(p0_x, p0_y, p1_x, p1_y, objX, objY, objX + objW, objY)
	
	if topX then
		local dist = math._getIntersectDistance(magnitude, topX, topY)
		
		if dist < shortestDist then
			shortestDist = dist
			firstX, firstY = topX, topY
		end
	end
	
	local botX, botY = math.getLineIntersection(p0_x, p0_y, p1_x, p1_y, objX, objY + objH, objX + objW, objY + objH)
	
	if botX then
		local dist = math._getIntersectDistance(magnitude, botX, botY)
		
		if dist < shortestDist then
			shortestDist = dist
			firstX, firstY = botX, botY
		end
	end
	
	local leftX, leftY = math.getLineIntersection(p0_x, p0_y, p1_x, p1_y, objX, objY, objX, objY + objH)
	
	if leftX then
		local dist = math._getIntersectDistance(magnitude, leftX, leftY)
		
		if dist < shortestDist then
			shortestDist = dist
			firstX, firstY = leftX, leftY
		end
	end
	
	local leftX, leftY = math.getLineIntersection(p0_x, p0_y, p1_x, p1_y, objX + objW, objY, objX + objW, objY + objH)
	
	if leftX then
		local dist = math._getIntersectDistance(magnitude, leftX, leftY)
		
		if dist < shortestDist then
			shortestDist = dist
			firstX, firstY = leftX, leftY
		end
	end
	
	return firstX, firstY, shortestDist
end

function math._getIntersectDistance(mag, x2, y2)
	local magTwo = math.magnitude(x2, y2)
	
	return math.dist(mag, magTwo)
end

math.easing = require("engine/easing")
