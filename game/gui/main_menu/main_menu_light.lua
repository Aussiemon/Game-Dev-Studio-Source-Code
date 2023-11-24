local mainMenuLight = {}

mainMenuLight.canHover = false
mainMenuLight.hightlightSpeed = 1

function mainMenuLight:init()
	self.lightStrength = 0
end

function mainMenuLight:draw(w, h)
	love.graphics.setBlendMode("add")
	
	local quadStruct = quadLoader:getQuadStructure("main_menu_window_light")
	
	self.lightStrength = self.lightStrength + frameTime * self.hightlightSpeed
	
	if self.lightStrength >= math.pi * 2 then
		self.lightStrength = self.lightStrength - math.pi * 2
	end
	
	love.graphics.setColor(255, 255, 255, 70 + math.ceil(60 * math.max(0, math.sin(self.lightStrength)) / 10) * 10)
	love.graphics.setBlendMode("add")
	
	local scaleX, scaleY = quadStruct.quad:getSpriteScale(w, h)
	
	love.graphics.draw(quadStruct.texture, quadStruct.quad, 0, 0, 0, scaleX, scaleY)
	love.graphics.setBlendMode("alpha")
end

gui.register("MainMenuLight", mainMenuLight)
