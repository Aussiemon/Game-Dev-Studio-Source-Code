game.screenshotEncoder = love.thread.newThread("engine/screenshot_encoder_thread.lua")
game.screenshotEncoder_CHANNEL_IN = love.thread.getChannel("screenshotEncoder_in")

game.screenshotEncoder:start()

function game.captureScreenshot(threaded)
	local screenShot = love.graphics.newScreenshot(true)
	
	if threaded then
		game.screenshotEncoder_CHANNEL_IN:push(screenShot)
	else
		love.filesystem.writeScreenshot(screenShot)
	end
end
