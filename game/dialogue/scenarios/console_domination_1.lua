dialogueHandler.registerQuestion({
	nextQuestion = "console_domination_1_2",
	id = "console_domination_1_1",
	image = "the_investor_1",
	uniqueDialogueID = "console_domination_1",
	text = _T("CONSOLE_DOMINATION_1_1", "Well hello! It's good to finally meet the most-qualified job candidate! Let's get right down to business... You've no doubt taken an interest in the gaming industry and all of the game development side of things, but you're here for a different reason."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "console_domination_1_3",
	id = "console_domination_1_2",
	text = _T("CONSOLE_DOMINATION_1_2", "You're here, because while making great games can be a good source of income, getting down to the nitty-gritty of it all and making a platform for the games can be an even better source of income."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "console_domination_1_4",
	id = "console_domination_1_3",
	text = _T("CONSOLE_DOMINATION_1_3", "Now, let me tell you, while you might have made a game or two in the past, making a platform is a task of a completely different caliber. I'm talking walking the fine line between success and absolute failure, a line so thin it's hard to keep your balance on point."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "console_domination_1_4",
	text = _T("CONSOLE_DOMINATION_1_4", "You've fit the bill for leading the development and oversight of a platform best, and since I'm not really the most qualified person for talking about the hardware side of things, I'll just refer you to my top-of-the-line egghead business partner here."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "console_domination_2_2",
	nameID = "labcoat",
	id = "console_domination_2_1",
	uniqueDialogueID = "console_domination_2",
	image = game.getGameTypeData("scenario_console_domination").labCoatPortrait,
	text = _T("CONSOLE_DOMINATION_2_1", "Hello! Let's get straight to the details. In order to design a platform, you'll need to not only select the hardware for it, but also determine what it should sell for, how much it should cost to license out to game developers, and various other things."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "console_domination_2_3",
	id = "console_domination_2_2",
	text = _T("CONSOLE_DOMINATION_2_2", "Now, let's not get ahead of ourselves. Since this is your first platform, you should pick the cheapest parts to put into your platform, adjust the amount of time for it's development, and, optionally, pick a lead architect."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "console_domination_2_3",
	text = _T("CONSOLE_DOMINATION_2_3", "Don't expect to be able to sell a platform with a huge profit margin. In most cases you'll be lucky to get a profit of a couple of dollars per platform sold."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "console_domination_3_2",
	nameID = "labcoat",
	id = "console_domination_3_1",
	uniqueDialogueID = "console_domination_3",
	image = game.getGameTypeData("scenario_console_domination").labCoatPortrait,
	text = _T("CONSOLE_DOMINATION_3_1", "Right, now that everything is setup and the blueprints are ready, we move on to the first stage of platform development - hardware architecture design. At this point we'll be prototyping and trying to put things together in the most efficient way possible."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "console_domination_3_2",
	text = _T("CONSOLE_DOMINATION_3_2", "Since there is no console hardware specification yet, you can't really get on with making games for the platform, so what you should do for now is just wait a while until we're done with the base hardware design, or get working on an engine you intend to use for games."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "console_domination_4_2",
	nameID = "labcoat",
	id = "console_domination_4_1",
	uniqueDialogueID = "console_domination_4",
	image = game.getGameTypeData("scenario_console_domination").labCoatPortrait,
	text = _T("CONSOLE_DOMINATION_4_1", "Okay, the team is telling me they've finished the overall hardware design."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "console_domination_4_3",
	id = "console_domination_4_2",
	text = _T("CONSOLE_DOMINATION_4_2", "Remember when I told you that you'd be lucky to make a slim profit per each platform you make? That's where game developers come in. Now that we've got a hardware spec, it's time for you to look for developers that will make games for your platform."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "console_domination_4_4",
	id = "console_domination_4_3",
	text = _T("CONSOLE_DOMINATION_4_3", "Additionally, it might be a good idea to get working on a game of your own for the console while you're waiting. It doesn't have to be exclusive to your console, especially since this is your first platform."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	id = "console_domination_4_4",
	text = _T("CONSOLE_DOMINATION_4_4", "With that said, make sure you wait until the games are finished. Having enough games on launch day is crucial in leaving a good first impression, and the first impression is where it matters most."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	nameID = "labcoat",
	id = "console_domination_5_1",
	uniqueDialogueID = "console_domination_5",
	image = game.getGameTypeData("scenario_console_domination").labCoatPortrait,
	text = _T("CONSOLE_DOMINATION_5_1", "Fantastic, now give this some time, those interested in making games for your platform will reply to us, and we'll go onwards from there."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "console_domination_6_2",
	nameID = "labcoat",
	id = "console_domination_6_1",
	uniqueDialogueID = "console_domination_6",
	image = game.getGameTypeData("scenario_console_domination").labCoatPortrait,
	text = _T("CONSOLE_DOMINATION_6_1", "Alright, with game developers on our team we can proceed onwards. While we're working on finalizing the hardware and the overall package of the platform, game developers will be hard at work to make games for launch day."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "console_domination_6_3",
	id = "console_domination_6_2",
	text = _T("CONSOLE_DOMINATION_6_2", "Keep in mind, the developers have agreed to work with you for the currently specified console price. If you increase the price of the console, you'll need to look for developers again."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	id = "console_domination_6_3",
	text = _T("CONSOLE_DOMINATION_6_3", "Another thing, if you price the console too high, potential developers might refuse partnerships with you. The reason for that is simple: they don't consider your platform a safe investment of money when it comes to the trade-off between the price of the platform and time they spend working on games."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "console_domination_7_2",
	nameID = "labcoat",
	id = "console_domination_7_1",
	uniqueDialogueID = "console_domination_7",
	image = game.getGameTypeData("scenario_console_domination").labCoatPortrait,
	text = _T("CONSOLE_DOMINATION_7_1", "The console's all ready. Now we're just waiting on you to give us the signal to release it."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "console_domination_7_2",
	text = _T("CONSOLE_DOMINATION_7_2", "Don't forget, make sure all the in-progress games are finished, so that launch day is not lacking in games. A bad first impression is in no way going to be good for the platform."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "console_domination_8_2",
	nameID = "labcoat",
	id = "console_domination_8_1",
	uniqueDialogueID = "console_domination_8",
	image = game.getGameTypeData("scenario_console_domination").labCoatPortrait,
	text = _T("CONSOLE_DOMINATION_8_1", "Excellent! Now people will begin buying the console. Don't be surprised if you're seemingly operating at a loss at first."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "console_domination_8_3",
	id = "console_domination_8_2",
	text = _T("CONSOLE_DOMINATION_8_2", "If you weren't too greedy with the platform cost, development time, and got a decent amount of launch-day games, then the game sales will more than make up for manufacturing and repair expenses."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "console_domination_8_3",
	text = _T("CONSOLE_DOMINATION_8_3", "If you think you priced the console too aggressively, you can always decrease it's price after release. Keep in mind that bumping the price up will make people angrier than a price cut, so if you increase the price post-release, you'll have to deal with less sales in the long run."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "console_domination_9_2",
	nameID = "labcoat",
	id = "console_domination_9_1",
	uniqueDialogueID = "console_domination_9",
	image = game.getGameTypeData("scenario_console_domination").labCoatPortrait,
	text = _T("CONSOLE_DOMINATION_9_1", "Right, well, we've launched a platform, so my job here is done. You'll have to report to our investor friend here, so I'll go back to the hardware labs, since that's where my work is best suited."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "console_domination_9_3",
	id = "console_domination_9_2",
	text = _T("CONSOLE_DOMINATION_9_2", "If anything happens with the platform, I'll advise you on how to proceed."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "console_domination_9_4",
	id = "console_domination_9_3",
	text = _T("CONSOLE_DOMINATION_9_3", "One tip I can give you now is to make more games for your platform, since that way you'll be getting all 100% of the profit per each game copy sold, and making your platform more attractive to others. It's a win-win."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "console_domination_9_4",
	text = _T("CONSOLE_DOMINATION_9_4", "But you have to remain realistic. If the launch was bad, and it doesn't seem like the console can be saved, then there isn't anything you can do to save it. In that case it might be a better idea to discontinue the platform. Not right off the bat, mind you, but once enough time has passed."),
	answers = {
		"end_conversation_got_it"
	}
})

local gameTypeData = game.getGameTypeData("scenario_console_domination")

dialogueHandler.registerQuestion({
	nextQuestion = "console_domination_10_2",
	id = "console_domination_10_1",
	image = "the_investor_1",
	uniqueDialogueID = "console_domination_10",
	text = _T("CONSOLE_DOMINATION_10_1", "Let's get straight to business. While making money off games is a good venture, that's not what you're here for. This is your first product launch, but that doesn't mean the folks in charge of investing money into your operation will be pulling any punches."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "console_domination_10_3",
	id = "console_domination_10_2",
	text = _T("CONSOLE_DOMINATION_10_2", "So, the bottom line of this whole deal is this: you'll need to make a profit of $MONEY within TIME from consoles alone. And I stress this: from consoles alone. Games you make for it don't count, games that other developers make for them do count."),
	getText = function(self, dialogueObject)
		return _format(self.text, "MONEY", string.comma(gameTypeData.fundsToFinish), "TIME", timeline:getTimePeriodText(gameTypeData.timeLimit))
	end,
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "console_domination_10_4",
	id = "console_domination_10_3",
	text = _T("CONSOLE_DOMINATION_10_3", "Goes without saying that making games for your consoles is a fantastic way of keeping yourself afloat, and making the platform itself more attractive to potential customers, but you'll have to make sure your platforms are the source of this huge income, not your games."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "console_domination_10_4",
	text = _T("CONSOLE_DOMINATION_10_4", "Now, I hope we're on the same page, after all this is the job you signed up for! Good luck to you, and I hope you don't come up empty handed in TIME!"),
	getText = function(self, dialogueObject)
		return _format(self.text, "TIME", timeline:getTimePeriodText(gameTypeData.timeLimit))
	end,
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	id = "console_domination_timelimit",
	image = "the_investor_1",
	text = _T("CONSOLE_DOMINATION_TIMELIMIT", "Well friend, TIME have passed and those $MONEY are nowhere to be found. As unfortunate as it is, this business opportunity you had didn't come to proper fruition. Sorry, but it's over."),
	answers = {
		"generic_continue"
	},
	getText = function(self, dialogueObject)
		return _format(self.text, "TIME", timeline:getTimePeriodText(gameTypeData.timeLimit), "MONEY", string.comma(gameTypeData.fundsToFinish))
	end,
	onFinish = function()
		game.gameOver(_format(_T("CONSOLE_DOMINATION_GAMEOVER", "The investor has replaced you with someone else, because you didn't manage to make a profit of $MONEY in TIME."), "TIME", timeline:getTimePeriodText(gameTypeData.timeLimit), "MONEY", string.comma(gameTypeData.fundsToFinish)))
	end
})
dialogueHandler.registerQuestion({
	nextQuestion = "console_domination_dev_buyout_2",
	id = "console_domination_dev_buyout_1",
	uniqueDialogueID = "console_domination_dev_buyout",
	image = game.getGameTypeData("scenario_console_domination").labCoatPortrait,
	text = _T("CONSOLE_DOMINATION_DEV_BUYOUT_1", "Welcome to the ugly side of the console market. Well, as ugly as it can get if you take these things personally. To other manufacturers and game developers it's just business, so they'll take any advantage they can get."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "console_domination_dev_buyout_2",
	text = _T("CONSOLE_DOMINATION_DEV_BUYOUT_2", "There isn't anything you can do aside from offering game developers a better deal than your rivals can provide. In other words, you'll have to spend some of your funds on swaying the odds in your favor."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "console_domination_architecture_problems_2",
	id = "console_domination_architecture_problems_1",
	uniqueDialogueID = "console_domination_architecture_problems",
	image = game.getGameTypeData("scenario_console_domination").labCoatPortrait,
	text = _T("CONSOLE_DOMINATION_ARCHITECTURE_PROBLEMS_1", "Well this is unfortunate, and also embarassing, ahaha..."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "console_domination_architecture_problems_2",
	text = _T("CONSOLE_DOMINATION_ARCHITECTURE_PROBLEMS_2", "These things tend to happen every once in a while. Unfortunately, there isn't much we can do about this. We'll need to resolve whatever the problem is with the architecture, and that means more time needed."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "console_domination_firmware_crack_2",
	id = "console_domination_firmware_crack_1",
	uniqueDialogueID = "console_domination_firmware_crack",
	image = game.getGameTypeData("scenario_console_domination").labCoatPortrait,
	text = _T("CONSOLE_DOMINATION_FIRMWARE_CRACK_1", "Oof, now that's a big one. These things don't tend to happen very often, but when they do, you bet they're going to hit your sales."),
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "console_domination_firmware_crack_2",
	text = _T("CONSOLE_DOMINATION_FIRMWARE_CRACK_2", "One thing you can do to reduce the chances of these things happening is to provide more development time for your platform, and by more I mean over the minimum amount of time. That way the development team will be able to find more loopholes and patch them."),
	answers = {
		"end_conversation_got_it"
	}
})
dialogueHandler.registerQuestion({
	nextQuestion = "console_domination_finish_2",
	id = "console_domination_finish_1",
	image = "the_investor_1",
	uniqueDialogueID = "console_domination_finish",
	text = _T("CONSOLE_DOMINATION_FINISH_1", "Looks like you were the most fit candidate for the job after all! Congratulations, you've made those $MONEY that you were tasked with on time! Seems you can achieve some amazing things when given the chance to make a console."),
	getText = function(self, dialogueObject)
		return _format(self.text, "MONEY", gameTypeData.fundsToFinish)
	end,
	answers = {
		"generic_continue"
	}
})
dialogueHandler.registerQuestion({
	id = "console_domination_finish_2",
	text = _T("CONSOLE_DOMINATION_FINISH_2", "You've done a fine job, and the folks that invested money into your operation are no doubt happy about that. Whatever happens from this point onwards is up to you, so feel free to work on your studio in whatever way you wish. Good job on your hard efforts!"),
	answers = {
		"end_conversation"
	}
})
