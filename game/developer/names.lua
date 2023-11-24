names = {}
names.first = {}
names.last = {}
names.backgrounds = {}
names.sequentialFirst = {}
names.sequentialLast = {}
names.backgroundSkinColor = {}
names.backgroundHairColor = {}
names.backgroundEyeColor = {}
names.firstNameTranslationKey = "NAME_"
names.lastNameTranslationKey = "SURNAME_"

function names:registerBackground(backgroundID)
	table.insert(names.backgrounds, backgroundID)
	
	names.backgroundSkinColor[backgroundID] = {}
	names.backgroundHairColor[backgroundID] = {}
	names.backgroundEyeColor[backgroundID] = {}
	names.first[backgroundID] = names.first[backgroundID] or {
		male = {},
		female = {}
	}
	names.last[backgroundID] = names.last[backgroundID] or {
		male = {},
		female = {}
	}
	names.sequentialFirst[backgroundID] = names.sequentialFirst[backgroundID] or {
		male = {},
		female = {}
	}
	names.sequentialLast[backgroundID] = names.sequentialLast[backgroundID] or {
		male = {},
		female = {}
	}
end

function names:addSkinColorToBackground(background, skinColor)
	table.insert(names.backgroundSkinColor[background], skinColor)
end

function names:addHairColorToBackground(background, hairColor)
	table.insert(names.backgroundHairColor[background], hairColor)
end

function names:addEyeColorToBackground(background, eyeColor)
	table.insert(names.backgroundEyeColor[background], eyeColor)
end

