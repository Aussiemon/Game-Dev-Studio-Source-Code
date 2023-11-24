local bribeConfirm = {}
local bribe = advertisement:getData("bribe")

function bribeConfirm:init()
	self:setFont(fonts.get("pix20"))
	self:setText(_T("CONFIRM", "Confirm"))
end

function bribeConfirm:setBribeSize(size)
	self.bribeSize = size
	
	events:fire(bribe.EVENTS.BRIBE_SIZE_CHANGED)
end

function bribeConfirm:setTarget(target)
	self.bribeTarget = target
end

function bribeConfirm:getTarget()
	return self.bribeTarget
end

function bribeConfirm:setProject(proj)
	self.project = proj
end

function bribeConfirm:getBribeSize()
	return self.bribeSize
end

function bribeConfirm:isDisabled()
	if not self.bribeSize or not self.bribeTarget then
		return true
	end
	
	return false
end

function bribeConfirm:onClick(x, y, key)
	if self:isDisabled() then
		return 
	end
	
	local bribeChancesKnown = self.bribeTarget:getBribeChancesRevealed()
	local bribeAccepted = advertisement:getData("bribe"):offerBribe(self.bribeTarget, self.bribeSize, self.project)
	local title, text
	
	if not bribeAccepted then
		title = _T("BRIBE_REFUSED", "Bribe refused")
		text = _T("BRIBE_REFUSED_DESC", "Your bribe offer has been refused.")
	else
		title = _T("BRIBE_ACCEPTED", "Bribe accepted")
		text = _T("BRIBE_ACCEPTED_DESC", "Your bribe offer has been accepted.")
		
		studio:deductFunds(self.bribeSize, nil, "marketing")
		self.project:changeMoneySpent(self.bribeSize)
	end
	
	local popupClass
	local canShowDiscoveryText = bribeAccepted and not bribeChancesKnown
	
	popupClass = canShowDiscoveryText and "DescboxPopup" or "Popup"
	
	local popup = gui.create(popupClass)
	
	popup:setWidth(500)
	popup:setFont(fonts.get("pix24"))
	popup:setTextFont(fonts.get("pix20"))
	
	if canShowDiscoveryText then
		popup:getExtraInfoDescbox():addText(_format(_T("DISCOVERED_REVIEWER_BRIBE_CHANCES", "Discovered bribe accept & reveal chances for 'REVIEWER'!"), "REVIEWER", self.bribeTarget:getName()), "bh22", nil, 0, 490, "question_mark", 24, 24)
	end
	
	popup:setTitle(title)
	popup:setText(text)
	popup:setOnKillCallback(game.genericClearFrameControllerCallback)
	popup:addButton(fonts.get("pix20"), _T("OK", "OK"), nil)
	popup:center()
	frameController:push(popup)
end

gui.register("BribeConfirmButton", bribeConfirm, "Button")
