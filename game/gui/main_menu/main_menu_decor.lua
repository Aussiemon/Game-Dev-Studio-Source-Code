local mainMenuDecor = {}

mainMenuDecor.spriteName = nil
mainMenuDecor.canHover = false

function mainMenuDecor:setSprite(name)
	self.spriteName = name
end

function mainMenuDecor:updateSprites()
	self.spriteID = self:allocateSprite(self.spriteID, self.spriteName, 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.5)
end

gui.register("MainMenuDecor", mainMenuDecor)
