local cancelGame = {}

function cancelGame:init()
	self:setFont("pix20")
	self:setText(_T("CANCEL", "Cancel"))
end

function cancelGame:onClick(localX, localY, key)
	frameController:pop()
end

gui.register("CancelGameButton", cancelGame, "Button")
