cullingTester = {}
cullingTester.horBoundsMultiplier = 1
cullingTester.vertBoundsMultiplier = 1
cullingTester.horBoundsAddition = 100
cullingTester.vertBoundsAddition = 100

function cullingTester:setupRenderBounds()
	self.renderBoundX = scrW * self.horBoundsMultiplier + self.horBoundsAddition
	self.renderBoundY = scrH * self.vertBoundsMultiplier + self.vertBoundsAddition
	self.halfRenderBoundX = self.renderBoundX * 0.5
	self.halfRenderBoundY = self.renderBoundY * 0.5
end

cullingTester:setupRenderBounds()

function cullingTester:updateCameraPosition()
	self.camX, self.camY = camera:getCenter()
	self.boundX, self.boundY = scrW * self.horBoundsMultiplier / camera.scaleX + self.horBoundsAddition, scrH * self.vertBoundsMultiplier / camera.scaleY + self.vertBoundsAddition
end

function cullingTester:shouldCull(ent)
	local entMidX, entMidY = ent:getCenter()
	
	if math.dist(entMidX, self.camX) >= self.boundX or math.dist(entMidY, self.camY) >= self.boundY then
		return true
	end
	
	return false
end

function cullingTester:testPasses(ent)
	return not self:shouldCull(ent)
end

cullingTester.canDraw = cullingTester.testPasses
