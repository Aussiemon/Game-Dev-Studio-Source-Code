activities:registerNew({
	notOnTheHouseEnjoymentScale = 0.8,
	reducedEnjoymentTime = 14,
	enjoymentToTeamworkExperience = 15,
	minimumPeopleAmount = 8,
	maxReducedEnjoyment = 0.5,
	icon = "activity_paintball",
	baseEnjoymentRating = 50,
	skillToProgress = "teamwork",
	notEnoughPeopleEnjoymentReduction = 0.05,
	id = "paintball",
	costPerEmployee = 40,
	display = _T("ACTIVITY_PAINTBALL", "Paintball"),
	displayPopup = _T("ACTIVITY_PAINTBALL_POPUP_TITLE", "Paintball"),
	activityDisplay = _T("ACTIVITY_PAINTBALL_ACTION", "play paintball"),
	autoOrganizedAction = _T("ACTIVITY_PAINTBALL_AUTO_ORGANIZED", "play paintball"),
	mentionHint = _T("ACTIVITY_PAINTBALL_MENTION", "I'm fairly sure that folks would enjoy paintball, especially people that love to get physical or like mil-sim type of stuff in general, so someone like NAME would have a great time."),
	description = {
		{
			font = "pix18",
			text = _T("ACTIVITY_PAINTBALL_DESCRIPTION_1", "Paintball is a great way to team-build. It's fun, it's intense, and most importantly, it heavily relies on teamwork.")
		}
	},
	randomEnjoymentOffset = {
		0.95,
		1.1
	},
	contributingInterests = {
		firearms = 2,
		lifting = 1.5,
		milsim = 2,
		pacifism = 0.25,
		parkour = 1.4
	},
	knowledgeIncrease = {
		{
			id = "firearms",
			min = 2,
			max = 3
		},
		{
			id = "stealth",
			min = 10,
			max = 12
		}
	},
	chanceToTurnDown = {
		firearms = {
			mul = 0.5
		},
		lifting = {
			mul = 0.75
		},
		milsim = {
			mul = 0.5
		},
		pacifism = {
			add = 100
		}
	},
	postActivityVisit = function(self, employee, enjoymentRating)
		skills:progressSkill(employee, self.skillToProgress, self.enjoymentToTeamworkExperience * enjoymentRating)
	end
})
activities:registerNew({
	notOnTheHouseEnjoymentScale = 0.8,
	reducedEnjoymentTime = 14,
	enjoymentToTeamworkExperience = 15,
	minimumPeopleAmount = 8,
	maxReducedEnjoyment = 0.5,
	icon = "activity_airsoft",
	baseEnjoymentRating = 50,
	skillToProgress = "teamwork",
	notEnoughPeopleEnjoymentReduction = 0.05,
	id = "airsoft",
	costPerEmployee = 50,
	display = _T("ACTIVITY_AIRSOFT", "Airsoft"),
	displayPopup = _T("ACTIVITY_AIRSOFT_POPUP_TITLE", "Airsoft"),
	activityDisplay = _T("ACTIVITY_AIRSOFT_ACTION", "play airsoft"),
	autoOrganizedAction = _T("ACTIVITY_AIRSOFT_AUTO_ORGANIZED", "play airsoft"),
	mentionHint = _T("ACTIVITY_AIRSOFT_MENTION", "I think people would have a lot of fun with airsoft, especially those that like a little work-out or guns in general. In other words, people like NAME would love it."),
	description = {
		{
			font = "pix18",
			text = _T("ACTIVITY_AIRSOFT_DESCRIPTION", "Just like Paintball, except with replicas of real weapons.")
		}
	},
	randomEnjoymentOffset = {
		0.8,
		1.25
	},
	contributingInterests = {
		firearms = 2,
		lifting = 1.5,
		milsim = 2,
		pacifism = 0.25,
		parkour = 1.4
	},
	knowledgeIncrease = {
		{
			id = "firearms",
			min = 10,
			max = 12
		},
		{
			id = "stealth",
			min = 10,
			max = 12
		},
		{
			id = "military_jargon",
			min = 10,
			max = 12
		}
	},
	chanceToTurnDown = {
		firearms = {
			mul = 0.5
		},
		lifting = {
			mul = 0.75
		},
		milsim = {
			mul = 0.5
		},
		pacifism = {
			add = 100
		}
	},
	postActivityVisit = function(self, employee, enjoymentRating)
		skills:progressSkill(employee, self.skillToProgress, self.enjoymentToTeamworkExperience * enjoymentRating)
	end
})
activities:registerNew({
	notOnTheHouseEnjoymentScale = 0.75,
	reducedEnjoymentTime = 7,
	maxReducedEnjoyment = 0.25,
	icon = "activity_shooting_range",
	baseEnjoymentRating = 60,
	mainInterest = "firearms",
	id = "gunrange",
	costPerEmployee = 60,
	display = _T("ACTIVITY_GUN_RANGE", "Gun range"),
	displayPopup = _T("ACTIVITY_GUN_RANGE_POPUP_TITLE", "A visit to the gun range"),
	activityDisplay = _T("ACTIVITY_GUN_RANGE_ACTION", "shoot guns at a gun range"),
	autoOrganizedAction = _T("ACTIVITY_GUN_RANGE_AUTO_ORGANIZED", "the gun range"),
	mentionHint = _T("ACTIVITY_GUN_RANGE_MENTION", "You like shooting guns? Even if you don't I'm sure there are folks in the office that do. And don't get me started with NAME, he'd revere you as a God if you were to organize a trip to the gun range on the house."),
	description = {
		{
			font = "pix18",
			text = _T("ACTIVITY_GUN_RANGE_DESCRIPTION_1", "While it may not be a good choice for team-building, it's still fun to shoot guns.")
		},
		{
			font = "pix16",
			lineSpacing = -4,
			text = _T("ACTIVITY_GUN_RANGE_DESCRIPTION_2", "(unless you're a pacifist)")
		}
	},
	randomEnjoymentOffset = {
		0.9,
		1.4
	},
	contributingInterests = {
		firearms = 2,
		pacifism = 0.2,
		milsim = 2
	},
	knowledgeIncrease = {
		id = "firearms",
		min = 20,
		max = 25
	},
	chanceToTurnDown = {
		firearms = {
			mul = 0.25
		},
		milsim = {
			mul = 0.5
		},
		pacifism = {
			add = 100
		}
	}
})
activities:registerNew({
	notOnTheHouseEnjoymentScale = 0.9,
	reducedEnjoymentTime = 14,
	enjoymentToTeamworkExperience = 15,
	maxReducedEnjoyment = 0.25,
	icon = "activity_gym",
	baseEnjoymentRating = 10,
	skillToProgress = "teamwork",
	id = "gym",
	costPerEmployee = 15,
	display = _T("HIT_THE_GYM", "Hit the Gym"),
	displayPopup = _T("ACTIVITY_HIT_THE_GYM_POPUP_TITLE", "Working out with coworkers"),
	activityDisplay = _T("HIT_THE_GYM_ACTION", "lift some heavy stuff at a gym"),
	autoOrganizedAction = _T("HIT_THE_GYM_AUTO_ORGANIZED", "the gym"),
	mentionHint = _T("HIT_THE_GYM_MENTION", "I'm sure folks like NAME would enjoy a trip to the gym, not so sure it would be fun for a lot of people though. Regardless, with how well everyone gets along here I'm sure people would have a good time, so it's worth a try."),
	description = {
		{
			font = "pix18",
			text = _T("HIT_THE_GYM_DESCRIPTION_1", "Pump that iron! Probably going to get real awkward in there at first, but at least you get to spot your coworkers, which counts as teamwork.")
		},
		{
			font = "pix16",
			lineSpacing = -4,
			text = _T("HIT_THE_GYM_DESCRIPTION_2", "No homo.")
		}
	},
	randomEnjoymentOffset = {
		0.9,
		1.1
	},
	contributingInterests = {
		parkour = 1.5,
		lifting = 2
	},
	postActivityVisit = function(self, employee, enjoymentRating)
		skills:progressSkill(employee, self.skillToProgress, self.enjoymentToTeamworkExperience * enjoymentRating)
	end
})
activities:registerNew({
	notOnTheHouseEnjoymentScale = 0.9,
	reducedEnjoymentTime = 14,
	baseEnjoymentRating = 8,
	maxReducedEnjoyment = 0.25,
	id = "bowling",
	icon = "activity_bowling",
	costPerEmployee = 10,
	display = _T("ACTIVITY_GO_BOWLING", "Bowling"),
	displayPopup = _T("ACTIVITY_GO_BOWLING_POPUP_TITLE", "Bowling"),
	activityDisplay = _T("ACTIVITY_GO_BOWLING_ACTION", "play bowling"),
	autoOrganizedAction = _T("ACTIVITY_GO_BOWLING_AUTO_ORGANIZED", "play bowling"),
	mentionHint = _T("ACTIVITY_GO_BOWLING_MENTION", "While bowling isn't exactly exhilarating, I'm sure calm folks like NAME would enjoy it. It ain't expensive either, so organizing it on-the-house won't go wrong."),
	description = {
		{
			font = "pix18",
			text = _T("ACTIVITY_GO_BOWLING_DESCRIPTION", "More of a competition rather than a team-building activity, can be fun regardless.")
		}
	},
	randomEnjoymentOffset = {
		0.9,
		1.1
	},
	contributingInterests = {
		pacifism = 1.25
	}
})
activities:registerNew({
	reducedEnjoymentTime = 7,
	baseEnjoymentRating = 100,
	maxReducedEnjoyment = 0.25,
	id = "skydiving",
	icon = "activity_skydiving",
	notOnTheHouseEnjoymentScale = 0.5,
	costPerEmployee = 120,
	display = _T("ACTIVITY_SKYDIVING", "Skydiving"),
	displayPopup = _T("ACTIVITY_SKYDIVING_POPUP_TITLE", "Skydiving"),
	activityDisplay = _T("ACTIVITY_SKYDIVING_ACTION", "try out skydiving"),
	autoOrganizedAction = _T("ACTIVITY_SKYDIVING_AUTO_ORGANIZED", "try out skydiving"),
	description = {
		{
			font = "pix18",
			text = _T("ACTIVITY_SKYDIVING_DESCRIPTION", "Get the ultimate adrenaline rush! Not many things can get more exciting than this.")
		}
	},
	randomEnjoymentOffset = {
		0.8,
		1.3
	}
})
activities:registerNew({
	icon = "activity_kart_racing",
	reducedEnjoymentTime = 14,
	baseEnjoymentRating = 35,
	maxReducedEnjoyment = 0.25,
	id = "kartracing",
	notOnTheHouseEnjoymentScale = 0.8,
	costPerEmployee = 25,
	display = _T("ACTIVITY_KART_RACING", "Kart racing"),
	displayPopup = _T("ACTIVITY_KART_RACING_POPUP_TITLE", "Kart racing"),
	activityDisplay = _T("ACTIVITY_KART_RACING_ACTION", "race each other in go-karts"),
	autoOrganizedAction = _T("ACTIVITY_KART_RACING_AUTO_ORGANIZED", "kart racing"),
	description = {
		{
			font = "pix18",
			text = _T("ACTIVITY_KART_RACING_DESCRIPTION", "Compete against your coworkers to see who's the best behind the wheel. Won't find much team-building here, but it's very fun.")
		}
	},
	knowledgeIncrease = {
		id = "vehicles",
		min = 20,
		max = 25
	},
	randomEnjoymentOffset = {
		0.9,
		1.1
	}
})
activities:registerNew({
	notOnTheHouseEnjoymentScale = 0.85,
	reducedEnjoymentTime = 7,
	baseEnjoymentRating = 10,
	maxReducedEnjoyment = 0.25,
	id = "rockclimbing",
	icon = "activity_rock_climbing",
	costPerEmployee = 12,
	display = _T("ACTIVITY_ROCK_CLIMBING", "Rock climbing"),
	displayPopup = _T("ACTIVITY_ROCK_CLIMBING_POPUP_TITLE", "Rock climbing"),
	activityDisplay = _T("ACTIVITY_ROCK_CLIMBING_ACTION", "do some rock climbing"),
	autoOrganizedAction = _T("ACTIVITY_ROCK_CLIMBING_AUTO_ORGANIZED", "a rock climbing club"),
	mentionHint = _T("ACTIVITY_ROCK_CLIMBING_MENTION", "If you were to organize a trip to a local rock climbing club I'm sure in-shape folks like NAME would appreciate it. And even those that aren't as physically active would have a good time, too."),
	description = {
		{
			font = "pix18",
			text = _T("ACTIVITY_ROCK_CLIMBING_DESCRIPTION", "Hope you're not afraid of heights! A good physical shape is a necessity for this.")
		}
	},
	randomEnjoymentOffset = {
		0.9,
		1.1
	},
	knowledgeIncrease = {
		id = "parkour",
		min = 20,
		max = 25
	},
	contributingInterests = {
		parkour = 1.5,
		lifting = 1.5
	}
})
interests:addMutualExclusion("firearms", "pacifism")
activities:registerNew({
	notOnTheHouseEnjoymentScale = 0.8,
	reducedEnjoymentTime = 14,
	enjoymentToTeamworkExperience = 20,
	minimumPeopleAmount = 4,
	maxReducedEnjoyment = 0.5,
	icon = "activity_camping",
	baseEnjoymentRating = 28,
	skillToProgress = "teamwork",
	notEnoughPeopleEnjoymentReduction = 0.05,
	id = "camping",
	costPerEmployee = 20,
	display = _T("ACTIVITY_CAMPING", "Camping"),
	displayPopup = _T("ACTIVITY_CAMPING_POPUP_TITLE", "Camping out"),
	activityDisplay = _T("ACTIVITY_CAMPING_ACTION", "go camping"),
	autoOrganizedAction = _T("ACTIVITY_CAMPING_AUTO_ORGANIZED", "camp out in the wilderness"),
	mentionHint = _T("ACTIVITY_CAMPING_MENTION", "Camping could be good, and it's a scientifically proven fact that meat cooked over a campfire is a lot tastier than on a stove! I'm sure folks that are into camping and hunting, like NAME, would be grateful for a trip like that."),
	description = {
		{
			font = "pix18",
			text = _T("ACTIVITY_CAMPING_DESCRIPTION_1", "Can you separate edible berries from poisonous ones? What about mushrooms? Great way to test your skills in that regard by going on a camping trip!")
		},
		{
			font = "pix16",
			text = _T("ACTIVITY_CAMPING_DESCRIPTION_2", "(just don't eat those if you're unsure)")
		}
	},
	randomEnjoymentOffset = {
		0.7,
		1.4
	},
	contributingInterests = {
		hunting = 1.5
	},
	knowledgeIncrease = {
		{
			id = "primitive_technology",
			min = 20,
			max = 25
		},
		{
			id = "survival",
			min = 20,
			max = 25
		}
	},
	chanceToTurnDown = {
		hunting = {
			mul = 0.5
		}
	},
	postActivityVisit = function(self, employee, enjoymentRating)
		skills:progressSkill(employee, self.skillToProgress, self.enjoymentToTeamworkExperience * enjoymentRating)
	end
})
activities:registerNew({
	notOnTheHouseEnjoymentScale = 0.8,
	reducedEnjoymentTime = 7,
	enjoymentToTeamworkExperience = 20,
	minimumPeopleAmount = 2,
	maxReducedEnjoyment = 0.5,
	icon = "interest_martial_arts",
	baseEnjoymentRating = 8,
	skillToProgress = "teamwork",
	notEnoughPeopleEnjoymentReduction = 0.05,
	id = "martial_arts",
	costPerEmployee = 10,
	display = _T("ACTIVITY_MARTIAL_ARTS", "Visit a dojo"),
	displayPopup = _T("ACTIVITY_MARTIAL_ARTS_POPUP_TITLE", "Practicing martial arts with coworkers"),
	activityDisplay = _T("ACTIVITY_MARTIAL_ARTS_ACTION", "visit a martial arts dojo"),
	autoOrganizedAction = _T("ACTIVITY_MARTIAL_ARTS_AUTO_ORGANIZED", "a martial arts dojo"),
	mentionHint = _T("ACTIVITY_MARTIAL_ARTS_MENTION", "I think practicing martial arts together with team members would be good, and if the guys learn a thing or two they could use the newfound knowledge for a fighting game. Not to mention, NAME would love an activity like this."),
	description = {
		{
			font = "pix18",
			text = _T("ACTIVITY_MARTIAL_ARTS_DESCRIPTION", "It's all about humility and respect towards your opponent in martial arts.")
		}
	},
	randomEnjoymentOffset = {
		0.7,
		1.5
	},
	contributingInterests = {
		parkour = 1.4,
		lifting = 1.5,
		martialarts = 2,
		pacifism = 0.2
	},
	knowledgeIncrease = {
		id = "fighting",
		min = 20,
		max = 25
	},
	chanceToTurnDown = {
		lifting = {
			mul = 0.5
		},
		martialarts = {
			mul = 0.25
		},
		parkour = {
			mul = 0.6
		},
		pacifism = {
			add = 80
		}
	},
	postActivityVisit = function(self, employee, enjoymentRating)
		skills:progressSkill(employee, self.skillToProgress, self.enjoymentToTeamworkExperience * enjoymentRating)
	end
})
activities:registerNew({
	notOnTheHouseEnjoymentScale = 0.8,
	reducedEnjoymentTime = 14,
	enjoymentToTeamworkExperience = 20,
	minimumPeopleAmount = 4,
	maxReducedEnjoyment = 0.5,
	icon = "activity_medieval_fight",
	baseEnjoymentRating = 40,
	skillToProgress = "teamwork",
	notEnoughPeopleEnjoymentReduction = 0.05,
	id = "medieval_fighting",
	costPerEmployee = 35,
	display = _T("ACTIVITY_MEDIEVAL_FIGHTING", "Medieval fighting"),
	displayPopup = _T("ACTIVITY_MEDIEVAL_FIGHTING_POPUP_TITLE", "Participating in a medieval fight with coworkers"),
	activityDisplay = _T("ACTIVITY_MEDIEVAL_FIGHTING_ACTION", "play out a medieval fight"),
	autoOrganizedAction = _T("ACTIVITY_MEDIEVAL_FIGHTING_AUTO_ORGANIZED", "play out a medieval fight"),
	mentionHint = _T("ACTIVITY_MEDIEVAL_FIGHTING_MENTION", "Do you take interest in the medieval fights? Donning chainmail armor, grabbing a sword and engaging in a make-believe medieval fight would be fun, I'm sure. I know NAME is interested in medieval times and participates in events like this, so he would definitely enjoy it."),
	description = {
		{
			font = "pix18",
			text = _T("ACTIVITY_MEDIEVAL_FIGHTING_DESCRIPTION", "Put on some heavy plate or brigandine armor, get yourself a sword and step into the fray as a footman of the medieval times.")
		}
	},
	randomEnjoymentOffset = {
		0.7,
		1.5
	},
	contributingInterests = {
		pacifism = 0.2,
		lifting = 1.5,
		martialarts = 1.5,
		medieval_fighting = 2,
		parkour = 1.25
	},
	knowledgeIncrease = {
		id = "medieval_fighting",
		min = 20,
		max = 25
	},
	chanceToTurnDown = {
		lifting = {
			mul = 0.5
		},
		martialarts = {
			mul = 0.5
		},
		medieval_fighting = {
			mul = 0.25
		},
		parkour = {
			mul = 0.6
		},
		pacifism = {
			add = 80
		}
	},
	postActivityVisit = function(self, employee, enjoymentRating)
		skills:progressSkill(employee, self.skillToProgress, self.enjoymentToTeamworkExperience * enjoymentRating)
	end
})
activities:registerNew({
	notOnTheHouseEnjoymentScale = 0.8,
	reducedEnjoymentTime = 14,
	minimumPeopleAmount = 2,
	maxReducedEnjoyment = 0.5,
	icon = "interest_photography",
	baseEnjoymentRating = 10,
	notEnoughPeopleEnjoymentReduction = 0.05,
	id = "photography_course",
	costPerEmployee = 100,
	display = _T("ACTIVITY_PHOTOGRAPHY_COURSE", "Photography course"),
	displayPopup = _T("ACTIVITY_PHOTOGRAPHY_COURSE_POPUP_TITLE", "Photography Course"),
	activityDisplay = _T("ACTIVITY_PHOTOGRAPHY_COURSE_ACTION", "sign up for a photography course"),
	autoOrganizedAction = _T("ACTIVITY_PHOTOGRAPHY_COURSE_AUTO_ORGANIZED", "attend a photography course"),
	mentionHint = _T("ACTIVITY_PHOTOGRAPHY_COURSE_MENTION", "If you feel like learning a trick or two about photography then sign up for a photography course! NAME takes an interest in photography, so it would be right up his alley."),
	description = {
		{
			font = "pix18",
			text = _T("ACTIVITY_PHOTOGRAPHY_COURSE_DESCRIPTION", "Exposure, shutter speed, ISO level... If you can set up all of these right you'll be able to make a great photo. Want to find out how? Sign up for a photography course today!")
		}
	},
	randomEnjoymentOffset = {
		0.7,
		1.4
	},
	contributingInterests = {
		photography = 1.5
	},
	chanceToTurnDown = {
		photography = {
			mul = 0.5
		}
	},
	knowledgeIncrease = {
		id = "photography",
		min = 20,
		max = 25
	}
})
activities:registerNew({
	notOnTheHouseEnjoymentScale = 0.8,
	reducedEnjoymentTime = 14,
	minimumPeopleAmount = 2,
	maxReducedEnjoyment = 0.5,
	icon = "interest_abstract_art",
	baseEnjoymentRating = 10,
	notEnoughPeopleEnjoymentReduction = 0.05,
	id = "art_gallery_visit",
	costPerEmployee = 40,
	display = _T("ACTIVITY_ART_GALLERY_VISIT", "Art gallery visit"),
	displayPopup = _T("ACTIVITY_ART_GALLERY_VISIT_POPUP_TITLE", "Art Gallery Visit"),
	activityDisplay = _T("ACTIVITY_ART_GALLERY_VISIT_ACTION", "visit an art gallery"),
	autoOrganizedAction = _T("ACTIVITY_ART_GALLERY_VISIT_AUTO_ORGANIZED", "visit an art gallery"),
	mentionHint = _T("ACTIVITY_ART_GALLERY_VISIT_MENTION", "I think a visit to the art gallery would be pretty fun. There's all sorts of bizarre paintings there no doubt. Would benefit our artists, they could probably get some ideas when it comes to abstract art. NAME would definitely enjoy a visit like that, since he's into abstract art."),
	description = {
		{
			font = "pix18",
			text = _T("ACTIVITY_ART_GALLERY_DESCRIPTION", "Visit the local art gallery and check out the paintings people have drawn. Abstract art, ahoy!")
		}
	},
	randomEnjoymentOffset = {
		0.7,
		1.4
	},
	contributingInterests = {
		photography = 1.5
	},
	chanceToTurnDown = {
		photography = {
			mul = 0.5
		}
	},
	knowledgeIncrease = {
		id = "stylizing",
		min = 10,
		max = 12
	}
})
activities:registerNew({
	notOnTheHouseEnjoymentScale = 0.8,
	reducedEnjoymentTime = 14,
	minimumPeopleAmount = 2,
	maxReducedEnjoyment = 0.5,
	icon = "role_software_engineer",
	baseEnjoymentRating = 8,
	notEnoughPeopleEnjoymentReduction = 0.05,
	id = "ai_programming_course",
	costPerEmployee = 100,
	display = _T("ACTIVITY_AI_PROGRAMMING_COURSE", "AI programming course"),
	displayPopup = _T("ACTIVITY_AI_PROGRAMMING_COURSE_POPUP_TITLE", "AI Programming Course"),
	activityDisplay = _T("ACTIVITY_AI_PROGRAMMING_COURSE_ACTION", "sign up for an AI programming course"),
	autoOrganizedAction = _T("ACTIVITY_AI_PROGRAMMING_COURSE_AUTO_ORGANIZED", "to an AI programming course"),
	mentionHint = _T("ACTIVITY_AI_PROGRAMMING_COURSE_MENTION", "If you're into software and programming in general, I think signing up for an AI programming course would be beneficial. NAME would absolutely benefit from that for sure, since I've heard he's into machine learning and writes up all sorts of fancy AI in his spare time."),
	description = {
		{
			font = "pix18",
			text = _T("ACTIVITY_AI_PROGRAMMING_COURSE_DESCRIPTION", "State machines, machine learning, pattern recognition, all this and more will be explained here!")
		}
	},
	randomEnjoymentOffset = {
		0.7,
		1.4
	},
	contributingInterests = {
		machine_learning = 1.5
	},
	chanceToTurnDown = {
		machine_learning = {
			mul = 0.5
		}
	},
	knowledgeIncrease = {
		id = "machine_learning",
		min = 20,
		max = 25
	}
})
activities:registerNew({
	notOnTheHouseEnjoymentScale = 0.8,
	reducedEnjoymentTime = 14,
	minimumPeopleAmount = 2,
	maxReducedEnjoyment = 0.5,
	icon = "interest_parkour",
	baseEnjoymentRating = 15,
	notEnoughPeopleEnjoymentReduction = 0.05,
	id = "parkour_school_visit",
	costPerEmployee = 30,
	display = _T("ACTIVITY_PARKOUR_SCHOOL_VISIT", "Parkour school visit"),
	displayPopup = _T("ACTIVITY_PARKOUR_SCHOOL_VISIT_POPUP_TITLE", "Parkour School Visit"),
	activityDisplay = _T("ACTIVITY_PARKOUR_SCHOOL_VISIT_ACTION", "visit a parkour school"),
	autoOrganizedAction = _T("ACTIVITY_PARKOUR_SCHOOL_VISIT_AUTO_ORGANIZED", "visit a parkour school"),
	mentionHint = _T("ACTIVITY_PARKOUR_SCHOOL_VISIT_MENTION", "How do you feel about learning how to use your momentum to reach places you thought were unreachable? A visit to a parkour school would be fun, and NAME would be absolutely delighted to hear you're organizing something like that."),
	description = {
		{
			font = "pix18",
			text = _T("ACTIVITY_PARKOUR_SCHOOL_VISIT_DESCRIPTION", "Learn how to use your own momentum to your advantage, and to reach places you once thought were impossible to get to!")
		}
	},
	randomEnjoymentOffset = {
		0.7,
		1.4
	},
	contributingInterests = {
		lifting = 1.5,
		parkour = 2,
		martialarts = 1.5
	},
	chanceToTurnDown = {
		parkour = {
			mul = 0.25
		},
		lifting = {
			mul = 0.5
		},
		martialarts = {
			mul = 0.5
		}
	},
	knowledgeIncrease = {
		id = "parkour",
		min = 20,
		max = 25
	}
})
