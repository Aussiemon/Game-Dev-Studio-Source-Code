local VERSION = 20140418.11
local OBJDEF = {
	VERSION = VERSION
}
local author = "-[ JSON.lua package by Jeffrey Friedl (http://regex.info/blog/lua/json), version " .. tostring(VERSION) .. " ]-"
local isArray = {
	__tostring = function()
		return "JSON array"
	end
}

isArray.__index = isArray

local isObject = {
	__tostring = function()
		return "JSON object"
	end
}

isObject.__index = isObject

function OBJDEF:newArray(tbl)
	return setmetatable(tbl or {}, isArray)
end

function OBJDEF:newObject(tbl)
	return setmetatable(tbl or {}, isObject)
end

local function unicode_codepoint_as_utf8(codepoint)
	if codepoint <= 127 then
		return string.char(codepoint)
	elseif codepoint <= 2047 then
		local highpart = math.floor(codepoint / 64)
		local lowpart = codepoint - 64 * highpart
		
		return string.char(192 + highpart, 128 + lowpart)
	elseif codepoint <= 65535 then
		local highpart = math.floor(codepoint / 4096)
		local remainder = codepoint - 4096 * highpart
		local midpart = math.floor(remainder / 64)
		local lowpart = remainder - 64 * midpart
		
		highpart = 224 + highpart
		midpart = 128 + midpart
		lowpart = 128 + lowpart
		
		if highpart == 224 and midpart < 160 or highpart == 237 and midpart > 159 or highpart == 240 and midpart < 144 or highpart == 244 and midpart > 143 then
			return "?"
		else
			return string.char(highpart, midpart, lowpart)
		end
	else
		local highpart = math.floor(codepoint / 262144)
		local remainder = codepoint - 262144 * highpart
		local midA = math.floor(remainder / 4096)
		
		remainder = remainder - 4096 * midA
		
		local midB = math.floor(remainder / 64)
		local lowpart = remainder - 64 * midB
		
		return string.char(240 + highpart, 128 + midA, 128 + midB, 128 + lowpart)
	end
end

function OBJDEF:onDecodeError(message, text, location, etc)
	if text then
		if location then
			message = string.format("%s at char %d of: %s", message, location, text)
		else
			message = string.format("%s: %s", message, text)
		end
	end
	
	if etc ~= nil then
		message = message .. " (" .. OBJDEF:encode(etc) .. ")"
	end
	
	if self.assert then
		self.assert(false, message)
	else
		assert(false, message)
	end
end

OBJDEF.onDecodeOfNilError = OBJDEF.onDecodeError
OBJDEF.onDecodeOfHTMLError = OBJDEF.onDecodeError

function OBJDEF:onEncodeError(message, etc)
	if etc ~= nil then
		message = message .. " (" .. OBJDEF:encode(etc) .. ")"
	end
	
	if self.assert then
		self.assert(false, message)
	else
		assert(false, message)
	end
end

local function grok_number(self, text, start, etc)
	local integer_part = text:match("^-?[1-9]%d*", start) or text:match("^-?0", start)
	
	if not integer_part then
		self:onDecodeError("expected number", text, start, etc)
	end
	
	local i = start + integer_part:len()
	local decimal_part = text:match("^%.%d+", i) or ""
	
	i = i + decimal_part:len()
	
	local exponent_part = text:match("^[eE][-+]?%d+", i) or ""
	
	i = i + exponent_part:len()
	
	local full_number_text = integer_part .. decimal_part .. exponent_part
	local as_number = tonumber(full_number_text)
	
	if not as_number then
		self:onDecodeError("bad number", text, start, etc)
	end
	
	return as_number, i
end

