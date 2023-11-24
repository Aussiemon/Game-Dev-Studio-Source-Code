particleEditor = {}
particleEditor.EFFECTS_FOLDER = "particle_effects/"

function particleEditor:enter()
	love.filesystem.createDirectory(particleEditor.EFFECTS_FOLDER)
	mainMenu:hide()
	gui.removeAllUIElements()
	
	self.active = false
	self.system = love.graphics.newParticleSystem(cache.getImage("textures/generic_quad.png"))
	
	self.system:start()
	self.system:setColors(255, 255, 255, 255)
	self.system:setEmitterLifetime(-1)
	self.system:setSizes(16, 16)
	self.system:setDirection(0)
	
	self.textures = {}
	self.radialAcceleration = {
		0,
		0
	}
	self.tangentialAcceleration = {
		0,
		0
	}
	self.linearAcceleration = {
		0,
		0,
		0,
		0
	}
	self.sizes = {
		1,
		1
	}
	self.rotation = {
		0,
		0
	}
	self.colors = {
		255,
		255,
		255,
		255
	}
	self.spread = {
		0,
		0
	}
	self.linearDamping = {
		0,
		0
	}
	self.speed = {
		0,
		0
	}
	self.spin = {
		0,
		0
	}
	self.quads = {}
	self.quadObjects = {}
	
	self:setColors(255, 0, 0, 255)
	self:setInsertMode("top")
	self:setSizes(2, 2)
	self:setEmissionRate(0)
	self:setParticleLifetime(1)
	self:setAreaSpread(0, 0)
	self:setLinearDamping(0, 0)
	self:setLinearAcceleration(0, 0, 0, 0)
	self:setRadialAcceleration(0, 0)
	self:setSpeed(100, 0)
	self:setEmissionBurst(1)
	self:setSpinVariation(0)
	self:setTexture("textures/generic_quad.png")
	self:setRandomQuad(false)
	
	self.guiElements = {}
	self.name = "new_particle_effect"
	
	self:initUI()
	gameStateService:addState(self)
	layerRenderer:addLayer(self)
	inputService:addHandler(self)
	inputService:removeHandler(game.mainInputHandler)
end

function particleEditor:leave()
	self.active = false
	
	for key, element in ipairs(self.guiElements) do
		element:kill()
		
		self.guiElements[key] = nil
	end
	
	gameStateService:removeState(self)
	layerRenderer:removeLayer(self)
	inputService:removeHandler(self)
	inputService:addHandler(game.mainInputHandler)
	mainMenu:show()
end

function particleEditor:toggle()
	if self.active then
		self:leave()
	else
		self:enter()
	end
end

function particleEditor:setQuads(quadList)
	if type(quadList[1]) ~= "string" then
		local realQuadList = {}
		
		print(quadList)
		
		for key, quadObject in ipairs(quadList) do
			realQuadList[key] = quadLoader:getQuadObjectStructure(quadObject).name
		end
		
		quadList = realQuadList
	end
	
	table.clearArray(self.quads)
	table.clearArray(self.quadObjects)
	
	for key, quadName in ipairs(quadList) do
		self:addQuad(quadName, true)
	end
	
	self.system:setQuads(self.quadObjects)
end

