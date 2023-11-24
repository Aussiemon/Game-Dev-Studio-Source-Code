timeline = {}
timeline.baseYear = 1988
timeline.DEFAULT_TIMESCALE_MULTIPLIER = 0.75
timeline.ADJUST_TIMESCALE_RANGE = {
	0.4,
	1
}
timeline.WEEKS_IN_MONTH = 4
timeline.MONTHS_IN_YEAR = 12
timeline.WEEKS_IN_YEAR = timeline.WEEKS_IN_MONTH * timeline.MONTHS_IN_YEAR
timeline.DAYS_IN_WEEK = 5
timeline.DAYS_IN_MONTH = timeline.DAYS_IN_WEEK * timeline.WEEKS_IN_MONTH
timeline.DAYS_IN_YEAR = timeline.MONTHS_IN_YEAR * timeline.DAYS_IN_MONTH
timeline.realSpeed = 0
timeline.realProgressTime = 0
timeline.curTime = 0
timeline.timePlayed = 0
timeline.MONTH_NAMES = {
	_T("JANUARY", "January"),
	_T("FEBRUARY", "February"),
	_T("MARCH", "March"),
	_T("APRIL", "April"),
	_T("MAY", "May"),
	_T("JUNE", "June"),
	_T("JULY", "July"),
	_T("AUGUST", "August"),
	_T("SEPTEMBER", "September"),
	_T("OCTOBER", "October"),
	_T("NOVEMBER", "November"),
	_T("DECEMBER", "December")
}
timeline.speedSounds = {
	[0] = "time_pause",
	"time_1x",
	"time_2x",
	"time_3x",
	"time_4x",
	"time_5x"
}
timeline.pauseSound = "time_pause"
timeline.EVENTS = {
	NEW_DAY = events:new(),
	NEW_WEEK = events:new(),
	NEW_MONTH = events:new(),
	NEW_YEAR = events:new(),
	SPEED_CHANGED = events:new(),
	PAUSED_TIMELINE = events:new(),
	UNPAUSED_TIMELINE = events:new(),
	NEW_TIMELINE = events:new(),
	TIME_SET = events:new()
}

function timeline:init()
	self.speed = 1
	self.curTime = 0
	self.timePlayed = 0
	self.paused = false
	self.canAdjustSpeed = true
	self.passedTime = 0
	self._init = true
end

function timeline:reset()
	if not self._init then
		return 
	end
	
	self:init()
	
	self._init = false
	self.paused = false
	self.canAdjustSpeed = true
	self.speed = 1
	self.curTime = 0
	self.timePlayed = 0
end

function timeline:getMonthName(id)
	return self.MONTH_NAMES[id]
end

function timeline:updateRealSpeed()
	self.realSpeed = self.paused and 0 or self.speed
	self.realProgressTime = frameTime * self.realSpeed
end

function timeline:getRealSpeed()
	return self.realSpeed
end

function timeline:setTime(time)
	self.curTime = time
	
	self:updateTime()
	events:fire(timeline.EVENTS.TIME_SET, time)
end

function timeline:setTimescaleMultiplier(mult)
	self.timescale = mult
	self.SINGLE_DAY_DURATION = 1 / mult
end

function timeline:getTimescaleMultiplier()
	return self.timescale
end

timeline:setTimescaleMultiplier(timeline.DEFAULT_TIMESCALE_MULTIPLIER)

function timeline:updateTime()
	local time = self.curTime
	
	self.curDay = self:getDay(time)
	self.curWeek = self:getWeek(time)
	self.curMonth = self:getMonth(time)
	self.curYear = self:getYear(time)
end

function timeline:progress(dt)
	self.timePlayed = self.timePlayed + dt
	
	self:updateRealSpeed()
	
	if self.paused then
		return 
	end
	
	self._breakIteration = false
	self._previousTime = self.curTime
	
	if self.speed > 0 then
		self.passedTime = self.passedTime + dt
	end
	
	local realSpeed = 0
	local realDelta = dt * timeline.timescale
	
	for i = 1, self.speed do
		local prevDay, prevWeek, prevMonth, prevYear = self.curDay, self.curWeek, self.curMonth, self.curYear
		local newTimeline = false
		
		self.curTime = self.curTime + realDelta
		
		self:updateTime()
		
		if self.curDay ~= prevDay then
			events:fire(timeline.EVENTS.NEW_DAY)
			
			newTimeline = true
		end
		
		if self.curWeek ~= prevWeek then
			events:fire(timeline.EVENTS.NEW_WEEK)
			
			newTimeline = true
		end
		
		if self.curMonth ~= prevMonth then
			events:fire(timeline.EVENTS.NEW_MONTH)
			
			newTimeline = true
		end
		
		if self.curYear ~= prevYear then
			events:fire(timeline.EVENTS.NEW_YEAR)
			
			newTimeline = true
		end
		
		studio:update(dt, dt)
		
		if newTimeline then
			events:fire(timeline.EVENTS.NEW_TIMELINE)
		end
		
		realSpeed = realSpeed + 1
		
		if self._breakIteration then
			break
		end
	end
	
	self.simulatedTime = dt * realSpeed
	
	studio:postTimelineUpdate(dt, dt * realSpeed)
	
	self.timeDelta = self.curTime - self._previousTime
