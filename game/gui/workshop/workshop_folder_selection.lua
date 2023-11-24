local folderSel = {}

folderSel.CATCHABLE_EVENTS = {
	workshop.EVENTS.MOD_FOLDER_SELECTED
}
folderSel.mouseOverColor = game.UI_COLORS.LIGHT_GREEN:duplicate()
folderSel.mouseOverColor.a = 150

function folderSel:init()
	self.invalidParameters = {}
end

function folderSel:setBackColor(clr)
	self.backColor = clr
end

function folderSel:updateSprites()
	if self.active then
		self:setNextSpriteColor(game.UI_COLORS.LIGHT_GREEN:unpack())
	elseif self:isMouseOver() then
		self:setNextSpriteColor(folderSel.mouseOverColor:unpack())
	else
		self:setNextSpriteColor(self.backColor:unpack())
	end
	
	self.backSprite = self:allocateSprite(self.backSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
end

function folderSel:setDirectory(dir, displayDir)
	self.directory = dir
	self.displayDirectory = displayDir
end

function folderSel:verifyDirectory()
	self.validDirectory = workshop:getModDirectoryValidity(self.directory, self.invalidParameters)
	
	if not self.validDirectory then
		self.active = false
	end
end

function folderSel:handleEvent(event, dir)
	self.active = self.directory == dir
	
	self:queueSpriteUpdate()
end

function folderSel:onMouseEntered()
	self.descBox = gui.create("GenericDescbox")
	
	if not self.validDirectory then
		for key, param in ipairs(self.invalidParameters) do
			self.descBox:addText(workshop.INVALID_PARAM_TEXT[param], "bh20", game.UI_COLORS.RED, 0, wrapW, "close_button", 22, 22)
			
			if key < #self.invalidParameters then
				self.descBox:addSpaceToNextText(4)
			end
		end
	else
		self.descBox:addText(_T("WORKSHOP_MOD_FOLDER_VALID", "Mod folder is setup properly"), "bh20", game.UI_COLORS.LIGHT_GREEN, 0, wrapW, "checkmark", 22, 22)
	end
	
	self.descBox:positionToMouse(_S(5), _S(5))
	self:queueSpriteUpdate()
end

function folderSel:onMouseLeft()
	self:killDescBox()
	self:queueSpriteUpdate()
end

function folderSel:setFont(font)
	self.font = font
	self.fontObject = fonts.get(font)
	self.textY = self.h * 0.5 - self.fontObject:getHeight() * 0.5
end

function folderSel:onClick(x, y, key)
	if not self.validDirectory then
		return 
	end
	
	if key == gui.mouseKeys.LEFT then
		workshop:getModUploadData().folder = self.directory
		self.active = true
		
		local button = workshop:getNextPageButton()
		
		button:setCanClick(true)
		button:queueSpriteUpdate()
		events:fire(workshop.EVENTS.MOD_FOLDER_SELECTED, self.directory)
	end
end

function folderSel:draw(w, h)
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self.displayDirectory, _S(2), self.textY, 255, 255, 255, 255, 0, 0, 0, 255)
end

gui.register("WorkshopFolderSelection", folderSel)
