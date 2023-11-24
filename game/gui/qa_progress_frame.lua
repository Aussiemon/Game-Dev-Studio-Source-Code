local qaProgressFrame = {}

qaProgressFrame._iconSpacing = 3
qaProgressFrame._baseDisplayWidth = 80
qaProgressFrame._baseDisplayHeight = 26
qaProgressFrame._verticalFontSpacing = 3
qaProgressFrame._barSize = 9
qaProgressFrame._barFillSize = 7
qaProgressFrame.mainTextBackgroundColor = color(86, 104, 135, 255)
qaProgressFrame.font = "bh24"

function qaProgressFrame:init()
	self.mainTextFont = fonts.get("pix24")
	self.mainTextFontHeight = self.mainTextFont:getHeight()
	self.iconSpacing = math.round(_S(qaProgressFrame._iconSpacing))
	self.barSize = math.round(_S(qaProgressFrame._barSize))
	self.barFillSize = math.round(_S(qaProgressFrame._barFillSize))
	self.barSpacing = self.barSize - self.barFillSize
	
	self:setDisplayText(_T("QA", "QA"))
end

function qaProgressFrame:setData(progress)
	self.progress = progress
end

function qaProgressFrame:onMouseEntered()
	self.descBox = gui.create("GenericDescbox")
	
	self.descBox:addText(_T("QA_DESCRIPTION_1", "This project is currently being tested by an outside QA firm."), "bh20", nil, 3, 500)
	self.descBox:addText(_T("QA_DESCRIPTION_2", "Every day new issues may be found.\nAt the end of the QA session you will be given an overall report on how many issues were found."), "pix18", nil, 10, 500)
	self.descBox:addText(string.easyformatbykeys(_T("QA_PROGRESS_TEXT", "The QA session is currently COMPLETION% complete."), "COMPLETION", math.round(self.progress * 100)), "bh18", game.UI_COLORS.LIGHT_BLUE, 0, 500, "question_mark", 22, 22)
	
	local x, y = self:getPos(true)
	
	self.descBox:setPos(x + self.w + _S(5), y)
	self:queueSpriteUpdate()
end

function qaProgressFrame:onMouseLeft()
	self:killDescBox()
	self:queueSpriteUpdate()
end

function qaProgressFrame:setDisplayText(text)
	self.displayText = text
	self.qualityTextWidth = self.mainTextFont:getWidth(text)
end

function qaProgressFrame:setProject(proj)
	self.project = proj
end

function qaProgressFrame:getProject()
	return self.project
end

function qaProgressFrame:getIconSize()
	return 0
end

function qaProgressFrame:updateSprites()
	self:setNextSpriteColor(0, 0, 0, 150)
	
	self.baseSprite = self:allocateSprite(self.baseSprite, "generic_1px", 0, 0, 0, self.w, self.h, 0, 0, -0.5)
	
	self:setNextSpriteColor(qaProgressFrame.mainTextBackgroundColor:unpack())
	
	self.underTextSprite = self:allocateSprite(self.underTextSprite, "generic_1px", self.iconSpacing, self.iconSpacing, 0, self.w - self.iconSpacing * 2, self.mainTextFontHeight + self.iconSpacing, 0, 0, -0.5)
	
	self:setNextSpriteColor(0, 0, 0, 255)
	
	self.underBarSprite = self:allocateSprite(self.underBarSprite, "generic_1px", self.iconSpacing, self.mainTextFontHeight + self.iconSpacing + self.barSize, 0, self.w - self.iconSpacing * 2, self.barSize, 0, 0, -0.5)
	
	local offset = _S(1)
	local x, y = self.iconSpacing + offset, self.mainTextFontHeight + self.iconSpacing + self.barSize + self.barSpacing * 0.5
	local w, h = self.w - self.iconSpacing * 2 - offset * 2, self.barFillSize
	
	self:setNextSpriteColor(40, 40, 40, 255)
	
	self.innerBarSprite = self:allocateSprite(self.innerBarSprite, "generic_1px", x, y, 0, w, h, 0, 0, -0.5)
	
	self:setNextSpriteColor(165, 202, 104, 255)
	
	self.progressbarSprite = self:allocateSprite(self.progressbarSprite, "generic_1px", x, y, 0, w * self.progress, h, 0, 0, -0.5)
	self.qualityTextY = _S(2)
end

function qaProgressFrame:draw(w, h)
	love.graphics.setFont(self.mainTextFont)
	love.graphics.printST(self.displayText, w * 0.5 - self.qualityTextWidth * 0.5, self.qualityTextY + self.iconSpacing)
end

gui.register("QAProgressFrame", qaProgressFrame, "QualityPointDisplay")
