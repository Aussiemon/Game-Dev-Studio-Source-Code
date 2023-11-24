local themeSel = {}

themeSel.themeSelectedColor = color(120, 169, 204, 255)
themeSel.CATCHABLE_EVENTS = {
	gameProject.EVENTS.CHANGED_THEME
}

function themeSel:setTheme(data)
	self.theme = data
end

function themeSel:setProject(proj)
	self.project = proj
end

function themeSel:handleEvent(event, gameProj, genreID)
	self:queueSpriteUpdate()
end

function themeSel:init()
	self.fontObject = fonts.get("pix20")
end

function themeSel:onSizeChanged()
	self.textX, self.textY = _S(self.backDropSize + 7), _S(3) + _S(self.backDropSize * 0.5) - self.fontObject:getHeight() * 0.5
end

function themeSel:onMouseEntered()
	themeSel.baseClass.onMouseEntered(self)
	
	local element = gui:getElementByID(gameProject.THEME_GENRE_MATCH_DESCBOX_ID)
	local x, y = element:getPos(true)
	local baseX = x + element.w
	
	element:updateDisplay(self.theme.id)
	element:setPos(baseX - element.w, y)
end

function themeSel:onMouseLeft()
	themeSel.baseClass.onMouseLeft(self)
	gui:getElementByID(gameProject.THEME_GENRE_MATCH_DESCBOX_ID):hideDisplay()
end

function themeSel:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		self.project:setTheme(self.theme.id)
	end
end

function themeSel:getPanelSelectColor()
	local ourTheme = self.theme.id
	local proj = self.project
	
	if proj:getTheme() == ourTheme then
		return self.themeSelectedColor
	end
end

function themeSel:onClickDown(x, y, key)
	sound:play("click_down", nil, nil, nil)
end

function themeSel:playClickSound(onClickState)
	sound:play("click_release", nil, nil, nil)
end

function themeSel:isOn()
	local proj = self.project
	local ourTheme = self.theme.id
	
	return proj:getTheme() == ourTheme
end

themeSel.backDropSize = 26

function themeSel:updateSprites()
	themeSel.baseClass.updateSprites(self)
	
	local backSize = self.backDropSize
	local isOn = self:isOn()
	local backColor, checkSprite
	
	if isOn then
		backColor = game.UI_COLORS.IMPORTANT_2
		checkSprite = "checkbox_on"
	else
		backColor = game.UI_COLORS.LIGHT_BLUE
		checkSprite = "checkbox_off"
	end
	
	self:setNextSpriteColor(backColor:unpack())
	
	self.gradientBack = self:allocateSprite(self.gradientBack, "weak_gradient_horizontal", _S(3), _S(3), 0, self.rawW - 50, backSize, 0, 0, -0.095)
	
	self:setNextSpriteColor(255, 255, 255, 255)
	
	self.backdrop = self:allocateSprite(self.backdrop, checkSprite, _S(4), _S(4), 0, backSize, backSize, 0, 0, -0.08)
end

function themeSel:draw(w, h)
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self.theme.display, self.textX, self.textY, 255, 255, 255, 255, 0, 0, 0, 255)
end

gui.register("ThemeSelectionElement", themeSel, "GenericElement")
