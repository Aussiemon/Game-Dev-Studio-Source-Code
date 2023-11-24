local editPartDesc = {}

function editPartDesc:hideDisplay()
	self:removeAllText()
	self:hide()
end

function editPartDesc:updateDisplay(partData)
	self:show()
	partData:fillDescbox(self)
end

gui.register("EditionPartInfoDescbox", editPartDesc, "GenericDescbox")
