local desiredRelation = 1.7777777777777777

function scaling.new_hud(size)
	return size * (resolutionHandler.realH / 1080) * math.min(resolutionHandler.resolutionRelation / desiredRelation, 1)
end
