local genreOption = {}

genreOption.CATCHABLE_EVENTS = {
	gameProject.EVENTS.CHANGED_GENRE
}

function genreOption:init()
	self.subgenresAvailable = studio:canSelectSubgenre()
end

function genreOption:handleEvent(event, projObj, newGenre)
	if self.subgenresAvailable then
		self:highlight(newGenre == self.genreID)
		self:queueSpriteUpdate()
	end
end

function genreOption:onMouseLeft()
	genreOption.baseClass.onMouseLeft(self)
	self:killDescBox()
end

function genreOption:onMouseEntered()
	genreOption.baseClass.onMouseEntered(self)
	
	self.descBox = gui.create("GenericDescbox")
	
	self:prepareDescbox()
	self:positionDescbox()
end

function genreOption:prepareDescbox()
	gameProject:fillWithGenreThemeMatches(self.descBox, self.genreID, 300)
	self.descBox:setDepth(200)
end

function genreOption:createSubgenreSelection()
	local category = gui.create("Category")
	
	category:setFont("bh20")
	category:setHeight(24)
	category:setText(_T("SUBGENRE", "Sub-genre"))
	category:tieVisibilityTo(self.parent)
	category:setCanHover(false)
	category:bringUp()
	
	local cbox = gui.create("ComboBox", nil, true)
	
	cbox:tieVisibilityTo(self.parent)
	self.parent:tieVisibilityTo(cbox)
	cbox:setHoverLink(self.parent)
	cbox:setAutoCloseTime(0.5)
	cbox:bringUp()
	cbox:setOptionButtonType("SubgenreComboBoxOption")
	
	local fontObj = fonts.get("pix20")
	local resGenres = studio:getResearchedGenres()
	local thisGenre = self.genreID
	local curSubgenre = self.baseButton:getProject():getSubgenre()
	
	for key, data in ipairs(genres.registered) do
		local id = data.id
		
		if resGenres[id] and id ~= thisGenre then
			local opt = cbox:addOption(0, 0, self.rawW, 18, data.display, fontObj, nil)
			
			opt:setSubgenre(id)
			opt:setBaseButton(self)
			
			if curSubgenre == id then
				opt:highlight(true)
			end
		end
	end
	
	local x, y = self.parent:getPos(true)
	
	category:setSize(math.max(category.rawW, _US(cbox.rawW) + 1))
	category:setPos(x + self.parent.w + _S(5), y)
	cbox:setPos(category.x, category.y + _S(category.rawH))
	
	cbox.genreID = self.genreID
	cbox.category = category
	self.subgenreCreated = true
	self.parent.subgenreCombobox = cbox
end

function genreOption:onSelectSubgenre(subgenreID)
	self.baseButton:setSubgenre(subgenreID)
end

function genreOption:onClicked()
	self.closeOnClick = false
	
	local success = self:attemptCreateSubgenreList()
	
	self.baseButton:setGenre(self.genreID)
	
	if not success then
		self.closeOnClick = true
	end
end

function genreOption:attemptCreateSubgenreList()
	if self.subgenresAvailable then
		self.closeOnClick = false
		
		self:verifySubgenreList()
		
		return true
	end
	
	return false
end

function genreOption:verifySubgenreList()
	local cbox = self.parent.subgenreCombobox
	
	if cbox then
		if cbox.genreID ~= self.genreID then
			if self.baseButton:getProject():getSubgenre() == self.genreID then
				self.baseButton:setSubgenre(nil)
			end
			
			self.parent:removeVisibilityTie(cbox)
			cbox:removeVisibilityTie(self.parent)
			cbox:kill()
			
			self.parent.subgenreCombobox = nil
		else
			return 
		end
	end
	
	self:createSubgenreSelection()
end

function genreOption:setBaseButton(button)
	self.baseButton = button
end

function genreOption:positionDescbox()
	local x, y = self:getPos(true)
	
	self.descBox:setPos(x - self.descBox.w - _S(5), y)
end

function genreOption:onHide()
	self:killDescBox()
end

function genreOption:kill()
	genreOption.baseClass.kill(self)
	self:killDescBox()
end

function genreOption:setGenre(genreID)
	self.genreID = genreID
end

gui.register("GenreComboBoxOption", genreOption, "ComboBoxOption")
