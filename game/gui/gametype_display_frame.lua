local gametypeDisplay = {}

gametypeDisplay.DESCBOX_SPACING = 5
gametypeDisplay.DESCBOX_COLOR = color(134, 144, 160, 150)
gametypeDisplay.EVENTS = {
	CHANGED_GAMETYPE = events:new()
}

function gametypeDisplay:init()
	self.topTextFont = fonts.get("pix24")
	self.topTextFontHeight = self.topTextFont:getHeight()
	self.topTextFontOffset = _S(3)
	self.topText = _T("NONE_SELECTED", "None selected")
	self.descBox = gui.create("GenericDescbox", self)
	
	self.descBox:setBackgroundColor(gametypeDisplay.DESCBOX_COLOR)
	self.descBox:setFadeInSpeed(0)
end

function gametypeDisplay:bringUp()
	self:addDepth(5)
end

function gametypeDisplay:onSizeChanged()
	self.descBox:addText(_T("SELECT_GAME_TYPE", "Please select one of the game types available on the list to the left to proceed with starting a new game."), "pix20", nil, 0, self.rawW)
	self:adjustDescboxPosition()
end

function gametypeDisplay:adjustDescboxPosition()
	local scaledSpace = _S(gametypeDisplay.DESCBOX_SPACING)
	
	self.descBox:setPos(0, self:getTopTextPosition() + scaledSpace)
end

function gametypeDisplay:getGametypeData()
	return self.data
end

function gametypeDisplay:kill()
	gametypeDisplay.baseClass.kill(self)
	game.setDesiredGametype(nil)
end

function gametypeDisplay:setSize(w, h)
	gametypeDisplay.baseClass.setSize(self, w, h)
	self.descBox:setWidth(self.w)
end

function gametypeDisplay:setCurrentGametype(data)
	if self.data == data then
		return 
	end
	
	self.data = data
	self.topText = data.display
	
	self.descBox:clearAllText()
	self:adjustDescboxPosition()
	self.descBox:setWidth(self.w)
	self.data:setupText(self.descBox, self)
	self.descBox:setWidth(self.w)
	game.setDesiredGametype(self.data.id, self.descBox)
	events:fire(gametypeDisplay.EVENTS.CHANGED_GAMETYPE)
end

function gametypeDisplay:getTopTextPosition()
	return self.topTextFontHeight + self.topTextFontOffset * 2
end

function gametypeDisplay:draw(w, h)
	local sizeReduct = self.topTextFontOffset * 2
	
	love.graphics.setColor(59, 79, 109, 255)
	love.graphics.rectangle("fill", 0, 0, w, self:getTopTextPosition())
	love.graphics.setFont(self.topTextFont)
	love.graphics.printST(self.topText, sizeReduct, self.topTextFontOffset, 240, 240, 240, 255, 0, 0, 0, 255)
end

gui.register("GametypeDisplay", gametypeDisplay)
