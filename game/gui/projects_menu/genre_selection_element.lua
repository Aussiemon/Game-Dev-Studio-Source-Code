local genreSel = {}

genreSel.subgenreSelectedColor = color(102, 127, 204, 255)
genreSel.genreSelectedColor = color(120, 169, 204, 255)
genreSel.CATCHABLE_EVENTS = {
	gameProject.EVENTS.CHANGED_GENRE,
	gameProject.EVENTS.SUBGENRE_CHANGED
}

function genreSel:setGenre(data)
	self.genre = data
end

function genreSel:setProject(proj)
	self.project = proj
end

function genreSel:isMainGenreOn()
	return self.parent.project:getGenre() == self.parent.genre.id
end

function genreSel:isSubgenreOn()
	return self.parent.project:getSubgenre() == self.parent.genre.id
end

function genreSel:mainGenreCheckCallback()
	local proj = self.parent.project
	local genreID = self.parent.genre.id
	local oldGenre = proj:getGenre()
	
	if oldGenre == genreID then
		proj:setGenre(nil)
	else
		proj:setGenre(genreID)
		
		if proj:getSubgenre() == genreID then
			proj:setSubgenre(nil)
		end
	end
end

function genreSel:subGenreCheckCallback()
	local proj = self.parent.project
	local genreID = self.parent.genre.id
	local oldSubgenre = proj:getSubgenre()
	
	if oldSubgenre == genreID then
		proj:setSubgenre(nil)
	else
		proj:setSubgenre(genreID)
		
		if proj:getGenre() == genreID then
			proj:setGenre(nil)
		end
	end
end

function genreSel:handleEvent(event, gameProj, genreID)
	self.mainGenre:queueSpriteUpdate()
	self.subGenre:queueSpriteUpdate()
	self:queueSpriteUpdate()
end

function genreSel:init()
	self.fontObject = fonts.get("pix20")
end

function genreSel:onSizeChanged()
	self.textX, self.textY = _S(self.backDropSize + 5), _S(3) + _S(self.backDropSize * 0.5) - self.fontObject:getHeight() * 0.5
	
	self:updateCheckboxPositions()
end

function genreSel:onMouseEntered()
	genreSel.baseClass.onMouseEntered(self)
	
	local element = gui:getElementByID(gameProject.GENRE_THEME_MATCH_DESCBOX_ID)
	local x, y = element:getPos(true)
	local baseX = x + element.w
	
	element:updateDisplay(self.genre.id)
	element:setPos(baseX - element.w, y)
	
	local element = gui:getElementByID(gameProject.GENRE_SUBGENRE_MATCH_DESCBOX_ID)
	
	element:updateDisplay(self.genre.id)
end

function genreSel:onMouseLeft()
	genreSel.baseClass.onMouseLeft(self)
	gui:getElementByID(gameProject.GENRE_THEME_MATCH_DESCBOX_ID):hideDisplay()
	gui:getElementByID(gameProject.GENRE_SUBGENRE_MATCH_DESCBOX_ID):hideDisplay()
end

function genreSel:createCheckboxes()
	local mainGenre = gui.create("Checkbox", self)
	
	mainGenre:setSize(20, 20)
	mainGenre:setFont("bh18")
	mainGenre:setText(_T("MAIN_GENRE", "Main genre"))
	mainGenre:setIsOnFunction(genreSel.isMainGenreOn)
	mainGenre:setTextAlignment(gui.SIDES.RIGHT, nil)
	mainGenre:setCheckCallback(genreSel.mainGenreCheckCallback)
	
	self.mainGenre = mainGenre
	
	local subGenre = gui.create("Checkbox", self)
	
	subGenre:setSize(20, 20)
	subGenre:setFont("bh18")
	subGenre:setText(_T("SUB_GENRE", "Sub-genre"))
	subGenre:setIsOnFunction(genreSel.isSubgenreOn)
	subGenre:setTextAlignment(gui.SIDES.LEFT, nil)
	subGenre:setCheckCallback(genreSel.subGenreCheckCallback)
	
	self.subGenre = subGenre
	
	self:updateCheckboxPositions()
end

function genreSel:getPanelSelectColor()
	local ourGenre = self.genre.id
	local proj = self.project
	
	if proj:getGenre() == ourGenre then
		return self.genreSelectedColor
	elseif proj:getSubgenre() == ourGenre then
		return self.subgenreSelectedColor
	end
end

function genreSel:isOn()
	local proj = self.project
	local ourGenre = self.genre.id
	
	return proj:getGenre() == ourGenre or proj:getSubgenre() == ourGenre
end

function genreSel:updateCheckboxPositions()
	if self.mainGenre then
		self.mainGenre:setPos(_S(5), self.h - _S(4) - self.mainGenre.h)
		self.subGenre:setPos(self.w - _S(5) - self.subGenre.w, self.mainGenre.localY)
	end
end

genreSel.backDropSize = 26
genreSel.iconSize = 24

function genreSel:updateSprites()
	genreSel.baseClass.updateSprites(self)
	
	local backSize = self.backDropSize
	local iconSize = self.iconSize
	local iconX, iconW, iconH = genres:getIconUISize(self.genre, backSize, backSize, iconSize)
	local isOn = self:isOn()
	
	if isOn or self:isMouseOver() then
		self:setNextSpriteColor(game.UI_COLORS.IMPORTANT_2:unpack())
		
		self.gradientBack = self:allocateSprite(self.gradientBack, "weak_gradient_horizontal", _S(3), _S(3), 0, self.rawW - 50, backSize, 0, 0, -0.095)
		
		self:setNextSpriteColor(130, 130, 130, 255)
		
		self.backdrop = self:allocateSprite(self.backdrop, "profession_backdrop", _S(3), _S(3), 0, backSize, backSize, 0, 0, -0.09)
		
		self:setNextSpriteColor(255, 255, 255, 255)
		
		self.icon = self:allocateSprite(self.icon, self.genre.icon, _S(3 + iconX), _S(3 + backSize * 0.5 - iconH * 0.5), 0, iconW, iconH, 0, 0, -0.07)
	else
		self:setNextSpriteColor(game.UI_COLORS.LIGHT_BLUE:unpack())
		
		self.gradientBack = self:allocateSprite(self.gradientBack, "weak_gradient_horizontal", _S(3), _S(3), 0, self.rawW - 50, backSize, 0, 0, -0.095)
		
		self:setNextSpriteColor(130, 130, 130, 255)
		
		self.backdrop = self:allocateSprite(self.backdrop, "profession_backdrop", _S(3), _S(3), 0, backSize, backSize, 0, 0, -0.09)
		
		self:setNextSpriteColor(100, 100, 100, 255)
		
		self.icon = self:allocateSprite(self.icon, self.genre.icon, _S(3 + iconX), _S(3 + backSize * 0.5 - iconH * 0.5), 0, iconW, iconH, 0, 0, -0.07)
	end
end

function genreSel:draw(w, h)
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self.genre.display, self.textX, self.textY, 255, 255, 255, 255, 0, 0, 0, 255)
end

gui.register("GenreSelectionElement", genreSel, "GenericElement")
