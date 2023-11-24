registered.music = {}
dm = {}
dm.totalMusic = 1
dm.combatMusicThreshold = 2
dm.curMusic = {}

function register.dynamicMusic(tbl)
	tbl.id = dm.totalMusic
	
	table.insert(registered.music, tbl)
	
	dm.totalMusic = dm.totalMusic + 1
end

function dm:init()
	self.nextCheckTime = 0
	
	for k, v in pairs(self.curMusic) do
		self.curMusic[k] = nil
	end
end

dm:init()

function dm:adjustVolume()
	local musicVolume = sound.musicVolume
	
	for key, data in pairs(self.curMusic) do
		local percentageToMax = data.maxVol / data.vol
		
		data.vol = data.maxVol * data.vol * musicVolume
	end
end

function dm:matchesReqs(t)
	local ply = pc
	
	if not matchSelector:passesSelection(t) then
		return false
	end
	
	if t.combatantCount and not ply:shouldPlayCombatMusic(t.combatantCount) then
		return false
	end
	
	return true
end

function dm:think(dt)
	local removalIndex = 1
	local musicVolume = sound.musicVolume
	
	for k, v in pairs(self.curMusic) do
		if curTime > self.nextCheckTime then
			if self:matchesReqs(registered.music[v.id]) then
				v.fadeOut = false
			else
				v.fadeOut = true
			end
		end
		
		if v.fadeOut then
			v.vol = math.approach(v.vol, 0, 0.05 * dt)
		else
			v.vol = math.approach(v.vol, v.maxVol * musicVolume, 0.05 * dt)
		end
		
		v.snd:setVolume(v.vol)
		
		if v.vol == 0 and v.fadeOut then
			v.snd:stop()
			table.remove(self.curMusic, removalIndex)
		else
			removalIndex = removalIndex + 1
		end
	end
	
	if curTime > self.nextCheckTime then
		for k, v in pairs(registered.music) do
			if self:matchesReqs(v) then
				local can = true
				
				for k2, v2 in pairs(self.curMusic) do
					if v2.id == v.id then
						can = false
						
						break
					end
				end
				
				if can then
					local snd = table.random(v.music)
					
					table.insert(self.curMusic, {
						vol = 0,
						id = v.id,
						snd = snd,
						maxVol = v.volume
					})
					snd:rewind()
					snd:setVolume(0)
					love.audio.playX(snd)
					snd:setLooping(true)
				end
			end
		end
		
		self.nextCheckTime = curTime + 0.1
	end
end
