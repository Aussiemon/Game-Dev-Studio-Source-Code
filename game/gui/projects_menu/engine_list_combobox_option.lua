local engineListComboBoxOption = {}

function engineListComboBoxOption:setEngine(engine)
	self.engine = engine
end

function engineListComboBoxOption:onMouseEntered()
	engineListComboBoxOption.baseClass.onMouseEntered(self)
	
	local x, y = self:getPos(true)
	
	x = x + _S(5) + self.w
	self.descBox = gui.create("GenericDescbox")
	
	engineStats:fillDescbox(self.engine, self.descBox, "pix20", 320, 22)
	self.descBox:overwriteDepth(110000)
	self.descBox:setPos(x, y)
end

function engineListComboBoxOption:onMouseLeft()
	engineListComboBoxOption.baseClass.onMouseLeft(self)
	self:killDescBox()
end

gui.register("EngineListComboBoxOption", engineListComboBoxOption, "ComboBoxOption")
