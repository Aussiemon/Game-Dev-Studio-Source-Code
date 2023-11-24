local bribeSelection = {}

bribeSelection.skinPanelFillColor = color(86, 104, 135, 255)
bribeSelection.skinPanelHoverColor = color(163, 176, 198, 255)
bribeSelection.skinPanelSelectColor = color(125, 175, 125, 255)
bribeSelection.skinPanelDisableColor = color(40, 40, 40, 255)
bribeSelection.skinTextFillColor = color(220, 220, 220, 255)
bribeSelection.skinTextHoverColor = color(240, 240, 240, 255)
bribeSelection.skinTextSelectColor = color(255, 255, 255, 255)
bribeSelection.skinTextDisableColor = color(150, 150, 150, 255)
bribeSelection.EVENTS = {
	BRIBE_SIZE_CHANGED = events:new()
}

function bribeSelection:init()
	self:setFont(fonts.get("pix20"))
	self:setAlignment(bribeSelection.LEFT)
end

function bribeSelection:setBribeSize(size)
	self.bribeSize = size
	
	self:setText(string.roundtobigcashnumber(size))
	events:fire(bribeSelection.EVENTS.BRIBE_SIZE_CHANGED, size)
end

function bribeSelection:getBribeSize()
	return self.bribeSize
end

function bribeSelection:setConfirmationButton(button)
	self.confirmationButton = button
end

function bribeSelection:isDisabled()
	return studio:hasFunds(self.bribeSize)
end

function bribeSelection:onClick(x, y, key)
	if self:isDisabled() then
		return 
	end
	
	button:setBribeSize(self.bribeSize)
end

function bribeSelection:isOn()
	return self.bribeSize == self.confirmationButton:getBribeSize()
end

gui.register("BribeSelectionButton", bribeSelection, "Button")
