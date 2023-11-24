splash = {}
splash.images = {}
splash.cur = 0
splash.active = false
splash.delay = 0

function splash:insertNew(img, time, sound, soundtime, bgColor, drawFunc)
	local t = {
		alpha = 0,
		approachRate = 1,
		img = love.graphics.newImage(img),
		time = time,
		sound = sound and love.audio.newSource(sound),
		soundTime = soundtime and curTime + soundtime,
		bgColor = bgColor,
		drawFunc = drawFunc
	}
	
	t.actualTime = time
	t.actualSoundTime = t.soundTime
	
	table.insert(self.images, t)
end

function splash:handleMouseClick(key)
	if key == gui.mouseKeys.LEFT then
		local t = self.images[self.cur]
		
		if t then
			if t.actualTime > 0 then
				if t.alpha == 255 then
					t.actualTime = 0
					t.alpha = 0
				end
			else
				t.approachRate = t.approachRate * 2
			end
		end
	end
end

function splash:handleKeyPress(key)
end

function splash:handleKeyRelease(key)
end

function splash:handleTextInput(text)
end

function splash:process(dt)
	if not self.active then
		return 
	end
	
	if self.delay > 0 then
		self.delay = self.delay - dt
		
		return 
	end
	
	if #self.images == 0 then
		self.active = false
		
		love.graphics.setColor(255, 255, 255, 255)
		
		return 
	end
	
	if not self.images[self.cur] then
		self.cur = self.cur + 1
	else
		local t = self.images[self.cur]
		
		if t.started then
			t.actualTime = t.actualTime - frameTime
			
			if t.actualSoundTime then
				t.actualSoundTime = t.actualSoundTime - frameTime
			end
		else
			t.started = true
		end
		
		if t.actualTime <= 0 then
			t.alpha = math.approach(t.alpha, 0, dt * 300 * t.approachRate)
			
			if t.alpha == 0 then
				self.cur = self.cur + 1
				
				if self.cur > #self.images then
					self.active = false
					
					self:releaseSplashTextures()
					love.graphics.setColor(255, 255, 255, 255)
				end
			end
		else
			if not t.soundplayed and t.sound and t.actualSoundTime <= 0 then
				love.audio.play(t.sound)
				
				t.soundplayed = true
			end
			
			t.alpha = math.approach(t.alpha, 255, dt * 300)
		end
	end
end

splash.update = splash.process

function splash:releaseSplashTextures()
	for k, v in pairs(self.images) do
		self.images[k] = nil
	end
end

function splash:draw()
	local t = self.images[self.cur]
	
	if t then
		local x, y = scrW, scrH
		
		if t.bgColor then
			love.graphics.setBackgroundColor(t.bgColor:unpack())
		end
		
		if t.img then
			local w, h = t.img:getDimensions()
			local smallest = math.min(w, h)
			local scale = y / smallest * 0.7
			
			love.graphics.setColor(255, 255, 255, t.alpha)
			love.graphics.draw(t.img, x * 0.5 - w * 0.5 * scale, y * 0.5 - h * 0.5 * scale, 0, scale, scale)
		end
		
		if t.drawFunc then
			t.drawFunc(t.alpha)
		end
	end
end
