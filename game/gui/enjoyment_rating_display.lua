local ratingDisplay = {}

ratingDisplay.skinPanelFillColor = color(86, 104, 135, 255)
ratingDisplay.skinPanelHoverColor = color(163, 176, 198, 255)

function ratingDisplay:setEmployee(employee)
	self.employee = employee
	self.name = employee:getFullName(true)
end

function ratingDisplay:setEnjoyment(rating)
	self.fontObject = fonts.get("pix24")
	self.ratingFontObject = fonts.get("bh22")
	self.rating = math.round(rating)
	self.ratingText = _format(_T("ACTIVITY_RATING", "POINTS pts."), "POINTS", self.rating)
	self.ratingWidth = self.ratingFontObject:getWidth(self.ratingText)
end

function ratingDisplay:think()
	if self.highlight then
		self:updateForeSprite()
	end
end

function ratingDisplay:updateSprites()
	self:setNextSpriteColor(gui.genericOutlineColor:unpack())
	
	self.backSprite = self:allocateSprite(self.backSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
	
	self:updateForeSprite()
	
	self.iconSprite = self:allocateSprite(self.iconSprite, "efficiency", self.w - _S(2) - (self.h - _S(4)), _S(2), 0, self.rawH - 4, self.rawH - 4, 0, 0, -0.1)
	self.textX = self.w - self.ratingWidth - 5 - self.h
end

function ratingDisplay:updateForeSprite()
	local color = self:getStateColor()
	
	if self.highlight then
		self.flash = self.flash + frameTime * 2
		
		if self.flash >= math.tau then
			self.flash = self.flash - math.tau
		end
		
		self:setNextSpriteColor(color:lerpColorResult(math.abs(math.cos(self.flash)), ratingDisplay.skinPanelHoverColor))
	else
		self:setNextSpriteColor(color:unpack())
	end
	
	self.foreSprite = self:allocateSprite(self.foreSprite, "vertical_gradient_75", _S(1), _S(1), 0, self.rawW - 2, self.rawH - 2, 0, 0, -0.1)
end

function ratingDisplay:setActivity(data)
	local newDiscovered = false
	
	self.activity = data
	
	local employee = self.employee
	
	self.positiveContributors = {}
	self.negativeContributors = {}
	
	if data.contributingInterests then
		for interest, contribution in pairs(data.contributingInterests) do
			if self.employee:hasInterest(interest) and studio:hasDiscoveredActivityAffector(self.activity.id, interest) then
				if activities:wasAffectorJustDiscovered(interest) then
					newDiscovered = true
				end
				
				if contribution < 1 then
					table.inserti(self.negativeContributors, interest)
				elseif contribution > 1 then
					table.inserti(self.positiveContributors, interest)
				end
			end
		end
	end
	
	self.highlight = newDiscovered
	self.flash = 0
end

function ratingDisplay:onKill()
	self:killDescBox()
end

function ratingDisplay:onMouseEntered()
	self.descBox = gui.create("GenericDescbox")
	
	local neutral = true
	
	if #self.positiveContributors > 0 then
		self.descBox:addSpaceToNextText(3)
		self.descBox:addText(_T("CONTRIBUTING_INTERESTS", "Contributing interests"), "pix24", game.UI_COLORS.LIGHT_BLUE, 3, 500, "increase", 24, 24)
		
		for key, contributor in ipairs(self.positiveContributors) do
			local signs, color = activities:getActivityContributorSign(self.activity, contributor)
			local text = string.easyformatbykeys(_T("INTEREST_CONTRIBUTION_LAYOUT", "SIGNS INTEREST"), "SIGNS", signs, "INTEREST", interests:getData(contributor).display)
			
			self.descBox:addText(text, "pix20", color, 0)
		end
		
		neutral = false
	end
	
	if #self.negativeContributors > 0 and #self.positiveContributors > 0 then
		self.descBox:addSpaceToNextText(6)
	end
	
	if #self.negativeContributors > 0 then
		self.descBox:addSpaceToNextText(3)
		self.descBox:addText(_T("CONFLICTING_INTERESTS", "Conflicting interests"), "pix24", game.UI_COLORS.RED, 3, 500, "decrease_red", 24, 24)
		
		for key, contributor in ipairs(self.negativeContributors) do
			local signs, color = activities:getActivityContributorSign(self.activity, contributor)
			local text = string.easyformatbykeys(_T("INTEREST_CONTRIBUTION_LAYOUT", "SIGNS INTEREST"), "SIGNS", signs, "INTEREST", interests:getData(contributor).display)
			
			self.descBox:addText(text, "pix20", color, 0)
		end
		
		neutral = false
	end
	
	if neutral then
		self.descBox:addText(_T("NO_CONFLICTING_OPINIONS", "Had no conflicting opinions."), "pix20", nil, 0)
	end
	
	self.descBox:centerToElement(self)
	
	self.highlight = false
	
	self:queueSpriteUpdate()
end

function ratingDisplay:onMouseLeft()
	self:killDescBox()
	self:queueSpriteUpdate()
end

function ratingDisplay:draw(w, h)
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self.name, 5, 0, 255, 255, 255, 255, 0, 0, 0, 255)
	love.graphics.setFont(self.ratingFontObject)
	love.graphics.printST(self.ratingText, self.textX, 0, 255, 255, 255, 255, 0, 0, 0, 255)
end

gui.register("EnjoymentRatingDisplay", ratingDisplay)
