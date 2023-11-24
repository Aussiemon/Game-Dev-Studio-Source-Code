local ceilingFan = {}

ceilingFan.canHover = false
ceilingFan.animSpeed = 1
ceilingFan.frames = {
	{
		quad = "main_menu_ceiling_fan_1",
		offset = {
			0,
			0
		}
	},
	{
		quad = "main_menu_ceiling_fan_2",
		offset = {
			4,
			0
		}
	},
	{
		quad = "main_menu_ceiling_fan_3",
		offset = {
			8,
			0
		}
	},
	{
		quad = "main_menu_ceiling_fan_4",
		offset = {
			8,
			0
		}
	}
}

function ceilingFan:setupFrames()
	for key, data in ipairs(self.frames) do
		local qData = quadLoader:getQuadStructure(data.quad)
		
		data.size = {
			qData.w * 4,
			qData.h * 4
		}
	end
end

ceilingFan:setupFrames()

function ceilingFan:init()
	self.animProgress = 0
end

function ceilingFan:makeIdle()
end

function ceilingFan:makeActive()
end

function ceilingFan:think()
	self.animProgress = self.animProgress + frameTime * self.animSpeed
	
	if self.animProgress >= 1 then
		self.animProgress = self.animProgress - 1
	end
	
	self:queueSpriteUpdate()
end

function ceilingFan:getDrawData()
	local data = self.frames[math.min(#self.frames, math.max(1, math.ceil(self.animProgress * #self.frames)))]
	
	return data.quad, data.offset, data.size
end

gui.register("MainMenuCeilingFan", ceilingFan, "MainMenuObject")
