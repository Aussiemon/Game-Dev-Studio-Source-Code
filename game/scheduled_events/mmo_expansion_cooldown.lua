local mmoExpCooldown = {}

mmoExpCooldown.inactive = true
mmoExpCooldown.id = "mmo_expansion_cooldown"

function mmoExpCooldown:validateEvent()
	return true
end

function mmoExpCooldown:activate()
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(500)
	popup:setFont("pix24")
	popup:setTitle(_T("MMO_OVERWHELMED_BY_CONTENT_TITLE", "Overwhelmed by Content"))
	popup:setTextFont("pix20")
	popup:setText(_format(_T("MMO_OVERWHELMED_BY_CONTENT", "The recent influx of expansions packs for the 'GAME' MMO has left players overwhelmed with the content amount, with a large portion of players choosing not to buy the latest expansion packs, due to the abundance of content."), "GAME", self.project:getName()))
	popup:setShowSound("bad_jingle")
	
	local left, right, extra = popup:getDescboxes()
	
	extra:addSpaceToNextText(10)
	extra:addTextLine(popup.w - _S(20), game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
	extra:addText(_T("MMO_OVERWHELMED_CONTENT_HINT", "Expansion packs for MMOs need to be released with a reasonable gap in time."), "bh20", nil, 0, popup.rawW - 30, "exclamation_point_red", 22, 22)
	popup:addOKButton("pix20")
	popup:center()
	frameController:push(popup)
end

function mmoExpCooldown:setProject(proj)
	self.project = proj
end

function mmoExpCooldown:canActivate()
	return timeline.curTime >= self.activationDate
end

function mmoExpCooldown:setActivationDate(date)
	self.activationDate = date
end

function mmoExpCooldown:save()
	local saved = mmoExpCooldown.baseClass.save(self)
	
	saved.gameID = self.project:getUniqueID()
	saved.activationDate = self.activationDate
	
	return saved
end

function mmoExpCooldown:load(data)
	self.project = studio:getProjectByUniqueID(data.gameID)
	self.activationDate = data.activationDate
end

scheduledEvents:registerNew(mmoExpCooldown)
