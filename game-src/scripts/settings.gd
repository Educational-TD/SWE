extends Node
## This class is used for accessing and changing player settings.
##
## Instantiating this class loads saved player settings (if they exist).
## The object's member variables can then be used to access the player
## settings more easily than using just a ConfigFile object.
##
## The settings available to the player are: difficulty, volume, and keybinds.

## Each grade represents a different question difficulty, higher is harder
enum Difficulty {
	GRADE_6,
	GRADE_7,
	GRADE_8,
}

## Mapping from enum value to string representation
const DIFF_TO_STRING = {
	Difficulty.GRADE_6: "Grade 6",
	Difficulty.GRADE_7: "Grade 7",
	Difficulty.GRADE_8: "Grade 8",
}


## The default keybindings
const default_keybinds: Dictionary[String, String] = {
	"upgrade_damage": "49",
	"upgrade_fire_rate": "50",
	"upgrade_range": "51",
}
const _file_path: String = "user://user_config.cfg" ## Default save location
var _settings_config: ConfigFile ## Stores loaded settings
## Question difficulty
var difficulty: Difficulty = Difficulty.GRADE_6
## Volume in range, 0 - 100
var volume: int = 50
 ## Game keybinds ["action": "keycode"]
var keybinds: Dictionary[String, String] = default_keybinds

## When this class is loaded the player config is loaded
func _ready() -> void:
	_settings_config = ConfigFile.new()
	var err = _settings_config.load(_file_path)
	
	if err != OK:
		pass # If loading config fails defaults get used
	else: # Get current settings
		difficulty = _settings_config.get_value(
			"UserSettings",
			"difficulty",
			Difficulty.GRADE_6,
		)
		volume = _settings_config.get_value(
			"UserSettings",
			"volume",
			50,
		)
		keybinds = _settings_config.get_value(
			"UserSettings",
			"keybinds",
			default_keybinds.duplicate(),
		)

## Save local settings into the ConfigFile object and save to default location.
func save_user_config() -> void:
	# set values
	_settings_config.set_value("UserSettings", "difficulty", difficulty)
	_settings_config.set_value("UserSettings", "volume", volume)
	_settings_config.set_value("UserSettings", "keybinds", keybinds)
	# save config to file system
	var err = _settings_config.save(_file_path)
	
	if err != OK:
		# TODO: handle this error case, add to use case possibly
		print("error in saving config")
