local subgenre = {}

subgenre.closeOnClick = false
subgenre.CATCHABLE_EVENTS = {
	gameProject.EVENTS.SUBGENRE_CHANGED
}

function subgenre:setSubgenre(sub)
	self.subgenreID = sub
end

function subgenre:handleEvent(event, projObj, newSub)
	self:highlight(newSub == self.subgenreID)
	self:queueSpriteUpdate()
end

function subgenre:onClicked()
	local subGenre = self.baseButton.baseButton:getProject():getSubgenre()
	
	if subGenre and subGenre == self.subgenreID then
		self.baseButton:onSelectSubgenre(nil)
	else
		self.baseButton:onSelectSubgenre(self.subgenreID)
	end
end

function subgenre:positionDescbox()
	local x, y = self:getPos(true)
	
	self.descBox:setPos(x + self.w + _S(5), y)
end

function subgenre:prepareDescbox()
	gameProject:fillWithSubgenreMatches(self.descBox, self.subgenreID, 300)
end

gui.register("SubgenreComboBoxOption", subgenre, "GenreComboBoxOption")
