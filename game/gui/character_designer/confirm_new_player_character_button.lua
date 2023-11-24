local confirmNewPC = {}

function confirmNewPC:init()
	self:setFont("pix20")
	self:setText(_T("CONFIRM_PLAYER_CHARACTER", "Confirm player character"))
end

function confirmNewPC:onClick(localX, localY, key)
	characterDesigner:finish()
end

gui.register("ConfirmNewPlayerCharacterButton", confirmNewPC, "Button")
