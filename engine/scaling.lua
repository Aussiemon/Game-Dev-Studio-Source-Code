scaling = {}
scaling.DEFAULT_SCALER = "ui"

function scaling.parallax(size)
	return size / 512
end

local desiredRelation = 1.7777777777777777

function scaling.ui(size)
	return size * (resolutionHandler.realH / 720) * math.min(resolutionHandler.resolutionRelation / desiredRelation, 1)
end

function scaling.ui_hor(size)
	return size * (resolutionHandler.realW / 1280)
end

function _S(value, scaler)
	scaler = scaler or scaling.DEFAULT_SCALER
	
	return scaling[scaler](value)
end

function _US(value, scaler)
	scaler = scaler or scaling.DEFAULT_SCALER
	
	return value / (scaling[scaler](value) / value)
end
