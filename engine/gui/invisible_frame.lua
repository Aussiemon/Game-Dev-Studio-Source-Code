local frame = {}

frame.canPropagateKeyPress = true

function frame:init()
end

function frame:createCloseButton()
end

function frame:setFont(font)
end

function frame:getFont()
end

function frame:setTitle(text)
end

function frame:hideCloseButton()
end

function frame:showCloseButton()
end

function frame:getCanBlockCamera()
	return false
end

function frame:getTitle()
end

function frame:draw(w, h)
end

function frame:performLayout()
end

function frame:adjustCloseButtonPosition()
end

gui.register("InvisibleFrame", frame, "Frame")
