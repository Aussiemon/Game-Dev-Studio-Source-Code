local bookPurchasePanel = {}

function bookPurchasePanel:handleEvent(event, bookID)
	if event == bookController.EVENTS.BOOK_PURCHASED then
		for key, item in ipairs(self.items) do
			if item.class == "BookPurchaseElement" then
				local bookData = item:getBookData()
				
				if bookData.id == bookID then
					if bookData.skillBoost then
						local nextBook = bookController:getNextBookOfSkillBoost(bookID, bookData.skillBoost.id)
						local buyableBooks = bookController:getBuyableBookCount(bookID)
						
						if nextBook then
							if buyableBooks == 0 then
								if not self:hasBookItem(nextBook.id) then
									item:setBookData(nextBook)
								else
									item:kill()
								end
							elseif not self:hasBookItem(nextBook.id) then
								self:addInFrontOf(bookController:createBookPurchaseElement(nextBook), item, nil)
							end
						elseif buyableBooks == 0 then
							item:kill()
						end
					else
						item:kill()
					end
				end
			end
		end
	end
end

function bookPurchasePanel:hasBookItem(bookID)
	for key, item in ipairs(self.items) do
		if item.class == "BookPurchaseElement" and item:getBookData().id == bookID then
			return true
		end
	end
	
	return false
end

gui.register("BookPurchaseScrollbarPanel", bookPurchasePanel, "ScrollbarPanel")
