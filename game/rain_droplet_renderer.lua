local rainDropletRenderer = {}

rainDropletRenderer.mtindex = {
	__index = rainDropletRenderer
}

setmetatable(rainDropletRenderer, require("engine/priority_spritebatch_layer").mtindex)

function rainDropletRenderer:draw()
	local progress = 1 - timeOfDay:getBrightness() / 255
	local loss = math.lerp(0, weather.darknessFromLightLevel, progress)
	local r, g, b, a = weather.rainDropletColor:unpack()
	
	love.graphics.setColor(r - loss, g - loss, b - loss, a)
	love.graphics.draw(self.spriteBatch, 0, 0)
	love.graphics.setColor(255, 255, 255, 255)
end

return rainDropletRenderer
