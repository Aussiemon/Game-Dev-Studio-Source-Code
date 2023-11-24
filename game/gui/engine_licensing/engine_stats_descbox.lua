local engineStatsDescbox = {}

function engineStatsDescbox:setEngine(engineObj)
	self.engine = engineObj
	
	self:setupDisplay()
end

function engineStatsDescbox:canShow()
	return self.engine ~= nil
end

function engineStatsDescbox:hideDisplay()
	self:removeAllText()
	
	self.engine = nil
	
	self:hide()
end

function engineStatsDescbox:setupDisplay()
	self:removeAllText()
	engineStats:fillDescbox(self.engine, self, "pix20", 320, 22)
	
	if not self.engine:isLicenseable() then
		self:addSpaceToNextText(10)
		self.engine:fillSaleDescboxInfo(self, "pix20", 320)
	end
	
	self:show()
end

gui.register("EngineStatsDescbox", engineStatsDescbox, "GenericDescbox")
