require("engine/gui/panel")

local PANEL = {}

function PANEL:draw(w, h)
end

function PANEL:onScroll(xVel, yVel)
	yVel = math.min(1, math.max(yVel, -1))
	
	self:getParent():mouseWheelScroll(yVel)
end

function PANEL:canEnable(item)
	return self.parent:canEnable(item)
end

function PANEL:onChildSizeChanged()
	self.parent:queueLayoutPerform()
end

function PANEL:getScrollbarPanel()
	return self:getParent()
end

function PANEL:removeChild(item)
	PANEL.baseClass.removeChild(self, item)
	self:getParent():removeItem(item)
end

gui.register("ScrollbarPanelCanvas", PANEL, "Panel")
