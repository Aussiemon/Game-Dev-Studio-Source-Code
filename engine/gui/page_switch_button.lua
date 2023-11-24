local pageSwitchButton = {}

function pageSwitchButton:setDirection(dir)
	self.direction = dir
end

function pageSwitchButton:setClickCallback(callback)
	self.clickCallback = callback
end

function pageSwitchButton:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		local callback = self.clickCallback
		
		self.parent:changePage(self.direction)
		
		if callback then
			callback(self)
		end
	end
end

gui.register("PageSwitchButton", pageSwitchButton, "Button")
