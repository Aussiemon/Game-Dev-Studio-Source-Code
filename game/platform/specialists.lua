platformParts:registerNewSpecialist({
	cost = 110000,
	affectorID = "performance",
	attractivenessIncrease = 0.1,
	gameScaleAffector = 0.25,
	id = "specialist_1",
	display = _T("PLATFORM_SPECIALIST_PERFORMANCE", "Performance Specialist"),
	description = _T("PLATFORM_SPECIALIST_PERFORMANCE_DESCRIPTION", "Specializes in efficiency, increasing maximum game scale and platform attractiveness."),
	applyAffectors = function(self, platformObj)
		platformObj:setGameScaleModifier(self.affectorID, self.gameScaleAffector)
		platformObj:setPlatformAttractModifier(self.affectorID, self.attractivenessIncrease)
	end,
	removeAffectors = function(self, platformObj)
		platformObj:setGameScaleModifier(self.affectorID, nil)
		platformObj:setPlatformAttractModifier(self.affectorID, nil)
	end,
	setupSpecialistText = function(self, descBox, wrapWidth)
		descBox:addTextLine(_S(200), game.UI_COLORS.LIGHT_BLUE, _S(24), "weak_gradient_horizontal")
		descBox:addSpaceToNextText(5)
		descBox:addText(_format(_T("PLATFORM_SPECIALIST_1_BOOST_GAME_SCALE", "Boosts maximum game scale by INC%"), "INC", math.round(self.gameScaleAffector * 100)), "bh18", nil, 5, wrapWidth, "increase", 22, 22)
		descBox:addTextLine(_S(200), game.UI_COLORS.LIGHT_BLUE, _S(24), "weak_gradient_horizontal")
		descBox:addText(_format(_T("PLATFORM_SPECIALIST_1_BOOST_ATTRACT", "Increases platform attractiveness"), "INC", math.round(self.attractivenessIncrease * 100)), "bh18", nil, 0, wrapWidth, "increase", 22, 22)
	end,
	addToBoostCategory = function(self, catObj, elemW)
		local hover = self:getBoostHoverText()
		local boost = gui.create("GradientIconPanel", nil)
		
		boost:setIcon("game_scale")
		boost:setBaseSize(elemW, 0)
		boost:setIconSize(20, nil, 22)
		boost:setFont("bh20")
		boost:setTextColor(game.UI_COLORS.LIGHT_BLUE)
		boost:setText(_format(_T("PLATFORM_SPECIALIST_1_BOOST_GAME_SCALE_SHORT", "+INC% max. game scale"), "INC", math.round(self.gameScaleAffector * 100)))
		boost:setHoverText(hover)
		catObj:addItem(boost)
		
		local boost = gui.create("GradientIconPanel", nil)
		
		boost:setIcon("star_yellow")
		boost:setBaseSize(elemW, 0)
		boost:setIconSize(20, nil, 22)
		boost:setFont("bh20")
		boost:setTextColor(game.UI_COLORS.LIGHT_BLUE)
		boost:setText(_format(_T("PLATFORM_SPECIALIST_1_BOOST_ATTRACT_SHORT", "+INC% platform attractiveness"), "INC", math.round(self.attractivenessIncrease * 100)))
		boost:setHoverText(hover)
		catObj:addItem(boost)
	end
})
platformParts:registerNewSpecialist({
	cost = 100000,
	affectorID = "streamline",
	devDifficultyAffector = -0.35,
	id = "specialist_2",
	display = _T("PLATFORM_SPECIALIST_Streamlining", "Streamlining Specialist"),
	description = _T("PLATFORM_SPECIALIST_SPECIALIST_DESCRIPTION", "Specializes in streamlining various systems, increasing attractiveness for developers."),
	applyAffectors = function(self, platformObj)
		platformObj:setDevDifficultyAffector(self.affectorID, self.devDifficultyAffector)
	end,
	removeAffectors = function(self, platformObj)
		platformObj:setDevDifficultyAffector(self.affectorID, nil)
	end,
	setupSpecialistText = function(self, descBox, wrapWidth)
		descBox:addTextLine(_S(200), game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
		descBox:addSpaceToNextText(5)
		descBox:addText(_format(_T("PLATFORM_SPECIALIST_2_BOOST_DEV_DIFFICULTY", "Decreases dev. difficulty by DEC%"), "DEC", math.round(math.abs(self.devDifficultyAffector * 100))), "bh18", nil, 5, wrapWidth, "increase", 22, 22)
	end,
	addToBoostCategory = function(self, catObj, elemW)
		local boost = gui.create("GradientIconPanel", nil)
		
		boost:setIcon("game_scale")
		boost:setBaseSize(elemW, 0)
		boost:setIconSize(20, nil, 22)
		boost:setFont("bh20")
		boost:setTextColor(game.UI_COLORS.LIGHT_BLUE)
		boost:setText(_format(_T("PLATFORM_SPECIALIST_2_BOOST_DEV_DIFFICULTY_SHORT", "-DEC% dev. difficulty"), "DEC", math.round(math.abs(self.devDifficultyAffector * 100))))
		boost:setHoverText(self:getBoostHoverText())
		catObj:addItem(boost)
	end
})
platformParts:registerNewSpecialist({
	cost = 130000,
	affectorID = "efficiency",
	productionCostDecrease = -0.15,
	id = "specialist_3",
	display = _T("PLATFORM_SPECIALIST_EFFICIENCY", "Efficiency Specialist"),
	description = _T("PLATFORM_SPECIALIST_EFFICIENCY_DESCRIPTION", "Specializes in hardware monolithy, decreasing production and repair costs."),
	applyAffectors = function(self, platformObj)
		platformObj:setPriceModifier(self.affectorID, self.productionCostDecrease)
	end,
	removeAffectors = function(self, platformObj)
		platformObj:setPriceModifier(self.affectorID, nil)
	end,
	setupSpecialistText = function(self, descBox, wrapWidth)
		descBox:addTextLine(_S(200), game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
		descBox:addSpaceToNextText(5)
		descBox:addText(_format(_T("PLATFORM_SPECIALIST_3_PRODUCTION_COST_DECREASE", "Decreases production cost by DEC%"), "DEC", math.round(math.abs(self.productionCostDecrease) * 100)), "bh18", nil, 5, wrapWidth, "increase", 22, 22)
	end,
	addToBoostCategory = function(self, catObj, elemW)
		local boost = gui.create("GradientIconPanel", nil)
		
		boost:setIcon("hud_main_menu")
		boost:setBaseSize(elemW, 0)
		boost:setIconSize(20, nil, 22)
		boost:setFont("bh20")
		boost:setTextColor(game.UI_COLORS.LIGHT_BLUE)
		boost:setText(_format(_T("PLATFORM_SPECIALIST_3_PRODUCTION_COST_DECREASE_SHORT", "-DEC% production cost"), "DEC", math.round(math.abs(self.productionCostDecrease) * 100)))
		boost:setHoverText(self:getBoostHoverText())
		catObj:addItem(boost)
	end
})
