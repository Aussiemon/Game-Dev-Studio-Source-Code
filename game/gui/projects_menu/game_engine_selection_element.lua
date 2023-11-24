local engineSelect = {}

function engineSelect:init()
	self.descriptionBox = gui.create("GenericDescbox", self)
	
	self.descriptionBox:setShowRectSprites(false)
	self.descriptionBox:setPos(0, _S(3))
	
	self.descriptionBoxRight = gui.create("GenericDescbox", self)
	
	self.descriptionBoxRight:setShowRectSprites(false)
end

function engineSelect:onSizeChanged()
	self.descriptionBoxRight:setPos(self.w * 0.5, _S(3))
end

function engineSelect:onMouseEntered()
	engineSelect.baseClass.onMouseEntered(self)
	
	local element = gui:getElementByID(gameProject.ENGINE_INFO_DESCBOX_ID)
	
	element:show()
	element:addSpaceToNextText(3)
	engineStats:fillDescbox(self.engine, element, "pix20", 300, 22)
end

function engineSelect:onMouseLeft()
	engineSelect.baseClass.onMouseLeft(self)
	
	local element = gui:getElementByID(gameProject.ENGINE_INFO_DESCBOX_ID)
	
	element:removeAllText()
	element:hide()
end

function engineSelect:setEngine(engineObj)
	self.engine = engineObj
	
	local wrapW = self.rawW
	local halfW = wrapW * 0.5
	
	self.descriptionBox:addTextLine(self.w - _S(20), game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
	self.descriptionBox:addText(self.engine:getName(), "bh22", nil, 6, wrapW)
	self.descriptionBoxRight:addSpaceToNextText(_US(fonts.get("bh22"):getHeight()) + 6)
	self.descriptionBox:addTextLine(self.w * 0.5 - _S(10), gui.genericGradientColor, nil, "weak_gradient_horizontal")
	self.descriptionBox:addText(_format(_T("ENGINE_FEATURE_COUNT", "FEATURES Features"), "FEATURES", self.engine:getFeatureCount()), "pix20", nil, 0, wrapW, "wrench", 22, 22)
	self.descriptionBoxRight:addTextLine(self.w * 0.5 - _S(10), gui.genericGradientColor, nil, "weak_gradient_horizontal")
	
	local revCount = self.engine:getRevisionCount()
	
	if revCount > 1 then
		self.descriptionBoxRight:addText(_format(_T("ENGINE_REVISION_COUNT", "REVISIONS Revisions"), "REVISIONS", revCount), "pix20", nil, 0, wrapW, "automatic", 22, 22)
	else
		self.descriptionBoxRight:addText(_T("ENGINE_ONE_REVISION", "1 Revision"), "pix20", nil, 0, wrapW, "automatic", 22, 22)
	end
	
	self:setHeight(_US(self.descriptionBox.rawH) + 3)
end

function engineSelect:setGame(gameObj)
	self.game = gameObj
end

function engineSelect:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		self.game:setEngine(nil, self.engine)
		self._basePanel:kill()
	end
end

gui.register("GameEngineSelectionElement", engineSelect, "GenericElement")
