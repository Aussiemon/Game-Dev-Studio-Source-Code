local driveAffectorBoostDisplay = {}

driveAffectorBoostDisplay.GRADIENT_COLOR = gui.genericOutlineColor

function driveAffectorBoostDisplay:setDriveAffector(affectorID)
	self.affectorID = affectorID
end

function driveAffectorBoostDisplay:setOffice(office)
	self.office = office
end

function driveAffectorBoostDisplay:addTextToDescbox()
	local data = studio.driveAffectors:getData(self.affectorID)
	
	if data.description then
		self.descBox:addText(data.description, "pix20", nil, 0, 400)
	end
	
	data:formatDescriptionText(self.office, self.descBox, 400)
end

gui.register("DriveAffectorBoostDisplay", driveAffectorBoostDisplay, "DescboxGradientIconTextDisplay")