function names:registerFirstName(background, isFemale, listOfNames)
	local targetList = names.first[background]
	
	targetList = isFemale and targetList.female or targetList.male
	
	local nameList = string.explode(listOfNames, "%s")
	
	for key, name in ipairs(nameList) do
		local nameKey = names.firstNameTranslationKey .. string.upper(name)
		
		targetList[#targetList + 1] = nameKey
		
		translation.add("en", nameKey, name)
	end
end

function names:registerLastName(background, isFemale, bothGenders, listOfNames)
	local targetList = names.last[background]
	
	if not bothGenders then
		targetList = isFemale and targetList.female or targetList.male
		
		local nameList = string.explode(listOfNames, "%s")
		
		for key, name in ipairs(nameList) do
			local nameKey = names.lastNameTranslationKey .. string.upper(name)
			
			targetList[#targetList + 1] = nameKey
			
			translation.add("en", nameKey, name)
		end
	else
		local male = targetList.male
		local female = targetList.female
		local nameList = string.explode(listOfNames, "%s")
		
		for key, name in ipairs(nameList) do
			local nameKey = names.lastNameTranslationKey .. string.upper(name)
			
			male[#male + 1] = nameKey
			female[#female + 1] = nameKey
			
			translation.add("en", nameKey, name)
		end
	end
end

function names:dumpNamesToClipboard()
	local toDump = {}
	
	for key, background in ipairs(names.backgrounds) do
		local first = names.first[background]
		local last = names.last[background]
		
		self:_dumpNames(toDump, first.male)
		self:_dumpNames(toDump, first.female)
		self:_dumpNames(toDump, last.male)
		self:_dumpNames(toDump, last.female)
	end
	
	love.system.setClipboardText(table.concat(toDump, "\n"))
end

function names:_dumpNames(list, nameList)
	for key, name in ipairs(nameList) do
		list[#list + 1] = "[\"" .. name .. "\"] = \"" .. _T(name) .. "\","
	end
end

function names:getFirstName(background, isFemale, index)
	local list = names.first[background]
	
	if isFemale then
		return _T(list.female[index])
	else
		return _T(list.male[index])
	end
end

function names:getLastName(background, isFemale, index)
	local list = names.last[background]
	
	if isFemale then
		return _T(list.female[index])
	else
		return _T(list.male[index])
	end
end

function names:getFullName(firstIndex, secondIndex, background, isFemale)
	local firstList = names.first[background]
	local lastList = names.last[background]
	
	if isFemale then
		return _format("FIRST LAST", "FIRST", _T(firstList.female[firstIndex]), "LAST", _T(lastList.female[secondIndex]))
	else
		return _format("FIRST LAST", "FIRST", _T(firstList.male[firstIndex]), "LAST", _T(lastList.male[secondIndex]))
	end
end

function names:resetSequentialFirst(background, isFemale)
	table.clear(self.sequentialFirst)
	self:fillNamesFrom(background, isFemale, self.first, self.sequentialFirst)
end

function names:resetSequentialLast(background, isFemale)
	table.clear(self.sequentialLast)
	self:fillNamesFrom(background, isFemale, self.last, self.sequentialLast)
end

function names:fillNamesFrom(background, isFemale, from, dest)
	local targetList = from[background]
	
	dest = dest[background]
	
	if isFemale then
		targetList = targetList.female
		dest = dest.female
	else
		targetList = targetList.male
		dest = dest.male
	end
	
	for key, value in ipairs(targetList) do
		dest[#dest + 1] = key
	end
end

function names:getAndRemove(background, isFemale, from)
	from = from[background]
	from = isFemale and from.female or from.male
	
	local randIndex = math.random(1, #from)
	local randResult = from[randIndex]
	
	table.remove(from, randIndex)
	
	return randResult, randIndex
end

function names:getRandomSequentialName(isFemale)
	local background = names.backgrounds[math.random(1, #names.backgrounds)]
	
	self:verifyNames(background, isFemale, self.sequentialFirst, self.first)
	self:verifyNames(background, isFemale, self.sequentialLast, self.last)
	
	local firstName = self:getAndRemove(background, isFemale, self.sequentialFirst)
	local lastName = self:getAndRemove(background, isFemale, self.sequentialLast)
	
	return firstName, lastName, background
end

function names:getRandomBackground()
	return names.backgrounds[math.random(1, #names.backgrounds)]
end

function names:verifyNames(background, isFemale, verification, fillFrom)
	local target = verification[background]
	
	target = isFemale and target.female or target.male
	
	if #target == 0 then
		self:fillNamesFrom(background, isFemale, fillFrom, verification)
	end
end

names:registerBackground("slavic")
names:registerBackground("germanic")
names:registerBackground("finnish")
names:registerFirstName("slavic", false, "Roman Igor Ivan Denis Vasiliy Oleg Piotr Giorgiy Kirill Aleksandr Aleksey Andrei Anton Artyom Artur Borimir Borislav Bronislav Boris Bogdan Velimir Viktor Vladimir Vyacheslav Gavriil Gleb Eruslan Maksim Orest Radomir Svetoslav Sergei Stanislav Taras Fedor Grichka")
names:registerFirstName("slavic", true, "Aleksandra Anastasiya Anzhela Diana Dunya Evgeniya Irina Jekaterina Julia Karina Katia Larisa Lena Liza Masha Nadezhda Anastasiya Natasha Olga Serafima Snezhana Svetlana Veronika Viktoriya Yeva Zhanna Zoya")
names:registerLastName("slavic", false, false, "Alekseev Andreev Antonov Bogdanov Bogomolov Borisov Chaykovsky Fedorov Filippov Ivanov Konstantinov Kozlov Krupin Kuznetsov Lagunov Maksimov Markov Matveev Medvedev Putin Mikhailov Naumov Nikolaev Orlov Pavlov Petrov Popov Romanov Sokolov Vasilyev Volkov Voronin Yakovlev Glebenkov Nevskiy Yanovich")
names:registerLastName("slavic", true, false, "Alekseeva Andreeva Antonova Bogdanova Bogomolova Borisova Chaykovsky Fedorova Filippova Ivanova Konstantinova Kozlova Krupinova Kuznetsova Lagunova Maksimova Markova Matveeva Medvedeva Putinova Mikhailova Naumova Nikolaeva Orlova Pavlova Petrova Popova Romanova Sokolova Vasilyeva Volkova Voronina Yakovleva Yanovich")
names:registerFirstName("germanic", false, "John Adam Aaron Ace Edgar Adolf Adolph David Al Matthew Tayley Jack James Eric Sam Charles Nick Jonathan Tito Todd Ainsley Andrew Ashton Baldric Baxter Bennett Bevis Billy Brad Brent Bud Carl Cedric Chris Cleve Curtis Dallas Derrick Dwayne Elton Emmett Faron Florence Franklin Gordon Garrett Gaz Gaylord Graham Gus Guy Hudson Hugh Ingram Irwin Ivor Jason Jesse Joel Joey Justin Kaysen Keegan Kendall Kevin Lance Lenny Lester Lewis Logan Louis Lucas Luke Nick Nigel Nolan Oliver Orson Osborne Patton Pearce Petter Philip Porter Raymond Reagan Reynold Ridley Robert Samson Seth Shaun Sid Smith Stuart Tayler Terry Tim Trevor Tyler Victor Vincent Walker Warrick Webster Wilburn Will Wystan Xavier Zack Zander Cody Van")
names:registerFirstName("germanic", true, "Adelia Adriana Amanda Anabelle Anastasia Angelina Anna Beatrix Brianne Camellia Chelsea Corinna Denice Diane Dominica Eleanore Erica Evelina Elizabeth Esther Felicia Freda Gabrielle Garnet Gina Glenda Harley Hayden Hilda Isidora Iris Irene Jade Jane Jean Jeanette Jessica Jordana Jodie Justine Kaleigh Kassandra Katelyn Kylee Lacy Laura Lenore Liana Lisa Madeleine Megan Maria Miranda Monica Natalie Nicole Nora Olivia Paige Patricia Pauline Philippa Rachael Reanna Rebecca Regina Rhonda Rosa Rose Samantha Sarah Scarlett Sharon Sherley Silvia Stacy Susan Taylor Teresa Theodora Tiffany Tracy Valerie Victoria Vivian Wenda Zoe Harriet Jennifer Jill Margaret Sadie")
names:registerLastName("germanic", false, true, "Abbott Atkins Adkins Akers Alden Barrett Beckett Bain Baker Bates Bishop Bowman Brooke Carpenter Cockburn Cooper Corey Davidson Dennell Dickman Duke Elder Elwin Evanson Everett Fisher Fairburn Fields Forester Freeman Gage Gabriels Gardner Garret Gibson Gilbert Gladwin Grant Groves Hancock Hallman Harris Henry Holmes Ilbert Ingham Jacobs Jarvis Keighley Kevinson Lane Layton Lukeson Masterson Marston Nathanson Newton Norman Norton Otis Parker Paulson Presley Quincy Radcliff Randall Rhodes Rimmer Rogers Rodney Sanderson Scott Shelton Sherman Simms Sudworth Steward Thatcher Howard Tuff Tyler Turner Trent Waterman Watkins Wesley Wilcox Woodcock Wyatt Davis Cigar Trump Carmack Drumpf Darkholme Herrington")
names:registerFirstName("finnish", false, "Pekka Jukka Tapio Otto Ville Pete Jaakko Johannes Kalevi Kalle Sami Sampo Riku Risto Roope Kyösti Teemu Tuomas Pasi Paavo Jari Jyri Timo Tero Jussi Late Pate Ossi Osmo Ilpo Marko Pete Panu Rape Markus Santeri Kari Jarmo Pentti Oskari Antti Olavi Manu Matias Emil Esko Juha Jere Kimmo Kärtsy")
names:registerFirstName("finnish", true, "Jaana Emmi Julia Janita Jenni Hanna Kaisa Vilma Mimmi Nea Senni Katri Anni Pinja Jutta Henna Iida Amalia Helmi Iiris Jonna Jasmiina Kiira Alma Riitta Liisa Janette Siiri Anu Sanna Sanni")
names:registerLastName("finnish", false, true, "Pekkanen Korhonen Mäkinen Nieminen Mäkelä Laine Heikkinen Niemi Ahonen Rantanen Virtanen Lehtinen Järvinen Järvi Liettänen Koskinen Korpi Lieto Kaarlonen Saaresto Kuivisto Hietanen Timpuri Partanen Kenkänen Letku Letkinen Ojala Koskela Saarela Pekkala Lapanen Niemelä Rantala Salmi Salminen Rajala Rapala Kajasto Hatakka")
