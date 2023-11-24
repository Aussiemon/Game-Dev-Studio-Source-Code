local vO = {}

function vO.__add(a, b)
	a.x = a.x + b.x
	a.y = a.y + b.y
	
	return a
end

function vO.__sub(a, b)
	a.x = a.x - b.x
	a.y = a.y - b.y
	
	return a
end

function vO.__mul(a, b)
	a.x = a.x * b.x
	a.y = a.y * b.y
	
	return a
end

function vO.__div(a, b)
	a.x = a.x / b.x
	a.y = a.y / b.y
	
	return a
end

vO.mtindex = {
	__index = vO
}

function vector(x, y)
	local vec = {
		x = x,
		y = y
	}
	
	setmetatable(vec, {
		__add = vO.__add,
		__sub = vO.__sub,
		__mul = vO.__mul,
		__div = vO.__div
	})
	
	return vec
end
