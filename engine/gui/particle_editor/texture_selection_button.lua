local textureSelect = {}

function textureSelect:setTexture(texture)
	self.texture = texture
	
	self:setText(self.texture)
end

function textureSelect:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		particleEditor:setTexture(self.texture)
	end
end

gui.register("PTextureSelectionButton", textureSelect, "Button")
