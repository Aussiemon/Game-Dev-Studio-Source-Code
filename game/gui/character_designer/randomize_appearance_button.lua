local randomizeAppearance = {}

function randomizeAppearance:init()
	self:setFont("pix20")
	self:setText(_T("RANDOMIZE_APPEARANCE", "Randomize appearance"))
end

function randomizeAppearance:onClick(localX, localY, key)
	characterDesigner:getEmployee():createPortrait()
end

gui.register("RandomizeAppearanceButton", randomizeAppearance, "Button")
