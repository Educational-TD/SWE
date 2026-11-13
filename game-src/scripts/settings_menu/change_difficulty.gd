extends HBoxContainer

signal difficulty_change(flag: bool) ## Change setting indicator

var _start_difficulty: Settings.Difficulty ## Intial difficulty

# Setup GUI on scene load
func _ready() -> void:
	# Setup difficulty slider and visual representation
	_start_difficulty = Settings.difficulty # Current or default difficulty
	$DifficultySlider.max_value = Settings.Difficulty.size() - 1 # 0 indexed
	$CurrentDifficultyLabel.text = Settings.DIFF_TO_STRING[_start_difficulty]
	$DifficultySlider.value = _start_difficulty
	$DifficultySlider.grab_focus()

## Handles updating the visual representation of chosen difficulty level
func _on_difficulty_slider_value_changed(value: float) -> void:
	var selected: Settings.Difficulty = int(value) as Settings.Difficulty
	Settings.difficulty = selected
	$CurrentDifficultyLabel.text = Settings.DIFF_TO_STRING[selected]
	difficulty_change.emit(_start_difficulty != selected) # emit true if changed
