local gameSelect = {}

gameSelect.skinPanelFillColor = color(80, 80, 80, 255)
gameSelect.skinPanelHoverColor = color(175, 160, 75, 255)
gameSelect.skinPanelSelectColor = color(125, 175, 125, 255)
gameSelect.skinPanelDisableColor = color(40, 40, 40, 255)
gameSelect.skinTextFillColor = color(220, 220, 220, 255)
gameSelect.skinTextHoverColor = color(240, 240, 240, 255)
gameSelect.skinTextSelectColor = color(255, 255, 255, 255)
gameSelect.skinTextDisableColor = color(150, 150, 150, 255)

function gameSelect:init()
	self:setFont(fonts.get("pix24"))
end

function gameSelect:setConfirmationButton(button)
	self.confirmButton = button
end

function gameSelect:setProject(proj)
	self.project = proj
end

function gameSelect:onClick(x, y, key)
	self.confirmButton:setProject(self.project)
end

function gameSelect:draw(w, h)
	if self:isMouseOver() then
	else
		self:killDescBox()
	end
	
	gameSelect.baseClass.draw(self, w, h)
end

gui.register("GameSelectionButton", gameSelect, "Button")
