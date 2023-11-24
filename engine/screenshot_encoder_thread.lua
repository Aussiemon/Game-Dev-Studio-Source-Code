local channelIn = love.thread.getChannel("screenshotEncoder_in")

require("love.image")
require("love.filesystem")
require("love.window")

local ffi = require("ffi")

require("engine/ffiimagedata")
require("engine/extrafilesystem")

local screenshotData
local step = "step"
local stepSize = 500

while true do
	screenshotData = channelIn:demand()
	
	if screenshotData then
		love.filesystem.writeScreenshot(screenshotData)
		collectgarbage(step, stepSize)
	end
end
