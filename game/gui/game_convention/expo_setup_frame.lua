local expoSetupFrame = {}

function expoSetupFrame:setBoothList(list)
	self.boothList = list
end

function expoSetupFrame:canCloseViaEscape()
	if self.reconfirmation then
		return false
	end
	
	return expoSetupFrame.baseClass.canCloseViaEscape(self)
end

function expoSetupFrame:setReconfirmation(reconfirm)
	self.reconfirmation = reconfirm
end

function expoSetupFrame:setBooking(book)
	self.booking = book
end

function expoSetupFrame:onHide()
	self.boothList:hide()
end

function expoSetupFrame:onHide()
	self.boothList:show()
end

function expoSetupFrame:setConventionData(data)
	self.conventionData = data
end

function expoSetupFrame:onKill()
	expoSetupFrame.baseClass.onKill(self)
	self.boothList:kill()
	
	if not self.booking then
		self.conventionData:clearDesiredData()
	end
end

gui.register("ExpoSetupFrame", expoSetupFrame, "Frame")
