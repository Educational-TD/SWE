extends Node
class_name Settings
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
	Difficulty.GRADE_6 : "Grade 6",
	Difficulty.GRADE_7 : "Grade 7",
	Difficulty.GRADE_8 : "Grade 8",
}

# TODO: change this to actual keybinds once we have that figured out
const default_keybinds: Dictionary[String, String] = {"test": "test"}
const _file_path: String = "user://user_config.cfg" ## Default save location

var difficulty: Difficulty ## Question difficulty
var volume: int ## Volume in range of 0 - 100
var keybinds: Dictionary[String, String] ## Game keybinds ["keys": "command"]
var _settings_config: ConfigFile ## Stores loaded settings

## On class construction, the player settings are loaded from the default
## save location and assigned to this class' instance variables.
func _init() -> void:
	_settings_config = ConfigFile.new()
	var err = _settings_config.load(_file_path)
	
	if err != OK: # if settings cannot be loaded use defaults
		difficulty = Difficulty.GRADE_6
		volume = 50
		keybinds = default_keybinds
	else: # Get current settings
		difficulty = _settings_config.get_value("UserSettings", "difficulty", Difficulty.GRADE_6)
		volume = _settings_config.get_value("UserSettings", "volume", 50)
		keybinds = _settings_config.get_value("UserSettings", "keybinds", default_keybinds)

## Save local settings into the ConfigFile obj and save to default location.
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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
