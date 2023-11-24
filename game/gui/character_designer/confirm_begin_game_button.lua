local confirmBeginGame = {}

function confirmBeginGame:init()
	self:setFont("pix20")
	self:setText(_T("CONFIRM_AND_START_GAME", "Confirm & start game"))
end

function confirmBeginGame:onClick(localX, localY, key)
	game.startNewGame()
end

gui.register("ConfirmBeginGameButton", confirmBeginGame, "Button")
