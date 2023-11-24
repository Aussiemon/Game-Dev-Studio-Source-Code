local CancelBookingCloseButton = {}

function CancelBookingCloseButton:setConventionData(data)
	self.conventionData = data
end

function CancelBookingCloseButton:onClick(x, y, key)
	CancelBookingCloseButton.baseClass.onClick(self, x, y, key)
	self.conventionData:cancel()
end

function CancelBookingCloseButton:onMouseEntered()
	CancelBookingCloseButton.baseClass.onMouseEntered(self)
	
	self.descBox = gui.create("GenericDescbox")
	
	self.descBox:addText(_T("CANCEL_EXPO_BOOKING_1", "Cancel booked expo"), "pix20", nil, 0, 600)
	self.descBox:addText(_T("CANCEL_EXPO_BOOKING_2", "Closing this window will cancel the expo booking."), "pix18", nil, 0, 600)
	self.descBox:centerToElement(self)
end

function CancelBookingCloseButton:onMouseLeft()
	CancelBookingCloseButton.baseClass.onMouseLeft(self)
	self:killDescBox()
end

gui.register("CancelBookingCloseButton", CancelBookingCloseButton, "FrameCloseButton")