local function grok_string(self, text, start, etc)
	if text:sub(start, start) ~= "\"" then
		self:onDecodeError("expected string's opening quote", text, start, etc)
	end
	
	local i = start + 1
	local text_len = text:len()
	local VALUE = ""
	
	while i <= text_len do
		local c = text:sub(i, i)
		
		if c == "\"" then
			return VALUE, i + 1
		end
		
		if c ~= "\\" then
			VALUE = VALUE .. c
			i = i + 1
		elseif text:match("^\\b", i) then
			VALUE = VALUE .. "\b"
			i = i + 2
		elseif text:match("^\\f", i) then
			VALUE = VALUE .. "\f"
			i = i + 2
		elseif text:match("^\\n", i) then
			VALUE = VALUE .. "\n"
			i = i + 2
		elseif text:match("^\\r", i) then
			VALUE = VALUE .. "\r"
			i = i + 2
		elseif text:match("^\\t", i) then
			VALUE = VALUE .. "\t"
			i = i + 2
		else
			local hex = text:match("^\\u([0123456789aAbBcCdDeEfF][0123456789aAbBcCdDeEfF][0123456789aAbBcCdDeEfF][0123456789aAbBcCdDeEfF])", i)
			
			if hex then
				i = i + 6
				
				local codepoint = tonumber(hex, 16)
				
				if codepoint >= 55296 and codepoint <= 56319 then
					local lo_surrogate = text:match("^\\u([dD][cdefCDEF][0123456789aAbBcCdDeEfF][0123456789aAbBcCdDeEfF])", i)
					
					if lo_surrogate then
						i = i + 6
						codepoint = 9216 + (codepoint - 55296) * 1024 + tonumber(lo_surrogate, 16)
					end
					
					if false then
					end
				end
				
				VALUE = VALUE .. unicode_codepoint_as_utf8(codepoint)
			else
				VALUE = VALUE .. text:match("^\\(.)", i)
				i = i + 2
			end
		end
	end
	
	self:onDecodeError("unclosed string", text, start, etc)
end

local function skip_whitespace(text, start)
	local match_start, match_end = text:find("^[ \n\r\t]+", start)
	
	if match_end then
		return match_end + 1
	else
		return start
	end
end

local grok_one

local function grok_object(self, text, start, etc)
	if not text:sub(start, start) == "{" then
		self:onDecodeError("expected '{'", text, start, etc)
	end
	
	local i = skip_whitespace(text, start + 1)
	local VALUE = self.strictTypes and self:newObject({}) or {}
	
	if text:sub(i, i) == "}" then
		return VALUE, i + 1
	end
	
	local text_len = text:len()
	
	while i <= text_len do
		local key, new_i = grok_string(self, text, i, etc)
		
		i = skip_whitespace(text, new_i)
		
		if text:sub(i, i) ~= ":" then
			self:onDecodeError("expected colon", text, i, etc)
		end
		
		i = skip_whitespace(text, i + 1)
		
		local val, new_i = grok_one(self, text, i)
		
		VALUE[key] = val
		i = skip_whitespace(text, new_i)
		
		local c = text:sub(i, i)
		
		if c == "}" then
			return VALUE, i + 1
		end
		
		if text:sub(i, i) ~= "," then
			self:onDecodeError("expected comma or '}'", text, i, etc)
		end
		
		i = skip_whitespace(text, i + 1)
	end
	
	self:onDecodeError("unclosed '{'", text, start, etc)
end

local function grok_array(self, text, start, etc)
	if not text:sub(start, start) == "[" then
		self:onDecodeError("expected '['", text, start, etc)
	end
	
	local i = skip_whitespace(text, start + 1)
	local VALUE = self.strictTypes and self:newArray({}) or {}
	
	if text:sub(i, i) == "]" then
		return VALUE, i + 1
	end
	
	local VALUE_INDEX = 1
	local text_len = text:len()
	
	while i <= text_len do
		local val, new_i = grok_one(self, text, i)
		
		VALUE[VALUE_INDEX] = val
		VALUE_INDEX = VALUE_INDEX + 1
		i = skip_whitespace(text, new_i)
		
		local c = text:sub(i, i)
		
		if c == "]" then
			return VALUE, i + 1
		end
		
		if text:sub(i, i) ~= "," then
			self:onDecodeError("expected comma or '['", text, i, etc)
		end
		
		i = skip_whitespace(text, i + 1)
	end
	
	self:onDecodeError("unclosed '['", text, start, etc)
end

