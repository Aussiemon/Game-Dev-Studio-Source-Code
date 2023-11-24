local function canPlaySpool(data)
	return not sound.getSoundData(data.sound)
end

local function registerDevComDialogue(data)
	data.canPlaySpool = canPlaySpool
	
	dialogueHandler.registerQuestion(data)
end

registerDevComDialogue({
	nextQuestion = "dev_commentary_intro_2",
	sound = "dc_intro_1",
	nameID = "roman_glebenkov",
	id = "dev_commentary_intro_1",
	image = "roman_glebenkov",
	uniqueDialogueID = "dev_commentary_intro",
	text = _T("DEV_COMMENTARY_INTRO_1", "Hey there and welcome to the developer commentary of Game Dev Studio! My name is Roman Glebenkov, and I'm the creator of Game Dev Studio."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_intro_3",
	sound = "dc_intro_2",
	id = "dev_commentary_intro_2",
	textDLC = _T("DEV_COMMENTARY_INTRO_2", "Before I start, I'd like to thank you for purchasing the Developer Commentary DLC. The commentary itself is available to everyone, but the narration is available only to those that have purchased the DLC. The reason why I chose to make the narration paid is simple: I don't like segregating gameplay content into DLC packs, and the free updates the game received added all sorts of new gameplay mechanics."),
	textNoDLC = _T("DEV_COMMENTARY_INTRO_2_NO_NARRATION", "The commentary is available to everyone, but the narration can be purchased separately for $1.99. The reason why I chose to make the narration paid is simple: I don't like segregating gameplay content into DLC packs, and the free updates the game received added all sorts of new gameplay mechanics."),
	getText = function(self, dialogueObject)
		if self:canPlaySound() then
			return self.textDLC
		end
		
		return self.textNoDLC
	end,
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_intro_4",
	sound = "dc_intro_3",
	id = "dev_commentary_intro_3",
	text = _T("DEV_COMMENTARY_INTRO_3", "People said that with all the updates the game received it should cost more now, but I don't want to raise the price of the game either. Naturally this meant that I had to go the route of giving some kind of value to people wishing to support me, which led to the creation of this DLC."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_intro_5",
	sound = "dc_intro_4",
	id = "dev_commentary_intro_4",
	text = _T("DEV_COMMENTARY_INTRO_4", "It doesn't provide any new gameplay mechanics, but it might be interesting to you in case you're a developer, or are just a fan of the game and wanted to find out how it was designed and made."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_intro_6",
	sound = "dc_intro_5",
	id = "dev_commentary_intro_5",
	text = _T("DEV_COMMENTARY_INTRO_5", "As you play through the scenario and trigger certain events, dialogue will appear shortly afterwards, going in-depth about how it was developed, the iterations it went through, and other various things you might find interesting."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_intro_7",
	sound = "dc_intro_6",
	id = "dev_commentary_intro_6",
	text = _T("DEV_COMMENTARY_INTRO_6", "Before I go on, I'd like to point out the difficulty setting in the game that you choose when you start a new game."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_intro_8",
	sound = "dc_intro_7",
	id = "dev_commentary_intro_7",
	text = _T("DEV_COMMENTARY_INTRO_7", "In the 1.0 release of the game, it wasn't there. This was mainly because I wanted people playing the game to experience the game and its difficulty as it was meant to be."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_intro_9",
	sound = "dc_intro_8",
	id = "dev_commentary_intro_8",
	text = _T("DEV_COMMENTARY_INTRO_8", "Unbeknownst to me this was a bad idea, even for a simulator type game. There were a lot of complaints regarding the difficulty when the game was just released, so much so that some people even left negative reviews."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_intro_10",
	sound = "dc_intro_9",
	id = "dev_commentary_intro_9",
	text = _T("DEV_COMMENTARY_INTRO_9", "Obviously this meant I had to do something if I didn't want to see an even bigger influx of negative reviews. So I decided to add a difficulty setting to the new game window, since I figured if a person is buying the game, then they should have the option to choose just how challenging the game is going to be."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_intro_11",
	sound = "dc_intro_10",
	id = "dev_commentary_intro_10",
	text = _T("DEV_COMMENTARY_INTRO_10", "This wasn't something that I wanted to do, since I wanted people to play and experience the game as it was meant to be played, but it was something I had to if I wanted to reduce the amount of negative reviews."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_intro_12",
	sound = "dc_intro_11",
	id = "dev_commentary_intro_11",
	text = _T("DEV_COMMENTARY_INTRO_11", "The 'Hard' difficulty is the closest you can get today to the original difficulty of the game. I say 'closest' because it's easier now than it was on launch day."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_intro_13",
	sound = "dc_intro_12",
	id = "dev_commentary_intro_12",
	text = _T("DEV_COMMENTARY_INTRO_12", "It's easier because the sale model and salary models were changed, and engine licensing and loans were added."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_intro_14",
	sound = "dc_intro_13",
	id = "dev_commentary_intro_13",
	text = _T("DEV_COMMENTARY_INTRO_13", "Despite that it still offers the true vision for the games difficulty, so if you haven't tried the game on that particular difficulty - be sure to give it a try."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_intro_15",
	sound = "dc_intro_14",
	id = "dev_commentary_intro_14",
	text = _T("DEV_COMMENTARY_INTRO_14", "With that out the way, let me tell you why I made this game in the first place. I played Game Dev Tycoon, really liked the idea, but thought that it was too superficial in its gameplay mechanics. So I thought to myself 'I'll make a game development game I'd put at least a hundred hours into!'. And that's what I did."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_intro_16",
	sound = "dc_intro_15",
	id = "dev_commentary_intro_15",
	text = _T("DEV_COMMENTARY_INTRO_15", "There is no other reason behind the existence of this game. I just wanted to make a game I'd have fun playing. At the time of making this commentary, seeing the games overall rating at over 80% positive on Steam makes me happy, because I know that I've made something that others have immensely enjoyed as well."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	id = "dev_commentary_intro_16",
	sound = "dc_intro_16",
	text = _T("DEV_COMMENTARY_INTRO_16", "So, that's it for the intro bit of the commentary. Play the game as usual, and you'll get more and more commentary as you interact with all sorts of game systems."),
	answers = {
		"end_conversation_got_it"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_building_2",
	sound = "dc_building_1",
	nameID = "roman_glebenkov",
	id = "dev_commentary_building_1",
	image = "roman_glebenkov",
	uniqueDialogueID = "dev_commentary_building",
	text = _T("DEV_COMMENTARY_BUILDING_1", "Office construction was a central feature of the game. I intentionally made it mandatory for workplaces and other objects to be unobstructed in order to be usable."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_building_3",
	sound = "dc_building_2",
	id = "dev_commentary_building_2",
	text = _T("DEV_COMMENTARY_BUILDING_2", "Unfortunately, some people didn't realize that this was intentional and a gameplay mechanic to force the element of having to think of your office layout and placing everything as efficiently as possible, and left negative reviews because of that. "),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_building_4",
	sound = "dc_building_3",
	id = "dev_commentary_building_3",
	text = _T("DEV_COMMENTARY_BUILDING_3", "Some people outright asked me to remove this part of the gameplay in the Steam discussions. It was disheartening at first, and I thought of ways to make it less strict, but eventually came to the conclusion that I won't sacrifice my vision of the game just because someone was upset that they're unable to construct offices that make zero sense in terms of their layout."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_building_5",
	sound = "dc_building_4",
	id = "dev_commentary_building_4",
	text = _T("DEV_COMMENTARY_BUILDING_4", "I wanted to force players to think of how they're going to lay their offices out. You've got limited space and you need to place everything as efficiently as possible to allow for as many workplaces, while balancing things like restrooms, water sources, kitchens (if that's your thing), and other stuff."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_building_6",
	sound = "dc_building_5",
	id = "dev_commentary_building_5",
	text = _T("DEV_COMMENTARY_BUILDING_5", "The 'Comfort' drive affector wasn't there in the 1.0 release. I believe I added it within 2 months of the games release, since people were upset that there weren't any decorative objects."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_building_7",
	sound = "dc_building_6",
	id = "dev_commentary_building_6",
	text = _T("DEV_COMMENTARY_BUILDING_6", "At the time of release I didn't even think of that. I was so engrossed in the game creation side of things that I simply didn't consider this. In reality it should have been obvious."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_building_8",
	sound = "dc_building_7",
	id = "dev_commentary_building_7",
	text = _T("DEV_COMMENTARY_BUILDING_7", "Shortly after release I released an update that added multiple decorative objects, and the 'Comfort' drive boost. The funny thing is that I realized just how important that was only after I added them."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_building_9",
	sound = "dc_building_8",
	id = "dev_commentary_building_8",
	text = _T("DEV_COMMENTARY_BUILDING_8", "Without these objects offices looked bland and generally unimaginative. You had rows of workplaces with toilets here and there, and maybe a kitchen. That's it."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	id = "dev_commentary_building_9",
	sound = "dc_building_9",
	text = _T("DEV_COMMENTARY_BUILDING_9", "Once I added the decorative objects, and played the game with them, I thought to myself 'damn, how did I not think of this?'. Hindsight is 20/20."),
	answers = {
		"end_conversation_got_it"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_expansion_2",
	sound = "dc_expansion_1",
	nameID = "roman_glebenkov",
	id = "dev_commentary_expansion_1",
	image = "roman_glebenkov",
	uniqueDialogueID = "dev_commentary_expansion",
	text = _T("DEV_COMMENTARY_EXPANSION_1", "When I started work on Game Dev Studio, the original idea was to have one big office that you would be able to extend many times. Essentially turning a small office into a huge one. In practice that didn't work out that well, because the office looked ugly, and the people playtesting the game ended up constructing ugly offices."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_expansion_3",
	sound = "dc_expansion_2",
	id = "dev_commentary_expansion_2",
	text = _T("DEV_COMMENTARY_EXPANSION_2", "Overall it was just square or rectangle shaped, meaning you could create huge rows of workplaces, and a few toilets here and there. It didn't look good at all, and didn't force the player to think as much since the shape was always rectangular."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_expansion_4",
	sound = "dc_expansion_3",
	id = "dev_commentary_expansion_3",
	text = _T("DEV_COMMENTARY_EXPANSION_3", "That's why I decided to have separate office buildings, and it was the right decision. Suddenly, players had to think more of how they were going to lay their offices out, and the offices themselves looked better."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_expansion_5",
	sound = "dc_expansion_4",
	id = "dev_commentary_expansion_4",
	text = _T("DEV_COMMENTARY_EXPANSION_4", "The office expansion was there since pretty much day one. Building floors were added in Update #30. And wow, did that change the progression of the game or what?"),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_expansion_6",
	sound = "dc_expansion_5",
	id = "dev_commentary_expansion_5",
	text = _T("DEV_COMMENTARY_EXPANSION_5", "Prior to adding floors, once you'd run out of space you'd have to purchase a new building. A new office building usually cost a damn good chunk of money. This meant expanding was a lot more difficult and more of a strategic move: expanding with barely any money in your pocket, and no income meant you'd go under."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_expansion_7",
	sound = "dc_expansion_6",
	id = "dev_commentary_expansion_6",
	text = _T("DEV_COMMENTARY_EXPANSION_6", "Floors drastically changed that. A single floor purchase costs a fraction of a new building, so expanding is a lot easier, presents much less risk, and is generally more readily available than office buildings. Not to mention the fact that the amount of employees you could have with floors increased several times over."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_expansion_8",
	sound = "dc_expansion_7",
	id = "dev_commentary_expansion_7",
	text = _T("DEV_COMMENTARY_EXPANSION_7", "This increase in maximum employees you can have meant that I would need to optimize the game even further for them. I love optimizing code, and over the course of all the updates I was always looking for things to optimize. Update #29 brought some nice optimizations of about 30% higher performance in preparation for multiple floors."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_expansion_9",
	sound = "dc_expansion_8",
	id = "dev_commentary_expansion_8",
	text = _T("DEV_COMMENTARY_EXPANSION_8", "For Update #30 I went even further and optimized areas I knew in the back of my mind I could squeeze more performance out of. That brought another 50% increase in performance compared to the previous update, which was exactly what I needed for this new feature."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_expansion_10",
	sound = "dc_expansion_9",
	id = "dev_commentary_expansion_9",
	text = _T("DEV_COMMENTARY_EXPANSION_9", "Don't get me wrong, the game didn't run poorly, but I always think that if a game could be made to run better, then the developer should do that. Not everyone has a top-of-the-line PC, so making sure the game was running well is something I felt obliged to ensure."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_expansion_11",
	sound = "dc_expansion_10",
	id = "dev_commentary_expansion_10",
	text = _T("DEV_COMMENTARY_EXPANSION_10", "In the end it was worth it. A certain fan of the game with a rather weak PC said that the game went from 30 FPS to a rock-solid 60 FPS. That's a fantastic result for a low-spec PC."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_expansion_12",
	sound = "dc_expansion_11",
	id = "dev_commentary_expansion_11",
	text = _T("DEV_COMMENTARY_EXPANSION_11", "The biggest optimizations came from Updates #23, #29, and #30. Updates #29 and #30 specifically brought optimizations necessary for the multiple office floors feature. Overall, depending on the scenario, with absolutely all of the optimizations put together, the game now runs three times better than before when it comes to the CPU."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_expansion_13",
	sound = "dc_expansion_12",
	id = "dev_commentary_expansion_12",
	text = _T("DEV_COMMENTARY_EXPANSION_12", "The feature itself is something that I wanted to add before I even released the game, but I shelved it because I thought that the game had enough office construction related content."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_expansion_14",
	sound = "dc_expansion_13",
	id = "dev_commentary_expansion_13",
	text = _T("DEV_COMMENTARY_EXPANSION_13", "So for Update #30 I decided to add that certain feature. It was worth it, because as far as I know everyone likes it, it makes the game easier, and overall is perfect for people that want to spend less time worrying about placing everything as efficiently as possible, and instead focus on making their offices look better."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	id = "dev_commentary_expansion_14",
	sound = "dc_expansion_14",
	text = _T("DEV_COMMENTARY_EXPANSION_14", "Multiple office floors is a feature that I didn't realize just how much better it made the game before I added it."),
	answers = {
		"end_conversation_got_it"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_activities_2",
	sound = "dc_activities_1",
	nameID = "roman_glebenkov",
	id = "dev_commentary_activities_1",
	image = "roman_glebenkov",
	uniqueDialogueID = "dev_commentary_activities",
	text = _T("DEV_COMMENTARY_ACTIVITIES_1", "The idea for activities was fairly simple - game developers are regular people with needs and interests like any other person. Therefore there should be team-building activities that would boost employee Drive levels."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_activities_3",
	sound = "dc_activities_2",
	id = "dev_commentary_activities_2",
	text = _T("DEV_COMMENTARY_ACTIVITIES_2", "I got the idea of adding this to the game after I went to play paintball with my past coworkers back in 2015 or 2016, when I was still working professionally as a game developer."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_activities_4",
	sound = "dc_activities_3",
	id = "dev_commentary_activities_3",
	text = _T("DEV_COMMENTARY_ACTIVITIES_3", "This feature also directly tied in to the Knowledge that employees had. Playing a lot of airsoft makes you acquainted with guns, practicing martial arts gets you acquainted with fighting, and so on. Not tying these two systems would have been a waste."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_activities_5",
	sound = "dc_activities_4",
	id = "dev_commentary_activities_4",
	text = _T("DEV_COMMENTARY_ACTIVITIES_4", "At launch day, activities had far too little incentive to be used. They gave relatively little Drive to bother with it, and the amount of Knowledge they provided ended up in having to spam them all the time to get anywhere."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_activities_6",
	sound = "dc_activities_5",
	id = "dev_commentary_activities_5",
	text = _T("DEV_COMMENTARY_ACTIVITIES_5", "The idea for that was: you don't go from not knowing anything about something to becoming an expert on it in just 6 months. It takes way more time for that to happen."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_activities_7",
	sound = "dc_activities_6",
	id = "dev_commentary_activities_6",
	text = _T("DEV_COMMENTARY_ACTIVITIES_6", "Unfortunately this was me applying real-life logic to something that didn't need it."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_activities_8",
	sound = "dc_activities_7",
	id = "dev_commentary_activities_7",
	text = _T("DEV_COMMENTARY_ACTIVITIES_7", "As a result, Update #22 increased the amount of Drive gained 4 times, meaning it made much more sense to organize team-building activities."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_activities_9",
	sound = "dc_activities_8",
	id = "dev_commentary_activities_8",
	text = _T("DEV_COMMENTARY_ACTIVITIES_8", "Update #30 drastically increased the amount of Knowledge gained too. This meant that you could get all that knowledge much easier and faster than before, but there was an obvious downside to it too: the game became easier, because Knowledge was much easier to attain."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_activities_10",
	sound = "dc_activities_9",
	id = "dev_commentary_activities_9",
	text = _T("DEV_COMMENTARY_ACTIVITIES_9", "Balancing so many things is not that easy. I didn't want the game to be the 'Dark Souls of game development sims' as some people have called it, yet at the same time I didn't want it to be too easy either."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	id = "dev_commentary_activities_10",
	sound = "dc_activities_10",
	text = _T("DEV_COMMENTARY_ACTIVITIES_10", "At some point I just said 'fuck it', and decided to make the game more fun for new players even if it meant the game were to become easier overall. In the end it was worth it. The amount of masochistic, hardcore players is far fewer than the amount of semi-casual players looking to have some fun, rather than to spend hours trying to figure out how every little feature works."),
	answers = {
		"end_conversation_got_it"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_employees_2",
	sound = "dc_employees_1",
	nameID = "roman_glebenkov",
	id = "dev_commentary_employees_1",
	image = "roman_glebenkov",
	uniqueDialogueID = "dev_commentary_employees",
	text = _T("DEV_COMMENTARY_EMPLOYEES_1", "When I started work on Game Dev Studio, I was making it with the core idea that the games focus will be on employees, meaning that I would make employees very important to the process of creating games."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_employees_3",
	sound = "dc_employees_2",
	id = "dev_commentary_employees_2",
	text = _T("DEV_COMMENTARY_EMPLOYEES_2", "Since games are made by regular people, I wanted players to value them more than in other games. That's why the dialogue system was made, why they would get ill sometimes, leave to work elsewhere and so on."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_employees_4",
	sound = "dc_employees_3",
	id = "dev_commentary_employees_3",
	text = _T("DEV_COMMENTARY_EMPLOYEES_3", "I didn't want employees to feel like pixels that you don't put much value into besides the fact that they're working on games."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_employees_5",
	sound = "dc_employees_4",
	id = "dev_commentary_employees_4",
	text = _T("DEV_COMMENTARY_EMPLOYEES_4", "Naturally this meant that I'd need to give them more than just skills. So I went with several things: skills, attributes, knowledge, traits, and later specializations."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_employees_6",
	sound = "dc_employees_5",
	id = "dev_commentary_employees_5",
	text = _T("DEV_COMMENTARY_EMPLOYEES_5", "There were also a couple of things I was thinking of adding, but decided not to since I thought that if I had too many employee stats, then the game would be micro-management hell."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_employees_7",
	sound = "dc_employees_6",
	id = "dev_commentary_employees_6",
	text = _T("DEV_COMMENTARY_EMPLOYEES_6", "One of the things that didn't make it in the game is experience with design on a per-genre and per-theme basis. There were a couple of other things, but I can't recall what they were at the moment."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_employees_8",
	sound = "dc_employees_7",
	id = "dev_commentary_employees_7",
	text = _T("DEV_COMMENTARY_EMPLOYEES_7", "Right now you've got 4 things to consider per every employee and it's sometimes a pain in the ass to consider all of that. Having more would have only made that worse, so I decided to stop with what there is now."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_employees_9",
	sound = "dc_employees_8",
	id = "dev_commentary_employees_8",
	text = _T("DEV_COMMENTARY_EMPLOYEES_8", "Employee roles were made with the idea that most people that play some kind of role within a company should not have more than 1 primary skill. There are very few people out there in real life that are professional programmers, sound designers, graphical engineers, etc., in just one person."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_employees_10",
	sound = "dc_employees_9",
	id = "dev_commentary_employees_9",
	text = _T("DEV_COMMENTARY_EMPLOYEES_9", "Most people stick to one skill and work on it. Most people can't be as good as someone who is dedicated to their craft if they're trying their hand at absolutely everything."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_employees_11",
	sound = "dc_employees_10",
	id = "dev_commentary_employees_10",
	text = _T("DEV_COMMENTARY_EMPLOYEES_10", "So you've got managers, software engineers, sound engineers, and so on. Game developers aren't miracle workers and each specializes in something because it's what they're best at."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_employees_12",
	sound = "dc_employees_11",
	id = "dev_commentary_employees_11",
	text = _T("DEV_COMMENTARY_EMPLOYEES_11", "Skills are pretty straight-forward: employees progress their main skill very quickly when working on games and practicing."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_employees_13",
	sound = "dc_employees_12",
	id = "dev_commentary_employees_12",
	text = _T("DEV_COMMENTARY_EMPLOYEES_12", "I intentionally made non-primary skills progress very slowly for non-CEO roles so that players couldn't just have employees that are experts at everything. That doesn't make any sense."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_employees_14",
	sound = "dc_employees_13",
	id = "dev_commentary_employees_13",
	text = _T("DEV_COMMENTARY_EMPLOYEES_13", "Aside from not making any sense, having it that way would also have made the game far too easy. You could have employees that are good at everything, where's the challenge in that?"),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_employees_15",
	sound = "dc_employees_14",
	id = "dev_commentary_employees_14",
	text = _T("DEV_COMMENTARY_EMPLOYEES_14", "The employee age plays directly into that - once they get old they retire, and you need to find a replacement for them. Losing employees in early stages of the game is rather stressful, but becomes trivial once you have a lot of money, since you can afford practically anyone."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_employees_16",
	sound = "dc_employees_15",
	id = "dev_commentary_employees_15",
	text = _T("DEV_COMMENTARY_EMPLOYEES_15", "Attributes were also made with the idea that you can't have every attribute maxed out. Every employee gets the exact same amount of attribute points, and it's up to you to allocate them."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_employees_17",
	sound = "dc_employees_16",
	id = "dev_commentary_employees_16",
	text = _T("DEV_COMMENTARY_EMPLOYEES_16", "Each attribute also corresponds best with the skills their role relates to, so mindlessly spending attribute points is a waste. I wanted players to think about where to spend the points."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_employees_18",
	sound = "dc_employees_17",
	id = "dev_commentary_employees_17",
	text = _T("DEV_COMMENTARY_EMPLOYEES_17", "Knowledge was the same thing as skills and attributes. Game devs are regular people with interests, so naturally they're doing something in their free time and getting acquainted with that hobby."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_employees_19",
	sound = "dc_employees_18",
	id = "dev_commentary_employees_18",
	text = _T("DEV_COMMENTARY_EMPLOYEES_18", "Take myself for example - I've worked professionally as a game dev for almost 3 years, and despite being a programmer I take interest in powerlifting, kickboxing, and airsoft."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_employees_20",
	sound = "dc_employees_19",
	id = "dev_commentary_employees_19",
	text = _T("DEV_COMMENTARY_EMPLOYEES_19", "So in my free time I partake in these hobbies. I lift heavy, I go to a kickboxing school, and occassionally play airsoft. I wanted to carry the same idea across; that game devs are regular people and not robots, since I noticed that a lot of people don't understand that games are made by people, and not inanimate objects that do nothing but work on games."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_employees_21",
	sound = "dc_employees_20",
	id = "dev_commentary_employees_20",
	text = _T("DEV_COMMENTARY_EMPLOYEES_20", "I remember people being upset that you can't have employees with every type of knowledge completely maxed out. That's just how life is. You can't be an expert in absolutely every single field."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_employees_22",
	sound = "dc_employees_21",
	id = "dev_commentary_employees_21",
	text = _T("DEV_COMMENTARY_EMPLOYEES_21", "Activities are there to increase knowledge levels, but in real life if you try something you're not particularly interested in, and afterwards don't stick to it, you're not going to be very knowledgeable in it. The same idea was applied to knowledge and activities here."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_employees_23",
	sound = "dc_employees_22",
	id = "dev_commentary_employees_22",
	text = _T("DEV_COMMENTARY_EMPLOYEES_22", "Traits is another thing that were given to employees to make them feel more 'alive'. Since every single person is different and isn't perfect, I wanted traits to be trade-offs, or side-grades rather than direct upgrades."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_employees_24",
	sound = "dc_employees_23",
	id = "dev_commentary_employees_23",
	text = _T("DEV_COMMENTARY_EMPLOYEES_23", "There are a couple of direct upgrade traits, but those are mostly limited to the employees, meaning you can't pick most of them for your player character."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_employees_25",
	sound = "dc_employees_24",
	id = "dev_commentary_employees_24",
	text = _T("DEV_COMMENTARY_EMPLOYEES_24", "For creating your own player character I wanted to limit players to traits that are mostly trade-offs, since they learn everything several times faster than other employees anyway."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_employees_26",
	sound = "dc_employees_25",
	id = "dev_commentary_employees_25",
	text = _T("DEV_COMMENTARY_EMPLOYEES_25", "Regular employees also have direct downgrade perks, those being: lazy, unmotivated, and slacker. They just make them work slower."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	id = "dev_commentary_employees_26",
	sound = "dc_employees_26",
	text = _T("DEV_COMMENTARY_EMPLOYEES_26", "This was done to make players want to replace employees with traits that aren't those, which meant putting some effort into finding suitable replacements."),
	answers = {
		"end_conversation_got_it"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_jobs_2",
	sound = "dc_jobs_1",
	nameID = "roman_glebenkov",
	id = "dev_commentary_jobs_1",
	image = "roman_glebenkov",
	uniqueDialogueID = "dev_commentary_jobs",
	text = _T("DEV_COMMENTARY_JOBS_1", "For hiring people you've got two choices: check the list of people looking for work, or post a job offer."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_jobs_3",
	sound = "dc_jobs_2",
	id = "dev_commentary_jobs_2",
	text = _T("DEV_COMMENTARY_JOBS_2", "Posting a job offer becomes a viable alternative only when you've got a lot of money, since looking for top-tier employees requires you to spend a hefty amount of money."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_jobs_4",
	sound = "dc_jobs_3",
	id = "dev_commentary_jobs_3",
	text = _T("DEV_COMMENTARY_JOBS_3", "Game Dev Tycoon also offers the ability to post job offers, but the amount of money you need to spend there is completely unrealistic, and really arcadey. I didn't like that about the game. So for Game Dev Studio I decided I would be much closer to reality in terms of the costs."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_jobs_5",
	sound = "dc_jobs_4",
	id = "dev_commentary_jobs_4",
	text = _T("DEV_COMMENTARY_JOBS_4", "The funny thing is that the closer you get to realism when designing gameplay mechanics, then those mechanics either get a lot easier or a lot more difficult. In the case of posting job offers, getting closer to realism made the game easier."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_jobs_6",
	sound = "dc_jobs_5",
	id = "dev_commentary_jobs_5",
	text = _T("DEV_COMMENTARY_JOBS_5", "The maximum price for a job listing is still blown out of proportion, but I decided to keep it at $50,000 so that it's not too easy, but not too hard either."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	id = "dev_commentary_jobs_6",
	sound = "dc_jobs_6",
	text = _T("DEV_COMMENTARY_JOBS_6", "In real life most websites charge between $300-$500 for a job listing. I decided that for the top-tier employee levels you'd need to spend a lot of money. The rationale for that is you're posting the job offer on as many sites as possible, which drastically increases your chances of finding job candidates, but costs a lot, since experts are much more rare than your average employee."),
	answers = {
		"end_conversation_got_it"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_games_2",
	sound = "dc_games_1",
	nameID = "roman_glebenkov",
	id = "dev_commentary_games_1",
	image = "roman_glebenkov",
	uniqueDialogueID = "dev_commentary_games",
	text = _T("DEV_COMMENTARY_GAMES_1", "Since creating games is the core theme of the game, this meant I was going to try and make it as unique as possible."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_games_3",
	sound = "dc_games_2",
	id = "dev_commentary_games_2",
	text = _T("DEV_COMMENTARY_GAMES_2", "Skills and knowledge were to play the most important role of the game creation process. Skills directly contribute to all aspects of the game quality, while knowledge contributes quality points only if there is a match between genre and theme, as well as certain tasks."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_games_4",
	sound = "dc_games_3",
	id = "dev_commentary_games_3",
	text = _T("DEV_COMMENTARY_GAMES_3", "I made knowledge grant quality points in certain cases to make sense. Guns contribute to gun related tasks and games, fighting knowledge contributes to fighting games, etc."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_games_5",
	sound = "dc_games_4",
	id = "dev_commentary_games_4",
	text = _T("DEV_COMMENTARY_GAMES_4", "Therefore in order to get the highest possible game quality and therefore review score, you need to have very experienced employees with a lot of knowledge."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_games_6",
	sound = "dc_games_5",
	id = "dev_commentary_games_5",
	text = _T("DEV_COMMENTARY_GAMES_5", "Engines also play into the game creation process. For one the performance level can negatively affect the review score if it's too poor. It makes sense too: in real life there are a lot of games that are really good, but perform like ass and so the overall enjoyment of it falls down. I'm pretty sure you can think of such games too."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_games_7",
	sound = "dc_games_6",
	id = "dev_commentary_games_6",
	text = _T("DEV_COMMENTARY_GAMES_6", "Then there's the ease of use engine attribute - it directly influences how fast the game development process is going to be."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_games_8",
	sound = "dc_games_7",
	id = "dev_commentary_games_7",
	text = _T("DEV_COMMENTARY_GAMES_7", "Theme-genre matches provide a bonus to the review score and selling power of the game. Audience-genre matches provide a bonus to the selling power. Perspective-genre matches too. You don't see that many first-person strategy games because they just wouldn't work well."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_games_9",
	sound = "dc_games_8",
	id = "dev_commentary_games_8",
	text = _T("DEV_COMMENTARY_GAMES_8", "Pricing that can completely screw your sales up if it's not right, platforms that don't work well with a given genre that also applies a penalty... I wanted to have a lot of these factors, so that players would need to think as much as possible."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_games_10",
	sound = "dc_games_9",
	id = "dev_commentary_games_9",
	text = _T("DEV_COMMENTARY_GAMES_9", "Because of this, I believe the game ended up being a lot more strategic. I remember reading one review of the game stating that it's more of a strategy rather than a simulation game because of all of this. I don't know whether to agree or disagree with that person, but what I can tell you is that I am happy that said person ended up really liking the game."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	id = "dev_commentary_games_10",
	sound = "dc_games_10",
	text = _T("DEV_COMMENTARY_GAMES_10", "The randomization of genre-theme matches completely throws a lot of it out the door. I remember when I first added that and played with it, the game felt completely new to me. I was so damn happy, because I felt like I was playing it for the first time again."),
	answers = {
		"end_conversation_got_it"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_engines_2",
	sound = "dc_engines_1",
	nameID = "roman_glebenkov",
	id = "dev_commentary_engines_1",
	image = "roman_glebenkov",
	uniqueDialogueID = "dev_commentary_engines",
	text = _T("DEV_COMMENTARY_ENGINES_1", "With engines I wanted to make them as re-usable as possible. I didn't like that in Game Dev Tycoon you need to pay money to add features to a new engine, and I didn't like the fact that you couldn't update engines with new features. It didn't make sense that implementing the same feature twice costed money more than once."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_engines_3",
	sound = "dc_engines_2",
	id = "dev_commentary_engines_2",
	text = _T("DEV_COMMENTARY_ENGINES_2", "Updating engines with new features hurts some stats, so if you updated them again and again you'd have to revamp them later on."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_engines_4",
	sound = "dc_engines_3",
	id = "dev_commentary_engines_3",
	text = _T("DEV_COMMENTARY_ENGINES_3", "The logic behind that was simple: when adding new features to an existing engine, some parts of it are overlooked. This results in messier code that is more difficult to work with. Therefore revamping game engines from time to time made sense. That's why updating and revamping are two separate actions."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_engines_5",
	sound = "dc_engines_4",
	id = "dev_commentary_engines_4",
	text = _T("DEV_COMMENTARY_ENGINES_4", "Engine licensing was not in the 1.0 release, but was added within the first month of release. In reality I rushed engine licensing because I was afraid of even more negative reviews piling up. It's not a good thing for launch day."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	id = "dev_commentary_engines_5",
	sound = "dc_engines_5",
	text = _T("DEV_COMMENTARY_ENGINES_5", "Despite it being somewhat rushed, I think it does a good enough job of providing an extra source of income to players. Sure, it doesn't have that much depth, but it performs its intended action perfectly."),
	answers = {
		"end_conversation_got_it"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_rivals_interaction_2",
	sound = "dc_rivals_interaction_1",
	nameID = "roman_glebenkov",
	id = "dev_commentary_rivals_interaction_1",
	image = "roman_glebenkov",
	uniqueDialogueID = "dev_commentary_rivals_interaction",
	text = _T("DEV_COMMENTARY_RIVALS_INTERACTION_1", "For interactions with rivals there wasn't much planned. I added rivals for the sole reason of having something to do aside from making games. Having absolutely zero obstacles beyond problems in your own office wouldn't have made the game that much fun as it is with rivals. They add an element of surprise or randomness to the game."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_rivals_interaction_3",
	sound = "dc_rivals_interaction_2",
	id = "dev_commentary_rivals_interaction_2",
	text = _T("DEV_COMMENTARY_RIVALS_INTERACTION_2", "I got the idea to add rivals when I was working on the 'Introduction' scenario for the game, which was called 'Story Mode' in the 1.0 version of the game, and was the original tutorial."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_rivals_interaction_4",
	sound = "dc_rivals_interaction_3",
	id = "dev_commentary_rivals_interaction_3",
	text = _T("DEV_COMMENTARY_RIVALS_INTERACTION_3", "The idea was to build the campaign around competing with a nasty rival at the late stages of the scenario."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_rivals_interaction_5",
	sound = "dc_rivals_interaction_4",
	id = "dev_commentary_rivals_interaction_4",
	text = _T("DEV_COMMENTARY_RIVALS_INTERACTION_4", "I remember being really excited when interacting with rivals once I implemented everything I had on my checklist for them. As a creator of the game, I have no clue just how much fun it is to any other person playing the game for the first time. The only thing I know is that sometimes I went 'son of a bitch' when rivals would put a stick in the wheel while playing through the game."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_rivals_interaction_6",
	sound = "dc_rivals_interaction_5",
	id = "dev_commentary_rivals_interaction_5",
	text = _T("DEV_COMMENTARY_RIVALS_INTERACTION_5", "I knew that people would ask for the ability to collaborate with other studios on a single game project, but I didn't add that because I couldn't see it add much depth to it."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_rivals_interaction_7",
	sound = "dc_rivals_interaction_6",
	id = "dev_commentary_rivals_interaction_6",
	text = _T("DEV_COMMENTARY_RIVALS_INTERACTION_6", "Not to mention in real life multiple devs work on a single game very rarely and in most cases only do so if they're both under the same publisher. Convincing random companies to work together on a single project seems unlikely."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_rivals_interaction_8",
	sound = "dc_rivals_interaction_7",
	id = "dev_commentary_rivals_interaction_7",
	text = _T("DEV_COMMENTARY_RIVALS_INTERACTION_7", "I guess I could have extended the lawsuits and other stuff to the collabs to add some kind of drama, but again, I didn't see a feature like that adding much gameplay depth."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	id = "dev_commentary_rivals_interaction_8",
	sound = "dc_rivals_interaction_8",
	text = _T("DEV_COMMENTARY_RIVALS_INTERACTION_8", "On the flip side of the coin, I think this obsession of mine with gameplay depth over fluff-type content is what possibly prevented the game from being even better. At the time of making this commentary I am burned out from working on Game Dev Studio, so thinking up new gameplay features is very difficult and feels like a chore. I might get back to releasing more updates for the game once I finish my second game."),
	answers = {
		"end_conversation_got_it"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_rivals_slander_2",
	sound = "dc_rivals_slander_1",
	nameID = "roman_glebenkov",
	id = "dev_commentary_rivals_slander_1",
	image = "roman_glebenkov",
	uniqueDialogueID = "dev_commentary_rivals_slander",
	text = _T("DEV_COMMENTARY_RIVALS_SLANDER_1", "Rivals posting slanderous articles about you and generally being assholes towards you once you'd steal an employee from them is what the main focus was for them."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_rivals_slander_3",
	sound = "dc_rivals_slander_2",
	id = "dev_commentary_rivals_slander_2",
	text = _T("DEV_COMMENTARY_RIVALS_SLANDER_2", "I wanted them to be something that would mess up your plans every now and then if you chose to mess with them. Despite that I decided to make said slander not affect much aside from your Reputation levels."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	id = "dev_commentary_rivals_slander_3",
	sound = "dc_rivals_slander_3",
	text = _T("DEV_COMMENTARY_RIVALS_SLANDER_3", "If I made them more hardcore, then that would've made playthroughs a lot more difficult."),
	answers = {
		"end_conversation_got_it"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_rivals_court_2",
	sound = "dc_rivals_court_1",
	nameID = "roman_glebenkov",
	id = "dev_commentary_rivals_court_1",
	image = "roman_glebenkov",
	uniqueDialogueID = "dev_commentary_rivals_court",
	text = _T("DEV_COMMENTARY_RIVALS_COURT_1", "Court cases between you and your rivals were the ultimate result of messing with each other."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_rivals_court_3",
	sound = "dc_rivals_court_2",
	id = "dev_commentary_rivals_court_2",
	text = _T("DEV_COMMENTARY_RIVALS_COURT_2", "I considered things like sabotage, or spying on rivals, but that doesn't make much sense and I don't think there are a lot of such cases in real life. Which is why I decided to not add said things."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	id = "dev_commentary_rivals_court_3",
	sound = "dc_rivals_court_3",
	text = _T("DEV_COMMENTARY_RIVALS_COURT_3", "Court cases on the other hand, while there have been very few, are not out the realm of possibility, which is why I decided to add them to the game. I couldn't think of much else that would make sense in terms of real-life and would also be fun."),
	answers = {
		"end_conversation_got_it"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_rivals_bribes_2",
	sound = "dc_rivals_bribes_1",
	nameID = "roman_glebenkov",
	id = "dev_commentary_rivals_bribes_1",
	image = "roman_glebenkov",
	uniqueDialogueID = "dev_commentary_rivals_bribes",
	text = _T("DEV_COMMENTARY_RIVALS_BRIBES_1", "Between all the employee stealing, slander, and court cases there had to be something to make not messing with your rivals worth it. Asking about potential review bribing info was the logical solution."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_rivals_bribes_3",
	sound = "dc_rivals_bribes_2",
	id = "dev_commentary_rivals_bribes_2",
	text = _T("DEV_COMMENTARY_RIVALS_BRIBES_2", "It made sense, since if you're not on bad terms with another company they might just share their info with you."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	id = "dev_commentary_rivals_bribes_3",
	sound = "dc_rivals_bribes_3",
	text = _T("DEV_COMMENTARY_RIVALS_BRIBES_3", "This was the least I could do in regards to something positive that could come out of not trying to screw other rivals over."),
	answers = {
		"end_conversation_got_it"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_game_editions_2",
	sound = "dc_game_editions_1",
	nameID = "roman_glebenkov",
	id = "dev_commentary_game_editions_1",
	image = "roman_glebenkov",
	uniqueDialogueID = "dev_commentary_game_editions",
	text = _T("DEV_COMMENTARY_GAME_EDITIONS_1", "Game editions were added in Update #30. It was a feature that I wanted to add to spice up game creation. The idea was to add a high-risk, high-reward way of getting more money and reputation."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_game_editions_3",
	sound = "dc_game_editions_2",
	id = "dev_commentary_game_editions_2",
	text = _T("DEV_COMMENTARY_GAME_EDITIONS_2", "If you price your editions right, and provide enough value, then they're going to get you a lot more sales, extra reputation, and opinion points. If you don't, then that's where the risk comes from. You can lose far more reputation and opinion points from a screw-up like that than you can get from a single game which has properly set-up game editions."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	id = "dev_commentary_game_editions_3",
	sound = "dc_game_editions_3",
	text = _T("DEV_COMMENTARY_GAME_EDITIONS_3", "All in all, this is one of the few features I didn't see people complain about, so I think the design for it is just right. Not too punishing, not too rewarding. Just right."),
	answers = {
		"end_conversation_got_it"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_platforms_2",
	sound = "dc_platforms_1",
	nameID = "roman_glebenkov",
	id = "dev_commentary_platforms_1",
	image = "roman_glebenkov",
	uniqueDialogueID = "dev_commentary_platforms",
	text = _T("DEV_COMMENTARY_PLATFORMS_1", "For platforms I decided not to go the historically accurate route, since I wanted to have a simulation of the console market."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_platforms_3",
	sound = "dc_platforms_2",
	id = "dev_commentary_platforms_2",
	text = _T("DEV_COMMENTARY_PLATFORMS_2", "The market simulation depends on what games you and your rivals make for the platforms, and a little bit of randomness. The random bit is used for generating fake games that are then used for calculating the attractiveness of the platform."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_platforms_4",
	sound = "dc_platforms_3",
	id = "dev_commentary_platforms_3",
	text = _T("DEV_COMMENTARY_PLATFORMS_3", "Naturally a player can't compete with a bunch of fake games being made by non-existent companies, so that meant I had to make the games that the player and rivals release have a larger impact on the attractiveness of a platform."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_platforms_5",
	sound = "dc_platforms_4",
	id = "dev_commentary_platforms_4",
	text = _T("DEV_COMMENTARY_PLATFORMS_4", "This made the system work perfectly - if you stick to one platform and make a lot of games for it, its attractiveness will skyrocket, and you will essentially play a role in the fate of all the other platforms."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_platforms_6",
	sound = "dc_platforms_5",
	id = "dev_commentary_platforms_5",
	text = _T("DEV_COMMENTARY_PLATFORMS_5", "For the stats of platforms I decided to go with a bit of real-life stats, those being the licensing fees and the popularity. Things like development difficulty are 50/50 on real-life and speculation. For example the Playstation 3 was difficult to develop for since it had a largely different architecture for its processor and graphics."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_platforms_7",
	sound = "dc_platforms_6",
	id = "dev_commentary_platforms_6",
	text = _T("DEV_COMMENTARY_PLATFORMS_6", "The funny thing is, even though this game is fiction some people got upset that their favorite console manufacturer would go bankrupt because of the console market simulation system."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	id = "dev_commentary_platforms_7",
	sound = "dc_platforms_7",
	text = _T("DEV_COMMENTARY_PLATFORMS_7", "Even in fiction people get upset when their favorite console manufacturer doesn't 'win'. I never expected to see negative reviews due to this fact alone, or have it mentioned as a negative in said reviews, but this shows just how emotionally attached a lot of people playing and reviewing games are. It's something to consider in case you're a game developer."),
	answers = {
		"end_conversation_got_it"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_loans_2",
	sound = "dc_loans_1",
	nameID = "roman_glebenkov",
	id = "dev_commentary_loans_1",
	image = "roman_glebenkov",
	uniqueDialogueID = "dev_commentary_loans",
	text = _T("DEV_COMMENTARY_LOANS_1", "Loaning money was not in the 1.0 release, and just like with engine licensing was added very shortly after release, in Update #7. People asked for it in the Steam discussions."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_loans_3",
	sound = "dc_loans_2",
	id = "dev_commentary_loans_2",
	text = _T("DEV_COMMENTARY_LOANS_2", "In all honesty it should have been in the game at launch. It's another one of those features that I didn't think of until I released the game."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_loans_4",
	sound = "dc_loans_3",
	id = "dev_commentary_loans_3",
	text = _T("DEV_COMMENTARY_LOANS_3", "It was absolutely necessary for people that are not big into simulator type games, or casual players looking to have fun rather than to get into the nitty-gritty of any game."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_loans_5",
	sound = "dc_loans_4",
	id = "dev_commentary_loans_4",
	text = _T("DEV_COMMENTARY_LOANS_4", "The initial interest rate for loans was insanely high. 5% every month. That amounts to 60% in a year. That's way too high. I thought 5% was fine for short periods of time, what I didn't realize is that it should've been about 5% per year, not month."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	id = "dev_commentary_loans_5",
	sound = "dc_loans_5",
	text = _T("DEV_COMMENTARY_LOANS_5", "Update #29 reduced the loan interest rate to 1%, leading to 12% per year. Update #30 further reduced it down to 8% per year. Now compare that to the initial 60% per year. Whoops."),
	answers = {
		"end_conversation_got_it"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_platform_creation_2",
	sound = "dc_platform_creation_1",
	nameID = "roman_glebenkov",
	id = "dev_commentary_platform_creation_1",
	image = "roman_glebenkov",
	uniqueDialogueID = "dev_commentary_platform_creation",
	text = _T("DEV_COMMENTARY_PLATFORM_CREATION_1", "Platform creation was added in Update #18. It was something that the community asked for, and since other games of the same genre have this feature I thought what the hell, why not."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_platform_creation_3",
	sound = "dc_platform_creation_2",
	id = "dev_commentary_platform_creation_2",
	text = _T("DEV_COMMENTARY_PLATFORM_CREATION_2", "In reality this wasn't a feature that I planned to add. I don't really care that much for things like creating platforms, and didn't really care for such features in other games. I focused more on the game creation aspect, so that's why this gameplay feature wasn't in the game on day 1."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_platform_creation_4",
	sound = "dc_platform_creation_3",
	id = "dev_commentary_platform_creation_3",
	text = _T("DEV_COMMENTARY_PLATFORM_CREATION_3", "The idea for player-made platforms was fairly simple: provide another way of earning money and reputation points, but make it really, really difficult to make a lot of money on, and make it high-risk."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_platform_creation_5",
	sound = "dc_platform_creation_4",
	id = "dev_commentary_platform_creation_4",
	text = _T("DEV_COMMENTARY_PLATFORM_CREATION_4", "The reason why I chose to make this gameplay mechanic really difficult, is because it can get you a lot of money if you do everything right. I also decided to stay realistic when it came to platform creation costs. Consoles these days are sold at a loss for the manufacturer, and they recoup the losses through game sales."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_platform_creation_6",
	sound = "dc_platform_creation_5",
	id = "dev_commentary_platform_creation_5",
	text = _T("DEV_COMMENTARY_PLATFORM_CREATION_5", "Once again, people didn't understand that. They wanted to make money off console sales, and also off the console game sales too. I did make certain bits of console creation easier in the following updates, but the component part prices remained the same. In other words, while it is easier to succeed on consoles now than it was before, it's still a gamble, and you need to get a lot of things right if you wish to make a lot of money."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_platform_creation_7",
	sound = "dc_platform_creation_6",
	id = "dev_commentary_platform_creation_6",
	text = _T("DEV_COMMENTARY_PLATFORM_CREATION_6", "The specialist system was there to give a potential boost to your platform if they're available. They provide a rather big bonus to a particular area of your platform, and specialists in real life are very important when building hardware. Take Jim Keller for example. He's one of the main reasons why the Ryzen CPU architecture that AMD has developed turned out so damn good."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_platform_creation_8",
	sound = "dc_platform_creation_7",
	id = "dev_commentary_platform_creation_7",
	text = _T("DEV_COMMENTARY_PLATFORM_CREATION_7", "Experts in the hardware area are very sought after, so naturally their salaries are high. I referred to real-life salaries for Game Dev Studio. Naturally, since they're in demand I made them unavailable for large periods of time. Designing a hardware architecture takes a lot of time and effort, so once again I referred to real life for their 'busy time' duration."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	id = "dev_commentary_platform_creation_8",
	sound = "dc_platform_creation_8",
	text = _T("DEV_COMMENTARY_PLATFORM_CREATION_8", "The parts that go in a console were split up into 4 parts to make players understand how much work goes into making a console. Obviously I didn't go into areas like custom designed chips or semi-custom designed chips, but I believe it carried the idea across well."),
	answers = {
		"end_conversation_got_it"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_mmos_2",
	sound = "dc_mmos_1",
	nameID = "roman_glebenkov",
	id = "dev_commentary_mmos_1",
	image = "roman_glebenkov",
	uniqueDialogueID = "dev_commentary_mmos",
	text = _T("DEV_COMMENTARY_MMOS_1", "MMOs weren't present in the game at launch day, and were added in Update #14. If I remember correctly, this was something that I wanted to add to the game. The idea for them was pretty similar to player-made platforms: high risk, high reward."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_mmos_3",
	sound = "dc_mmos_2",
	id = "dev_commentary_mmos_2",
	text = _T("DEV_COMMENTARY_MMOS_2", "Just like with platform creation, I decided to go balls-to-the-wall with difficulty with this particular mechanic, and made them very hard to succeed on. The funny thing is, if you manage to succeed, then you're going to make a lot of money."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_mmos_4",
	sound = "dc_mmos_3",
	id = "dev_commentary_mmos_3",
	text = _T("DEV_COMMENTARY_MMOS_3", "MMOs were really difficult, and still are to this day. I've released a couple of updates that made certain bits of it easier, but I still stuck to the original idea of making them really difficult."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_mmos_5",
	sound = "dc_mmos_4",
	id = "dev_commentary_mmos_4",
	text = _T("DEV_COMMENTARY_MMOS_4", "Prior to the addition of multiple office floors, you pretty much had to rely on renting out servers. You could buy and place your own servers, but the office space limit of a single floor made it practically impossible to rely on your own server racks alone. You still need to rent servers out when your MMOs get a huge amount of traffic, but that can be partially offset since you have a lot more office space now than before."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	id = "dev_commentary_mmos_5",
	sound = "dc_mmos_5",
	text = _T("DEV_COMMENTARY_MMOS_5", "This is another side-effect of a feature like office floors that I didn't think of before I added that feature. It's funny how an addition of a feature like that carries over to so many gameplay mechanics and adds new ways of playing the game."),
	answers = {
		"end_conversation_got_it"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_interviews_2",
	sound = "dc_interviews_1",
	nameID = "roman_glebenkov",
	id = "dev_commentary_interviews_1",
	image = "roman_glebenkov",
	uniqueDialogueID = "dev_commentary_interviews",
	text = _T("DEV_COMMENTARY_INTERVIEWS_1", "Interviews were made with the idea that there are right and wrong things to say during an interview. Despite that, I chose not to penalize players for having bad interviews. Instead, the penalty for badly leading an interview is that you don't get much from it. In other words it's a waste of time."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_interviews_3",
	sound = "dc_interviews_2",
	id = "dev_commentary_interviews_2",
	text = _T("DEV_COMMENTARY_INTERVIEWS_2", "There is practically no way of making a feature like this have a lot of depth, since the questions you have are limited. Once you find out the best answers to each, any depth there was simply fades away. You could add more questions, but they will be prey to the same problem I just described."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_interviews_4",
	sound = "dc_interviews_3",
	id = "dev_commentary_interviews_3",
	text = _T("DEV_COMMENTARY_INTERVIEWS_3", "One particular way of remedying this issue is to make each question have some kind of consequence depending on the answer you've chosen. I didn't think of this when I was working on interviews, but I might just do something about them in a future update."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_interviews_5",
	sound = "dc_interviews_4",
	id = "dev_commentary_interviews_4",
	text = _T("DEV_COMMENTARY_INTERVIEWS_4", "The best way to implement interviews would be to make a mini-game that doesn't have anything in common with interviews, like collecting a certain amount of something in some kind of arena, but that wasn't something I wanted to do."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_interviews_6",
	sound = "dc_interviews_5",
	id = "dev_commentary_interviews_5",
	text = _T("DEV_COMMENTARY_INTERVIEWS_5", "In order to somewhat remedy this problem I decided I'd add the ability to hype up your games during interviews. Every time you hype it up, the expectations for the game increase, but the game gets a lot more hype. If the game doesn't reach or exceed these expectations - you get a penalty. If your game is good - great, you get a lot more reputation points."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	id = "dev_commentary_interviews_6",
	sound = "dc_interviews_6",
	text = _T("DEV_COMMENTARY_INTERVIEWS_6", "This feature alone has more depth to it than the question answering part of interviews."),
	answers = {
		"end_conversation_got_it"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_reviews_2",
	sound = "dc_reviews_1",
	nameID = "roman_glebenkov",
	id = "dev_commentary_reviews_1",
	image = "roman_glebenkov",
	uniqueDialogueID = "dev_commentary_reviews",
	text = _T("DEV_COMMENTARY_REVIEWS_1", "With reviews I wanted to give players as much info on what to do with their next game as possible. It reveals all the matches there are, the only thing people need to do is open the reviews and read through them."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_reviews_3",
	sound = "dc_reviews_2",
	id = "dev_commentary_reviews_2",
	text = _T("DEV_COMMENTARY_REVIEWS_2", "Not every single review is going to reveal something new, but that's expected. You need to play through the game and learn new things gradually, rather than get every bit of information instantly."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_reviews_4",
	sound = "dc_reviews_3",
	id = "dev_commentary_reviews_3",
	text = _T("DEV_COMMENTARY_REVIEWS_3", "I don't think a lot of people know this, but the quality point display to the left of the review window shows the quality point amount you needed to have in order to reach a 100% score in that particular aspect."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_reviews_5",
	sound = "dc_reviews_4",
	id = "dev_commentary_reviews_4",
	text = _T("DEV_COMMENTARY_REVIEWS_4", "One interesting thing is that people have left negative reviews because of the review system. Some people thought that if their graphics score is at 100%, with the rest being at 30-40%, then there's no way the game should get 5/10 ratings. It was a little disappointing to see such reviews just because people felt like they should be awarded a certain rating."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_reviews_6",
	sound = "dc_reviews_5",
	id = "dev_commentary_reviews_5",
	text = _T("DEV_COMMENTARY_REVIEWS_5", "I disagree with the idea that if one aspect of a game is fantastic with the rest being poor or average, then the game should get a good rating anyway. There are plenty of games in real life that excel in one area, and completely fuck up something else, which leads to the game being far less enjoyable than intended."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	id = "dev_commentary_reviews_6",
	sound = "dc_reviews_6",
	text = _T("DEV_COMMENTARY_REVIEWS_6", "Still, I decided to make it a bit easier for people, and in one of the updates made genre-theme matches increase the review rating by a bit. So now even if your game aspects aren't that good, you can still get a bonus to the review rating if the theme-genre match is good."),
	answers = {
		"end_conversation_got_it"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_bribes_2",
	sound = "dc_bribes_1",
	nameID = "roman_glebenkov",
	id = "dev_commentary_bribes_1",
	image = "roman_glebenkov",
	uniqueDialogueID = "dev_commentary_bribes",
	text = _T("DEV_COMMENTARY_BRIBES_1", "Bribing was made to be high-risk, low-reward. There really isn't much I can say aside from that. I personally don't condone bribing reviews, just like pretty much any other gamer. I added bribes as more of a 'you fucked up, what the hell were you thinking?' type of thing. It's more of a mockery feature than anything else."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_bribes_3",
	sound = "dc_bribes_2",
	id = "dev_commentary_bribes_2",
	text = _T("DEV_COMMENTARY_BRIBES_2", "You can boost your review scores by bribing reviewers, but if too many accept a bribe, then people are going to get suspicious and you'll lose those precious reputation points."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	id = "dev_commentary_bribes_3",
	sound = "dc_bribes_3",
	text = _T("DEV_COMMENTARY_BRIBES_3", "Again, bribing is not a serious nor valid gameplay mechanic and was added to make fun of players and screw their progress up."),
	answers = {
		"end_conversation_got_it"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_adverts_2",
	sound = "dc_adverts_1",
	nameID = "roman_glebenkov",
	id = "dev_commentary_adverts_1",
	image = "roman_glebenkov",
	uniqueDialogueID = "dev_commentary_adverts",
	text = _T("DEV_COMMENTARY_ADVERTS_1", "With game adverts I wanted to have a lot of options. Mass adverts have a ton of sub-options, each works best in certain scenarios, each has its own cost, and so on. The idea was to give players as many options as possible, so that they would make use of what they can afford and reap the benefits."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_adverts_3",
	sound = "dc_adverts_2",
	id = "dev_commentary_adverts_2",
	text = _T("DEV_COMMENTARY_ADVERTS_2", "With advertisements I referred to real life for their prices. A lot of people didn't realize just how expensive advertisements are, and didn't seem to understand that advertisements are best performed while the game is still in development. Some even asked me to lower their costs."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_adverts_4",
	sound = "dc_adverts_3",
	id = "dev_commentary_adverts_3",
	text = _T("DEV_COMMENTARY_ADVERTS_3", "People wanted advertisements to be even cheaper than they are now, even with the advertisement budget slider."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_adverts_5",
	sound = "dc_adverts_4",
	id = "dev_commentary_adverts_4",
	text = _T("DEV_COMMENTARY_ADVERTS_4", "The advertisement rounds option was added in Update #30 by request of the community. Once again, it's a feature that I didn't think much of when I was working on the game. I realized just how handy it is after I added it and played with it."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_adverts_6",
	sound = "dc_adverts_5",
	id = "dev_commentary_adverts_5",
	text = _T("DEV_COMMENTARY_ADVERTS_5", "Let's players were made with the idea that the majority of people don't watch online personalities to make up their mind in regard to purchasing a game. It takes a lot of hundreds of thousands of views to make a difference. Most people watch such content for the personalities of said content creators."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_adverts_7",
	sound = "dc_adverts_6",
	id = "dev_commentary_adverts_6",
	text = _T("DEV_COMMENTARY_ADVERTS_6", "The funny thing is that I designed this feature around this speculation, which turned out to be true. There are a few gameplay videos of Game Dev Studio with around 30 thousand views or so, and when I look at the sale statistics on the day the video was uploaded there is either no bump or a minimal bump in sales. It's really ironic."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_adverts_8",
	sound = "dc_adverts_7",
	id = "dev_commentary_adverts_7",
	text = _T("DEV_COMMENTARY_ADVERTS_7", "Shilling was made with a similar idea. You need to shill to a lot of people in order to get a bump in sales. The only difference between this and let's plays is that you can get busted while shilling."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_adverts_9",
	sound = "dc_adverts_8",
	id = "dev_commentary_adverts_8",
	text = _T("DEV_COMMENTARY_ADVERTS_8", "I added this many advertisement options as a reflection of the way I've seen games being advertised in real life."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	id = "dev_commentary_adverts_9",
	sound = "dc_adverts_9",
	text = _T("DEV_COMMENTARY_ADVERTS_9", "Releasing screenshots was not in the 1.0 release. It was added in Update #30, as another way of getting some hype for your game when starting out with barely any funds."),
	answers = {
		"end_conversation_got_it"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_outro_2",
	sound = "dc_outro_1",
	nameID = "roman_glebenkov",
	id = "dev_commentary_outro_1",
	image = "roman_glebenkov",
	uniqueDialogueID = "dev_commentary_outro",
	text = _T("DEV_COMMENTARY_OUTRO_1", "Well, it looks like you've gone through every bit of commentary! I hope it was fun to get a behind-the-scenes look at the game, how it was made, the iterations it went through, and the doubts and hardships I've gone through while updating it."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_outro_3",
	sound = "dc_outro_2",
	id = "dev_commentary_outro_2",
	answers = {
		"generic_continue"
	},
	textDLC = _T("DEV_COMMENTARY_OUTRO_2", "It was fun to create and narrate this developer commentary. I'd like to thank you for purchasing the Developer Commentary DLC once again. I hope the narration quality was satisfactory and made going through this scenario more fun."),
	textNoDLC = _T("DEV_COMMENTARY_OUTRO_2_NO_NARRATION", "If you wish to support me and any future game I've yet to make be sure to check out the Developer Commentary DLC. It adds narration to this particular scenario, and is more of a 'thank you' from me to you, rather than an actual DLC. It only costs $1.99, and after Steams cut and all the taxes, I get somewhere around 50% of that. So if you feel like buying me a cheeseburger at McDonalds be sure to check it out."),
	getText = function(self, dialogueObject)
		if self:canPlaySound() then
			return self.textDLC
		end
		
		return self.textNoDLC
	end
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_outro_4",
	sound = "dc_outro_3",
	id = "dev_commentary_outro_3",
	text = _T("DEV_COMMENTARY_OUTRO_3", "Game Dev Studio was a huge milestone in my life. It's the first game I've ever finished and released at the age of 23. I made a decent amount of mistakes with its release due to inexperience, and learned a lot from said mistakes. Mistakes I will not repeat in my future projects. I am grateful to all the constructive criticism that people have provided in their reviews, because a lot of it helped improve the game to where it is now."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_outro_5",
	sound = "dc_outro_4",
	id = "dev_commentary_outro_4",
	text = _T("DEV_COMMENTARY_OUTRO_4", "With all the updates I've released, all the content, and the bugs I've fixed I've come to the realization that Game Dev Studio was supposed to be released into Early Access first. Once again, this was not something I understood when I released the game at first, since it was my first game release. I just didn't expect to make a mistake this big."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_outro_6",
	sound = "dc_outro_5",
	id = "dev_commentary_outro_5",
	text = _T("DEV_COMMENTARY_OUTRO_5", "It's easy to sit here and reflect on all the things I got wrong, and feel sorry for the state the game released in, but that's not what anyone should be doing. I'm proud of the game I've made today. I've fixed the majority of bugs there are, I've added a lot of content in free updates, and most importantly added all the features in post-release updates that I told myself I would add."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_outro_7",
	sound = "dc_outro_6",
	id = "dev_commentary_outro_6",
	text = _T("DEV_COMMENTARY_OUTRO_6", "One thing I noticed is that the young generation of gamers wants to get everything as soon as possible. Instant gratification, if you will. I come from a generation of gamers where games seldom gave you everything you wanted. You had to be conservative with what you get and what you could get. I think this is the main reason why I decided to make Game Dev Studio a really hard game on launch day, and I think it's one of the main reasons why people didn't like it that much back then."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	nextQuestion = "dev_commentary_outro_8",
	sound = "dc_outro_7",
	id = "dev_commentary_outro_7",
	text = _T("DEV_COMMENTARY_OUTRO_7", "There is nothing about this game that makes me happier than seeing people leave positive reviews. Especially from people that have put 30, 50, 100 hours into the game. If a person has gotten 100 hours out of it for $9.99 or less if it was purchased on sale, then I know that I've made a really fun game. So if you like the game, or like it a lot, consider leaving a positive review if you haven't already. They always make me smile, since I read through all of them."),
	answers = {
		"generic_continue"
	}
})
registerDevComDialogue({
	id = "dev_commentary_outro_8",
	sound = "dc_outro_8",
	text = _T("DEV_COMMENTARY_OUTRO_8", "Thank you for sticking through the Developer Commentary. Thank you for purchasing, playing, and enjoying Game Dev Studio. Until next time!"),
	answers = {
		"end_conversation_got_it"
	}
})
