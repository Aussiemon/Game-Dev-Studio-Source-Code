floorQuadTree = {}
floorQuadTree.mtindex = {
	__index = floorQuadTree
}

function floorQuadTree.new(w, h, floors)
	local new = {}
	
	setmetatable(new, floorQuadTree.mtindex)
	new:init(w, h, floors)
	
	return new
end

function floorQuadTree:init(w, h, floors)
	self.floors = {}
	
	for i = 1, floors do
		self.floors[i] = QuadTree:new(w, h, 0, 0, true)
	end
end

function floorQuadTree:insert(object)
	self.floors[object:getFloor()]:insert(object)
end

function floorQuadTree:move(object, newFloor)
	local floor = object:getFloor()
	local floors = self.floors
	
	floors[floor]:remove(object)
	floors[newFloor]:insert(object)
end

function floorQuadTree:remove(object)
	self.floors[object:getFloor()]:remove(object)
end

function floorQuadTree:getQuadTree(floor)
	return self.floors[floor]
end

function floorQuadTree:update()
	local flr = self.floors
	
	for i = 1, #flr do
		flr[i]:update()
	end
end
