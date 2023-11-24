local confirmMapname = {}

confirmMapname.text = _T("SAVE_MAP", "Save map")

function confirmMapname:init()
	self:setFont("pix24")
end

function confirmMapname:setNameBox(box)
	self.textbox = box
end

function confirmMapname:onClick()
	frameController:pop()
	mapEditor:setMapName(self.textbox:getText())
	mapEditor:save()
end

gui.register("ConfirmMapNamingButton", confirmMapname, "Button")
