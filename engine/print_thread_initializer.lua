game.printThread = love.thread.newThread("engine/print_thread.lua")
game.printThread_CHANNEL_IN = love.thread.getChannel("printThread_in")

game.printThread:start()

local concatTable = {}
local printRange = 10

function print(...)
	local lastIndex
	
	for i = 1, printRange do
		local value = select(i, ...)
		
		if value then
			lastIndex = i
		end
		
		concatTable[i] = tostring(value)
	end
	
	if lastIndex then
		for i = printRange, lastIndex + 1, -1 do
			concatTable[i] = nil
		end
	end
	
	game.printThread_CHANNEL_IN:push(table.concat(concatTable, "\t"))
	table.clear(concatTable)
end
