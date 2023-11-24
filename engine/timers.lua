timer = {}
timer.simpleTimers = {}
timer.namedTimers = {}

function timer.simple(time, func)
	table.insert(timer.simpleTimers, {
		executionTime = curTime + time,
		func = func
	})
end

function timer.create(time, reps, timerName, func)
	timer.namedTimers[timerName] = {
		curReps = 0,
		executionTime = curTime + time,
		reps = reps,
		func = func
	}
end

function timer:removeAll()
	table.clear(timer.simpleTimers)
	table.clear(timer.namedTimers)
end

function timer:process(dt)
	local removeIndex = 1
	
	for i = 1, #self.simpleTimers do
		local v = self.simpleTimers[removeIndex]
		
		if curTime >= v.executionTime then
			v.func(dt)
			table.remove(self.simpleTimers, removeIndex)
		else
			removeIndex = removeIndex + 1
		end
	end
	
	for k, v in pairs(self.namedTimers) do
		if curTime >= v.executionTime then
			v.func(dt)
			
			v.curReps = v.curReps + 1
			
			if v.curReps >= v.reps then
				self.namedTimers[k] = nil
			end
		end
	end
end
