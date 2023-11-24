local stat = {}

stat.verticalSpacing = 0
stat.barWidth = 116
stat.barHeight = 10

function stat:init()
	self.performanceDisplay = gui.create("EngineStatDisplay", self)
	
	self.performanceDisplay:setHeight(28)
	self.performanceDisplay:setStatID("performance")
	self.performanceDisplay:setFont("pix18")
	self.performanceDisplay:setText(_T("ENGINE_PERFORMANCE_UNKNOWN", "Performance - ???%"))
	
	self.easeOfUseDisplay = gui.create("EngineStatDisplay", self)
	
	self.easeOfUseDisplay:setHeight(28)
	self.easeOfUseDisplay:setStatID("easeOfUse")
	self.easeOfUseDisplay:setFont("pix18")
	self.easeOfUseDisplay:setText(_T("ENGINE_EASE_OF_USE_UNKNOWN", "Ease of Use - ???%"))
	
	self.integrityDisplay = gui.create("EngineStatDisplay", self)
	
	self.integrityDisplay:setHeight(28)
	self.integrityDisplay:setStatID("integrity")
	self.integrityDisplay:setFont("pix18")
	self.integrityDisplay:setText(_T("ENGINE_INTEGRITY_UNKNOWN", "Integrity - ???%"))
end

function stat:onMouseEntered()
end

function stat:onMouseLeft()
end

function stat:onSizeChanged()
	local scaledX = _S(5)
	
	self.performanceDisplay:setPos(_S(5), _S(3))
	self.performanceDisplay:setWidth(self.rawW - 10)
	
	local x, y = self.performanceDisplay:getPos()
	
	self.easeOfUseDisplay:setPos(x, y + self.performanceDisplay.h + _S(2))
	self.easeOfUseDisplay:setWidth(self.rawW - 10)
	
	y = y + self.performanceDisplay.h + _S(2)
	
	self.integrityDisplay:setPos(x, y + self.performanceDisplay.h + _S(2))
	self.integrityDisplay:setWidth(self.rawW - 10)
end

function stat:setEngine(engineObj)
	self.engine = engineObj
	self.revision = engineObj:getRevision()
	
	if self.engine then
		local curStats = self.engine:getRevisionStats(self.revision)
		
		self.performanceDisplay:setText(_format(_T("ENGINE_PERFORMANCE", "Performance - STAT%"), "STAT", math.round(curStats.performance * 100)))
		self.performanceDisplay:setProgress(curStats.performance)
		self.easeOfUseDisplay:setText(_format(_T("ENGINE_EASE_OF_USE", "Ease of Use - STAT%"), "STAT", math.round(curStats.easeOfUse * 100)))
		self.easeOfUseDisplay:setProgress(curStats.easeOfUse)
		self.integrityDisplay:setText(_format(_T("ENGINE_INTEGRITY", "Integrity - STAT%"), "STAT", math.round(curStats.integrity * 100)))
		self.integrityDisplay:setProgress(curStats.integrity)
	end
end

function stat:getEngine()
	return self.engine
end

function stat:setRevision(rev)
	self.revision = rev
end

gui.register("EngineStatsDisplay", stat, "GenericElement")
