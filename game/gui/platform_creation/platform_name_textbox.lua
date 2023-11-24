local platName = {}

platName.ghostText = _T("ENTER_PLATFORM_NAME", "Enter platform name")

function platName:setPlatform(plat)
	self.platform = plat
end

function platName:onWrite()
	self.platform:setName(self.curText)
end

function platName:onDelete()
	self.platform:setName(self.curText)
end

gui.register("PlatformNameTextbox", platName, "TextBox")
