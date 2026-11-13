extends HBoxContainer

## Setup GUI on scene load
func _ready() -> void:
	# Setup difficulty slider and visual representation
	var diff = Settings.difficulty # Current or default difficulty
	$DifficultySlider.max_value = Settings.Difficulty.size() - 1 # 0 indexed
	$CurrentDifficultyLabel.text = Settings.DIFF_TO_STRING[diff]
	$DifficultySlider.value = diff

## Handles updating the visual representation of chosen difficulty level
func _on_difficulty_slider_value_changed(value: float) -> void:
	var selected: Settings.Difficulty = int(value) as Settings.Difficulty
	Settings.difficulty = selected
	$CurrentDifficultyLabel.text = Settings.DIFF_TO_STRING[selected]
