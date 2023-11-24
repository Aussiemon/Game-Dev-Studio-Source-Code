local button = {}

button.icon = "question_mark"
button.hoverText = {
	{
		font = "pix20",
		lineSpace = 6,
		text = _T("WORKSHOP_MOD_HELP_1", "Mod folders positioned within the 'mods_staging' will be read when creating the list of folders for uploading/updating a mod.")
	},
	{
		font = "pix20",
		text = _T("WORKSHOP_MOD_HELP_2", "In order to load a local mod (for development), you can create a folder named 'mods' and place your mod folder there. The difference between the 'mods_staging' and 'mods' folders is that in the 'mods_staging' folder there needs to be a sub-folder named 'files', where all the mod files are located, while in the 'mods' folder it needs to be in the mod folder itself. For example, the main.lua file would look like this: 'mods_staging/myMod/files/main.lua' and 'mods/myMod/main.lua' respectively.")
	}
}

gui.register("WorkshopModHelp", button, "IconButton")
