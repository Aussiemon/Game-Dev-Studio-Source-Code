local bookshelfBase = {}

bookshelfBase.class = "bookshelf_object_base"
bookshelfBase.objectType = "bookshelf"
bookshelfBase.minimumIllumination = 0
bookshelfBase.maxBooks = 3
bookshelfBase.bookshelfQuads = {}
bookshelfBase.BOOKSHELF = true
bookshelfBase.BASE = true
bookshelfBase.monthlyCosts = monthlyCost.new()
bookshelfBase.EVENTS = {
	FILLED = events:new(),
	CLEARED = events:new(),
	POST_CLEARED = events:new(),
	BOOK_COUNT_CHANGED = events:new(),
	BOOK_REMOVED = events:new(),
	BOOK_ADDED = events:new()
}

function bookshelfBase:init()
	bookshelfBase.baseClass.init(self)
	
	self.allocatedBooks = {}
	self.skillContribution = {}
end

function bookshelfBase:addDescriptionToDescbox(descBox, wrapWidth)
	bookshelfBase.baseClass.addDescriptionToDescbox(self, descBox, wrapWidth)
	descBox:addText(_T("BOOKSHELF_DESCRIPTION_1", "Can be filled with books to increase skill progression speed"), "bh18", nil, 0, wrapWidth, "question_mark", 22, 22)
	descBox:addText(_T("BOOKSHELF_DESCRIPTION_2", "The boost is provided to every employee in the office"), "pix18", nil, 0, wrapWidth)
end

function bookshelfBase:onPurchased()
	bookshelfBase.baseClass.onPurchased(self)
	bookController:addBookshelfObject(self)
end

function bookshelfBase:onRemoved()
	bookshelfBase.baseClass.onRemoved(self)
	bookController:removeBookshelfObject(self)
	self:clearBooks(not self.sold, true)
end

function bookshelfBase.openBookMenuCallback(option)
	bookController:createBookPurchaseMenu(option.bookshelf)
end

eventBoxText:registerNew({
	id = "filled_bookshelves",
	getText = function(self, data)
		return _format(data > 1 and _T("FILLED_BOOKSHELVES_WITH_BOOKS", "Filled AMOUNT bookshelves with books.") or _T("FILLED_BOOKSHELF_WITH_BOOKS", "Filled AMOUNT bookshelf with books."), "AMOUNT", data)
	end
})

function bookshelfBase.fillAllBookshelvesCallback(option)
	local totalFilled = 0
	
	for key, object in ipairs(bookController:getBookshelves()) do
		if object:fillWithBooks(true) > 0 then
			totalFilled = totalFilled + 1
		end
	end
	
	if totalFilled > 0 then
		bookController:recalculateAllSkillExperienceBoosts()
		game.addToEventBox("filled_bookshelves", totalFilled, 1)
	end
end

eventBoxText:registerNew({
	id = "cleared_bookshelves",
	getText = function(self, data)
		return _format(data > 1 and _T("CLEARED_BOOKSHELVES", "Cleared AMOUNT bookshelves.") or _T("CLEARED_BOOKSHELF", "Cleared AMOUNT bookshelf."), "AMOUNT", data)
	end
})

function bookshelfBase.clearAllBookshelvesCallback(option)
	local totalCleared = 0
	
	for key, object in ipairs(bookController:getBookshelves()) do
		if object:clearBooks(true) > 0 then
			totalCleared = totalCleared + 1
		end
	end
	
	if totalCleared then
		bookController:recalculateAllSkillExperienceBoosts()
		game.addToEventBox("cleared_bookshelves", totalCleared, 1)
	end
end

function bookshelfBase:fillInteractionComboBox(comboBox)
	comboBox:addOption(0, 0, 0, 24, _T("MANAGE_BOOKS", "Manage books"), fonts.get("pix20"), bookshelfBase.openBookMenuCallback).bookshelf = self
	comboBox:addOption(0, 0, 0, 24, _T("FILL_ALL_BOOKSHELVES", "Fill all bookshelves"), fonts.get("pix20"), bookshelfBase.fillAllBookshelvesCallback).bookshelf = self
	comboBox:addOption(0, 0, 0, 24, _T("CLEAR_ALL_BOOKSHELVES", "Clear all bookshelves"), fonts.get("pix20"), bookshelfBase.clearAllBookshelvesCallback).bookshelf = self
end

