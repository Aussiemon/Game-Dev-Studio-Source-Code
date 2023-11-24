knowledge:registerNew({
	id = "firearms",
	icon = "interest_firearms",
	display = _T("FIREARMS", "Firearms"),
	description = _T("FIREARMS_KNOWLEDGE_DESCRIPTION", "Knowing how firearms work is crucial for any military simulation game. It is not as important for games that aren't simulators, but attention to detail is still welcome.")
})
knowledge:registerNew({
	id = "fighting",
	icon = "interest_martial_arts",
	display = _T("MARTIAL_ARTS", "Martial arts"),
	description = _T("MARTIAL_ARTS_DESCRIPTION_KNOWLEDGE", "Muay Thai, Jiu-jitsu, boxing - knowledge of any martial art will help your Fighting games. While not necessary for over-the-top fighting games, it can still contribute to the project.")
})
knowledge:registerNew({
	id = "parkour",
	icon = "interest_parkour",
	display = _T("PARKOUR", "Parkour"),
	description = _T("PARKOUR_KNOWLEDGE_DESCRIPTION", "Any action or adventure game that focuses on movement should have research done on this topic. May prove somewhat useful for games that have some parkour or free-running elements.")
})
knowledge:registerNew({
	id = "stealth",
	icon = "interest_stealth",
	display = _T("STEALTH", "Stealth"),
	description = _T("STEALTH_KNOWLEDGE_DESCRIPTION", "Just lowering your stance is not enough to be stealthy. Having knowledge on this topic is a necessity for any stealth game.")
})
knowledge:registerNew({
	id = "photography",
	icon = "interest_photography",
	display = _T("PHOTOGRAPHY", "Photography"),
	description = _T("PHOTOGRAPHY_KNOWLEDGE_DESCRIPTION", "Photography is useful for photorealism, general world design and games of the sandbox genre that have procedural world generation.")
})

local publicSpeaking = {
	id = "public_speaking",
	icon = "interest_public_speaking",
	display = _T("PUBLIC_SPEAKING", "Public speaking"),
	description = _T("PUBLIC_SPEAKING_KNOWLEDGE_DESCRIPTION", "Knowledge of public speaking can improve the ability to perform damage control, increase the efficiency in game expos and increase the benefits of motivational speeches.")
}

function publicSpeaking:setupDescbox(descBox, employee, wrapWidth)
	publicSpeaking.baseClass.setupDescbox(self, descBox, employee, wrapWidth)
	
	if employee:isPlayerCharacter() then
		descBox:addSpaceToNextText(6)
		descBox:addText(_format(_T("INCREASED_MOTIVATIONAL_SPEECH_EFFICIENCY", "INCREASE% more efficient motivational speeches"), "INCREASE", math.round(employee:getKnowledge(self.id) * motivationalSpeeches.PUBLIC_SPEAKING_TO_SCORE, 1)), "bh18", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth, "increase", 22, 22)
		descBox:addText(_T("IMPROVED_INTERACTION_WITH_EMPLOYEES", "Improved interaction with employees in specific contexts"), "bh18", game.UI_COLORS.LIGHT_BLUE, 0, wrapWidth, "exclamation_point", 22, 22)
	end
end

knowledge:registerNew(publicSpeaking)
knowledge:registerNew({
	id = "medieval_fighting",
	icon = "interest_medieval_fighting",
	display = _T("MEDIEVAL_FIGHTING", "Medieval fighting"),
	description = _T("MEDIEVAL_FIGHTING_KNOWLEDGE_DESCRIPTION", "Knowing how people fought in the medieval ages is necessary for any medieval game looking to impress a player.")
})
knowledge:registerNew({
	id = "survival",
	icon = "interest_primitive_technology",
	display = _T("SURVIVAL", "Survival"),
	description = _T("SURVIVAL_KNOWLEDGE_DESCRIPTION", "Who knows when you're going to be forced to live out in the wilderness? Any game of the Wilderness theme will benefit from this.")
})
knowledge:registerNew({
	id = "military_jargon",
	icon = "activity_airsoft",
	display = _T("MILITARY_JARGON", "Military jargon"),
	description = _T("MILITARY_JARGON_KNOWLEDGE_DESCRIPTION", "'Copy that!' What do they mean by this? Nobody knows. Any military simulation type game depends on knowledge of this topic.")
})
knowledge:registerNew({
	id = "machine_learning",
	icon = "interest_machine_learning",
	display = _T("MACHINE_LEARNING", "Machine learning"),
	description = _T("MACHINE_LEARNING_KNOWLEDGE_DESCRIPTION", "Knowledge in machine learning provides a boost in gameplay score for specific tasks.")
})
knowledge:registerNew({
	id = "stylizing",
	icon = "interest_abstract_art",
	display = _T("STYLIZING", "Stylizing"),
	description = _T("STYLIZING_DESCRIPTION", "Knowledge in stylizing contributes to graphics tasks that are heavily stylized")
})
knowledge:registerNew({
	id = "primitive_technology",
	icon = "interest_primitive_technology",
	display = _T("KNOWLEDGE_PRIMITIVE_TECHNOLOGY", "Primitive technology"),
	description = _T("KNOWLEDGE_PRIMITIVE_TECHNOLOGY_DESCRIPTION", "Strategy games set thousands of years ago looking to impress should have research done on this topic.")
})
knowledge:registerNew({
	id = "vehicles",
	icon = "interest_auto_racing",
	display = _T("VEHICLES", "Vehicles"),
	description = _T("VEHICLES_DESCRIPTION", "Knowledge in vehicles helps make better racing games and anything related to vehicles.")
})
