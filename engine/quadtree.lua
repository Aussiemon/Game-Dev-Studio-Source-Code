assert(class ~= nil, "MiddleClass not detected. Please require it before using Apply")

local function _intersect(ax1, ay1, aw, ah, bx1, by1, bw, bh)
	local ax2, ay2, bx2, by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
	
	return ax1 < bx2 and bx1 < ax2 and ay1 < by2 and by1 < ay2
end

local function _contained(ax1, ay1, aw, ah, bx1, by1, bw, bh)
	local ax2, ay2, bx2, by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
	
	return bx1 <= ax1 and ax2 <= bx2 and by1 <= ay1 and ay2 <= by2
end

local function _createChildNodes(node)
	if node.width * node.height < 16 or #node.children > 0 then
		return 
	end
	
	local hw = node.width / 2
	local hh = node.height / 2
	
	node:addChild(QuadTree:new(hw, hh, node.x, node.y))
	node:addChild(QuadTree:new(hw, hh, node.x, node.y))
	node:addChild(QuadTree:new(hw, hh, node.x, node.y + hh))
	node:addChild(QuadTree:new(hw, hh, node.x + hw, node.y))
	node:addChild(QuadTree:new(hw, hh, node.x + hw, node.y + hh))
end

local _emptyCheck

function _emptyCheck(node, searchUp)
	if not node then
		return 
	end
	
	if node:getCount() == 0 then
		node.children = {}
		
		if searchUp then
			_emptyCheck(node.parent)
		end
	end
end

local function _doInsert(node, item)
	if node then
		local prev = node.root.previous[item]
		
		if prev ~= node then
			if prev then
				prev:remove(item)
			end
			
			node.itemsCount = node.itemsCount + 1
			node.root.previous[item] = node
			node.root.unassigned[item] = nil
			node.items[item] = item
		end
	end
	
	return node
end

local function _doRemove(node, item, makeUnassigned)
	if node and node.items[item] then
		if node.items[item] then
			node.itemsCount = node.itemsCount - 1
		end
		
		node.root.previous[item] = nil
		node.items[item] = nil
		
		if makeUnassigned == true then
			node.root.unassigned[item] = item
		end
	end
end

QuadTree = class("QuadTree")

function QuadTree:initialize(width, height, x, y, isRoot)
	self.x, self.y, self.width, self.height = x or 0, y or 0, width, height
	self.items = setmetatable({}, {
		__mode = "k"
	})
	self.itemsCount = 0
	self.children = {}
	self.lastQuery = {}
	
	if isRoot then
		self.previous = setmetatable({}, {
			__mode = "k"
		})
		self.unassigned = setmetatable({}, {
			__mode = "k"
		})
		self.root = self
	end
end

function QuadTree:addChild(child)
	self.children[#self.children + 1] = child
	child.root = self.root
end

function QuadTree:getBoundingBox()
	return self.x, self.y, self.width, self.height
end

function QuadTree:getCount()
	local count = self.itemsCount
	
	for _, child in ipairs(self.children) do
		count = count + child:getCount()
	end
	
	return count
end

function QuadTree:getAllItems()
	local results = {}
	
	for _, node in ipairs(self.children) do
		for _, item in ipairs(node:getAllItems()) do
			table.insert(results, item)
		end
	end
	
	for _, item in pairs(self.items) do
		table.insert(results, item)
	end
	
	return results
end

function QuadTree:insert(item)
	return _doInsert(self:findNode(item), item)
end

function QuadTree:remove(item)
	local node = self.root.previous[item]
	
	_doRemove(node, item, false)
	_emptyCheck(node, true)
end

function QuadTree:query(x, y, w, h, out)
	local results = out or self.lastQuery
	local nx, ny, nw, nh
	
	for _, item in pairs(self.items) do
		if _intersect(x, y, w, h, item:getBoundingBox()) then
			table.insert(results, item)
		end
	end
	
	for _, child in ipairs(self.children) do
		nx, ny, nw, nh = child:getBoundingBox()
		
		if _contained(x, y, w, h, nx, ny, nw, nh) then
			local list = child:query(x, y, w, h)
			
			for k, item in ipairs(list) do
				table.insert(results, item)
				
				list[k] = nil
			end
			
			break
		elseif _contained(nx, ny, nw, nh, x, y, w, h) then
			for _, item in ipairs(child:getAllItems()) do
				table.insert(results, item)
			end
		elseif _intersect(x, y, w, h, nx, ny, nw, nh) then
			local list = child:query(x, y, w, h)
			
			for k, item in ipairs(list) do
				table.insert(results, item)
				
				list[k] = nil
			end
		end
	end
	
	return results
end

function QuadTree:findNode(item, searchUp)
	local x, y, w, h = item:getBoundingBox()
	
	if _contained(x, y, w, h, self:getBoundingBox()) then
		_createChildNodes(self)
		
		for _, child in ipairs(self.children) do
			local descendant = child:findNode(item, false)
			
			if descendant then
				return descendant
			end
		end
		
		return self
	elseif searchUp == true and self.parent then
		return self.parent:findNode(item, true)
	else
		return nil
	end
end

function QuadTree:update()
	if self.unassigned then
		for _, item in pairs(self.unassigned) do
			self.root:insert(item)
		end
	end
	
	for _, item in pairs(self.items) do
		local newNode = self:findNode(item, true)
		
		if self ~= newNode then
			_doRemove(self, item, true)
			_doInsert(newNode, item)
		end
	end
	
	for _, child in ipairs(self.children) do
		child:update()
	end
	
	_emptyCheck(self, false)
end
