local bookshelf = {}

bookshelf.tileWidth = 2
bookshelf.tileHeight = 1
bookshelf.quad = quadLoader:load("bookshelf_1")
bookshelf.icon = "icon_bookshelf_1"
bookshelf.class = "bookshelf"
bookshelf.display = _T("BOOKSHELF", "Bookshelf")
bookshelf.description = _T("BOOKSHELF_DESCRIPTION", "Show everyone how educated you are.")
bookshelf.roomType = {
	[studio.ROOM_TYPES.CONFERENCE] = true,
	[studio.ROOM_TYPES.OFFICE] = true
}
bookshelf.category = "office"
bookshelf.scaleX = 1.5
bookshelf.scaleY = 1
bookshelf.minimumIllumination = 0
bookshelf.cost = 50
bookshelf.preventsMovement = true
bookshelf.preventsLight = true
bookshelf.bookshelfQuads = {
	[0] = "bookshelf_1",
	"bookshelf_2",
	"bookshelf_3",
	"bookshelf_4"
}

objects.registerNew(bookshelf, "bookshelf_object_base")
