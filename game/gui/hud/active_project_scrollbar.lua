local activeProjScroll = {}

function activeProjScroll:setProjectBox(box)
	self.projectBox = box
end

function activeProjScroll:addItem(...)
	activeProjScroll.baseClass.addItem(self, ...)
	self.projectBox:verifyVisibility()
end

function activeProjScroll:removeItem(...)
	activeProjScroll.baseClass.removeItem(self, ...)
	self.projectBox:verifyVisibility()
end

gui.register("ActiveProjectScrollbar", activeProjScroll, "ScrollbarPanel")
