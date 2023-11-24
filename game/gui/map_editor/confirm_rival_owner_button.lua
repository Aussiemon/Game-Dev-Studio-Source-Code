local confirmRivalOwner = {}

confirmRivalOwner.text = _T("CONFIRM_RIVAL_ID", "Confirm rival ID")

function confirmRivalOwner:init()
	self:setFont("pix24")
end

function confirmRivalOwner:setNameBox(box)
	self.textbox = box
end

function confirmRivalOwner:setPrefabData(prefabData)
	self.prefabData = prefabData
end

function confirmRivalOwner:onClick()
	frameController:pop()
	mapEditor:setPrefabRivalOwner(self.prefabData, self.textbox:getText())
end

gui.register("ConfirmRivalOwnerButton", confirmRivalOwner, "Button")
