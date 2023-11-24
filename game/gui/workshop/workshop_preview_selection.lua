local previewSel = {}

previewSel.CATCHABLE_EVENTS = {
	workshop.EVENTS.PREVIEW_FOLDER_SELECTED
}
previewSel.mouseOverColor = game.UI_COLORS.LIGHT_GREEN:duplicate()
previewSel.mouseOverColor.a = 150

function previewSel:init()
	self.invalidParameters = {}
end

function previewSel:setBackColor(clr)
	self.backColor = clr
end

function previewSel:updateSprites()
	if self.active then
		self:setNextSpriteColor(game.UI_COLORS.LIGHT_GREEN:unpack())
	elseif self:isMouseOver() then
		self:setNextSpriteColor(previewSel.mouseOverColor:unpack())
	else
		self:setNextSpriteColor(self.backColor:unpack())
	end
	
	self.backSprite = self:allocateSprite(self.backSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
end

function previewSel:setDirectory(dir, displayDir)
	self.directory = dir
	self.displayDirectory = displayDir
	
	self:verifyDirectory()
end

function previewSel:loadImage()
	self.image = love.graphics.newImage(self.directory)
end

function previewSel:onKill()
	self.image = nil
end

function previewSel:verifyDirectory()
	if not love.filesystem.exists(self.directory) then
		return false
	end
	
	return true
end

function previewSel:handleEvent(event, dir)
	self.active = self.directory == dir
	
	self:queueSpriteUpdate()
end

function previewSel:onMouseEntered()
	if not self.image then
		self:loadImage()
	end
	
	self.imgDisplay = gui.create("GenericImage")
	
	self.imgDisplay:setImage(self.image)
	self.imgDisplay:setDesiredSize(200)
	self.imgDisplay:positionToMouse(_S(5), _S(5))
	self.imgDisplay:tieVisibilityTo(self)
	self.imgDisplay:bringUp()
	self:queueSpriteUpdate()
end

function previewSel:onMouseLeft()
	self:killDescBox()
	
	if self.imgDisplay then
		self.imgDisplay:kill()
		
		self.imgDisplay = nil
	end
	
	self:queueSpriteUpdate()
end

function previewSel:setFont(font)
	self.font = font
	self.fontObject = fonts.get(font)
	self.textY = self.h * 0.5 - self.fontObject:getHeight() * 0.5
end

function previewSel:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		workshop:getModUploadData().preview = self.directory
		self.active = true
		
		local button = workshop:getNextPageButton()
		
		button:setCanClick(true)
		button:queueSpriteUpdate()
		events:fire(workshop.EVENTS.PREVIEW_FOLDER_SELECTED, self.directory)
	end
end

function previewSel:draw(w, h)
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self.displayDirectory, _S(2), self.textY, 255, 255, 255, 255, 0, 0, 0, 255)
end

gui.register("WorkshopPreviewSelection", previewSel)
