local utf8 = require("utf8")

string.utf8 = utf8

function utf8.getCharPos(s, position)
	local start = utf8.offset(s, 0, position)
	local finish = start
	local charPos = math.min(#s, start + 1)
	
	if not utf8.len(s, charPos, charPos) then
		finish = finish + 1
		
		while true do
			if utf8.len(s, start, finish) then
				break
			else
				finish = finish + 1
			end
		end
	end
	
	return start, finish
end

function string.SecondsToClock(seconds)
	local seconds = tonumber(seconds)
	
	if seconds <= 0 then
		return 0, 0, 0
	else
		local hours = string.format("%02.f", math.floor(seconds / 3600))
		local mins = string.format("%02.f", math.floor(seconds / 60 - hours * 60))
		local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60))
		
		return hours, mins, secs
	end
end

function string.explode(str, div, output)
	local output = output or {}
	
	while true do
		local pos1, pos2 = str:find(div)
		
		if not pos1 then
			output[#output + 1] = str
			
			break
		end
		
		output[#output + 1], str = str:sub(1, pos1 - 1), str:sub(pos2 + 1)
	end
	
	return output
end

function string.roundtobigcashnumber(value, regularRound)
	if value < 0 then
		value = math.abs(value)
		
		if value >= 1000000000 then
			return string.easyformatbykeys(_T("NEGATIVE_ROUNDED_CASH_BILLION", "-$BILLION_B"), "BILLION_", math.round(value / 1000000000, 1))
		elseif value >= 1000000 then
			return string.easyformatbykeys(_T("NEGATIVE_ROUNDED_CASH_MILLION", "-$MILLION_M"), "MILLION_", math.round(value / 1000000, 2))
		elseif value >= 1000 then
			return string.easyformatbykeys(_T("NEGATIVE_ROUNDED_CASH_THOUSAND", "-$THOUSAND_K"), "THOUSAND_", math.round(value / 1000, 2))
		end
		
		return string.easyformatbykeys(_T("NEGATIVE_ROUNDED_CASH", "-$CASH"), "CASH", math.round(value))
	end
	
	if value >= 1000000000 then
		return string.easyformatbykeys(_T("ROUNDED_CASH_BILLION", "$BILLION_B"), "BILLION_", math.round(value / 1000000000, 1))
	elseif value >= 1000000 then
		return string.easyformatbykeys(_T("ROUNDED_CASH_MILLION", "$MILLION_M"), "MILLION_", math.round(value / 1000000, 2))
	elseif value >= 1000 then
		return string.easyformatbykeys(_T("ROUNDED_CASH_THOUSAND", "$THOUSAND_K"), "THOUSAND_", math.round(value / 1000, 2))
	end
	
	return string.easyformatbykeys(_T("ROUNDED_CASH", "$CASH"), "CASH", math.round(value, regularRound))
end

string.roundToBigCashNumber = string.roundtobigcashnumber

function string.roundtobignumber(value)
	if value < 0 then
		local rounded = math.abs(value)
		
		if rounded >= 1000000000 then
			return string.easyformatbykeys(_T("NEGATIVE_ROUNDED_BILLION", "-BILLION_B"), "BILLION_", math.round(rounded / 1000000000, 1))
		elseif rounded >= 1000000 then
			return string.easyformatbykeys(_T("NEGATIVE_ROUNDED_MILLION", "-MILLION_M"), "MILLION_", math.round(rounded / 1000000, 2))
		elseif rounded >= 1000 then
			return string.easyformatbykeys(_T("NEGATIVE_ROUNDED_THOUSAND", "-THOUSAND_K"), "THOUSAND_", math.round(rounded / 1000, 2))
		end
		
		return math.round(value)
	end
	
	if value >= 1000000000 then
		return string.easyformatbykeys(_T("ROUNDED_BILLION", "BILLION_B"), "BILLION_", math.round(value / 1000000000, 1))
	elseif value >= 1000000 then
		return string.easyformatbykeys(_T("ROUNDED_MILLION", "MILLION_M"), "MILLION_", math.round(value / 1000000, 2))
	elseif value >= 1000 then
		return string.easyformatbykeys(_T("ROUNDED_THOUSAND", "THOUSAND_K"), "THOUSAND_", math.round(value / 1000, 2))
	end
	
	return math.round(value)
end

function string.roundtobignumbernodecimals(value)
	if value >= 1000000000 then
		return string.easyformatbykeys(_T("ROUNDED_BILLION", "BILLION_B"), "BILLION_", math.round(value / 1000000000, 1))
	elseif value >= 1000000 then
		return string.easyformatbykeys(_T("ROUNDED_MILLION", "MILLION_M"), "MILLION_", math.round(value / 1000000, 2))
	elseif value >= 1000 then
		if value >= 100000 then
			return string.easyformatbykeys(_T("ROUNDED_THOUSAND", "THOUSAND_K"), "THOUSAND_", math.round(value / 1000))
		else
			return string.easyformatbykeys(_T("ROUNDED_THOUSAND", "THOUSAND_K"), "THOUSAND_", math.round(value / 1000, 2))
		end
	end
	
	return math.round(value)
end

string.roundToBigNumber = string.roundtobignumber

function string.deletesymbol(s)
	if #s == 0 then
		return s
	end
	
	return string.sub(s, 1, utf8.offset(s, -1) - 1)
end

function string.left(s, pos)
	return string.sub(s, 1, pos)
end

function string.right(s, pos)
	return string.sub(s, -pos)
end

function string.specificrep(positiveSign, negativeSign, baselineValue, currentValue, sectionValue, maxSigns)
	maxSigns = maxSigns or 3
	
	local signAmount = math.min(math.ceil(baselineValue / sectionValue * currentValue), maxSigns)
	local signs
	
	if baselineValue < currentValue then
		signs = positiveSign
	else
		signs = negativeSign
	end
	
	return string.rep(signs, signAmount), signAmount
end

function string.countlines(s)
	return select(2, string.gsub(s, "\n", "")) + 1
end

function string.withoutspaces(s)
	return string.gsub(s, "%s+", "")
end

function string.formatbykeys(target, replacement)
	local result = string.gsub(target, "[%w_]+", replacement)
	
	return result
end

string.formatByKeys = string.formatbykeys

local replacementTable = {}

function string.prepareCrashlog(trace, msg)
	local err = {}
	
	table.insert(err, msg .. "\n")
	
	for l in string.gmatch(trace, "(.-)\n") do
		if not string.match(l, "boot.lua") then
			l = string.gsub(l, "stack traceback:", "Traceback\n")
			
			table.insert(err, l)
		end
	end
	
	local p = table.concat(err, "\n")
	
	p = string.gsub(p, "\t", "")
	p = string.gsub(p, "%[string \"(.-)\"%]", "%1")
	
	return p
end

function string.easyformatbykeys(target, ...)
	local cur = 1
	
	while true do
		local element = select(cur, ...)
		local replacement = select(cur + 1, ...)
		
		if not element or not replacement then
			break
		end
		
		target = string.gsub(target, element, replacement)
		cur = cur + 2
	end
	
	return target
end

string.easyFormatByKeys = string.easyformatbykeys
_format = string.easyformatbykeys
string.symbolWidth = {}

function string.cutToWidth(text, font, targetWidth)
	local textWidth = font:getWidth(text)
	
	if targetWidth < textWidth then
		local keyLength = string.symbolWidth[font]
		local dotsWidth = keyLength["..."]
		local curWidth = textWidth
		local curPos = #text
		
		for i = curPos, 1, -1 do
			local stringStartPos = utf8.offset(text, 0, curPos)
			local letter = string.sub(text, stringStartPos, curPos)
			
			if targetWidth > curWidth + dotsWidth then
				return string.sub(text, 1, curPos) .. "..."
			else
				keyLength[letter] = keyLength[letter] or font:getWidth(letter)
				curWidth = curWidth - keyLength[letter]
				curPos = stringStartPos - 1
				
				if curPos <= 0 then
					return text
				end
			end
		end
	else
		return text
	end
	
	return ""
end

string.cuttowidth = string.cutToWidth

function string.timegroup(time)
	local niceTime, timeGroup
	
	if time >= 1728000 then
		niceTime = math.ceil(time / 1728000)
		timeGroup = niceTime == 1 and "month" or "months"
	elseif time >= 432000 then
		niceTime = math.ceil(time / 432000)
		timeGroup = niceTime == 1 and "week" or "weeks"
	elseif time >= 86400 then
		niceTime = math.ceil(time / 86400)
		timeGroup = niceTime == 1 and "day" or "days"
	elseif time >= 3600 then
		niceTime = math.ceil(time / 3600)
		timeGroup = niceTime == 1 and "hour" or "hours"
	elseif time >= 60 then
		niceTime = math.ceil(time / 60)
		timeGroup = niceTime == 1 and "minute" or "minutes"
	else
		niceTime = math.ceil(time)
		timeGroup = niceTime == 1 and "second" or "seconds"
	end
	
	return niceTime, timeGroup
end

function string.nearestmultiplier(number, rounding)
	if number >= 1000000 then
		return math.round(number / 1000000, rounding) .. "M"
	elseif number >= 1000 then
		return math.round(number / 1000, rounding) .. "K"
	end
	
	return math.round(number)
end

function string.formatsuffix(text, amount)
	if amount == 1 then
		return text
	end
	
	return text .. "s"
end

string.indefiniteArticles = {
	e = true,
	a = true,
	u = true,
	o = true,
	i = true
}
string.indefiniteAN = "an"
string.indefiniteA = "a"

function string.article(word)
	return string.indefiniteArticles[string.sub(word, 1, 1)] and string.indefiniteAN or string.indefiniteA
end

function string.comma(number)
	number = math.round(number)
	
	local res = tostring(number):reverse():gsub("%d%d%d", "%1,"):reverse()
	
	if number < 0 then
		return res:gsub("^-,", "")
	end
	
	return res:gsub("^,", "")
end

local finalWordTable = {}
local empty = ""
local space = " "
local words = {}

function string.wrap(text, font, lineWidth, prevWidth, extraLine)
	if extraLine then
		local maxWidth, firstText = font:getWrap(text, lineWidth - extraLine)
		
		if #firstText == 1 then
			return firstText[1], #firstText, font:getHeight() * #firstText
		end
		
		local firstTextEntry = table.remove(firstText, 1)
		local newText = table.concat(firstText, " ")
		local maxWidth, textList = font:getWrap(newText, lineWidth)
		
		return table.concat(textList, "\n"), #textList, font:getHeight() * (#textList + 1), firstTextEntry
	end
	
	local maxWidth, textList = font:getWrap(text, lineWidth)
	
	return table.concat(textList, "\n"), #textList, font:getHeight() * #textList, textList
end

function string._wrap(wordList, font, lineWidth, prevWidth, stopAtNewLine)
end

local meta = getmetatable("")

function meta.__add(a, b)
	return a .. b
end

function meta.__sub(a, b)
	return a:gsub(b, "")
end

function meta.__mul(a, b)
	return a:rep(b)
end

function meta.__div(a, b)
	return a:explode(b)
end
