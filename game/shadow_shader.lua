shadowShader = {}
shadowShader.enabled = nil
shadowShader.wallShadowFramebuffer = nil
shadowShader.sampleCount = nil
shadowShader.stepSize = nil
shadowShader.wallShadowFramebufferFinal = nil
shadowShader.qualityPreset = 1
shadowShader.scaleDivider = nil
shadowShader.USE_SHADOW_SHADER = false
shadowShader.DEFAULT_QUALITY_PRESET = 2
shadowShader.QUALITY_PRESETS = {
	{
		stepSize = 0,
		sizeDivider = 1,
		sampleCount = 0,
		disable = true,
		name = _T("SHADOW_SHADER_DISABLED", "Disabled"),
		description = {
			{
				font = "pix18",
				wrapWidth = 400,
				text = _T("SHADOW_SHADER_DISABLED_DESCRIPTION", "Recommended if you have an old GPU/integrated graphics rated at less than 200 GFlops.")
			}
		}
	},
	{
		stepSize = 2,
		sizeDivider = 2,
		sampleCount = 7,
		name = _T("SHADOW_SHADER_LOW", "Low"),
		description = {
			{
				font = "pix18",
				wrapWidth = 400,
				text = _T("SHADOW_SHADER_LOW_DESCRIPTION", "Recommended if you have an old GPU/integrated graphics rated at more than 200 GFlops.")
			}
		}
	},
	{
		stepSize = 1.5,
		sizeDivider = 1.5,
		sampleCount = 10,
		name = _T("SHADOW_SHADER_MEDIUM", "Medium"),
		description = {
			{
				font = "pix18",
				wrapWidth = 400,
				text = _T("SHADOW_SHADER_MEDIUM_DESCRIPTION", "Recommended if you have an old GPU or integrated graphics rated at more than 300 GFlops.")
			}
		}
	},
	{
		stepSize = 1,
		sizeDivider = 1,
		sampleCount = 14,
		name = _T("SHADOW_SHADER_HIGH", "High"),
		description = {
			{
				font = "pix18",
				wrapWidth = 400,
				text = _T("SHADOW_SHADER_HIGH_DESCRIPTION", "Recommended if you have an old GPU or integrated graphics rated at more than 400 GFlops.")
			}
		}
	}
}
shadowShader.DESCRIPTION = {
	{
		font = "pix18",
		text = _T("SHADOW_SHADER_DESCRIPTION", "An effect simulating light being obstructed by nearby objects")
	}
}

function shadowShader:init()
	self.renderableSpriteBatches = {}
end