end

function timeline:hasYearReachedDate(year1, month1, year2, month2)
	return self:yearToTime(year1) + self:monthToTime(month1) >= self:yearToTime(year2) + self:monthToTime(month2)
end

function timeline:getPassedTime()
	return self.passedTime
end

function timeline:breakIteration()
	self._breakIteration = true
end

function timeline:pause(resetSpeed)
	local wasPaused = self.paused
	
	self.paused = true
	self.resetSpeed = resetSpeed
	
	if not wasPaused and self.speed > 0 then
		sound:play(self.pauseSound)
	end
	
	sound.manager:pause()
	events:fire(timeline.EVENTS.PAUSED_TIMELINE)
end

function timeline:playSoundSpeed()
end

function timeline:resume()
	local wasPaused = self.paused
	
	self.paused = false
	
	if self.resetSpeed then
		self:setSpeed(self.resetSpeed)
		
		self.resetSpeed = nil
	elseif wasPaused and self.speed > 0 then
		self:playSpeedSound()
	end
	
	if self.speed > 0 then
		sound.manager:resume()
	end
	
	events:fire(timeline.EVENTS.UNPAUSED_TIMELINE)
end

function timeline:setCanAdjustSpeed(can)
	self.canAdjustSpeed = can
end

function timeline:getCanAdjustSpeed()
	return self.canAdjustSpeed
end

function timeline:attemptSetSpeed(speed)
	if not self.canAdjustSpeed or studio.expansion:isActive() or frameController:getFrameCount() > 0 then
		return 
	end
	
	self:setSpeed(speed)
end

function timeline:isPaused()
	return self.paused
end

function timeline:getPassedYears(date)
	local curYear = self:getYear(date)
	
	return curYear - timeline.baseYear
end

function timeline:playSpeedSound()
	local speedSound = timeline.speedSounds[self.speed]
	
	if speedSound then
		sound:play(speedSound)
	end
end

function timeline:setSpeed(speed, loaded)
	local prevSpeed = self.speed
	
	if speed > 0 and prevSpeed == speed then
		speed = 0
	end
	
	self.speed = speed
	
	if speed == 0 then
		sound.manager:pause()
	elseif prevSpeed == 0 then
		sound.manager:resume()
	end
	
	if prevSpeed ~= speed then
		self:playSpeedSound()
	end
	
	events:fire(timeline.EVENTS.SPEED_CHANGED, speed, loaded)
end

function timeline:getSpeed()
	return self.speed
end

function timeline:getTime()
	return self.curTime
end

function timeline:getDay(time)
	if not time then
		return self.curDay
	end
	
	return math.ceil(time - math.floor(time / timeline.DAYS_IN_WEEK) * timeline.DAYS_IN_WEEK)
end

function timeline:getTimeText(start, finish)
	local value, timeSection = self:getLargestTime(start, finish)
	
	return value > 1 and value .. " " .. timeSection .. "s" or value .. " " .. timeSection
end

function timeline:getLargestTime(start, finish)
	local delta = finish - start
	
	if delta >= timeline.DAYS_IN_YEAR then
		return self:getYear(delta, 0), "year"
	elseif delta >= timeline.DAYS_IN_MONTH then
		return self:getMonths(start, finish), "month"
	elseif delta >= timeline.DAYS_IN_WEEK then
		return self:getWeeks(start, finish), "week"
	end
	
	return self:getDay(delta), "day"
end

function timeline:getWeek(time)
	if not time then
		return self.curWeek
	end
	
	return math.ceil(time / timeline.DAYS_IN_WEEK - math.floor(time / timeline.DAYS_IN_MONTH) * timeline.WEEKS_IN_MONTH)
end

function timeline:getWeekProgress(time)
	time = time or self.curTime
	
	return math.ceil(time / timeline.DAYS_IN_WEEK) - time / timeline.DAYS_IN_WEEK
end

function timeline:getMonth(time)
	if not time then
		return self.curMonth
	end
	
	return math.max(1, math.ceil((time - math.floor(time / timeline.DAYS_IN_YEAR) * timeline.DAYS_IN_YEAR) / timeline.DAYS_IN_MONTH))
end

function timeline:getPreviousMonth()
	local month = self:getMonth()
	
	if month == 1 then
		return timeline.MONTHS_IN_YEAR
	end
	
	return month - 1
end

function timeline:getMonthProgress(time)
	time = time or self.curTime
	
	return math.ceil(time / timeline.DAYS_IN_MONTH) - time / timeline.DAYS_IN_MONTH
end

function timeline:getDateTime(year, month)
	return self:yearToTime(year) + self:monthToTime(month)
