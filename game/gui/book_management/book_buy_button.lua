local buyBook = {}

buyBook.EVENTS = {
	POST_PURCHASE_BOOK = events:new(),
	POST_PURCHASE_PLACE_BOOK = events:new()
}

function buyBook:setParent(parent)
	buyBook.baseClass.setParent(self, parent)
	self:updateText()
end

function buyBook:onClick(x, y, key)
	local bookData = self:getParent():getBookData()
	local cost = bookData:getCost()
	
	if studio:hasFunds(cost) then
		bookController:purchaseBook(bookData.id)
		events:fire(buyBook.EVENTS.POST_PURCHASE_BOOK, bookData.id)
	end
end

function buyBook:updateText()
	local bookData = self.parent:getBookData()
	
	self:setText(string.easyformatbykeys(_T("PURCHASE_BOOK", "Purchase $PRICE"), "PRICE", bookData:getCost()))
end

gui.register("BookBuyButton", buyBook, "Button")
