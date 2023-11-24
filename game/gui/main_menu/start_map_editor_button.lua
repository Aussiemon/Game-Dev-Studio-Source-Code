local startMapEdit = {}

startMapEdit.fallbackWidth = 100
startMapEdit.fallbackHeight = 60
startMapEdit.defaultTileType = floors:getData("grass").id
startMapEdit.text = _T("CREATE_MAP", "Create map")

function startMapEdit:init()
	self:setFont(fonts.get("pix24"))
end

function startMapEdit:setWidthBox(box)
	self.widthBox = box
end

function startMapEdit:setHeightBox(box)
	self.heightBox = box
end

function startMapEdit:onClick()
	local width = tonumber(self.widthBox:getText()) or self.fallbackWidth
	local width, height = width, tonumber(self.heightBox:getText()) or self.fallbackHeight
	
	gui.removeAllUIElements()
	mainMenu:hide()
	mapEditor:enter(width, height, startMapEdit.defaultTileType)
end

gui.register("StartMapEditorButton", startMapEdit, "Button")
