local letsPlayerSelection = {}

letsPlayerSelection.iconSize = 80
letsPlayerSelection.descboxOffset = letsPlayerSelection.iconSize + 5
letsPlayerSelection.skinPanelSelectColor = color(125, 175, 125, 255)

function letsPlayerSelection:init()
	self.wrapWidth = 0
	self.leftBox = gui.create("GenericDescbox", self)
	
	self.leftBox:setShowRectSprites(false)
	self.leftBox:overwriteDepth(10)
	self.leftBox:setFadeInSpeed(0)
	self.leftBox:setX(_S(self.descboxOffset))
	
	self.rightBox = gui.create("GenericDescbox", self)
	
	self.rightBox:setShowRectSprites(false)
	self.rightBox:overwriteDepth(10)
	self.rightBox:setFadeInSpeed(0)
end

function letsPlayerSelection:setProject(proj)
	self.project = proj
end

function letsPlayerSelection:onSizeChanged()
	self.smallestAxis = math.min(self.rawH, self.rawW)
	
	self.rightBox:setPos(self.leftBox.x + _S(self.wrapWidth), 0)
end

function letsPlayerSelection:onMouseEntered()
	letsPlayerSelection.baseClass.onMouseEntered(self)
	
	self.descBox = gui.create("GenericDescbox")
	
	self.letsPlayer:setupDescbox(self.descBox, 400)
	self.descBox:positionToMouse(_S(10), _S(10))
end

function letsPlayerSelection:onMouseLeft()
	letsPlayerSelection.baseClass.onMouseLeft(self)
	self:killDescBox()
end

function letsPlayerSelection:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		if self.disabled then
			return 
		end
		
		local id = self.letsPlayer:getID()
		local key = table.find(self.list, id)
		
		if key then
			advertisement:getData("lets_plays"):removeDesiredLetsPlayer(id)
			
			self.active = false
		else
			advertisement:getData("lets_plays"):addDesiredLetsPlayer(id)
			
			self.active = true
		end
		
		self:queueSpriteUpdate()
	end
end

function letsPlayerSelection:isOn()
	return self.active
end

function letsPlayerSelection:isDisabled()
	return self.disabled
end

function letsPlayerSelection:setList(list)
	self.list = list
end

function letsPlayerSelection:updateSprites()
	letsPlayerSelection.baseClass.updateSprites(self)
	
	local bgIconSize = self.iconSize
	local quadName = self.icon
	local quad = quadLoader:load(quadName)
	local scale = quad:getScaleToSize(bgIconSize - 10)
	local w, h = quad:getSize()
	
	w, h = w * scale, h * scale
	
	local baseIconX = _S(5)
	local baseX, baseY = baseIconX - _S(2), _S(5)
	
	self:setNextSpriteColor(14, 16, 21, 200)
	
	self.backgroundSprite = self:allocateSprite(self.backgroundSprite, "generic_1px", baseX, baseY, 0, bgIconSize, bgIconSize, 0, 0, 0.5)
	self.iconSprite = self:allocateSprite(self.iconSprite, self.icon, baseX + _S(bgIconSize * 0.5 - w * 0.5), baseY + _S(bgIconSize * 0.5 - h * 0.5), 0, w, h, 0, 0, 0.5)
end

