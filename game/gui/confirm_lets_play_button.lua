local confirmLetsPlay = {}

function confirmLetsPlay:setCostDisplay(cd)
	self.costDisplay = cd
end

function confirmLetsPlay:setProject(proj)
	self.project = proj
end

function confirmLetsPlay:updateCost(cost, listOfLPers)
	if #listOfLPers == 0 then
		self.cost = nil
		self.disabled = true
	else
		self.cost = cost
		self.disabled = not studio:hasFunds(cost)
	end
	
	self:queueSpriteUpdate()
end

function confirmLetsPlay:isDisabled()
	return self.disabled or not self.cost
end

function confirmLetsPlay:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT and not self.disabled and self.cost and studio:hasFunds(self.cost) then
		advertisement:getData("lets_plays"):addLetsPlayers(self.project)
		studio:deductFunds(self.cost, nil, "marketing")
		frameController:pop()
		
		local popup = game.createPopup(600, _T("LETS_PLAY_VIDEOS_STARTED_TITLE", "'Lets Play' Videos Started"), _T("LETS_PLAY_VIDEOS_STARTED_DESC", "You've contacted online personalities and started a video series.\n\nThe project will receive weekly videos from each selected video maker, and the game project will amass popularity over the course of the videos"), fonts.get("pix24"), fonts.get("pix20"))
		
		frameController:push(popup)
	end
end

gui.register("ConfirmLetsPlayButton", confirmLetsPlay, "Button")
