gcm = {}
gcm.curGarbage = 0
gcm.timestamp = 0

local count = "count"

function gcm:mark()
	self.curGarbage = collectgarbage(count)
end

local dif
local mul = 100
local maxStepSize = 500
local minStepSize = 10

function gcm:getStepSize()
	dif = math.round((collectgarbage(count) - self.curGarbage) / 1024 * mul)
	
	return math.clamp(dif, minStepSize, maxStepSize)
end

function gcm:compare()
	return (collectgarbage(count) - self.curGarbage) / 1024
end

function gcm:collectGarbage()
	if curTime > self.timestamp then
		local step = gcm:getStepSize()
		
		collectgarbage("step", step)
		
		self.timestamp = curTime + 0.1
		
		gcm:mark()
	end
end