function grok_one(self, text, start, etc)
	start = skip_whitespace(text, start)
	
	if start > text:len() then
		self:onDecodeError("unexpected end of string", text, nil, etc)
	end
	
	if text:find("^\"", start) then
		return grok_string(self, text, start, etc)
	elseif text:find("^[-0123456789 ]", start) then
		return grok_number(self, text, start, etc)
	elseif text:find("^%{", start) then
		return grok_object(self, text, start, etc)
	elseif text:find("^%[", start) then
		return grok_array(self, text, start, etc)
	elseif text:find("^true", start) then
		return true, start + 4
	elseif text:find("^false", start) then
		return false, start + 5
	elseif text:find("^null", start) then
		return nil, start + 4
	else
		self:onDecodeError("can't parse JSON", text, start, etc)
	end
end

function OBJDEF:decode(text, etc)
	if type(self) ~= "table" or self.__index ~= OBJDEF then
		OBJDEF:onDecodeError("JSON:decode must be called in method format", nil, nil, etc)
	end
	
	if text == nil then
		self:onDecodeOfNilError(string.format("nil passed to JSON:decode()"), nil, nil, etc)
	elseif type(text) ~= "string" then
		self:onDecodeError(string.format("expected string argument to JSON:decode(), got %s", type(text)), nil, nil, etc)
	end
	
	if text:match("^%s*$") then
		return nil
	end
	
	if text:match("^%s*<") then
		self:onDecodeOfHTMLError(string.format("html passed to JSON:decode()"), text, nil, etc)
	end
	
	if text:sub(1, 1):byte() == 0 or text:len() >= 2 and text:sub(2, 2):byte() == 0 then
		self:onDecodeError("JSON package groks only UTF-8, sorry", text, nil, etc)
	end
	
	local success, value = pcall(grok_one, self, text, 1, etc)
	
	if success then
		return value
	else
		if self.assert then
			self.assert(false, value)
		else
			assert(false, value)
		end
		
		return nil, value
	end
end

local function backslash_replacement_function(c)
	if c == "\n" then
		return "\\n"
	elseif c == "\r" then
		return "\\r"
	elseif c == "\t" then
		return "\\t"
	elseif c == "\b" then
		return "\\b"
	elseif c == "\f" then
		return "\\f"
	elseif c == "\"" then
		return "\\\""
	elseif c == "\\" then
		return "\\\\"
	else
		return string.format("\\u%04x", c:byte())
	end
end

local chars_to_be_escaped_in_JSON_string = "[" .. "\"" .. "%\\" .. "%z" .. "\x01" .. "-" .. "\x1F" .. "]"

local function json_string_literal(value)
	local newval = value:gsub(chars_to_be_escaped_in_JSON_string, backslash_replacement_function)
	
	return "\"" .. newval .. "\""
end

local function object_or_array(self, T, etc)
	local string_keys = {}
	local number_keys = {}
	local number_keys_must_be_strings = false
	local maximum_number_key
	
	for key in pairs(T) do
		if type(key) == "string" then
			table.insert(string_keys, key)
		elseif type(key) == "number" then
			table.insert(number_keys, key)
			
			if key <= 0 or key >= math.huge then
				number_keys_must_be_strings = true
			elseif not maximum_number_key or maximum_number_key < key then
				maximum_number_key = key
			end
		end
	end
	
	if #string_keys == 0 and not number_keys_must_be_strings then
		if #number_keys > 0 then
			return nil, maximum_number_key
		elseif tostring(T) == "JSON array" then
			return nil
		elseif tostring(T) == "JSON object" then
			return {}
		else
			return nil
		end
	end
	
	table.sortl(string_keys)
	
	local map
	
	if #number_keys > 0 then
		if json.noKeyConversion then
			self:onEncodeError("a table with both numeric and string keys could be an object or array; aborting", etc)
		end
		
		map = {}
		
		for key, val in pairs(T) do
			map[key] = val
		end
		
		table.sortl(number_keys)
		
		for _, number_key in ipairs(number_keys) do
			local string_key = tostring(number_key)
			
			if map[string_key] == nil then
				table.insert(string_keys, string_key)
				
				map[string_key] = T[number_key]
			else
				self:onEncodeError("conflict converting table with mixed-type keys into a JSON object: key " .. number_key .. " exists both as a string and a number.", etc)
			end
		end
	end
	
	return string_keys, nil, map
end

local encode_value

