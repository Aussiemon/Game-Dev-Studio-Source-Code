local creditsSound = {}

creditsSound.name = "main_menu_credits"
creditsSound.sound = {
	"sounds/ui/main_menu/creditsPicFrame.wav"
}
creditsSound.soundType = "static"
creditsSound.looping = false
creditsSound.volume = sounds.volume
creditsSound.volumeType = sound.VOLUME_TYPES.EFFECTS
creditsSound.noVolumeAdjust = true
creditsSound.playAlways = true

register.newSoundData(creditsSound)
register.newSoundChannel("main_menu_credits", 1)

local optionsSound = {}

optionsSound.name = "main_menu_options"
optionsSound.sound = {
	"sounds/ui/main_menu/openSettingsFileCab.wav"
}
optionsSound.soundType = "static"
optionsSound.looping = false
optionsSound.volume = sounds.volume
optionsSound.volumeType = sound.VOLUME_TYPES.EFFECTS
optionsSound.noVolumeAdjust = true
optionsSound.playAlways = true

register.newSoundData(optionsSound)
register.newSoundChannel("main_menu_options", 1)

local exitGame = {}

exitGame.name = "main_menu_exit"
exitGame.sound = {
	"sounds/ui/main_menu/exitGameDoor.wav"
}
exitGame.soundType = "static"
exitGame.looping = false
exitGame.volume = sounds.volume
exitGame.volumeType = sound.VOLUME_TYPES.EFFECTS
exitGame.noVolumeAdjust = true
exitGame.playAlways = true

register.newSoundData(exitGame)
register.newSoundChannel("main_menu_exit", 1)

local loadGame = {}

loadGame.name = "main_menu_load_game"
loadGame.sound = {
	"sounds/ui/main_menu/loadGameCalendar.wav"
}
loadGame.soundType = "static"
loadGame.looping = false
loadGame.volume = sounds.volume
loadGame.volumeType = sound.VOLUME_TYPES.EFFECTS
loadGame.noVolumeAdjust = true
loadGame.playAlways = true

register.newSoundData(loadGame)
register.newSoundChannel("main_menu_load_game", 1)

local newGame = {}

newGame.name = "main_menu_new_game"
newGame.sound = {
	"sounds/ui/main_menu/newGameTyping.wav"
}
newGame.soundType = "static"
newGame.looping = false
newGame.volume = sounds.volume
newGame.volumeType = sound.VOLUME_TYPES.EFFECTS
newGame.noVolumeAdjust = true
newGame.playAlways = true

register.newSoundData(newGame)
register.newSoundChannel("main_menu_new_game", 1)