end

timeline.formatFuncs = {}
timeline.formatFuncs.ru = {
	days = function(days)
		return translation.conjugateRussianText(days, "%s дней", "%s дня", "%s день")
	end,
	weeks = function(weeks)
		return translation.conjugateRussianText(weeks, "%s недель", "%s недели", "%s неделя")
	end,
	months = function(months)
		return translation.conjugateRussianText(months, "%s месяцев", "%s месяца", "%s месяц")
	end,
	years = function(years)
		return translation.conjugateRussianText(years, "%s лет", "%s года", "%s год")
	end
}

function timeline:getTimePeriodText(timePeriod)
	local formatMethods = timeline.formatFuncs[translation.currentLanguage]
	
	if timePeriod > timeline.DAYS_IN_YEAR then
		local years = math.round(timePeriod / timeline.DAYS_IN_YEAR, 1)
		
		if formatMethods and formatMethods.years then
			return formatMethods.years(years)
		end
		
		if years > 1 then
			return string.easyformatbykeys(_T("AMOUNT_OF_TIME_YEARS", "YEARS years"), "YEARS", years)
		end
		
		return _T("AMOUNT_OF_TIME_SINGLE_YEAR", "1 year")
	elseif timePeriod > timeline.DAYS_IN_MONTH then
		local months = math.floor(timePeriod / timeline.DAYS_IN_MONTH)
		
		if formatMethods and formatMethods.months then
			return formatMethods.months(months)
		end
		
		if months > 1 then
			return string.easyformatbykeys(_T("AMOUNT_OF_TIME_MONTHS", "MONTHS months"), "MONTHS", months)
		end
		
		return _T("AMOUNT_OF_TIME_SINGLE_MONTH", "1 month")
	elseif timePeriod > timeline.DAYS_IN_WEEK then
		local weeks = math.floor(timePeriod / timeline.DAYS_IN_WEEK)
		
		if formatMethods and formatMethods.weeks then
			return formatMethods.weeks(weeks)
		end
		
		if weeks > 1 then
			return string.easyformatbykeys(_T("AMOUNT_OF_TIME_WEEKS", "WEEKS weeks"), "WEEKS", weeks)
		end
		
		return _T("AMOUNT_OF_TIME_SINGLE_WEEK", "1 week")
	elseif timePeriod > 1 then
		local days = math.floor(timePeriod)
		
		if formatMethods and formatMethods.days then
			return formatMethods.days(days)
		end
		
		if days > 1 then
			return string.easyformatbykeys(_T("AMOUNT_OF_TIME_DAYS", "DAYS days"), "DAYS", days)
		end
	end
	
	if formatMethods and formatMethods.days then
		return formatMethods.days(1)
	end
	
	return _T("AMOUNT_OF_TIME_SINGLE_DAY", "1 day")
end

function timeline:hasDateBeenReached(year, month)
	return self:getDateTime(self:getYear(), self:getMonth()) >= self:getDateTime(year, month or 0)
end

function timeline:getYear(time, baseTime)
	if not time then
		return self.curYear
	end
	
	baseTime = baseTime or timeline.baseYear
	
	return math.floor(baseTime + time / timeline.DAYS_IN_YEAR)
end

function timeline:getYearProgress(time)
	time = time or self.curTime
	
	return time / timeline.DAYS_IN_YEAR - math.floor(time / timeline.DAYS_IN_YEAR)
end

function timeline:getWeeks(start, finish)
	return math.floor((finish - start) / timeline.DAYS_IN_WEEK)
end

function timeline:getMonths(start, finish)
	return math.floor((finish - start) / timeline.DAYS_IN_MONTH)
end

function timeline:yearToTime(year)
	return (year - timeline.baseYear) * timeline.MONTHS_IN_YEAR * timeline.DAYS_IN_MONTH
end

function timeline:monthToTime(month)
	return (month - 1) * timeline.DAYS_IN_MONTH
end

function timeline:weekToTime(week)
	return week * timeline.DAYS_IN_WEEK
end

function timeline:getTimePlayed()
	return self.timePlayed
end

function timeline:save()
	return {
		curTime = self.curTime,
		passedTime = self.passedTime,
		speed = self.speed,
		paused = self.paused,
		resetSpeed = self.resetSpeed,
		timePlayed = self.timePlayed,
		timescale = self.timescale
	}
end

function timeline:load(data)
	self:init()
	
	self.curTime = data.curTime
	self.passedTime = data.passedTime
	
	self:updateTime()
	self:setSpeed(data.speed, true)
	
	self.resetSpeed = data.resetSpeed
	self.timePlayed = data.timePlayed or self.timePlayed
	
	if data.timescale then
		self:setTimescaleMultiplier(data.timescale)
	else
		self:setTimescaleMultiplier(timeline.DEFAULT_TIMESCALE_MULTIPLIER)
	end
	
	self:setSpeed(0)
end

timeline:init()
