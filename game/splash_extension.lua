local oldReleaseFunc = splash.releaseSplashTextures

function splash:releaseSplashTextures()
	oldReleaseFunc(self)
	self:hide()
	game.initMainState()
end

function splash:show()
	gameStateService:addState(self)
	layerRenderer:addLayer(self)
	inputService:addHandler(self)
	
	self.active = true
end

function splash:hide()
	gameStateService:removeState(self)
	layerRenderer:removeLayer(self)
	inputService:removeHandler(self)
	
	self.active = false
end
