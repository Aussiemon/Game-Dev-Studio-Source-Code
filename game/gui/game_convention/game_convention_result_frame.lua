local resultFrame = {}

resultFrame.minimumPeeps = 6
resultFrame.maximumPeeps = 100
resultFrame.peepPerVisitors = 50
resultFrame.peepDisplaySpeed = 0.2
resultFrame.positionApproachSpeed = 120
resultFrame.alphaApproachSpeed = 300
resultFrame.peepSizeMult = 3
resultFrame.runAnimTime = 0.6
resultFrame.cheerAnimTime = 0.6
resultFrame.peepVariations = {
	{
		run = {
			"guy_run_1_1",
			"guy_run_1_2",
			"guy_run_1_3",
			"guy_run_1_2"
		},
		cheer = {
			"guy_cheer_1_1",
			"guy_cheer_1_2"
		},
		cheerOffset = {
			{
				0,
				0
			},
			{
				0,
				0
			}
		}
	},
	{
		run = {
			"guy_run_2_1",
			"guy_run_2_2",
			"guy_run_2_3",
			"guy_run_2_2"
		},
		cheer = {
			"guy_cheer_2_1",
			"guy_cheer_2_2"
		},
		cheerOffset = {
			{
				0,
				0
			},
			{
				0,
				0
			}
		}
	},
	{
		run = {
			"guy_run_3_1",
			"guy_run_3_2",
			"guy_run_3_3",
			"guy_run_3_2"
		},
		cheer = {
			"guy_cheer_3_1",
			"guy_cheer_3_2"
		},
		cheerOffset = {
			{
				0,
				0
			},
			{
				0,
				0
			}
		}
	},
	{
		run = {
			"gal_run_1_1",
			"gal_run_1_2",
			"gal_run_1_3",
			"gal_run_1_2"
		},
		cheer = {
			"gal_cheer_1_1",
			"gal_cheer_1_2"
		},
		cheerOffset = {
			{
				0,
				0
			},
			{
				-2,
				0
			}
		}
	},
	{
		run = {
			"gal_run_2_1",
			"gal_run_2_2",
			"gal_run_2_3",
			"gal_run_2_2"
		},
		cheer = {
			"gal_cheer_2_1",
			"gal_cheer_2_2"
		},
		cheerOffset = {
			{
				0,
				0
			},
			{
				0,
				-4
			}
		}
	},
	{
		run = {
			"gal_run_3_1",
			"gal_run_3_2",
			"gal_run_3_3",
			"gal_run_1_2"
		},
		cheer = {
			"gal_cheer_3_1",
			"gal_cheer_3_2"
		},
		cheerOffset = {
			{
				0,
				0
			},
			{
				0,
				0
			}
		}
	}
}

function resultFrame:init()
	self.colorVariance = 0
end

function resultFrame:setupAnimations()
	self.animationData = {}
	
	for key, data in ipairs(self.peepVariations) do
		self.animationData[key] = {}
		self.animationData[key].run = {}
		self.animationData[key].cheer = {}
		
		for animKey, spriteID in ipairs(data.run) do
			local quadData = quadLoader:getQuadStructure(spriteID)
			
			self.animationData[key].run[animKey] = quadData
		end
		
		for animKey, spriteID in ipairs(data.cheer) do
			local quadData = quadLoader:getQuadStructure(spriteID)
			
			self.animationData[key].cheer[animKey] = quadData
		end
	end
end

function resultFrame:setVisitorCount(count)
	self:setPeepCount(math.min(resultFrame.maximumPeeps, math.max(resultFrame.minimumPeeps, math.floor(count / resultFrame.peepPerVisitors))))
end

function resultFrame:setupSpriteData()
	self.displayedPeeps = 0
	self.prevDisplayedPeeps = 0
	self.displayedPeepIDs = {}
	self.vacantPeepIDs = {}
	self.peepAlphas = {}
	self.peepSpriteIDs = {}
	self.peepX = {}
	self.peepY = {}
	self.targetPeepX = {}
	self.peepAnimProgress = {}
	self.spriteVariations = {}
	self.spritesToEvaluate = {}
