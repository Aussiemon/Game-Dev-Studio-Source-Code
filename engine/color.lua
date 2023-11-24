local cO = {}

function cO.__add(a, b)
	a.r = a.r + b.r
	a.g = a.g + b.g
	a.b = a.b + b.b
	a.a = a.a + a.a
	
	return a
end

function cO.__sub(a, b)
	a.r = a.r - b.r
	a.g = a.g - b.g
	a.b = a.b - b.b
	a.a = a.a - a.a
	
	return a
end

function cO.__mul(a, b)
	a.r = a.r * b.r
	a.g = a.g * b.g
	a.b = a.b * b.b
	a.a = a.a * a.a
	
	return a
end

function cO.__div(a, b)
	a.r = a.r / b.r
	a.g = a.g / b.g
	a.b = a.b / b.b
	a.a = a.a / a.a
	
	return a
end

function cO:duplicate(otherColorObject)
	if otherColorObject then
		self.r, self.g, self.b, self.a = otherColorObject:getColor()
	end
	
	return color(self.r, self.g, self.b, self.a)
end

cO.copy = cO.duplicate
cO.clone = cO.duplicate

function cO:lerp(delta, r, g, b, a)
	self.r = math.lerp(self.r, r, delta)
	self.g = math.lerp(self.g, g, delta)
	self.b = math.lerp(self.b, b, delta)
	self.a = math.lerp(self.a, a, delta)
end

function cO:lerpAction(targetColor, speed)
	local oldTarget = self.targetColor
	
	self.targetColor = targetColor
	
	if self.targetColor then
		if oldTarget ~= self.targetColor then
			if not self.startColor then
				self.startColor = self:copy()
			else
				self.startColor:setColor(self.r, self.g, self.b, self.a)
			end
			
			self.progress = 0
		end
		
		local oldProgress = self.progress
		
		self.progress = math.approach(self.progress, 1, speed)
		
		self:setColor(self.startColor:lerpResult(self.progress, self.targetColor.r, self.targetColor.g, self.targetColor.b, self.targetColor.a))
		
		return oldProgress ~= self.progress
	end
	
	return false
end

function cO:table()
	return {
		self.r,
		self.g,
		self.b,
		self.a
	}
end

function cO:lerpColor(otherColor, delta)
	self:lerp(delta, otherColor:unpack())
end

function cO:random()
	self.r = math.random(0, 255)
	self.g = math.random(0, 255)
	self.b = math.random(0, 255)
end

function cO:normalize()
	self.r = self.r / 255
	self.g = self.g / 255
	self.b = self.b / 255
	self.a = self.a / 255
end

cO.randomize = cO.random

function cO:getMostVibrant()
	return math.max(self.r, self.g, self.b)
end

function cO:getLeastVibrant()
	return math.min(self.r, self.g, self.b)
end

function cO:lerpFromTo(delta, from, to)
	self.r = math.lerp(from.r, to.r, delta)
	self.g = math.lerp(from.g, to.g, delta)
	self.b = math.lerp(from.b, to.b, delta)
	self.a = math.lerp(from.a, to.a, delta)
end

function cO:lerpResult(delta, r, g, b, a)
	return math.lerp(self.r, r, delta), math.lerp(self.g, g, delta), math.lerp(self.b, b, delta), math.lerp(self.a, a, delta)
end

function cO:lerpColorResult(delta, otherColor)
	return self:lerpResult(delta, otherColor:unpack())
end

function cO:lerpSelfResult(delta)
	return math.lerp(self.r, 0, delta), math.lerp(self.g, 0, delta), math.lerp(self.b, 0, delta), math.lerp(self.a, 0, delta)
end

function cO:getLength()
	return (self.r + self.g + self.b) / 3
end

function cO:setColor(r, g, b, a)
	self.r = r or self.r
	self.g = g or self.g
	self.b = b or self.b
	self.a = a or self.a
end

function cO:getColor()
	return self.r, self.g, self.b, self.a
end

function cO:getAlpha()
	return self.a
end

function cO:getRed()
	return self.r
end

function cO:getGreen()
	return self.g
end

function cO:getBlue()
	return self.b
end

function cO:setAlpha(a)
	self.a = a
end

function cO:setRed(r)
	self.r = r
end

function cO:setGreen(g)
	self.g = g
end

function cO:setBlue(b)
	self.b = b
end

function cO:print()
	print(self.r, self.g, self.b, self.a)
end

function cO:unpack()
	return self.r, self.g, self.b, self.a
end

function cO:saveRGB()
	return {
		self.r,
		self.g,
		self.b
	}
end

cO._mtindex = {
	__index = cO,
	__add = cO.__add,
	__sub = cO.__sub,
	__mul = cO.__mul,
	__div = cO.__div
}

function color(r, g, b, a)
	a = a or 255
	
	local c = {
		r = r,
		g = g,
		b = b,
		a = a
	}
	
	setmetatable(c, cO._mtindex)
	
	return c
end
