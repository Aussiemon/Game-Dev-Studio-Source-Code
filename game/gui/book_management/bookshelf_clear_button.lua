local bookshelfClear = {}

function bookshelfClear:onClick(x, y, key)
	self.parent:getBookshelf():clearBooks()
end

gui.register("BookshelfClearButton", bookshelfClear, "Button")
