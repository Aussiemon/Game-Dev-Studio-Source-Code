local canGameDisappoint = {}

canGameDisappoint.id = "cancelled_game_disappointment"
canGameDisappoint.inactive = true
canGameDisappoint.gameName = nil

function canGameDisappoint:activate()
	canGameDisappoint.baseClass.activate(self)
	
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(500)
	popup:setFont("pix24")
	popup:setTextFont("pix20")
	popup:setTitle(_T("FANS_UPSET_TITLE", "Fans Upset"))
	popup:setText(_format(_T("FANS_UPSET_CANCELLED_GAME", "Having heard about the cancellation of 'GAME' your fans were disappointed and upset. Cancelling announced & hyped-up games is not a good idea."), "GAME", self.gameName))
	
	local left, right, extra = popup:getDescboxes()
	
	extra:addTextLine(popup.w - _S(20), game.UI_COLORS.UI_PENALTY_LINE)
	extra:addText(_format(_T("YOUVE_LOST_REPUTATION_POINTS", "You've lost REPLOSS reputation points."), "REPLOSS", string.comma(self.repDrop)), "bh20", game.UI_COLORS.RED, 0, popup.rawW - 20, "exclamation_point_red", 24, 24)
	popup:addOKButton("pix20")
	popup:hideCloseButton()
	popup:setShowSound("bad_jingle")
	popup:center()
	frameController:push(popup)
end

function canGameDisappoint:canActivate()
	return timeline.curTime >= self.activationDate
end

function canGameDisappoint:setActivationDate(date)
	self.activationDate = date
end

function canGameDisappoint:setGameName(name)
	self.gameName = name
end

function canGameDisappoint:save()
	local saved = canGameDisappoint.baseClass.save(self)
	
	saved.gameName = self.gameName
	saved.activationDate = self.activationDate
	
	return saved
end

function canGameDisappoint:load(data)
	canGameDisappoint.baseClass.load(self, data)
	
	self.gameName = data.gameName
	self.activationDate = data.activationDate or timeline.curTime + timeline.DAYS_IN_WEEK
end

scheduledEvents:registerNew(canGameDisappoint, "delayed_reputation_drop")
