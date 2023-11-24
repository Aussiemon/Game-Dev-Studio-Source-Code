registered.atlases = {}
registered.atlasQuads = {}
registered.atlasSizes = {}

function register.newAtlas(name, img, size, hint)
	size = size or 256
	hint = hint or "dynamic"
	
	local atlas = cache.getImage(img)
	
	if not registered.atlases[name] then
		registered.atlases[name] = love.graphics.newSpriteBatch(atlas, size, hint)
	end
	
	registered.atlasSizes[name] = {
		w = atlas:getWidth(),
		h = atlas:getHeight()
	}
end
