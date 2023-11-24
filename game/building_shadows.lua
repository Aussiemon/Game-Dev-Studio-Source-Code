buildingShadows = {}
buildingShadows.STEP_SIZE = 40
buildingShadows.enabled = true
buildingShadows.renderableSpriteBatches = {}
buildingShadows.RENDER_DEPTH = 55
buildingShadows.DESCRIPTION = {
	{
		font = "pix18",
		wrapWidth = 350,
		text = _T("EFFECT_SHADOWS_DESCRIPTION", "When enabled, will make buildings and various objects cast shadows onto the world.")
	}
}

function buildingShadows:sendDataToShaders()
	self:sendStepSize()
end

function buildingShadows:sendStepSize()
	shaders.buildingShadowShader:send("STEP_SIZE", self.STEP_SIZE)
end

function buildingShadows:sendCoordinatesToShader()
	local dirX, dirY = math.normalfromdeg(timeOfDay:getShadowSampleDirection())
	
	self.shadowDirX, self.shadowDirY = dirX, dirY
	
	shaders.buildingShadowShader:send("stepX", dirX / self.bufferW * math.min(1, camera.scaleX))
	shaders.buildingShadowShader:send("stepY", dirY / self.bufferH * math.min(1, camera.scaleY))
end

function buildingShadows:onResolutionChanged()
	if self.enabled then
		self:initializeFramebuffers()
	end
end

function buildingShadows:addRenderableSpriteBatch(sb)
	if not sb.SHADOW_SHADER then
		return 
	end
	
	if not table.find(self.renderableSpriteBatches, sb) then
		self.renderableSpriteBatches[#self.renderableSpriteBatches + 1] = sb
	end
end

function buildingShadows:removeRenderableSpriteBatch(sb)
	if not sb.SHADOW_SHADER then
		return 
	end
	
	table.removeObject(self.renderableSpriteBatches, sb)
end

function buildingShadows:remove()
	table.clearArray(self.renderableSpriteBatches)
end

function buildingShadows:enable()
	if not self.enabled then
		if not self.buildingShadowMask then
			self:initializeFramebuffers()
		else
			priorityRenderer:add(self.buildingShadowMask, buildingShadows.RENDER_DEPTH)
		end
		
		self.enabled = true
	end
end

function buildingShadows:disable()
	if self.enabled then
		if self.buildingShadowMask then
			priorityRenderer:remove(self.buildingShadowMask)
		end
		
		self.enabled = false
	end
end

function buildingShadows:initializeFramebuffers()
	if self.buildingShadowMask then
		priorityRenderer:remove(self.buildingShadowMask)
	end
	
	self:sendDataToShaders()
	
	local bufferW, bufferH = resolutionHandler.realW, resolutionHandler.realH
	local overdrawRange = self.STEP_SIZE * 2
	
	bufferW, bufferH = bufferW + overdrawRange, bufferH + overdrawRange
	
	local halfStep = overdrawRange * 0.5
	local bufferSize = {
		bufferW,
		bufferH
	}
	
	self.bufferW, self.bufferH = bufferW, bufferH
	self.buildingShadowMask = frameBuffer.new(bufferW, bufferH, buildingShadows.RENDER_DEPTH, nil)
	
	shaders.buildingShadowShader:send("maskBuffer", self.buildingShadowMask:getBuffer())
	self.buildingShadowMask:setDrawCallback(function(framebuffer)
		local maskBuffer = self.buildingShadowMask:getBuffer()
		
		self:sendCoordinatesToShader()
		
		local floorTileGridRenderer = game.worldObject:getFloorTileGrid().renderer
		local floorContainer, wallContainer, officeContainer, southern, outer, outerSouthern = floorTileGridRenderer:getSpriteContainers()
		local scaleX, scaleY = camera.scaleX, camera.scaleY
		local renderScale = 1
		local renderScaleX, renderScaleY = renderScale, renderScale
		local basePos = halfStep
		local baseX, baseY = math.round(basePos / scaleX), math.round(basePos / scaleY)
		local lowestScale = math.min(1, scaleX)
		local stepSize = self.STEP_SIZE
		local renderOffsetX, renderOffsetY = 0, 0
		
		if scaleX > 1 then
			renderOffsetX, renderOffsetY = stepSize, stepSize
		end
		
		camera:unset()
		camera:set(renderScale, renderScale, lowestScale, lowestScale, -renderOffsetX, -renderOffsetY)
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.setCanvas(maskBuffer)
		love.graphics.clear(0, 0, 0, 0)
		
		for key, sb in ipairs(self.renderableSpriteBatches) do
			sb:draw(baseX, baseY, renderScaleX, renderScaleY)
		end
		
		love.graphics.setBlendMode("alpha", "premultiplied")
		wallContainer:draw(baseX, baseY, renderScaleX, renderScaleY)
		officeContainer:draw(baseX, baseY, renderScaleX, renderScaleY)
		southern:draw(baseX, baseY, renderScaleX, renderScaleY)
		outer:draw(baseX, baseY, renderScaleX, renderScaleY)
		outerSouthern:draw(baseX, baseY, renderScaleX, renderScaleY)
		love.graphics.setBlendMode("alpha", "alphamultiply")
		camera:unset()
		love.graphics.setCanvas()
		
		local offsetX, offsetY = 0, 0
		
		if scaleX > 1 then
			love.graphics.scale(scaleX, scaleY)
			
			offsetX, offsetY = -stepSize / scaleX - stepSize, -stepSize / scaleY - stepSize
		else
			offsetX, offsetY = -stepSize, -stepSize
		end
		
		love.graphics.setCanvas(game.mainFrameBufferObject)
		love.graphics.setBlendMode("multiply")
		love.graphics.setShader(shaders.buildingShadowShader)
		love.graphics.draw(maskBuffer, offsetX, offsetY)
		love.graphics.setShader()
		love.graphics.setBlendMode("alpha")
		
		if scaleX > 1 then
			love.graphics.scale(1 / scaleX, 1 / scaleY)
		end
		
		camera:set()
		
		return true
	end)
end
