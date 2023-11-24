local agreement = {}

agreement.skinPanelFillColor = game.UI_COLORS.IMPORTANT_2
agreement.skinPanelHoverColor = game.UI_COLORS.IMPORTANT_1

function agreement:onMouseEntered()
	self:queueSpriteUpdate()
end

function agreement:onMouseLeft()
	self:queueSpriteUpdate()
end

function agreement:onClick(x, y, key)
	steam.OpenWorkshopAgreement()
end

function agreement:isOn()
	return false
end

function agreement:draw(w, h)
	love.graphics.setFont(self.font)
	love.graphics.printST(self.displayText, w * 0.5 - self.displayWidth * 0.5, h * 0.5 - self.displayHeight * 0.5, 255, 255, 255, 255, 0, 0, 0, 255)
end

local genericElement = gui.getClassTable("GenericElement")

agreement.updateSprites = genericElement.updateSprites

gui.register("WorkshopLegalAgreementElement", agreement, "Label")
