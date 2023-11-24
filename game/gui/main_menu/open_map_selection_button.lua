local openMapSelectionButton = {}

openMapSelectionButton.text = _T("LOAD_EXISTING_MAP", "Load existing map")

function openMapSelectionButton:init()
	self:setFont("pix24")
end

function openMapSelectionButton:onClick()
	frameController:pop()
	mapEditor:openLoadingDialog()
end

gui.register("OpenMapSelectionButton", openMapSelectionButton, "Button")
