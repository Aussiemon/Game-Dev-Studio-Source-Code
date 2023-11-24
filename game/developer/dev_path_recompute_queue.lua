devPathRecomputeQueue = {}

function devPathRecomputeQueue:init()
	self.queue = {}
	self.queueMap = {}
end

function devPathRecomputeQueue:remove()
	for key, data in ipairs(self.queue) do
		self.queueMap[data[1]] = nil
		self.queue[key] = nil
	end
end

function devPathRecomputeQueue:addToQueue(dev, targetObj)
	if self.queueMap[dev] then
		for key, data in ipairs(self.queue) do
			if data[1] == dev then
				data[2] = targetObj
			end
		end
	else
		table.insert(self.queue, {
			dev,
			targetObj
		})
		
		self.queueMap[dev] = true
	end
end

function devPathRecomputeQueue:removeFromQueue(dev)
	for key, data in ipairs(self.queue) do
		if data[1] == dev then
			table.remove(self.queue, dev)
			
			self.queueMap[dev] = nil
			
			return true
		end
	end
	
	return false
end

function devPathRecomputeQueue:update()
	local queue = self.queue
	local qSize = #queue
	
	if qSize > 0 then
		local rIdx = 1
		
		for i = 1, qSize do
			local data = queue[rIdx]
			local dev, targetObj = data[1], data[2]
			
			if not dev:getWalkPath() then
				if not targetObj:isReachable() then
					dev:setRequiresPathRecompute(false)
					dev:abortCurrentAction()
					table.remove(queue, rIdx)
				else
					local path = dev:getEmployer():getPathToObjectEntrance(dev, targetObj)
					
					if path then
						dev:setRequiresPathRecompute(false)
						dev:setWalkPath(path)
						
						self.queueMap[dev] = nil
						
						table.remove(queue, rIdx)
					else
						rIdx = rIdx + 1
					end
				end
			else
				table.remove(queue, rIdx)
			end
		end
	end
end
