local gametypeSelection = {}

gametypeSelection.skinPanelFillColor = game.UI_COLORS.NEW_HUD_FILL_3
gametypeSelection.skinPanelHoverColor = game.UI_COLORS.NEW_HUD_HOVER
gametypeSelection.skinPanelSelectColor = game.UI_COLORS.NEW_HUD_HOVER_DESATURATED
gametypeSelection.skinTextFillColor = color(245, 245, 245, 255)
gametypeSelection.skinTextHoverColor = color(245, 245, 245, 255)
gametypeSelection.skinTextSelectColor = color(255, 255, 255, 255)

function gametypeSelection:init()
	self.font = fonts.get("pix20")
end

function gametypeSelection:handleEvent(event)
	if event == gui.getClassTable("GametypeDisplay").EVENTS.CHANGED_GAMETYPE then
		self:queueSpriteUpdate()
	end
end

function gametypeSelection:setGametypeData(data)
	self.gametypeData = data
	
	local text, lineCount, height = string.wrap(self.gametypeData.display, self.font, self.w - _S(2))
	
	self:setHeight(_US(height) + 4)
	
	self.displayText = text
end

function gametypeSelection:setGametypeDisplayFrame(frame)
	self.frame = frame
end

function gametypeSelection:onClick()
	self.frame:setCurrentGametype(self.gametypeData)
	self:queueSpriteUpdate()
end

function gametypeSelection:isOn()
	return self.frame:getGametypeData() == self.gametypeData
end

function gametypeSelection:onMouseEntered()
	self:queueSpriteUpdate()
end

function gametypeSelection:onMouseLeft()
	self:queueSpriteUpdate()
end

function gametypeSelection:updateSprites()
	local pcol, tcol = self:getStateColor()
	
	self:setNextSpriteColor(game.UI_COLORS.NEW_HUD_OUTER:unpack())
	
	self.underSprite = self:allocateSprite(self.underSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
	
	self:setNextSpriteColor(pcol:unpack())
	
	self.backgroundSprite = self:allocateSprite(self.backgroundSprite, "vertical_gradient_75", _S(1), _S(1), 0, self.rawW - 2, self.rawH - 2, 0, 0, -0.1)
end

function gametypeSelection:draw(w, h)
	local pcol, tcol = self:getStateColor()
	
	love.graphics.setFont(self.font)
	love.graphics.printST(self.displayText, _S(2), _S(2), tcol.r, tcol.g, tcol.b, tcol.a, 0, 0, 0, 255)
end

gui.register("GametypeSelection", gametypeSelection)
