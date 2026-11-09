extends Control


const Difficulty = Settings.Difficulty

const DIFF_TO_STRING = {
	Difficulty.GRADE_6 : "Grade 6",
	Difficulty.GRADE_7 : "Grade 7",
	Difficulty.GRADE_8 : "Grade 8",
}

# Difficulty nodes
@onready var difficultyHBox: HBoxContainer = $MarginContainer/VBoxContainer/DifficultyHBox
@onready var difficultySlider: HSlider = difficultyHBox.get_node("DifficultySlider")
@onready var currentDifficulty: Label = difficultyHBox.get_node("CurrentDifficultyLabel")
# Volume nodes
@onready var volumeHBox: HBoxContainer = $MarginContainer/VBoxContainer/VolumeHBox
@onready var volumeSlider: HSlider = volumeHBox.get_node("VolumeSlider")
@onready var currentVolume: Label = volumeHBox.get_node("CurrentVolumeLabel")

var localSettings

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		back_to_title()


func is_left_click(event: InputEvent) -> bool:
	if (
		event is InputEventMouseButton 
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed()
	):
		return true
	else:
		return false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	localSettings = Settings.new() # get settings object
	
	difficultySlider.max_value = Difficulty.size() - 1 # 0 indexed
	
	var current_diff = localSettings.difficulty
	difficultySlider.value = current_diff
	currentDifficulty.text = DIFF_TO_STRING[current_diff]
	volumeSlider.value = localSettings.volume
	
	print("local settings %s" % localSettings)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func back_to_title() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_difficulty_slider_value_changed(value: float) -> void:
	var selected = int(value) as Difficulty
	currentDifficulty.text = DIFF_TO_STRING[selected]


func _on_volume_slider_value_changed(value: float) -> void:
	var formatted := "%d%%"
	currentVolume.text = (formatted % value)


func _on_back_label_gui_input(event: InputEvent) -> void:
	if (is_left_click(event)):
		back_to_title()


func _on_save_label_gui_input(event: InputEvent) -> void:
	if (is_left_click(event)):
		localSettings.difficulty = difficultySlider.value
		localSettings.volume = volumeSlider.value
		localSettings.save_user_config()
		back_to_title()
