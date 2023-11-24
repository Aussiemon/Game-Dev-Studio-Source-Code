require("engine/gui/button")

local PANEL = {}

PANEL.skinPanelOutlineColor = color(0, 0, 0, 0)
PANEL.text = ""

function PANEL:onClick(x, y, but)
	local parent = self:getParent()
	
	parent:scroll(-parent.jump)
end

function PANEL:draw(w, h)
	local pcol, tcol = self:getStateColor()
	
	love.graphics.setColor(pcol.r, pcol.g, pcol.b, pcol.a)
	love.graphics.rectangle("fill", 0, 0, w, h)
end

gui.register("ScrollbarPanelUp", PANEL, "Button")
