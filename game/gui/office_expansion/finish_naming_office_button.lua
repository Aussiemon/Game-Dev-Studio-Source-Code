local finishNaming = {}

function finishNaming:setOffice(office)
	self.office = office
end

function finishNaming:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		self.office:finishNaming()
		finishNaming.baseClass.onClick(self, x, y, key)
	end
end

gui.register("FinishNamingOfficeButton", finishNaming, "CloseButton")
