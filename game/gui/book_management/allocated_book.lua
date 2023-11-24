local allocatedBook = {}

allocatedBook.skillBoostColorText = color(215, 255, 204, 255)

function allocatedBook:setBookData(bookData)
	self.bookData = bookData
end

function allocatedBook:getBookData()
	return self.bookData
end

function allocatedBook:onMouseEntered()
	self.descBox = gui.create("GenericDescbox")
	
	self.descBox:addText(self.bookData.display, "pix22", nil, 0, 400)
	self.descBox:addText(self.bookData:formulateBoostText(), "pix20", game.UI_COLORS.LIGHT_BLUE, 0, 400, "increase", 22, 22)
	
	if self.bookData.description then
		self.descBox:addSpaceToNextText(5)
		
		for key, data in ipairs(self.bookData.description) do
			self.descBox:addText(data.text, data.font, data.textColor, data.lineSpace or 0, 400)
		end
	end
	
	self.descBox:addSpaceToNextText(10)
	self.descBox:addText(_T("BOOK_UNASSIGN_BUTTON", "Remove from bookshelf"), "pix20", game.UI_COLORS.IMPORTANT_1, 0, 400, "mouse_right", 22, 22)
	self.descBox:centerToElement(self)
end

function allocatedBook:onClick(x, y, key)
	if key == gui.mouseKeys.RIGHT then
		bookController:getCurrentBookshelfObject():removeBook(self.bookData.id)
	end
end

function allocatedBook:onMouseLeft()
	self:killDescBox()
end

function allocatedBook:updateSprites()
	self.bookSprite = self:allocateSprite(self.bookSprite, self.bookData.icon, 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
end

gui.register("AllocatedBook", allocatedBook)
