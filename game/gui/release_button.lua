local releaseButton = {}

function releaseButton:setProject(proj)
	self.project = proj
end

function releaseButton:setSkip(skip)
	self.skip = skip
end

function releaseButton:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		self.project:release(self.skip)
		frameController:pop()
	end
end

gui.register("ReleaseButton", releaseButton, "Button")
