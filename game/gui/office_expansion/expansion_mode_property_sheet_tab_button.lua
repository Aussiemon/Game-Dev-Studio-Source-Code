local expansionSheetButton = {}

function expansionSheetButton:setCategoryID(id)
	self.categoryID = id
	
	if id then
		self.categoryData = objectCategories:getCategory(self.categoryID)
	end
end

function expansionSheetButton:setIconOverride(override)
	self.iconOverride = override
end

expansionSheetButton.iconActiveColor = color(152, 187, 226, 255)
expansionSheetButton.iconInactiveColor = color(81, 100, 119, 255)
expansionSheetButton.backgroundActiveColor = color(91, 120, 153, 255)
expansionSheetButton.backgroundInActiveColor = color(73, 98, 127, 255)

function expansionSheetButton:updateSprites()
	local sprite = self:isOn() and "purchase_tab_active" or "purchase_tab_inactive"
	
	self.backgroundSprite = self:allocateSprite(self.backgroundSprite, sprite, 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
	
	if self:isOn() then
		self:setNextSpriteColor(expansionSheetButton.iconActiveColor:unpack())
	else
		self:setNextSpriteColor(expansionSheetButton.iconInactiveColor:unpack())
	end
	
	self.categoryIcon = self:allocateSprite(self.categoryIcon, self.iconOverride or self.categoryData.icon, _S(3), _S(3), 0, self.rawW - 6, self.rawH - 6, 0, 0, -0.05)
end

gui.register("ExpansionModePropertySheetTabButton", expansionSheetButton, "PropertySheetTabButton")
