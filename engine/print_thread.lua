local channelIn = love.thread.getChannel("printThread_in")
local screenshotData
local step = "step"
local stepSize = 10

while true do
	printData = channelIn:demand()
	
	if printData then
		print(printData)
		collectgarbage(step, stepSize)
	end
end
