local qualityPointFrame = {}

qualityPointFrame._iconSpacing = 3
qualityPointFrame._baseDisplayWidth = 80
qualityPointFrame._baseDisplayHeight = 26
qualityPointFrame._verticalFontSpacing = 3
qualityPointFrame.baseIconSize = 16
qualityPointFrame.mainTextBackgroundColor = color(86, 104, 135, 255)

function qualityPointFrame:init()
	self.textFont = fonts.get("pix22")
	self.mainTextFont = fonts.get("pix24")
	self.mainTextFontHeight = self.mainTextFont:getHeight()
	self.baseDisplayWidth = math.round(_S(qualityPointFrame._baseDisplayWidth))
	self.baseDisplayHeight = math.round(_S(qualityPointFrame._baseDisplayHeight))
	self.iconSpacing = math.round(_S(qualityPointFrame._iconSpacing))
	self.verticalFontSpacing = math.round(_S(qualityPointFrame._verticalFontSpacing))
	self.iconScale = _S(1.5)
	self.scaledIconSize = self.baseIconSize * self.iconScale
	
	self:setDisplayText(_T("QUALITY", "Quality"))
	
	self.quadBatch = spriteBatchController:newSpriteBatch("quality_point_display_quads", "textures/generic_quad.png", 8, "static", 100, false, true, false, true)
	self.genericQuad = quadLoader:load("generic_quad", "textures/generic_quad.png", 0, 0, 1, 1)
	self.spritebatch = spriteBatchController:newSpriteBatch("quality_point_display", "textures/spritesheets/ui_icons.png", 8, "static", 100, false, true, false, true)
	self.text = love.graphics.newText(self.textFont)
end

function qualityPointFrame:setDisplayText(text)
	self.displayText = text
	self.qualityTextWidth = self.mainTextFont:getWidth(text)
end

function qualityPointFrame:getScaledIconSize()
	return self.scaledIconSize
end

function qualityPointFrame:getIconScale()
	return self.iconScale
end

function qualityPointFrame:setProject(proj)
	self.project = proj
end

function qualityPointFrame:getQuadBatch()
	return self.quadBatch
end

function qualityPointFrame:getSpriteBatch()
	return self.spritebatch
end

function qualityPointFrame:getTextBatch()
	return self.text
end

function qualityPointFrame:getProject()
	return self.project
end

function qualityPointFrame:rebuildText()
	self.text:clear()
	
	for key, element in ipairs(self.children) do
		element:buildText()
	end
end

function qualityPointFrame:setupDisplay()
	local maxWidth = self.w
	local rowCount = 0
	local curH = self.mainTextFontHeight + self.verticalFontSpacing + self.iconSpacing
	
	self.quadBatch:resetContainer()
	self.spritebatch:resetContainer()
	self.text:clear()
	
	local qualityTypeCount = #gameQuality.registered
	
	for key, qualityData in ipairs(gameQuality.registered) do
		local element = gui.create("QualityPointDisplay", self)
		
		element:setBaseFrame(self)
		element:setQualityID(qualityData.id)
		element:addDepth(5)
		
		curH = curH + self.iconSpacing
		
		element:setupDisplay(self.iconSpacing, curH, self.baseDisplayWidth, self.baseDisplayHeight)
		element:setPos(self.iconSpacing, curH)
		
		curH = curH + self.baseDisplayHeight
	end
	
	self.w = self.baseDisplayWidth + self.iconSpacing * 2
	self.h = curH + self.iconSpacing
	self.qualityTextY = _S(2)
end

function qualityPointFrame:draw(w, h)
	love.graphics.setColor(0, 0, 0, 150)
	love.graphics.rectangle("fill", 0, 0, w, h)
	love.graphics.setColor(qualityPointFrame.mainTextBackgroundColor:unpack())
	love.graphics.rectangle("fill", self.iconSpacing, self.iconSpacing, w - self.iconSpacing * 2, self.mainTextFontHeight + self.verticalFontSpacing)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setFont(self.mainTextFont)
	love.graphics.printST(self.displayText, w * 0.5 - self.qualityTextWidth * 0.5, self.qualityTextY + self.iconSpacing)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.quadBatch:getSpritebatch(), 0, 0)
	love.graphics.draw(self.spritebatch:getSpritebatch(), 0, 0)
	love.graphics.draw(self.text, 0, 0)
end

gui.register("QualityPointFrame", qualityPointFrame)
