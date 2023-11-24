local loadMap = {}

function loadMap:setFile(filePath, fileName)
	self.mapFile = filePath
	self.mapFileName = fileName
end

function loadMap:onClick()
	mapEditor:loadMap(self.mapFile, self.mapFileName)
	frameController:pop()
end

gui.register("LoadMapButton", loadMap, "Button")
