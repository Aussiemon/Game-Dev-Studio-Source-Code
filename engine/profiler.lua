profiler = {}
profiler.marked = {}
profiler.minDur = {}

function profiler:mark(id, minDur)
	if profiler.marked[id] then
		profiler:compare(id)
		
		profiler.marked[id] = nil
		
		return 
	end
	
	profiler.marked[id] = os.clock()
	profiler.minDur[id] = minDur or nil
end

function profiler:compare(id)
	local time = os.clock() - profiler.marked[id]
	
	if profiler.minDur[id] then
		if time > profiler.minDur[id] then
			print(id, "took", time)
		end
	else
		print(id, "took", time)
	end
	
	profiler.marked[id] = nil
end
