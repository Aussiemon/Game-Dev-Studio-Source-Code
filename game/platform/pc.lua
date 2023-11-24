platforms:registerNew({
	startingQuad = "platform_pc_1",
	frustrationMultiplier = 1.3,
	manufacturer = "hardmacro",
	cutPerSale = 0,
	startingSharePercentage = 0.5,
	laterQuad = "platform_pc_2",
	month = 1,
	developmentTimeAffector = 0.6,
	laterQuadYear = 2004,
	defaultAttractiveness = 100,
	id = "pc",
	display = _T("PLATFORM_PC", "PC"),
	releaseDate = {
		year = 1980,
		month = 1
	},
	scaleProgression = {
		{
			year = 1988,
			scale = 4
		},
		{
			year = 1989,
			scale = 4.5
		},
		{
			year = 1990,
			scale = 5
		},
		{
			year = 1991,
			scale = 5.5
		},
		{
			year = 1992,
			scale = 6
		},
		{
			year = 1993,
			scale = 7
		},
		{
			year = 1994,
			scale = 7.5
		},
		{
			year = 1995,
			scale = 8
		},
		{
			year = 1996,
			scale = 9
		},
		{
			year = 1997,
			scale = 10
		},
		{
			year = 1998,
			scale = 10.5
		},
		{
			year = 1999,
			scale = 11
		},
		{
			year = 2000,
			scale = 12
		},
		{
			year = 2001,
			scale = 13
		},
		{
			year = 2003,
			scale = 14
		},
		{
			year = 2005,
			scale = 15
		},
		{
			year = 2007,
			scale = 16
		},
		{
			year = 2009,
			scale = 17
		},
		{
			year = 2010,
			scale = 18
		},
		{
			year = 2011,
			scale = 19
		},
		{
			year = 2012,
			scale = 20
		}
	},
	getMaxProjectScale = function(self, targetTime)
		local curYear = timeline:getYear(targetTime)
		local scaleValue = self.scaleProgression[1].scale
		
		for key, data in ipairs(self.scaleProgression) do
			if curYear >= data.year and scaleValue < data.scale then
				scaleValue = data.scale
			end
		end
		
		return scaleValue
	end,
	getDisplayQuad = function(self)
		if timeline:getYear() >= self.laterQuadYear then
			return self.laterQuad
		end
		
		return self.startingQuad
	end,
	genreMatching = {
		fighting = 0.7,
		racing = 1.1,
		action = 1,
		sandbox = 1.15,
		strategy = 1.15,
		simulation = 1.15,
		horror = 1,
		adventure = 1,
		rpg = 1.05
	}
})
