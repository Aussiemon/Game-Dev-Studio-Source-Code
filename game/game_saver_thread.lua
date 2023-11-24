require("love.filesystem")
require("love.image")
require("love.math")

local bitser = require("engine/bitser")

require("engine/ffiimagedata")

local inChannel = love.thread.getChannel("GAME_SAVER_IN")

while true do
	local data = inChannel:demand()
	
	love.filesystem.write(data.savePath, love.math.compress(data.saveData, "lz4", 9))
	
	local scale = data.screenshotScale
	local realScreenshotData = love.image.newImageData(data.screenW / scale, data.screenH / scale)
	local w, h = realScreenshotData:getDimensions()
	local screenshot = data.screenshot
	local refW, refH = screenshot:getDimensions()
	
	refW, refH = refW - scale, refH - scale
	
	for x = 0, w - 1 do
		for y = 0, h - 1 do
			realScreenshotData:setPixel(x, y, screenshot:getPixel(math.min(refW, x * scale), math.min(refH, y * scale)))
		end
	end
	
	local previewData = {
		saveDate = data.saveDate,
		gameTime = data.gameTime,
		funds = data.funds,
		employeeCount = data.employeeCount,
		screenshot = realScreenshotData:getString(),
		screenW = w,
		screenH = h,
		playthroughHash = data.playthroughHash,
		activeModData = data.activeModData
	}
	
	love.filesystem.write(data.previewPath, love.math.compress(bitser.dumps(previewData), "lz4", 9))
	
	previewData.screenshot = nil
	data.screenshot = nil
	previewData = nil
	realScreenshotData = nil
	data = nil
	
	for i = 1, 2 do
		collectgarbage("collect")
	end
end
