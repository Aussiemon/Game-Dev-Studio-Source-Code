coroutineManager = {}
coroutineManager.total = {}
coroutineManager.suspended = "suspended"
coroutineManager.dead = "dead"
coroutineManager.uniqueID = 0

local coroutine = coroutine

function coroutineManager:add(name, delay, initialDelay, func)
	self.uniqueID = self.uniqueID + 1
	delay = delay or 0
	initialDelay = initialDelay or 0
	name = name or table.concatEasy("", "coroutine #", self.uniqueID)
	
	local corout = coroutine.create(func)
	local coroutTable = {
		name = name,
		corout = corout,
		delay = delay,
		curTime = curTime + initialDelay
	}
	
	table.insert(self.total, coroutTable)
	
	if initialDelay <= 0 then
		coroutine.resume(corout)
	end
	
	return coroutTable
end

function coroutineManager:exists(name)
	for k, v in pairs(self.total) do
		if v.name == name then
			return true
		end
	end
	
	return false
end

function coroutineManager:resumeAll()
	for k, v in pairs(self.total) do
		if coroutine.status(v.corout) ~= self.dead then
			coroutine.resume(v.corout)
		end
	end
end

function coroutineManager:clearAll()
	for k, v in pairs(self.total) do
		self.total[k] = nil
	end
end

function coroutineManager:clearAllDead()
	for k, v in pairs(self.total) do
		if coroutine.status(v.corout) == self.dead then
			self.total[k] = nil
		end
	end
end

function coroutineManager:clearAllSuspended()
	for k, v in pairs(self.total) do
		if coroutine.status(v.corout) == self.dead then
			self.total[k] = nil
		end
	end
end

function coroutineManager:clearNamed(name, one, deadOnly)
	for k, v in pairs(self.total) do
		if v.name == name and (deadOnly and coroutine.status(v.corout) == self.dead or not deadOnly) then
			self.total[k] = nil
			
			if one then
				break
			end
		end
	end
end

function coroutineManager:process(dt)
	local status
	
	for k, v in pairs(self.total) do
		status = coroutine.status(v.corout)
		
		if status == self.suspended then
			if v.delay > 0 then
				if curTime > v.curTime then
					coroutine.resume(v.corout)
					
					v.curTime = curTime + v.delay
				end
			else
				coroutine.resume(v.corout)
			end
		elseif status == self.dead then
			self.total[k] = nil
		end
	end
end
