local translatedText = {}

translatedText.text = nil

function translatedText:__tostring()
	return self.text
end

function translatedText:__concat(other)
	return tostring(self) .. tostring(other)
end

function translatedText:new(text)
	local new = {}
	
	setmetatable(new, translatedText)
	
	new.text = text
	
	return new
end

translation = {}
translation.defaultTexts = {}
translation.languageList = {}
translation.languageTranslationKey = {}
translation.languageFiles = {}
translation.textContainers = {}
translation.currentLanguage = "en"
translation.desiredLanguage = "en"
translation.defaultLanguage = "en"
translation.DESIRED_LANGUAGE_FILE = "language"

function translation.setLanguage(langID)
	translation.currentLanguage = langID
	
	if not translation.defaultTexts[langID] then
		translation.defaultTexts[langID] = {}
		
		table.insert(translation.languageList, langID)
	end
end

function translation.addLanguage(languageID, translationKey, text)
	if not translation.defaultTexts[languageID] then
		translation.defaultTexts[languageID] = {}
		
		table.insert(translation.languageList, languageID)
		translation.add("en", translationKey, text)
		
		translation.languageTranslationKey[languageID] = translationKey
	end
end

function translation.addLanguageFile(id, filePath)
	translation.languageFiles[id] = filePath
end

function translation.setDesiredLanguage(langID)
	translation.desiredLanguage = langID
	
	translation.saveDesiredLanguageFile()
end

function translation.saveDesiredLanguageFile()
	love.filesystem.write(translation.DESIRED_LANGUAGE_FILE, translation.desiredLanguage)
end

function translation.loadDesiredLanguage()
	local loadedData = love.filesystem.read(translation.DESIRED_LANGUAGE_FILE)
	
	if loadedData and translation.defaultTexts[loadedData] then
		translation.desiredLanguage = loadedData
		translation.currentLanguage = loadedData
		
		local path = translation.languageFiles[loadedData]
		
		if path then
			require(path)
		end
	end
end

function translation.getDesiredLanguage()
	return translation.desiredLanguage
end

function translation.get(key, defaultText)
	if defaultText then
		local prev = translation.defaultTexts.en[key]
		
		if prev and prev ~= defaultText then
			print("WARNING: duplicate translation key '" .. key .. "' with mis-matched text being set in " .. string.gsub(debug.traceback(), "stack traceback:", ""))
		end
	else
		local language = translation.defaultTexts[translation.currentLanguage]
		
		if language then
			return language[key] or translation.defaultTexts.en[key]
		end
		
		return translation.defaultTexts.en[key]
	end
	
	if not translation.defaultTexts.en[key] then
		translation.defaultTexts.en[key] = defaultText
	end
	
	local language = translation.defaultTexts[translation.currentLanguage]
	
	if language then
		return language[key] or translation.defaultTexts.en[key]
	end
	
	return translation.defaultTexts.en[key]
end

local concatList = {}

function translation.compareAgainst(listOne, listTwo, diffID)
	for key, value in pairs(listOne) do
		if not listTwo[key] then
			concatList[#concatList + 1] = "[\"" .. key .. "\"] = \"" .. value .. "\","
		end
	end
	
	local final = table.concat(concatList, "\n")
	
	table.clearArray(concatList)
	love.filesystem.write("diff_" .. diffID, final)
end

function translation.add(languageID, key, text)
	translation.defaultTexts[languageID][key] = text
end

function translation.addBulk(languageID, keyList)
	local language = translation.defaultTexts[languageID]
	
	for key, text in pairs(keyList) do
		language[key] = text
	end
end

function translation.dumpLanguageToClipboard(languageID)
	local out = ""
	local lang = translation.defaultTexts[languageID]
	
	for key, text in pairs(lang) do
		out = out .. "[\"" .. key .. "\"] = \"" .. text .. "\",\n"
	end
	
	love.system.setClipboardText(out)
end

translation.addLanguage("en", "LANGUAGE_ENGLISH", "English")
translation.setLanguage("en")

_T = translation.get

if not MAIN_THREAD then
	return 
end

translation.LOCALIZATION_FILE_DIRECTORY = "localization/"
translation.LOCALIZATION_LOAD_ORDER_FILE = translation.LOCALIZATION_FILE_DIRECTORY .. "load_order"

require(translation.LOCALIZATION_LOAD_ORDER_FILE)

if RELEASE then
	translation.LOCALIZATION_AUTOLOAD_FILE_DIRECTORY = BASE_GAME_FOLDER .. translation.LOCALIZATION_FILE_DIRECTORY .. "autoload/"
else
	translation.LOCALIZATION_AUTOLOAD_FILE_DIRECTORY = translation.LOCALIZATION_FILE_DIRECTORY .. "autoload/"
end

function translation.loadLocalizationFiles(baseDirectory)
	for key, file in ipairs(love.filesystem.getDirectoryItems(baseDirectory)) do
		if not love.filesystem.isDirectory(file) and string.find(file, ".lua") then
			require(baseDirectory .. string.gsub(file, ".lua", ""))
		end
	end
end

function translation.verifyUTF8(language, font)
	local keys = translation.defaultTexts[language]
	
	for key, text in pairs(keys) do
		font:getWidth(text)
	end
end

function translation.conjugateRussianText(value, one, two, three, comma)
	local hund = value - math.floor(value / 100) * 100
	local ten = value - math.floor(value / 10) * 10
	local realValue = value
	
	if comma then
		value = string.comma(value)
	else
		value = tostring(value)
	end
	
	if realValue < 100 and hund > 4 and hund < 21 then
		return string.format(one, value)
	elseif ten == 1 then
		return string.format(three, value)
	elseif ten >= 2 and ten <= 4 then
		return string.format(two, value)
	end
	
	return string.format(one, value)
end

translation.loadLocalizationFiles(translation.LOCALIZATION_AUTOLOAD_FILE_DIRECTORY)
translation.loadDesiredLanguage()
