local buyBook = {}

function buyBook:onClick(x, y, key)
	local bookData = self:getParent():getBookData()
	local cost = bookData:getCost()
	
	if studio:hasFunds(cost) then
		bookController:purchaseBook(bookData.id)
		
		if bookController:getCurrentBookshelfObject():placeBook(bookData.id) then
			events:fire(buyBook.EVENTS.POST_PURCHASE_PLACE_BOOK, bookData.id)
			self:updateClickability()
		else
			events:fire(buyBook.EVENTS.POST_PURCHASE_BOOK, bookData.id)
		end
	end
end

buyBook.ALREADY_PRESENT_HOVERTEXT = {
	{
		font = "bh18",
		wrapWidth = 400,
		iconWidth = 22,
		iconHeight = 22,
		icon = "exclamation_point",
		text = _T("BOOK_ALREADY_PRESENT_IN_THE_OFFICE_OF_BOOK", "This book is already on a bookshelf in this office")
	}
}

function buyBook:updateClickability()
	local bookshelf = bookController:getCurrentBookshelfObject()
	
	if bookController:isBookAllocated(bookshelf:getOffice(), self:getParent():getBookData().id) then
		self:setCanClick(false)
		self:setHoverText(buyBook.ALREADY_PRESENT_HOVERTEXT)
		self:queueSpriteUpdate()
	end
end

function buyBook:updateText()
	local bookData = self.parent:getBookData()
	
	self:setText(string.easyformatbykeys(_T("PURCHASE_AND_PLACE_BOOK", "Buy & place $PRICE"), "PRICE", bookData:getCost()))
end

gui.register("BookBuyAndPlaceButton", buyBook, "BookBuyButton")
