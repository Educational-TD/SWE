extends Node
class_name Settings

enum Difficulty {GRADE_6, GRADE_7, GRADE_8}

# TODO: change this to actual keybinds
const default_keybinds: Dictionary[String, String]= {"test": "test"}
const file_path: String = "user://user_config.cfg"

var difficulty: Difficulty
var volume: int
var keybinds: Dictionary[String, String]
var settings_config: ConfigFile

# Initing this object load current settings
func _init() -> void:
	settings_config = ConfigFile.new()
	var err = settings_config.load(file_path)
	
	if err != OK: # if settings cannot be loaded use defaults
		difficulty = Difficulty.GRADE_6
		volume = 50
		keybinds = default_keybinds
	else:
		difficulty = settings_config.get_value("UserSettings", "difficulty", Difficulty.GRADE_6)
		volume = settings_config.get_value("UserSettings", "volume", 50)
		keybinds = settings_config.get_value("UserSettings", "keybinds", default_keybinds)


func save_user_config() -> void:
	# set values
	settings_config.set_value("UserSettings", "difficulty", difficulty)
	settings_config.set_value("UserSettings", "volume", volume)
	settings_config.set_value("UserSettings", "keybinds", keybinds)
	# save config to file system
	var err = settings_config.save(file_path)
	
	if err == OK:
		# TODO: handle this error case, add to use case possibly
		print("error in saving config")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
