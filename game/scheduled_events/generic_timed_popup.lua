local genericTimedPopup = {}

genericTimedPopup.id = "generic_timed_popup"
genericTimedPopup.inactive = true
genericTimedPopup.title = nil
genericTimedPopup.text = nil
genericTimedPopup.titleFont = nil
genericTimedPopup.textFont = nil

function genericTimedPopup:validateEvent()
	return scheduledEvents.activatedEvents[self.id]
end

function genericTimedPopup:getTitle()
	return self.title
end

function genericTimedPopup:getText()
	return self.text
end

function genericTimedPopup:activate()
	genericTimedPopup.baseClass.activate(self)
	
	if self.unlockID then
		unlocks:makeAvailable(self.unlockID)
	end
	
	local title = self:getTitle()
	
	if title then
		local text = self:getText()
		
		if text then
			local popup = game.createPopup(600, title, text, self.titleFont, self.textFont, nil)
			
			popup:hideCloseButton()
			frameController:push(popup)
		end
	end
end

scheduledEvents:registerNew(genericTimedPopup)

function game.registerTimedPopup(id, title, text, titleFont, textFont, date, factToSet, unlockID)
	scheduledEvents:registerNew({
		inactive = false,
		id = id,
		factToSet = factToSet,
		unlockID = unlockID,
		date = date,
		title = title,
		text = text,
		titleFont = titleFont,
		textFont = textFont
	}, "generic_timed_popup")
end
