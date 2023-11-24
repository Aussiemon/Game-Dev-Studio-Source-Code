local bookInventoryPanel = {}
local booksByID = {}

function bookInventoryPanel:handleEvent(event, bookID, bookData)
	local bookshelfClass = objects.getClassData("bookshelf_object_base")
	
	if event == bookController.EVENTS.BOOK_PLACED then
		for key, item in ipairs(self.items) do
			if item.class == "BookInventoryElement" and item:getBookData().id == bookID then
				self:removeItem(item)
				item:kill()
			end
		end
	elseif event == bookController.EVENTS.BOOK_REMOVED then
		local element = bookController:createBookInventoryElement(bookController:getBookData(bookID))
		
		self:addItem(element)
	elseif event == gui.getClassTable("BookBuyAndPlaceButton").EVENTS.POST_PURCHASE_BOOK and not self:hasBookItem(bookID) and not bookController:isBookAllocated(bookController:getCurrentBookshelfObject():getOffice(), bookID) then
		local element = bookController:createBookInventoryElement(bookController:getBookData(bookID))
		
		self:addItem(element)
	end
end

function bookInventoryPanel:hasBookItem(bookID)
	for key, item in ipairs(self.items) do
		if item.class == "BookInventoryElement" and item:getBookData().id == bookID then
			return true
		end
	end
	
	return false
end

gui.register("BookInventoryScrollbarPanel", bookInventoryPanel, "ScrollbarPanel")
