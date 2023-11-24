require("engine/gui/scrollbar_up")

local PANEL = {}

PANEL.skinPanelOutlineColor = color(0, 0, 0, 20)

function PANEL:init()
	self.drag = false
	self.dragStart = 0
	self.dragPos = 0
end

function PANEL:onClick()
end

function PANEL:onClickDown(x, y, key)
	local isVertical = self:getParent():isVertical()
	
	self.drag = true
	self.dragStart = isVertical and y or x
	
	local x, y = self:getPos()
	
	self.dragScroll = self:getParent().actualScroll
	self.dragPos = isVertical and y or x
end

function PANEL:onRelease(x, y, key)
	self.drag = false
	self.dragStart = 0
	self.dragPos = 0
end

function PANEL:onScroll(xVel, yVel)
	local val = self:getParent().jump
	
	if yVel < 0 then
		val = -val
	end
	
	self:getParent():scroll(val)
end

function PANEL:draw(w, h)
	local pcol, tcol = self:getStateColor()
	
	love.graphics.setColor(pcol.r, pcol.g, pcol.b, pcol.a)
	
	if self:getParent():isVertical() then
		love.graphics.rectangle("fill", 0, 2, w, h - 4)
	else
		love.graphics.rectangle("fill", 2, 0, w - 4, h)
	end
	
	local poutline = self:getPanelOutlineColor()
	
	love.graphics.setColor(poutline.r, poutline.g, poutline.b, poutline.a)
	love.graphics.setLineWidth(2)
	love.graphics.setLineStyle("rough")
	love.graphics.rectangle("line", 1, 2, w - 2, h - 4)
end

gui.register("ScrollbarPanelGrip", PANEL, "ScrollbarPanelUp")
