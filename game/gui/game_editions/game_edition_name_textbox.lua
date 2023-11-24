local editName = {}

editName.maxSize = 25
editName.CATCHABLE_EVENTS = {
	gameEditions.EVENTS.SETUP_ELEMENT_SELECTED
}

function editName:handleEvent(event, obj)
	self:setEdition(obj)
end

function editName:setEdition(edit)
	self.edition = edit
	
	self:setText(self.edition:getName())
	self:deselect()
	self:setCanClick(true)
end

function editName:onWrite()
	self.edition:setName(self.curText)
end

function editName:onDelete()
	self.edition:setName(self.curText)
end

gui.register("GameEditionNameTextbox", editName, "TextBox")