end

function resultFrame:getXSpread()
	return 0.8, 0.95
end

function resultFrame:getYSpread()
	return 0.35, 0.75
end

function resultFrame:getTargetX()
	return 0.4, 0.75
end

function resultFrame:setPeepCount(count)
	self:setupSpriteData()
	
	self.peepCount = count
	self.peepDisplaySpeed = self.peepCount * self.peepDisplaySpeed
	
	local peepVarCount = #self.peepVariations
	local xSpreadMin, xSpreadMax = self:getXSpread()
	local ySpreadMin, ySpreadMax = self:getYSpread()
	local xTargetStart, xTargetFinish = self:getTargetX()
	
	for i = 1, self.peepCount do
		self.vacantPeepIDs[i] = i
		self.spriteVariations[i] = math.random(1, peepVarCount)
		self.peepAlphas[i] = 0
		self.peepAnimProgress[i] = 0
		self.peepX[i] = _S(math.random(self.rawW * xSpreadMin, self.rawW * xSpreadMax) + math.random(-30, 30))
		self.peepY[i] = _S(math.random(self.rawH * ySpreadMin, self.rawH * ySpreadMax) + math.random(-30, 30))
		self.targetPeepX[i] = _S(math.random(self.rawW * xTargetStart, self.rawW * xTargetFinish))
	end
end

