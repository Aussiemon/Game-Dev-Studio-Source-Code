local startSelling = {}

function startSelling:setTargetEngine(eng)
	self.targetEngine = eng
	
	self:updateState()
	self:updateText()
end

function startSelling:updateState()
	if self.targetEngine then
		local cost = tonumber(self.costTextbox:getText())
		
		if cost and cost > 0 then
			self:setCanClick(true)
			self:queueSpriteUpdate()
		else
			self:setCanClick(false)
			self:queueSpriteUpdate()
		end
		
		self.costTextbox:setCanClick(true)
		self.costTextbox:queueSpriteUpdate()
	else
		self.costTextbox:setCanClick(false)
		self.costTextbox:queueSpriteUpdate()
		self:setCanClick(false)
		self:queueSpriteUpdate()
	end
end

function startSelling:setCostTextbox(textbox)
	self.costTextbox = textbox
end

function startSelling:onMouseLeft()
	startSelling.baseClass.onMouseLeft(self)
	
	if self.updatedPrice then
		self.updatedPrice = false
		
		self:updateText()
	end
end

function startSelling:updateText()
	if self.updatedPrice then
		self:setText(_T("ENGINE_UPDATED_PRICE", "Updated price!"))
		
		return 
	end
	
	local soldEngine = studio:getSoldEngine()
	
	if self.targetEngine then
		if soldEngine ~= self.targetEngine then
			self:setText(_T("START_SELLING_ENGINE", "Start selling"))
		else
			self:setText(_T("UPDATE_ENGINE_SELL_PRICE", "Update price"))
		end
	else
		self:setText(_T("START_SELLING_ENGINE", "Start selling"))
	end
end

function startSelling:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		self.targetEngine:setCost(tonumber(self.costTextbox:getText()))
		
		local curSoldEngine = studio:getSoldEngine()
		
		if curSoldEngine == self.targetEngine then
			self.updatedPrice = true
		end
		
		studio:startSellingEngine(self.targetEngine)
		self:updateText()
	end
end

gui.register("StartSellingEngineButton", startSelling, "Button")
