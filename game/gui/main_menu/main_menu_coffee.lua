local coffee = {}

coffee.animSpeed = 0.6666666666666666
coffee.alphaFadeSpeed = 0.01

local noOffset = {
	0,
	0
}

coffee.frames = {
	{
		quad = "main_menu_coffee_steam_1",
		offset = noOffset
	},
	{
		quad = "main_menu_coffee_steam_2",
		offset = noOffset
	},
	{
		quad = "main_menu_coffee_steam_3",
		offset = {
			0,
			-4
		}
	},
	{
		quad = "main_menu_coffee_steam_4",
		offset = {
			0,
			-8
		}
	},
	{
		quad = "main_menu_coffee_steam_5",
		offset = {
			0,
			-8
		}
	},
	{
		quad = "main_menu_coffee_steam_6",
		offset = {
			0,
			-4
		}
	}
}

function coffee:init()
	self.alpha = 1
end

function coffee:getDrawColor()
	return 255, 255, 255, math.min(255, math.ceil(self.alpha * 255 / 10) * 10)
end

function coffee:think()
	coffee.baseClass.think(self)
	
	self.alpha = math.max(0, self.alpha - frameTime * self.alphaFadeSpeed)
end

function coffee:updateSprites()
	coffee.baseClass.updateSprites(self)
	
	local qData = quadLoader:getQuadStructure("main_menu_coffee_mug")
	
	self.mugSprite = self:allocateSprite(self.mugSprite, "main_menu_coffee_mug", -_S(16), _S(52), 0, qData.w * 4, qData.h * 4, 0, 0, -0.6)
end

gui.register("MainMenuCoffee", coffee, "MainMenuCeilingFan")
coffee:setupFrames()