function particleEditor:addQuad(quad, skipSet)
	local quadObject = quadLoader:load(quad)
	
	table.insert(self.quads, {
		quad = quad,
		object = quadObject
	})
	table.insert(self.quadObjects, quadObject)
	
	if not skipSet then
		self:updateQuadUsage()
	end
	
	if self.selectedQuadsScrollbar then
		self.selectedQuadsScrollbar:addItem(self:createActiveQuadElement(self.quads[#self.quads]))
	end
end

function particleEditor:removeQuad(data)
	local index
	
	for key, otherData in ipairs(self.quads) do
		if data == otherData then
			index = key
			
			break
		end
	end
	
	table.remove(self.quads, index)
	table.remove(self.quadObjects, index)
	self.system:setQuads(self.quadObjects)
	
	for key, item in ipairs(self.selectedQuadsScrollbar:getItems()) do
		if item.quadData == data then
			item:kill()
		end
	end
end

function particleEditor:setEmissionBurst(value)
	self.emissionBurst = value
end

function particleEditor:setSpin(min, max)
	min = min or self.spin[1]
	max = max or self.spin[2]
	
	if self.loading then
		min = math.deg(min)
		max = math.deg(max)
	end
	
	self.spin[1] = min
	self.spin[2] = max
	
	self.system:setSpin(math.rad(self.spin[1]), math.rad(self.spin[2]))
end

function particleEditor:setSpinVariation(var)
	self.spinVariation = var
	
	self.system:setSpinVariation(var)
end

function particleEditor:setName(name)
	self.name = name
end

function particleEditor:loadEffect(effectPath)
	self.loading = true
	
	local data, readData = particleEffects:registerFromFile(effectPath)
	
	data:applyTo(self, true)
	
	self.loading = false
	
	self:setRandomQuad(readData.randomQuad)
end

function particleEditor:setEmitterLifetime(time)
	self.emitterLifetime = time
end

function particleEditor:setRandomQuad(state)
	self.randomQuad = state
	
	self:updateQuadUsage()
end

function particleEditor:updateQuadUsage()
	if self.randomQuad then
		local quad = self.quadObjects[math.random(1, #self.quadObjects)]
		
		self.system:setQuads(quad)
	else
		self.system:setQuads(self.quadObjects)
	end
end

function particleEditor:updateTextureUsage()
	if #self.textures > 1 then
		self.system:setTexture(cache.getImage(self.textures[math.random(1, #self.textures)]))
	end
end

function particleEditor:setTexture(img)
	if type(img) ~= "string" then
		img = cache.getTexturePath(img)
	end
	
	if table.find(self.textures, img) then
		return 
	end
	
	table.clearArray(self.quads)
	table.clearArray(self.quadObjects)
	self.system:setQuads(self.quadObjects)
	table.insert(self.textures, img)
	self.system:setTexture(cache.getImage(img))
	
	if self.selectedTexturesScrollbar then
		self.selectedTexturesScrollbar:addItem(self:createActiveTextureElement(img))
	end
end

function particleEditor:removeTexture(texture)
	if table.removeObject(self.textures, texture) and #self.textures > 0 then
		self.system:setTexture(cache.getImage(self.textures[math.random(1, #self.textures)]))
	end
end

function particleEditor:setInsertMode(mode)
	self.insertMode = mode
	
	self.system:setInsertMode(mode)
end

function particleEditor:setEmissionRate(rate)
	self.emissionRate = rate
	
	self.system:setEmissionRate(rate)
end

function particleEditor:setParticleLifetime(value)
	self.particleLifetime = value
	
	self.system:setParticleLifetime(value)
end

function particleEditor:setSizes(min, max)
	min = min or self.sizes[1]
	max = max or self.sizes[2]
	self.sizes[1] = min
	self.sizes[2] = max
	
	self.system:setSizes(self.sizes[1], self.sizes[2])
end

function particleEditor:setRadialAcceleration(min, max)
	min = min or self.radialAcceleration[1]
	max = max or self.radialAcceleration[2]
	self.radialAcceleration[1] = min
	self.radialAcceleration[2] = max
	
	self.system:setRadialAcceleration(min, max)
end

function particleEditor:setTangentialAcceleration(min, max)
	min = min or self.tangentialAcceleration[1]
	max = max or self.tangentialAcceleration[2]
	self.tangentialAcceleration[1] = min
	self.tangentialAcceleration[2] = max
	
	self.system:setTangentialAcceleration(min, max)
end

function particleEditor:setLinearAcceleration(xMin, yMin, xMax, yMax)
	xMin = xMin or self.linearAcceleration[1]
	yMin = yMin or self.linearAcceleration[2]
	xMax = xMax or self.linearAcceleration[3]
	yMax = yMax or self.linearAcceleration[4]
	self.linearAcceleration[1] = xMin
	self.linearAcceleration[2] = yMin
	self.linearAcceleration[3] = xMax
	self.linearAcceleration[4] = yMax
	
	self.system:setLinearAcceleration(self.linearAcceleration[1], self.linearAcceleration[2], self.linearAcceleration[3], self.linearAcceleration[4])
end

function particleEditor:setRotation(min, max)
	min = min or self.rotation[1]
	max = max or self.rotation[2]
	self.rotation[1] = min
	self.rotation[2] = max
	
	self.system:setRotation(min, max)
end

function particleEditor:setBufferSize(buffer)
	self.bufferSize = buffer
	
	self.system:setBufferSize(buffer)
end

function particleEditor:setLinearDamping(min, max)
	min = min or self.linearDamping[1]
	max = max or self.linearDamping[2]
	self.linearDamping[1] = min
	self.linearDamping[2] = max
	
	self.system:setLinearDamping(min, max)
end

function particleEditor:setAreaSpread(distributionMode, x, y)
	if type(distributionMode) == "number" then
		x = distributionMode
		y = x
	end
	
	x = x or self.spread[1]
	y = y or self.spread[2]
	self.spread[1] = x
	self.spread[2] = y
	
	self.system:setAreaSpread("normal", self.spread[1], self.spread[2])
end

function particleEditor:setSpeed(min, max)
	min = min or self.speed[1]
	max = max or self.speed[2]
	self.speed[1] = min
	self.speed[2] = max
	
	self.system:setSpeed(self.speed[1], self.speed[2])
end

function particleEditor:setColors(r, g, b, a)
	r = r or self.colors[1]
	g = g or self.colors[2]
	b = b or self.colors[3]
	a = a or self.colors[4]
	self.colors[1] = r
	self.colors[2] = g
	self.colors[3] = b
	self.colors[4] = a
	
	self.system:setColors(r, g, b, a, r, g, b, 0)
end

function particleEditor:getSystem()
	return self.system
end

function particleEditor:initUI()
	self.yPosition = _S(10)
	self.xPosition = _S(10)
	
	local saveButton = gui.create("Button")
	
	saveButton:setSize(100, 30)
	saveButton:setFont("pix24")
	saveButton:setText("Save")
	saveButton:setPos(self.xPosition, self.yPosition)
	
	function saveButton.onClick(elem, x, y, key)
		self:saveParticleEffect()
	end
	
	local loadButton = gui.create("Button")
	
	loadButton:setSize(100, 30)
	loadButton:setFont("pix24")
	loadButton:setText("Load")
	loadButton:setPos(saveButton.x + _S(3) + saveButton.w, saveButton.y)
	
	function loadButton.onClick(elem, x, y, key)
		self:openLoadingDialog()
	end
	
	self:addUIElement(saveButton, false, true)
	
	local nameTextbox = gui.create("TextBox")
	
	nameTextbox:setPos(self.xPosition, self.yPosition)
	nameTextbox:setSize(200, 20)
	nameTextbox:setText(self.name)
	nameTextbox:setLimitTextToWidth(true)
	nameTextbox:setFont("pix16")
	
	function nameTextbox.onWrite(elem)
		self:setName(elem:getText())
	end
	
	self:addUIElement(nameTextbox, false, true)
	
	local textureButton = gui.create("Button")
	
	textureButton:setSize(100, 25)
	textureButton:setFont("pix18")
	textureButton:setText("Set texture")
	textureButton:setPos(self.xPosition, self.yPosition)
	
	function textureButton.onClick(elem, x, y, key)
		self:openTextureDialog()
	end
	
	local quadButton = gui.create("Button")
	
	quadButton:setSize(100, 25)
	quadButton:setFont("pix18")
	quadButton:setText("Setup quads")
	quadButton:setPos(textureButton.x + _S(3) + textureButton.w, textureButton.y)
	
	function quadButton.onClick(elem, x, y, key)
		self:openQuadDialog()
	end
	
	self:addUIElement(quadButton, false, true)
	
	local label = self:createLabel("Spawn rate")
	
	self:addUIElement(label, false, true)
	
	local emissionRate = gui.create("TextBox")
	
	emissionRate:setPos(self.xPosition, self.yPosition)
	emissionRate:setSize(60, 20)
	emissionRate:setText(self.spread[1])
	emissionRate:setNumbersOnly(true)
	emissionRate:setMaxText(4)
	emissionRate:setFont("pix16")
	
	function emissionRate.onWrite(elem)
		self:setEmissionRate(elem:getText())
	end
	
	self:addUIElement(emissionRate, false, true)
	
	local label = self:createLabel("Spawn amount")
	
	self:addUIElement(label, false, true)
	
	local emissionBurst = gui.create("TextBox")
	
	emissionBurst:setPos(self.xPosition, self.yPosition)
	emissionBurst:setSize(60, 20)
	emissionBurst:setText(self.emissionBurst)
	emissionBurst:setNumbersOnly(true)
	emissionBurst:setMaxText(4)
	emissionBurst:setFont("pix16")
	
	function emissionBurst.onWrite(elem)
		self:setEmissionBurst(elem:getText())
	end
	
	self:addUIElement(emissionBurst, false, true)
	
	local label = self:createLabel("Max particles")
	
	self:addUIElement(label, false, true)
	
	local buffer = gui.create("TextBox")
	
	buffer:setPos(self.xPosition, self.yPosition)
	buffer:setSize(60, 20)
	buffer:setText(self.spread[1])
	buffer:setNumbersOnly(true)
	buffer:setMaxText(4)
	buffer:setFont("pix16")
	
	function buffer.onWrite(elem)
		self:setBufferSize(elem:getText())
	end
	
	self:addUIElement(buffer, false, true)
	
	local label = self:createLabel("Color")
	
	self:addUIElement(label, false, true)
	
	local redTextbox = self:createColorTextbox(self.colors[1], nil, function(elem)
		self:setColors(elem:getText(), nil, nil, nil)
	end)
	local greenTextbox = self:createColorTextbox(self.colors[2], redTextbox, function(elem)
		self:setColors(nil, elem:getText(), nil, nil)
	end)
	local blueTextbox = self:createColorTextbox(self.colors[3], greenTextbox, function(elem)
		self:setColors(nil, nil, elem:getText(), nil)
	end)
	local alphaTextbox = self:createColorTextbox(self.colors[4], blueTextbox, function(elem)
		self:setColors(nil, nil, nil, elem:getText())
	end)
	
	self:addUIElement(redTextbox, false, true)
	
	local label = self:createLabel("Spin/sec (min/max)")
	
	self:addUIElement(label, false, true)
	
	local xText = gui.create("TextBox")
	
	xText:setPos(self.xPosition, self.yPosition)
	xText:setSize(60, 20)
	xText:setText(self.spin[1])
	xText:setNumbersOnly(true)
	xText:setMaxText(4)
	xText:setFont("pix16")
	
	function xText.onWrite(elem)
		self:setSpin(elem:getText(), nil)
	end
	
	local yText = gui.create("TextBox")
	
	yText:setPos(xText.x + xText.w + _S(3), self.yPosition)
	yText:setSize(60, 20)
	yText:setText(self.spin[2])
	yText:setNumbersOnly(true)
	yText:setMaxText(4)
	yText:setFont("pix16")
	
	function yText.onWrite(elem)
		self:setSpin(nil, elem:getText())
	end
	
	self:addUIElement(xText, false, false)
	self:addUIElement(yText, false, true)
	
	local label = self:createLabel("Scale (min/max)")
	
	self:addUIElement(label, false, true)
	
	local xText = gui.create("TextBox")
	
	xText:setPos(self.xPosition, self.yPosition)
	xText:setSize(60, 20)
	xText:setText(self.sizes[1])
	xText:setNumbersOnly(true)
	xText:setMaxText(4)
	xText:setFont("pix16")
	
	function xText.onWrite(elem)
		self:setSizes(elem:getText(), nil)
	end
	
	local yText = gui.create("TextBox")
	
	yText:setPos(xText.x + xText.w + _S(3), self.yPosition)
	yText:setSize(60, 20)
	yText:setText(self.sizes[2])
	yText:setNumbersOnly(true)
	yText:setMaxText(4)
	yText:setFont("pix16")
	
	function yText.onWrite(elem)
		self:setSizes(nil, elem:getText())
	end
	
	self:addUIElement(xText, false, false)
	self:addUIElement(yText, false, true)
	
	local label = self:createLabel("Area spread (x/y)")
	
	self:addUIElement(label, false, true)
	
	local xText = gui.create("TextBox")
	
	xText:setPos(self.xPosition, self.yPosition)
	xText:setSize(60, 20)
	xText:setText(self.spread[1])
	xText:setNumbersOnly(true)
	xText:setMaxText(4)
	xText:setFont("pix16")
	
	function xText.onWrite(elem)
		self:setAreaSpread(elem:getText(), nil)
	end
	
	local yText = gui.create("TextBox")
	
	yText:setPos(xText.x + xText.w + _S(3), self.yPosition)
	yText:setSize(60, 20)
	yText:setText(self.spread[2])
	yText:setNumbersOnly(true)
	yText:setMaxText(4)
	yText:setFont("pix16")
	
	function yText.onWrite(elem)
		self:setAreaSpread(nil, nil, elem:getText())
	end
	
	self:addUIElement(xText, false, false)
	self:addUIElement(yText, false, true)
	
	local label = self:createLabel("Rotation (min/max)")
	
	self:addUIElement(label, false, true)
	
	local xText = gui.create("TextBox")
	
	xText:setPos(self.xPosition, self.yPosition)
	xText:setSize(60, 20)
	xText:setText(self.rotation[1])
	xText:setNumbersOnly(true)
	xText:setMaxText(3)
	xText:setFont("pix16")
	
	function xText.onWrite(elem)
		self:setRotation(math.rad(elem:getText()), nil)
	end
	
	local yText = gui.create("TextBox")
	
	yText:setPos(xText.x + xText.w + _S(3), self.yPosition)
	yText:setSize(60, 20)
	yText:setText(self.rotation[2])
	yText:setNumbersOnly(true)
	yText:setMaxText(3)
	yText:setFont("pix16")
	
	function yText.onWrite(elem)
		self:setRotation(nil, math.rad(elem:getText()))
	end
	
	self:addUIElement(xText, false, false)
	self:addUIElement(yText, false, true)
	
	local label = self:createLabel("Speed (min/max) relative to direction")
	
	self:addUIElement(label, false, true)
	
	local xText = gui.create("TextBox")
	
	xText:setPos(self.xPosition, self.yPosition)
	xText:setSize(60, 20)
	xText:setText(self.speed[1])
	xText:setNumbersOnly(true)
	xText:setMaxText(4)
	xText:setFont("pix16")
	
	function xText.onWrite(elem)
		self:setSpeed(elem:getText(), nil)
	end
	
	local yText = gui.create("TextBox")
	
	yText:setPos(xText.x + xText.w + _S(3), self.yPosition)
	yText:setSize(60, 20)
	yText:setText(self.speed[2])
	yText:setNumbersOnly(true)
	yText:setMaxText(4)
	yText:setFont("pix16")
	
	function yText.onWrite(elem)
		self:setSpeed(nil, elem:getText())
	end
	
	self:addUIElement(xText, false, false)
	self:addUIElement(yText, false, true)
	
	local label = self:createLabel("Tangential velocity (min/max)")
	
	self:addUIElement(label, false, true)
	
	local xText = gui.create("TextBox")
	
	xText:setPos(self.xPosition, self.yPosition)
	xText:setSize(60, 20)
	xText:setText(self.tangentialAcceleration[1])
	xText:setNumbersOnly(true)
	xText:setMaxText(4)
	xText:setFont("pix16")
	
	function xText.onWrite(elem)
		self:setTangentialAcceleration(elem:getText(), nil)
	end
	
	local yText = gui.create("TextBox")
	
	yText:setPos(xText.x + xText.w + _S(3), self.yPosition)
	yText:setSize(60, 20)
	yText:setText(self.tangentialAcceleration[2])
	yText:setNumbersOnly(true)
	yText:setMaxText(4)
	yText:setFont("pix16")
	
	function yText.onWrite(elem)
		self:setTangentialAcceleration(nil, elem:getText())
	end
	
	self:addUIElement(xText, false, false)
	self:addUIElement(yText, false, true)
	
	local label = self:createLabel("Radial velocity (min/max)")
	
	self:addUIElement(label, false, true)
	
	local xText = gui.create("TextBox")
	
	xText:setPos(self.xPosition, self.yPosition)
	xText:setSize(60, 20)
	xText:setText(self.radialAcceleration[1])
	xText:setNumbersOnly(true)
	xText:setMaxText(4)
	xText:setFont("pix16")
	
	function xText.onWrite(elem)
		self:setRadialAcceleration(elem:getText(), nil)
	end
	
	local yText = gui.create("TextBox")
	
	yText:setPos(xText.x + xText.w + _S(3), self.yPosition)
	yText:setSize(60, 20)
	yText:setText(self.radialAcceleration[2])
	yText:setNumbersOnly(true)
	yText:setMaxText(4)
	yText:setFont("pix16")
	
	function yText.onWrite(elem)
		self:setRadialAcceleration(nil, elem:getText())
	end
	
	self:addUIElement(xText, false, false)
	self:addUIElement(yText, false, true)
	
	local label = self:createLabel("Linear velocity (x1, y1, x2, y2)")
	
	self:addUIElement(label, false, true)
	
	local xMin = self:createLinearAccelTextbox(1, function(elem)
		self:setLinearAcceleration(elem:getText())
	end)
	
	self:addUIElement(xMin, false, false)
	
	local yMin = self:createLinearAccelTextbox(2, function(elem)
		self:setLinearAcceleration(nil, elem:getText())
	end)
	
	yMin:setPos(xMin.x + xMin.w + _S(3), xMin.y)
	self:addUIElement(yMin, false, false)
	
	local xMax = self:createLinearAccelTextbox(3, function(elem)
		self:setLinearAcceleration(nil, nil, elem:getText())
	end)
	
	xMax:setPos(yMin.x + yMin.w + _S(3), xMin.y)
	self:addUIElement(xMax, false, false)
	
	local yMax = self:createLinearAccelTextbox(4, function(elem)
		self:setLinearAcceleration(nil, nil, nil, elem:getText())
	end)
	
	yMax:setPos(xMax.x + xMax.w + _S(3), xMin.y)
	self:addUIElement(yMax, false, true)
end

function particleEditor:createLinearAccelTextbox(index, onWrite)
	local textbox = gui.create("TextBox")
	
	textbox:setPos(self.xPosition, self.yPosition)
	textbox:setSize(60, 20)
	textbox:setText(self.linearAcceleration[index])
	textbox:setNumbersOnly(true)
	textbox:setMaxText(4)
	textbox:setFont("pix16")
	
	textbox.onWrite = onWrite
	
	return textbox
end

function particleEditor:createColorTextbox(value, prevElement, onWrite)
	local textbox = gui.create("TextBox")
	local x = self.xPosition
	
	if prevElement then
		x = prevElement.x + prevElement.w + _S(3)
	end
	
	textbox:setPos(x, self.yPosition)
	textbox:setSize(50, 20)
	textbox:setText(value)
	textbox:setNumbersOnly(true)
	textbox:setMaxText(3)
	textbox:setFont("pix16")
	
	textbox.onWrite = onWrite
	
	self:addUIElement(textbox, false, false)
	
	return textbox
end

function particleEditor:createLabel(tag, font)
	local label = gui.create("Label")
	
	label:setPos(self.xPosition, self.yPosition)
	label:setFont(font or "pix18")
	label:setText(tag)
	
	return label
end

function particleEditor:createTaggedTextBox(tag, width, height, font)
	self:addUIElement(self:createLabel(tag, font), false, true)
	
	local textBox = gui.create("TextBox")
	
	textBox:setPos(self.xPosition, self.yPosition)
	textBox:setFont("pix16")
	textBox:setLimitTextToWidth(true)
	textBox:setSize(width, height)
	
	return textBox
end

function particleEditor:addUIElement(elem, addWidth, addHeight)
	table.insert(self.guiElements, elem)
	
	if addHeight then
		self.yPosition = self.yPosition + elem.h + _S(3)
	end
	
	if addWidth then
		self.xPosition = self.xPosition + elem.w + _S(3)
	end
end

function particleEditor:openLoadingDialog()
	local frame = gui.create("Frame")
	
	frame:setFont("pix24")
	frame:setText("Load particle effect")
	frame:setSize(500, 600)
	frame:center()
	
	local textureList = gui.create("ScrollbarPanel", frame)
	
	textureList:setPos(_S(5), _S(35))
	textureList:setSize(490, 560)
	textureList:setAdjustElementPosition(true)
	textureList:setSpacing(3)
	textureList:setPadding(3, 3)
	textureList:addDepth(100)
	
	self.availableQuadsScrollbar = textureList
	
	for key, effectName in ipairs(love.filesystem.getDirectoryItems(particleEditor.EFFECTS_FOLDER)) do
		if effectName:find(particleEffects.FILE_FORMAT) then
			local element = gui.create("PEffectLoadButton")
			
			element:setFont("pix20")
			element:setHeight(22)
			element:setEffectPath(particleEditor.EFFECTS_FOLDER .. effectName)
			textureList:addItem(element)
		end
	end
	
	frameController:push(frame)
end

function particleEditor:openTextureDialog()
	local frame = gui.create("Frame")
	
	frame:setFont("pix24")
	frame:setText("Texture setup")
	frame:setSize(700, 530)
	frame:center()
	
	function frame.postKill()
		self.availableTexturesScrollbar = nil
		self.selectedTexturesScrollbar = nil
	end
	
	local availableTextures = gui.create("ScrollbarPanel", frame)
	
	availableTextures:setPos(_S(5), _S(35))
	availableTextures:setSize(300, 460)
	availableTextures:setAdjustElementPosition(true)
	availableTextures:setSpacing(3)
	availableTextures:setPadding(3, 3)
	availableTextures:addDepth(50)
	
	self.availableTexturesScrollbar = availableTextures
	
	for key, imageName in ipairs(cache.cachedTexturesList) do
		local element = gui.create("PTextureSelectionButton")
		
		element:setFont("pix20")
		element:setHeight(22)
		element:setTexture(imageName)
		availableTextures:addItem(element)
	end
	
	local selectedTextures = gui.create("ScrollbarPanel", frame)
	
	selectedTextures:setPos(_S(395), _S(35))
	selectedTextures:setSize(300, 460)
	selectedTextures:setAdjustElementPosition(true)
	selectedTextures:setSpacing(3)
	selectedTextures:setPadding(3, 3)
	selectedTextures:addDepth(150)
	
	self.selectedTexturesScrollbar = selectedTextures
	
	for key, name in ipairs(self.textures) do
		selectedTextures:addItem(self:createActiveTextureElement(name))
	end
	
	frameController:push(frame)
end

function particleEditor:createActiveTextureElement(textureName)
	local element = gui.create("PActiveTextureButton")
	
	element:setFont("pix20")
	element:setHeight(22)
	element:setTextureData(textureName)
	
	return element
end

function particleEditor:openQuadDialog()
	if #self.textures == 0 then
		frameController:push(game.createPopup(500, "No texture selected", "In order to select quads for the particle system you must first choose a spritesheet for it.", "pix24", "pix20"))
		
		return 
	elseif #self.textures > 1 then
		frameController:push(game.createPopup(500, "More than 1 texture selected", "In order to select quads for the particle system you must choose only 1 texture and it has to be a spritesheet.", "pix24", "pix20"))
		
		return 
	end
	
	local parsedData = spritesheetParser:getTextureData(self.textures[1])
	
	if not parsedData then
		frameController:push(game.createPopup(500, "Invalid texture", "The selected texture is not a parsed spritesheet. It has no quads for selection and therefore is invalid.", "pix24", "pix20"))
		
		return 
	end
	
	local frame = gui.create("Frame")
	
	frame:setFont("pix24")
	frame:setText("Quad setup")
	frame:setSize(700, 530)
	frame:center()
	
	function frame.postKill()
		self.availableQuadsScrollbar = nil
		self.selectedQuadsScrollbar = nil
	end
	
	local availableQuads = gui.create("ScrollbarPanel", frame)
	
	availableQuads:setPos(_S(5), _S(35))
	availableQuads:setSize(300, 460)
	availableQuads:setAdjustElementPosition(true)
	availableQuads:setSpacing(3)
	availableQuads:setPadding(3, 3)
	availableQuads:addDepth(50)
	
	self.availableQuadsScrollbar = availableQuads
	
	for key, quad in ipairs(parsedData.quads) do
		local element = gui.create("PQuadSelectionButton")
		
		element:setFont("pix20")
		element:setHeight(22)
		element:setQuad(quad)
		availableQuads:addItem(element)
	end
	
	local selectedQuads = gui.create("ScrollbarPanel", frame)
	
	selectedQuads:setPos(_S(395), _S(35))
	selectedQuads:setSize(300, 460)
	selectedQuads:setAdjustElementPosition(true)
	selectedQuads:setSpacing(3)
	selectedQuads:setPadding(3, 3)
	selectedQuads:addDepth(150)
	
	self.selectedQuadsScrollbar = selectedQuads
	
	for key, data in ipairs(self.quads) do
		selectedQuads:addItem(self:createActiveQuadElement(data))
	end
	
	local randomcbox = gui.create("Checkbox", frame)
	
	randomcbox:setSize(24, 24)
	randomcbox:setFont("bh20")
	randomcbox:setText("use random quad from list")
	randomcbox:setPos(_S(5), _S(500))
	randomcbox:setIsOnFunction(function(cbox)
		return self.randomQuad
	end)
	randomcbox:setCheckCallback(function(cbox)
		self:setRandomQuad(not self.randomQuad)
	end)
	frameController:push(frame)
end

function particleEditor:createActiveQuadElement(quadData)
	local element = gui.create("PActiveQuadButton")
	
	element:setFont("pix20")
	element:setHeight(22)
	element:setQuadData(quadData)
	
	return element
end

function particleEditor:saveParticleEffect()
	local effectData = {
		name = self.name,
		emitterLifetime = tonumber(self.emitterLifetime),
		particleLifetime = tonumber(self.particleLifetime),
		emissionRate = tonumber(self.emissionRate),
		insertMode = self.insertMode,
		radialAcceleration = self.radialAcceleration,
		tangentialAcceleration = self.tangentialAcceleration,
		sizes = self.sizes,
		rotation = self.rotation,
		colors = self.colors,
		spread = self.spread,
		bufferSize = self.bufferSize,
		linearDamping = self.linearDamping,
		linearAcceleration = self.linearAcceleration,
		speed = self.speed,
		texture = self.texture,
		textures = self.textures,
		randomQuad = self.randomQuad,
		spin = self.spin
	}
	
	if #self.textures > 1 then
		effectData.textures = self.textures
	else
		effectData.texture = self.textures[1]
	end
	
	if #self.quads > 0 then
		effectData.quads = {}
		
		for key, data in ipairs(self.quads) do
			table.insert(effectData.quads, data.quad)
		end
	end
	
	local path = particleEditor.EFFECTS_FOLDER .. self.name .. particleEffects.FILE_FORMAT
	
	json.encodeFile(path, effectData)
	frameController:push(game.createPopup(500, "Particle effect saved", _format("Particle effect saved to PATH!", "PATH", path), "pix24", "pix20"))
end

function particleEditor:handleKeyPress(key)
	if self:_handleKeyPress(key) then
		inputService:setPreventPropagation(true)
		
		return true
	end
end

function particleEditor:_handleKeyPress(key)
	if key == "escape" then
		game.attemptCloseViaEscape()
		
		return true
	end
	
	if gui.handleKeyPress(key) then
		return true
	end
end

function particleEditor:handleKeyRelease(key)
	gui.handleKeyRelease(key)
	
	return true
end

function particleEditor:handleTextInput(text)
	if not gui.handleTextEntry(text) then
		local key = love.lastKeyPressed
		
		if key == "q" then
			frameController:pop()
			self:openQuadDialog()
			
			return true
		elseif key == "t" then
			frameController:pop()
			self:openTextureDialog()
			
			return true
		elseif key == "s" then
			frameController:pop()
			self:saveParticleEffect()
			
			return true
		end
	end
	
	return true
end

function particleEditor:update(dt)
	if self.system:getCount() == 0 then
		self:updateQuadUsage()
		self:updateTextureUsage()
		self.system:emit(self.emissionBurst)
	end
	
	self.system:update(dt)
end

function particleEditor:draw()
	love.graphics.draw(self.system, scrW * 0.5, scrH * 0.5)
	gui.performDrawing()
end

require("engine/gui/particle_editor/set_effect_name_button")
require("engine/gui/particle_editor/quad_selection_button")
require("engine/gui/particle_editor/active_quad_button")
require("engine/gui/particle_editor/texture_selection_button")
require("engine/gui/particle_editor/particle_effect_load_button")
require("engine/gui/particle_editor/active_texture_button")
