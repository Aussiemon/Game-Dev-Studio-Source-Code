local bookAllocate = {}

function bookAllocate:onClick(x, y, key)
	bookController:getCurrentBookshelfObject():placeBook(self:getParent():getBookData().id)
end

function bookAllocate:updateText()
	local bookData = self.parent:getBookData()
	
	self:setText(_T("PLACE_BOOK", "Add to bookshelf"))
end

gui.register("BookAllocateButton", bookAllocate, "BookBuyButton")
