require("engine/gui/scrollbar_up")

local PANEL = {}

function PANEL:onClick(x, y, but)
	local parent = self:getParent()
	
	parent:scroll(parent.jump)
end

gui.register("ScrollbarPanelDown", PANEL, "ScrollbarPanelUp")
