local installedMod = {}

function installedMod:setFolderName(name)
	self.folderName = name
	self.textX = _S(5)
	self.textY = self.h * 0.5 - self.fontObject:getHeight() * 0.5
end

function installedMod:draw(w, h)
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self.folderName, self.textX, self.textY, 255, 255, 255, 255, 0, 0, 0, 255)
end

gui.register("LocalInstalledMod", installedMod, "GenericElement")