function letsPlayerSelection:setLetsPlayer(lp)
	self.letsPlayer = lp
	self.icon = self.letsPlayer:getIcon()
	
	local cooldown = lp:getCooldown()
	local cooldownPresent = cooldown > 0
	local gamesInProgress = lp:getGamesInProgress()
	
	self.disabled = cooldownPresent or #gamesInProgress > 0
	
	local offset = self.descboxOffset
	local scaledOffset = _S(offset)
	local textColor = self.disabled and game.UI_COLORS.GREY or nil
	local wrapWidth = self.rawW * 0.5 - 10 - offset * 0.5
	local lineWidth = self.w * 0.5 - _S(10) - scaledOffset * 0.5
	local fullLineWidth = self.w - _S(10) - scaledOffset * 2
	
	self.wrapWidth = wrapWidth
	
	self.leftBox:addSpaceToNextText(3)
	self.leftBox:addTextLine(fullLineWidth, not cooldownPresent and gui.genericMainGradientColor or gui.genericGradientColor, nil, "weak_gradient_horizontal")
	self.leftBox:addText(lp:getName(), "bh22", textColor, 8, wrapWidth)
	self.leftBox:addTextLine(lineWidth, gui.genericGradientColor, nil, "weak_gradient_horizontal")
	self.leftBox:addText(_format(_T("LETS_PLAYER_VIEWERS", "Viewers: VIEWERS"), "VIEWERS", string.roundtobignumber(lp:getViewerbase())), "pix20", textColor, 3, wrapWidth, {
		{
			height = 24,
			icon = "generic_backdrop",
			width = 24
		},
		{
			width = 18,
			icon = "employees",
			x = 3,
			height = 18
		}
	})
	self.rightBox:addSpaceToNextText(32)
	self.rightBox:addTextLine(lineWidth, gui.genericGradientColor, nil, "weak_gradient_horizontal")
	self.rightBox:addText(_format(_T("LETS_PLAYER_VIDEOS", "Videos per contract: VIDEOS"), "VIDEOS", self.letsPlayer:getMaxVideos()), "pix20", textColor, 3, wrapWidth, {
		{
			height = 24,
			icon = "generic_backdrop",
			width = 24
		},
		{
			width = 18,
			icon = "story_quality",
			x = 3,
			height = 18
		}
	})
	
	local cost = lp:getPrice()
	local costText
	
	if cost > 0 then
		costText = _format(_T("LETS_PLAYER_PRICE", "Price: PRICE"), "PRICE", string.roundtobigcashnumber(cost))
	else
		costText = _T("LETS_PLAYER_PRICE_FREE", "Price: Free!")
	end
	
	self.leftBox:addTextLine(lineWidth, gui.genericGradientColor, nil, "weak_gradient_horizontal")
	self.leftBox:addText(costText, "pix20", textColor, 0, wrapWidth, {
		{
			height = 24,
			icon = "generic_backdrop",
			width = 24
		},
		{
			width = 18,
			icon = "wad_of_cash",
			x = 3,
			height = 18
		}
	})
	self.rightBox:addTextLine(lineWidth, gui.genericGradientColor, nil, "weak_gradient_horizontal")
	self.rightBox:addText(_format(_T("LETS_PLAYER_PAST_CONTRACTS", "Past contracts: CONTRACTS"), "CONTRACTS", lp:getTotalVideosMade()), "pix20", textColor, 0, wrapWidth, {
		{
			height = 24,
			icon = "generic_backdrop",
			width = 24
		},
		{
			width = 18,
			icon = "project_stuff",
			x = 3,
			height = 18
		}
	})
	
	if #gamesInProgress > 0 then
		self.leftBox:addSpaceToNextText(6)
		self.leftBox:addTextLine(fullLineWidth, game.UI_COLORS.YELLOW, nil, "weak_gradient_horizontal")
		self.leftBox:addText(_T("LETS_PLAYER_ALREADY_MAKING_VIDEOS", "This channel is already making a playthrough"), "bh20", nil, 0, self.rawW - 10, "exclamation_point", 22, 22)
	elseif cooldownPresent then
		self.leftBox:addSpaceToNextText(6)
		self.leftBox:addTextLine(fullLineWidth, game.UI_COLORS.ORANGE, nil, "weak_gradient_horizontal")
		self.leftBox:addText(_T("LETS_PLAYER_ON_COOLDOWN", "This channel is currently busy"), "bh20", nil, 0, self.rawW - 10, "exclamation_point", 22, 22)
	end
	
	self:setHeight(math.max(_US(self.rightBox.h), _US(self.leftBox.h)))
end

gui.register("LetsPlayerSelection", letsPlayerSelection, "GenericElement")
