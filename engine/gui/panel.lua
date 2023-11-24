local PANEL = {}

PANEL.canPropagateKeyPress = true
PANEL.drawColor = color(0, 0, 0, 255)

function PANEL:init()
	self.shouldDraw = true
	self.alpha = 175
end

function PANEL:draw(w, h)
	if not self.shouldDraw then
		return 
	end
	
	love.graphics.setColor(self.drawColor.r, self.drawColor.g, self.drawColor.b, self.alpha)
	love.graphics.rectangle("fill", 0, 0, w, h)
end

gui.register("Panel", PANEL)