function resultFrame:setBoothSize(size)
	self.boothSize = size
	
	local list = gameConventions.BACKGROUNDS[self.boothSize]
	
	self.backgroundSpriteID = list[math.random(1, #list)]
	self.boothConfig = {}
	self.coordMultiplier = self.rawW / quadLoader:getQuadStructure("convention_bg_small_1").w
	
	for key, data in ipairs(gameConventions.BOOTH_CONFIGS[self.boothSize]) do
		table.insert(self.boothConfig, self:setupBoothSprite(data))
	end
	
	self.boothSprites = {}
end

function resultFrame:setupBoothSprite(data)
	local rolledSprite = math.random(1, #data.quads)
	local spriteID = data.quads[rolledSprite]
	local struct = {
		spriteID = spriteID,
		quadData = quadLoader:getQuadStructure(spriteID),
		config = data
	}
	
	if data.extra then
		struct.extra = self:setupBoothSprite(data.extra)
	end
	
	return struct
end

function resultFrame:think()
	self:queueSpriteUpdate()
end

function resultFrame:setPeepSizeMultiplier(mult)
	self.peepSizeMult = mult
end

function resultFrame:updateBoothSprite(data)
	local quadData = data.quadData
	local coordMultiplier = self.coordMultiplier
	local height = quadData.h * coordMultiplier
	
	self:setNextSpriteColor(180, 180, 180, 255)
	
	data.allocatedSprite = self:allocateSprite(data.allocatedSprite, data.spriteID, _S(data.config.x * coordMultiplier), _S(data.config.y * coordMultiplier - height), 0, quadData.w * coordMultiplier, height, 0, 0, -0.75 + (data.config.depthOffset or 0))
end

function resultFrame:updateSprites()
	self.bgSprite = self:allocateSprite(self.bgSprite, self.backgroundSpriteID, 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.9)
	
	local coordMultiplier = self.coordMultiplier
	
	for key, data in ipairs(self.boothConfig) do
		self:updateBoothSprite(data)
		
		if data.extra then
			self:updateBoothSprite(data.extra)
		end
	end
	
	self:updatePeepSprites()
end

function resultFrame:updatePeepSprites()
	self.displayedPeeps = math.approach(self.displayedPeeps, self.peepCount, frameTime * self.peepDisplaySpeed)
	
	local flooredPeeps = math.floor(self.displayedPeeps)
	local newSprites = false
	
	if flooredPeeps > self.prevDisplayedPeeps then
		for i = 1, flooredPeeps - self.prevDisplayedPeeps do
			local removed = table.remove(self.vacantPeepIDs, math.random(1, #self.vacantPeepIDs))
			
			self.displayedPeepIDs[#self.displayedPeepIDs + 1] = removed
		end
		
		self.prevDisplayedPeeps = flooredPeeps
		newSprites = true
	end
	
	local approachSpeed = _S(frameTime * self.positionApproachSpeed)
	local alphaApproachSpeed = frameTime * self.alphaApproachSpeed
	local runTime, cheerTime = self.runAnimTime, self.cheerAnimTime
	local peepSizeMult = self.peepSizeMult
	
	for iter = 1, #self.displayedPeepIDs do
		local i = self.displayedPeepIDs[iter]
		local targetX, curX, curY, alpha, variant, animProgress = self.targetPeepX[i], self.peepX[i], self.peepY[i], self.peepAlphas[i], self.spriteVariations[i], self.peepAnimProgress[i]
		local spriteID, spriteKey, quadData
		
		animProgress = animProgress + frameTime
		
		if curX ~= targetX then
			curX = math.approach(curX, targetX, approachSpeed)
			self.peepX[i] = curX
			
			if runTime < animProgress then
				animProgress = animProgress - math.floor(animProgress / runTime) * runTime
			end
			
			local varFrames = self.peepVariations[variant].run
			
			spriteKey = math.max(1, math.ceil(animProgress / runTime * #varFrames))
			spriteID = varFrames[spriteKey]
			quadData = self.animationData[variant].run[spriteKey]
		else
			if cheerTime < animProgress then
				animProgress = animProgress - math.floor(animProgress / cheerTime) * cheerTime
			end
			
			local struct = self.peepVariations[variant]
			local varFrames = struct.cheer
			
			spriteKey = math.max(1, math.ceil(animProgress / cheerTime * #varFrames))
			spriteID = varFrames[spriteKey]
			quadData = self.animationData[variant].cheer[spriteKey]
			
			local offset = struct.cheerOffset[spriteKey]
			
			curX = curX + _S(offset[1] * peepSizeMult)
			curY = curY + _S(offset[2] * peepSizeMult)
		end
		
		self.peepAnimProgress[i] = animProgress
		
		if alpha ~= 255 then
			alpha = math.approach(alpha, 255, alphaApproachSpeed)
			self.peepAlphas[i] = alpha
		end
		
		self:setNextSpriteColor(255, 255, 255, alpha)
		
		self.peepSpriteIDs[i] = self:allocateSprite(self.peepSpriteIDs[i], spriteID, curX, curY - _S(quadData.h * peepSizeMult), 0, quadData.w * peepSizeMult, quadData.h * peepSizeMult, 0, 0, -0.8)
	end
	
	if newSprites then
		self:sortPeepSpriteDepth()
	end
end

function resultFrame:sortPeepSpriteDepth()
	for key, peepID in ipairs(self.displayedPeepIDs) do
		local curSpriteID = self.peepSpriteIDs[peepID][1]
		local curY = self.peepY[peepID]
		local closest, index = 0
		
		for otherKey, otherPeepID in ipairs(self.displayedPeepIDs) do
			if peepID ~= otherPeepID then
				local otherY = self.peepY[otherPeepID]
				local otherSpriteID = self.peepSpriteIDs[otherPeepID][1]
				
				if otherY < curY and closest < otherY and curSpriteID < otherSpriteID then
					closest = otherY
					index = otherPeepID
				end
			end
		end
		
		if index then
			self.peepSpriteIDs[index][1], self.peepSpriteIDs[peepID][1] = curSpriteID, self.peepSpriteIDs[index][1]
		end
	end
end

gui.register("GameConventionResultFrame", resultFrame)
resultFrame:setupAnimations()
