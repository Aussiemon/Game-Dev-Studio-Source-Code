local bookshelfInfo = {}

bookshelfInfo.bookshelfIconPad = 3
bookshelfInfo.internalBookshelfIconPad = 1
bookshelfInfo.buttonPad = 2
bookshelfInfo.textYPad = 5
bookshelfInfo.FULLNESS_SPRITES = {
	"icon_bookshelf_1",
	"icon_bookshelf_2",
	"icon_bookshelf_3",
	"icon_bookshelf_4"
}

function bookshelfInfo:init(bookshelf)
	self.bookshelf = bookshelf
	
	self:createButtons()
	self:updateText()
	self:updateFont()
	
	self.bookDisplayList = gui.create("AllocatedBookList", self)
	
	self.bookDisplayList:setLayoutType(self.bookDisplayList.LAYOUT_TYPES.HORIZONTAL)
	self:createBookDisplay()
end

function bookshelfInfo:getBookshelf()
	return self.bookshelf
end

function bookshelfInfo:postResolutionChanged()
	self:updateFont()
end

function bookshelfInfo:updateFont()
	self.fontObject = fonts.get("bh20")
end

function bookshelfInfo:performLayout()
	self:updateTextDisplayCoords()
end

function bookshelfInfo:onSizeChanged()
	self:updateTextDisplayCoords()
	self:positionButtons()
	
	local x, y = self.fillButton:getPos()
	
	self.bookDisplayList:setPos(self.fillButton.x + self.fillButton.w + _S(self.bookshelfIconPad), y)
end

function bookshelfInfo:createBookDisplay()
	for key, bookID in ipairs(self.bookshelf:getStoredBooks()) do
		self:createAllocatedBookDisplay(bookController:getBookData(bookID))
	end
end

function bookshelfInfo:createAllocatedBookDisplay(bookData)
	local bookDisplay = gui.create("AllocatedBook", self.bookDisplayList)
	
	bookDisplay:setBookData(bookData)
	bookDisplay:setSize(36, 36)
	
	return bookDisplay
end

function bookshelfInfo:handleEvent(event, bookshelfObject, bookID)
	local bookshelfClass = objects.getClassData("bookshelf_object_base")
	
	if event == bookshelfClass.EVENTS.BOOK_COUNT_CHANGED and bookshelfObject == self.bookshelf then
		self:updateSprites()
		self:updateText()
	elseif event == bookshelfClass.EVENTS.BOOK_ADDED then
		self:createAllocatedBookDisplay(bookController:getBookData(bookID))
	elseif event == bookshelfClass.EVENTS.BOOK_REMOVED then
		self.bookDisplayList:removeBookByID(bookID)
	elseif event == bookshelfClass.EVENTS.CLEARED then
		self.bookDisplayList:clearBooks()
	elseif event == bookshelfClass.EVENTS.FILLED then
		self.bookDisplayList:clearBooks()
		self:createBookDisplay()
	end
end

function bookshelfInfo:createButtons()
	self.fillButton = gui.create("BookshelfFillButton", self)
	
	self.fillButton:setFont("pix18")
	self.fillButton:setText(_T("FILL_WITH_BOOKS", "Fill with books"))
	self.fillButton:setSize(120, 20)
	
	self.clearButton = gui.create("BookshelfClearButton", self)
	
	self.clearButton:setFont("pix18")
	self.clearButton:setText(_T("CLEAR_BOOKSHELF", "Clear bookshelf"))
	self.clearButton:setSize(120, 20)
end

function bookshelfInfo:positionButtons()
	local edge = self:getBookshelfIconEdge()
	local buttonPad = _S(self.buttonPad)
	local y = _S(self.textYPad) + self.fontObject:getHeight() + buttonPad
	
	self.fillButton:setPos(edge, y)
	
	y = y + self.fillButton:getHeight() + buttonPad * 2
	
	self.clearButton:setPos(edge, y)
end

function bookshelfInfo:getBookshelfIconEdge()
	local quad = quadLoader:getQuad(bookshelfInfo.FULLNESS_SPRITES[1])
	local w, h = quad:getSize()
	local scale = quad:getScaleToSize(self.rawH)
	
	return _S(w * scale) + _S(self.bookshelfIconPad) + _S(self.internalBookshelfIconPad) * 2
end

function bookshelfInfo:updateText()
	self.displayText = string.easyformatbykeys(_T("BOOKSHELF_CAPACITY", "Capacity: CUR/MAX full"), "CUR", #self.bookshelf:getStoredBooks(), "MAX", self.bookshelf:getMaxBooks())
	
	self:updateTextDisplayCoords()
end

function bookshelfInfo:updateTextDisplayCoords()
	self.textX = self:getBookshelfIconEdge()
	self.textY = _S(self.textYPad)
end

function bookshelfInfo:updateSprites()
	local iconPad = bookshelfInfo.bookshelfIconPad
	local totalPad = iconPad + bookshelfInfo.internalBookshelfIconPad
	local scaledIconPad = _S(iconPad)
	local scaledInternalPad = _S(bookshelfInfo.internalBookshelfIconPad)
	local totalScaledPad = scaledIconPad + scaledInternalPad
	local quad = quadLoader:getQuad(bookshelfInfo.FULLNESS_SPRITES[1])
	local quadW, quadH = quad:getSize()
	local scale = quad:getScaleToSize(self.rawH)
	
	quadW, quadH = quadW * scale, quadH * scale
	
	self:setNextSpriteColor(0, 0, 0, 100)
	
	self.baseSprite = self:allocateSprite(self.baseSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
	
	local underShelfSpriteWidth = quadW - iconPad
	local underShelfSpriteHeight = quadH - iconPad
	
	self:setNextSpriteColor(0, 0, 0, 200)
	
	self.underBookshelfSprite = self:allocateSprite(self.underBookshelfSprite, "generic_1px", scaledIconPad, scaledIconPad, 0, underShelfSpriteWidth, underShelfSpriteHeight, 0, 0, -0.1)
	
	local index = math.min(#bookshelfInfo.FULLNESS_SPRITES, math.max(1, #self.bookshelf:getStoredBooks() + 1))
	local sprite = bookshelfInfo.FULLNESS_SPRITES[index]
	
	self.bookshelfSprite = self:allocateSprite(self.bookshelfSprite, sprite, totalScaledPad, totalScaledPad, 0, quadW - totalPad, quadH - totalPad, 0, 0, -0.05)
	
	self:setNextSpriteColor(0, 0, 0, 255)
	
	self.gradientSprite = self:allocateSprite(self.gradientSprite, "weak_gradient_horizontal", _S(quadW) + scaledInternalPad, scaledIconPad, 0, self.rawW - underShelfSpriteWidth - iconPad * 3, self.rawH - iconPad * 2, 0, 0, -0.1)
end

function bookshelfInfo:draw(w, h)
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self.displayText, self.textX, self.textY, 255, 255, 255, 255, 0, 0, 0, 255)
end

gui.register("BookshelfInfoDisplay", bookshelfInfo)
