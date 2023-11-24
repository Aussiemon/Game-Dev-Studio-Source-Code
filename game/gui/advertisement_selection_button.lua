local advertButton = {}

advertButton.skinPanelFillColor = color(86, 104, 135, 255)
advertButton.skinPanelHoverColor = color(163, 176, 198, 255)
advertButton.skinPanelDisableColor = color(40, 40, 40, 255)
advertButton.skinTextFillColor = color(220, 220, 220, 255)
advertButton.skinTextHoverColor = color(240, 240, 240, 255)
advertButton.skinTextDisableColor = color(150, 150, 150, 255)

local function confirmOption(self)
	local baseButton = self.tree.baseButton
	
	baseButton:getProject():onAdvertisementSelected(baseButton:getAdvertID())
end

function advertButton:init()
	self.descriptionBox = gui.create("GenericDescbox", self)
	
	self.descriptionBox:setShowRectSprites(false)
	self.descriptionBox:setFadeInSpeed(0)
	self.descriptionBox:overwriteDepth(5)
end

function advertButton:setProject(proj)
	self.project = proj
end

function advertButton:getProject()
	return self.project
end

function advertButton:setAdvertData(data)
	self.advertData = data
	self.advertID = data.id
	self.icon = self.advertData.icon
	
	local wrapWidth = 300
	local scaledLineWidth = _S(wrapWidth)
	
	self.descriptionBox:addTextLine(_S(wrapWidth), gui.genericMainGradientColor, nil, "weak_gradient_horizontal")
	self.descriptionBox:addText(self.advertData.display, "bh22", nil, 3, wrapWidth)
	self.descriptionBox:addTextLine(_S(wrapWidth), gui.genericGradientColor, nil, "weak_gradient_horizontal")
	self.descriptionBox:addText(self.advertData.description[1].text, "pix18", nil, 0, wrapWidth)
end

function advertButton:getAdvertID()
	return self.advertID
end

function advertButton:isDisabled()
	return not self.advertData:canSelect(self.project)
end

function advertButton:onKill()
	self:killDescBox()
end

function advertButton:onSizeChanged()
	self.smallestAxis = math.min(self.rawW, self.rawH)
	
	self.descriptionBox:setPos(math.min(self.w, self.h), _S(2))
end

function advertButton:updateSprites()
	local pcol = self:getStateColor()
	
	self:setNextSpriteColor(gui.genericOutlineColor:unpack())
	
	self.baseSprite = self:allocateSprite(self.baseSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.55)
	
	self:setNextSpriteColor(pcol:unpack())
	
	self.frontSprite = self:allocateSprite(self.frontSprite, "vertical_gradient_75", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.5)
	
	local smallest = self.smallestAxis
	local bgSize = self.smallestAxis - 4
	
	self:setNextSpriteColor(14, 16, 21, 200)
	
	local quadName = self.icon
	local quad = quadLoader:load(quadName)
	local scale = quad:getScaleToSize(bgSize - 4)
	local w, h = quad:getSize()
	
	w, h = w * scale, h * scale
	
	local baseX, baseY = _S(3), _S(2)
	local outC, innerC
	
	if not self.advertData:canSelect(self.project) then
		outC, innerC = game.UI_COLORS.NEW_HUD_OUTER_WEAK, game.UI_COLORS.NEW_HUD_FILL_WEAK
	else
		outC, innerC = game.UI_COLORS.NEW_HUD_OUTER, game.UI_COLORS.NEW_HUD_FILL
	end
	
	self:setNextSpriteColor(outC:unpack())
	
	self.bgSpriteUnder = self:allocateRoundedRectangle(self.bgSpriteUnder, baseX, baseY, bgSize, bgSize, 4, -0.5)
	
	self:setNextSpriteColor(innerC:unpack())
	
	self.bgSprite = self:allocateSprite(self.bgSprite, "vertical_gradient_60", baseX + _S(2), baseY + _S(2), 0, bgSize - 4, bgSize - 4, 0, 0, -0.5)
	self.iconSprite = self:allocateSprite(self.iconSprite, quadName, baseX + _S(bgSize * 0.5 - w * 0.5), baseY + _S(bgSize * 0.5 - h * 0.5), 0, w, h, 0, 0, -0.5)
end

function advertButton:onClick(x, y, key)
	if self:isDisabled() then
		return 
	end
	
	self.project:onAdvertisementSelected(self.advertID)
end

function advertButton:onMouseEntered()
	self:queueSpriteUpdate()
	
	self.descBox = gui.create("GenericDescbox")
	
	local wrapWidth = 500
	
	for key, data in ipairs(self.advertData.description) do
		self.descBox:addText(data.text, data.font, data.color, data.lineSpace, wrapWidth, data.icon, data.iconWidth, data.iconHeight)
	end
	
	self.advertData:setupDescbox(self.project, self.descBox, wrapWidth)
	self.descBox:centerToElement(self)
end

function advertButton:onMouseLeft()
	self:queueSpriteUpdate()
	self:killDescBox()
end

function advertButton:draw(w, h)
end

gui.register("AdvertisementSelectionButton", advertButton, "Button")
