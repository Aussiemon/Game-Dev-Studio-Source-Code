local magButton = {}

magButton.regularIconColor = color(255, 255, 255, 150)
magButton.maxZoomWidth = 3840
magButton.icon = "magnifying_glass"

function magButton:setDirection(dir)
	self.direction = dir
end

function magButton:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT and camera:changeZoomLevel(self.direction) then
		if self.direction < 0 then
			sound:play("feature_deselected", nil, nil, nil)
		else
			sound:play("feature_selected", nil, nil, nil)
		end
	end
end

function magButton:setMaxZoomWidth(width)
	self.maxZoomWidth = width
end

function magButton:updateSprites()
	magButton.baseClass.updateSprites(self)
	
	local directionQuad = self.direction > 0 and "increase" or "decrease"
	local indicatorSize = self.rawW * 0.5
	local scaledSize = _S(indicatorSize)
	
	self:setNextSpriteColor(self:getSpriteColor():unpack())
	
	self.directionSprite = self:allocateSprite(self.directionSprite, directionQuad, scaledSize, scaledSize, 0, indicatorSize, indicatorSize, 0, 0, -0.1)
end

gui.register("MagnificationButton", magButton, "IconButton")
