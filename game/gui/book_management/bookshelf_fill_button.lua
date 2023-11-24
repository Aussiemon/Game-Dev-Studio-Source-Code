local bookshelfFill = {}

function bookshelfFill:onClick(x, y, key)
	self.parent:getBookshelf():fillWithBooks()
end

gui.register("BookshelfFillButton", bookshelfFill, "Button")