function encode_value(self, value, parents, etc, indent)
	if value == nil then
		return "null"
	elseif type(value) == "string" then
		return json_string_literal(value)
	elseif type(value) == "number" then
		if value ~= value then
			return "null"
		elseif value >= math.huge then
			return "1e+9999"
		elseif value <= -math.huge then
			return "-1e+9999"
		else
			return tostring(value)
		end
	elseif type(value) == "boolean" then
		return tostring(value)
	elseif type(value) ~= "table" then
		self:onEncodeError("can't convert " .. type(value) .. " to JSON", etc)
	else
		local T = value
		
		if parents[T] then
			self:onEncodeError("table " .. tostring(T) .. " is a child of itself", etc)
		else
			parents[T] = true
		end
		
		local result_value
		local object_keys, maximum_number_key, map = object_or_array(self, T, etc)
		
		if maximum_number_key then
			local ITEMS = {}
			
			for i = 1, maximum_number_key do
				table.insert(ITEMS, encode_value(self, T[i], parents, etc, indent))
			end
			
			if indent then
				result_value = "[ " .. table.concat(ITEMS, ", ") .. " ]"
			else
				result_value = "[" .. table.concat(ITEMS, ",") .. "]"
			end
		elseif object_keys then
			local TT = map or T
			
			if indent then
				local KEYS = {}
				local max_key_length = 0
				
				for _, key in ipairs(object_keys) do
					local encoded = encode_value(self, tostring(key), parents, etc, "")
					
					max_key_length = math.max(max_key_length, #encoded)
					
					table.insert(KEYS, encoded)
				end
				
				local key_indent = indent .. "    "
				local subtable_indent = indent .. string.rep(" ", max_key_length + 2 + 4)
				local FORMAT = "%s%" .. string.format("%d", max_key_length) .. "s: %s"
				local COMBINED_PARTS = {}
				
				for i, key in ipairs(object_keys) do
					local encoded_val = encode_value(self, TT[key], parents, etc, subtable_indent)
					
					table.insert(COMBINED_PARTS, string.format(FORMAT, key_indent, KEYS[i], encoded_val))
				end
				
				result_value = "{\n" .. table.concat(COMBINED_PARTS, ",\n") .. "\n" .. indent .. "}"
			else
				local PARTS = {}
				
				for _, key in ipairs(object_keys) do
					local encoded_val = encode_value(self, TT[key], parents, etc, indent)
					local encoded_key = encode_value(self, tostring(key), parents, etc, indent)
					
					table.insert(PARTS, string.format("%s:%s", encoded_key, encoded_val))
				end
				
				result_value = "{" .. table.concat(PARTS, ",") .. "}"
			end
		else
			result_value = "[]"
		end
		
		parents[T] = false
		
		return result_value
	end
end

function OBJDEF:encode(value, etc)
	if type(self) ~= "table" or self.__index ~= OBJDEF then
		OBJDEF:onEncodeError("JSON:encode must be called in method format", etc)
	end
	
	return encode_value(self, value, {}, etc, nil)
end

function OBJDEF:encode_pretty(value, etc)
	if type(self) ~= "table" or self.__index ~= OBJDEF then
		OBJDEF:onEncodeError("JSON:encode_pretty must be called in method format", etc)
	end
	
	return encode_value(self, value, {}, etc, "")
end

function OBJDEF.__tostring()
	return "JSON encode/decode package"
end

OBJDEF.__index = OBJDEF

function OBJDEF:new(args)
	local new = {}
	
	if args then
		for key, val in pairs(args) do
			new[key] = val
		end
	end
	
	return setmetatable(new, OBJDEF)
end

json = OBJDEF:new()

function json.printTable(tab, s)
	s = s or ""
	
	for k, v in pairs(tab) do
		if type(v) == "table" then
			print(s .. "[" .. k .. "] = {")
			json.printTable(v, s .. "\t")
			print(s .. "}")
		else
			print(s .. "[" .. k .. "] = " .. v)
		end
	end
end

function json.encodeFile(file, data)
	local encoded = json:encode(data or {})
	
	return love.filesystem.write(file, encoded)
end

function json.decodeFile(file)
	local encoded = love.filesystem.read(file)
	
	if encoded then
		return json:decode(encoded)
	end
	
	return nil
end
