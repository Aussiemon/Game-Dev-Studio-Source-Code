mid = {}

function mid:get(img)
	local x, y = img:getDimensions()
	
	x = x * 0.5
	y = y * 0.5
	
	return x, y
end

function mid:getRelativeToBoundary(objW, objH, relW, relH)
	return relW * 0.5 - objW * 0.5, relH * 0.5 - objH * 0.5
end
