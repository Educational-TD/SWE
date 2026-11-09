extends Control

enum Difficulty {GRADE_6, GRADE_7, GRADE_8}

@onready var difficultySlider: HSlider = $MarginContainer/VBoxContainer/DifficultyHBox/DifficultySlider
@onready var currentDifficulty: Label = $MarginContainer/VBoxContainer/DifficultyHBox/CurrentDifficultyLabel
@onready var currentVolume: Label = $MarginContainer/VBoxContainer/VolumeHBox/CurrentVolumeLabel

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	difficultySlider.max_value = Difficulty.size() - 1
	difficultySlider.value_changed.connect(_difficulty_changed)


func _difficulty_changed(value: float) -> void:
	var difficulty: Difficulty = int(value) as Difficulty
	match difficulty:
		Difficulty.GRADE_6:
			currentDifficulty.text = "Grade 6"
		Difficulty.GRADE_7:
			currentDifficulty.text = "Grade 7"
		Difficulty.GRADE_8:
			currentDifficulty.text = "Grade 8"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_volume_slider_value_changed(value: float) -> void:
	var formatted := "%d%%"
	currentVolume.text = (formatted % value)
