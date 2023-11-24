local saveGameScrollBar = {}

saveGameScrollBar.CATCHABLE_EVENTS = {
	game.EVENTS.SAVEGAME_DELETED,
	game.EVENTS.SNAPSHOT_DELETED
}

function saveGameScrollBar:handleEvent(event, filename)
	for key, element in ipairs(self.items) do
		if element:getFileName() == filename then
			self:removeItem(element, nil, key)
			element:kill()
			
			break
		end
	end
end

gui.register("SaveGameScrollbarPanel", saveGameScrollBar, "ScrollbarPanel")