function bookshelfBase:getDisplayText()
	return _format(_T("BOOKSHELF_FULLNESS_LAYOUT", "NAME (CURRENT/MAX)"), "NAME", self:getName(), "CURRENT", #self.allocatedBooks, "MAX", self.maxBooks)
end

bookshelfBase.boostIDs = {}

function bookshelfBase:setupMouseOverDescbox(descbox, wrapWidth)
	bookshelfBase.baseClass.setupMouseOverDescbox(self, descbox, wrapWidth)
	
	for key, bookID in ipairs(self.allocatedBooks) do
		local bookData = bookController.registeredByID[bookID]
		
		if bookData.skillBoost and not table.find(self.boostIDs, bookData.skillBoost.id) and bookData.skillBoost then
			self.boostIDs[#self.boostIDs + 1] = bookData.skillBoost.id
		end
	end
	
	local total = #self.boostIDs
	
	if total > 0 then
		descbox:addSpaceToNextText(5)
		
		for key, skillID in ipairs(self.boostIDs) do
			local skillData = skills.registeredByID[skillID]
			
			descbox:addText(_format(_T("BOOKSHELF_SKILL_BOOST_DISPLAY", "+BOOST% to SKILL exp"), "BOOST", self.skillContribution[skillID] * 100, "SKILL", skillData.display), "bh_world20", game.UI_COLORS.LIGHT_BLUE_TEXT, key ~= total and 4 or 0, wrapWidth, skillData.icon, 20, 20)
			
			self.boostIDs[key] = nil
		end
	end
end

function bookshelfBase:getTextureQuad()
	return quadLoader:getQuad(self.bookshelfQuads[math.min(#self.bookshelfQuads, self.allocatedBooks and #self.allocatedBooks or 0)])
end

function bookshelfBase:recalculateContribution()
	table.clear(self.skillContribution)
	
	for key, bookID in ipairs(self.allocatedBooks) do
		local bookData = bookController.registeredByID[bookID]
		
		if bookData.skillBoost then
			self.skillContribution[bookData.skillBoost.id] = (self.skillContribution[bookData.skillBoost.id] or 0) + bookData.skillBoost.boost
		end
	end
end

function bookshelfBase:changeContribution(bookID, modifier)
	local bookData = bookController.registeredByID[bookID]
	
	if bookData.skillBoost then
		self.skillContribution[bookData.skillBoost.id] = (self.skillContribution[bookData.skillBoost.id] or 0) + bookData.skillBoost.boost * modifier
	end
end

function bookshelfBase:getContributedSkills()
	return self.skillContribution
end

function bookshelfBase:getContributedSkill(skillID)
	return self.skillContribution[skillID] or 0
end

function bookshelfBase:hasBook(bookID)
	for key, otherBookID in ipairs(self.allocatedBooks) do
		if otherBookID == bookID then
			return true
		end
	end
end

function bookshelfBase:placeBook(bookID)
	if self:hasBook(bookID) then
		return false
	end
	
	if #self.allocatedBooks >= self.maxBooks then
		self:removeBook(self.allocatedBooks[1])
	end
	
	self.allocatedBooks[#self.allocatedBooks + 1] = bookID
	
	bookController:allocateBook(bookID, self)
	self:changeContribution(bookID, 1)
	self:updateSprite()
	events:fire(bookshelfBase.EVENTS.BOOK_ADDED, self, bookID)
	events:fire(bookshelfBase.EVENTS.BOOK_COUNT_CHANGED, self, bookID)
	
	return true
end

function bookshelfBase:removeBook(bookID)
	local success = false
	
	for key, otherBookID in ipairs(self.allocatedBooks) do
		if otherBookID == bookID then
			table.remove(self.allocatedBooks, key)
			
			success = true
			
			break
		end
	end
	
	if not success then
		return false
	end
	
	bookController:deallocateBook(bookID, self)
	self:changeContribution(bookID, -1)
	self:updateSprite()
	events:fire(bookshelfBase.EVENTS.BOOK_REMOVED, self, bookID)
	events:fire(bookshelfBase.EVENTS.BOOK_COUNT_CHANGED, self, bookID)
	
	return true
end

function bookshelfBase:fillWithBooks(quiet)
	local books = bookController:getUnallocatedBooks(self.office)
	local allocated = math.min(#books, self.maxBooks - #self.allocatedBooks)
	
	for i = 1, allocated do
		local bookID = table.remove(books, math.random(1, #books))
		
		self.allocatedBooks[#self.allocatedBooks + 1] = bookID
		
		bookController:allocateBook(bookID, self, true)
		self:changeContribution(bookID, 1)
	end
	
	table.clearArray(books)
	
	if not quiet then
		bookController:recalculateSkillExperienceBoosts(self.office)
	end
	
	self:updateSprite()
	events:fire(bookshelfBase.EVENTS.FILLED, self, self.allocatedBooks)
	events:fire(bookshelfBase.EVENTS.BOOK_COUNT_CHANGED, self)
	
	return allocated
end

function bookshelfBase:sell()
	self.sold = true
	
	bookshelfBase.baseClass.sell(self)
end

function bookshelfBase:clearBooks(quiet, skipSpriteUpdate)
	events:fire(bookshelfBase.EVENTS.CLEARED, self, self.allocatedBooks)
	
	local prev = #self.allocatedBooks
	
	for key, bookID in ipairs(self.allocatedBooks) do
		bookController:deallocateBook(bookID, self, true)
		self:changeContribution(bookID, -1)
		
		self.allocatedBooks[key] = nil
	end
	
	if not quiet then
		bookController:recalculateSkillExperienceBoosts(self.office)
	end
	
	if not skipSpriteUpdate then
		self:updateSprite()
	end
	
	events:fire(bookshelfBase.EVENTS.POST_CLEARED, self)
	events:fire(bookshelfBase.EVENTS.BOOK_COUNT_CHANGED, self)
	
	return prev
end

function bookshelfBase:getStoredBooks()
	return self.allocatedBooks
end

function bookshelfBase:getMaxBooks()
	return self.maxBooks
end

bookshelfBase.getAllocatedBooks = bookshelfBase.getStoredBooks
bookshelfBase.getFilledBooks = bookshelfBase.getStoredBooks

function bookshelfBase:save()
	local saved = bookshelfBase.baseClass.save(self)
	
	saved.allocatedBooks = self.allocatedBooks
	
	return saved
end

function bookshelfBase:load(data)
	bookshelfBase.baseClass.load(self, data)
	
	self.allocatedBooks = data.allocatedBooks or self.allocatedBooks
	
	self:recalculateContribution()
	
	for key, bookID in ipairs(self.allocatedBooks) do
		bookController:allocateBook(bookID, self, true)
	end
end

objects.registerNew(bookshelfBase, "static_object_base")
