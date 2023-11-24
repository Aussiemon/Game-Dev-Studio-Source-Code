local hintPopup = {}

hintPopup.checkboxYPadding = 5
hintPopup.checkboxXPadding = 5

function hintPopup.checkboxChecked(checkbox)
	self.disabledHint = not self.disabledHint
	
	preferences:set(checkbox.popup:getHintID(), self.disabledHint)
end

function hintPopup.checkboxIsOn(checkbox)
	return preferences:get(checkbox.popup:getHintID())
end

function hintPopup:init()
	hintPopup.baseClass.init(self)
	
	self.checkbox = gui.create("Checkbox")
	
	self.checkbox:setSize(32, 32)
	
	self.checkbox.popup = self
	
	self.checkbox:setCheckCallback(hintPopup.checkboxChecked)
	self.checkbox:setIsOnFunction(hintPopup.checkboxIsOn)
end

function hintPopup:performLayout()
	hintPopup.baseClass.performLayout(self)
	self.checkbox:setPos(self.w - self.checkbox.w - _S(self.checkboxXPadding), self.h - self.checkbox.h - _S(self.checkboxYPadding))
	self.checkBox:performLayout()
end

function hintPopup:setHintID(hintID)
	self.hintID = hintID
end

function hintPopup:getHintID()
	return self.hintID
end

gui.register("HintPopup", hintPopup, "Popup")
