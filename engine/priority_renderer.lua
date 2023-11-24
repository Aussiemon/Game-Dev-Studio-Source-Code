priorityRenderer = {}
priorityRenderer.renderOrder = {}
priorityRenderer.activeRenderMap = {}

function priorityRenderer.sortFunc(a, b)
	return a.priority < b.priority
end

function priorityRenderer:add(object, priority)
	if self.activeRenderMap[object] then
		return 
	end
	
	priority = priority or 1
	
	local struct = {
		object = object,
		priority = priority
	}
	local index = 1
	
	for key, other in ipairs(self.renderOrder) do
		if priority > other.priority then
			index = key + 1
		end
	end
	
	table.insert(self.renderOrder, index, struct)
	
	self.activeRenderMap[object] = true
end

function priorityRenderer:findObject(object)
	for key, otherObject in ipairs(self.renderOrder) do
		if otherObject.object == object then
			return otherObject
		end
	end
	
	return nil
end

function priorityRenderer:remove(object)
	for key, otherObject in ipairs(self.renderOrder) do
		if otherObject.object == object then
			table.remove(self.renderOrder, key)
			
			break
		end
	end
	
	self.activeRenderMap[object] = nil
end

function priorityRenderer:draw()
	love.graphics.setColor(255, 255, 255, 255)
	
	for key, object in ipairs(self.renderOrder) do
		object.object:draw()
	end
end