function shadowShader:addRenderableSpriteBatch(sb)
	if sb.NO_AO_SHADER then
		return 
	end
	
	if not table.find(self.renderableSpriteBatches, sb) then
		self.renderableSpriteBatches[#self.renderableSpriteBatches + 1] = sb
	end
end

function shadowShader:removeRenderableSpriteBatch(sb)
	if sb.NO_AO_SHADER then
		return 
	end
	
	table.removeObject(self.renderableSpriteBatches, sb)
end

function shadowShader:remove()
	table.clearArray(self.renderableSpriteBatches)
end

function shadowShader:isEnabled()
	return self.enabled
end

function shadowShader:toggle()
	self.USE_SHADOW_SHADER = not self.USE_SHADOW_SHADER
	
	if self.USE_SHADOW_SHADER then
		self:disable()
	else
		self:enable()
	end
end

function shadowShader:enable()
	if not self.wallShadowFramebuffer then
		self:initializeFramebuffers()
	end
	
	self.enabled = true
	
	priorityRenderer:add(self.wallShadowFramebuffer, self.wallShadowFramebuffer:getPriority())
end

function shadowShader:disable()
	self.enabled = false
	
	if self.wallShadowFramebuffer then
		priorityRenderer:remove(self.wallShadowFramebuffer)
	end
end

function shadowShader:start()
	if self.enabled then
		priorityRenderer:add(self.wallShadowFramebuffer, self.wallShadowFramebuffer:getPriority())
	end
end

function shadowShader:stop()
	priorityRenderer:add(self.wallShadowFramebuffer, self.wallShadowFramebuffer:getPriority())
end

function shadowShader:onResolutionChanged()
	if self.wallShadowFramebuffer then
		self:removeBuffer()
	end
	
	if self.enabled then
		self:initializeFramebuffers()
		self:enable()
	end
end

function shadowShader:setQualityPreset(realPresetId)
	local presetId = math.min(#shadowShader.QUALITY_PRESETS, realPresetId or shadowShader.DEFAULT_QUALITY_PRESET)
	
	self.qualityPreset = presetId
	
	local presetData = shadowShader.QUALITY_PRESETS[self.qualityPreset]
	
	if self.scaleDivider ~= presetData.sizeDivider then
		self:initializeFramebuffers(presetData.sizeDivider)
	end
	
	if presetData.disable then
		self:disable()
	else
		self:enable()
	end
	
	self:setQualityData(presetData.sampleCount, presetData.stepSize, presetData.sizeDivider)
end

function shadowShader:getQualitySettings()
	return self.sampleCount, self.stepSize, self.scaleDivider
end

function shadowShader:getQualityPresets()
	return shadowShader.QUALITY_PRESETS
end

function shadowShader:getPresetBySettings(sampleCount, stepSize, sizeDivider)
	for key, data in pairs(shadowShader.QUALITY_PRESETS) do
		if data.sampleCount == sampleCount and data.stepSize == stepSize and data.sizeDivider == sizeDivider then
			return data
		end
	end
	
	return shadowShader.QUALITY_PRESETS[3]
end

function shadowShader:setQualityData(sampleCount, stepSize, scaleDivider)
	self.sampleCount = sampleCount
	self.stepSize = stepSize
	self.scaleDivider = scaleDivider
	
	self:sendDataToShaders()
end

function shadowShader:sendDataToShaders()
	shaders.horizontalShadowBlend:send("SAMPLE_COUNT", self.sampleCount)
	shaders.verticalShadowBlend:send("SAMPLE_COUNT", self.sampleCount)
	self:sendStepSize()
end

function shadowShader:sendStepSize()
	shaders.horizontalShadowBlend:send("STEP_SIZE", self.stepSize / self.scaleDivider)
	shaders.verticalShadowBlend:send("STEP_SIZE", self.stepSize / self.scaleDivider)
end

function shadowShader:sendZoomScale(scaleX, scaleY)
	shaders.horizontalShadowBlend:send("SCALEX", scaleX)
	shaders.verticalShadowBlend:send("SCALEY", scaleY)
end

shadowShader.workerSpritebatchIDs = {
	"worker_hair",
	"worker_head",
	"worker_torso",
	"worker_hands",
	"worker_legs",
	"worker_shoes"
}
shadowShader.workerSpriteBatches = {}

for key, id in ipairs(shadowShader.workerSpritebatchIDs) do
	shadowShader.workerSpriteBatches[#shadowShader.workerSpriteBatches + 1] = spriteBatchController:getContainer(id)
end

function shadowShader:removeBuffer()
	priorityRenderer:remove(self.wallShadowFramebuffer)
	
	self.wallShadowFramebuffer = nil
end

function shadowShader:initializeFramebuffers(scaleDivider)
	if self.wallShadowFramebuffer then
		self:removeBuffer()
		self:sendDataToShaders()
	end
	
	scaleDivider = scaleDivider or self.scaleDivider
	
	if not scaleDivider then
		return 
	end
	
	local bufferW, bufferH = (resolutionHandler.realW + 32) / scaleDivider, (resolutionHandler.realH + 32) / scaleDivider
	local bufferSize = {
		bufferW,
		bufferH
	}
	
	shaders.horizontalShadowBlend:send("res", bufferSize)
	shaders.verticalShadowBlend:send("res", bufferSize)
	
	self.wallShadowFramebuffer = frameBuffer.new(bufferW, bufferH, 3, nil, true)
	self.wallShadowFramebufferFinal = frameBuffer.new(bufferW, bufferH, false, nil)
	
	shaders.horizontalShadowBlend:send("sampleBuffer", self.wallShadowFramebuffer:getBuffer())
	self.wallShadowFramebuffer:setDrawCallback(function(framebuffer)
		local gridRender = game.worldObject:getFloorTileGrid().renderer
		local floorContainer, wallContainer, officeContainer, southern, outer, outerSouthern = gridRender:getSpriteContainers()
		local buffer = self.wallShadowFramebuffer:getBuffer()
		local finalBuffer = self.wallShadowFramebufferFinal:getBuffer()
		local bufferRenderScale = scaleDivider
		local scaleX, scaleY = camera.scaleX, camera.scaleY
		local renderScale = 1 / scaleDivider
		local renderScaleX, renderScaleY = renderScale, renderScale
		local basePos = 16 * renderScale
		local baseX, baseY = basePos / camera.scaleX, basePos / camera.scaleY
		
		camera:unset()
		camera:set(renderScale, renderScale)
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.setCanvas(buffer)
		love.graphics.clear()
		love.graphics.setColorMask(true, false, false, true)
		floorContainer:draw(baseX, baseY, renderScaleX, renderScaleY)
		officeContainer:draw(baseX, baseY, renderScaleX, renderScaleY)
		love.graphics.setColorMask(false, true, false, false)
		love.graphics.setColor(255, 76.5, 255, 58.650000000000006)
		wallContainer:draw(baseX, baseY, renderScaleX, renderScaleY)
		southern:draw(baseX, baseY, renderScaleX, renderScaleY)
		outer:draw(baseX, baseY, renderScaleX, renderScaleY)
		outerSouthern:draw(baseX, baseY, renderScaleX, renderScaleY)
		love.graphics.setColor(255, 255, 255, 255)
		
		for key, batch in ipairs(self.renderableSpriteBatches) do
			batch:updateSprites()
			love.graphics.draw(batch:getSpritebatch(), baseX, baseY, 0, renderScaleX, renderScaleY)
		end
		
		for key, batch in ipairs(shadowShader.workerSpriteBatches) do
			batch:updateSprites()
			love.graphics.draw(batch:getSpritebatch(), baseX, baseY, 0, renderScaleX, renderScaleY)
		end
		
		love.graphics.setColorMask(true, true, true, true)
		love.graphics.setColor(255, 255, 255, 255)
		camera:unset()
		love.graphics.setCanvas(finalBuffer)
		love.graphics.clear()
		love.graphics.setShader(shaders.horizontalShadowBlend)
		love.graphics.draw(buffer, -8 * renderScale, -8 * renderScale, 0, 1, 1)
		love.graphics.setCanvas()
		love.graphics.setCanvas(game.mainFrameBufferObject)
		love.graphics.setShader(shaders.verticalShadowBlend)
		love.graphics.draw(finalBuffer, -8, -8, 0, bufferRenderScale, bufferRenderScale)
		love.graphics.setShader()
		camera:set()
		
		return true
	end)
end

shadowShader:init()
