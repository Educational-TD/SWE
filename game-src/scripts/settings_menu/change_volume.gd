extends HBoxContainer

## Setup GUI on scene load
func _ready() -> void:
	# Setup volume slider and visual representation
	var volume = Settings.volume
	$CurrentVolumeLabel.text = "%d%%" % volume
	$VolumeSlider.value = volume

## Handles updating the visual representation of chosen volume level
func _on_volume_slider_value_changed(value: float) -> void:
	var formatted := "%d%%"
	Settings.volume = int(value)
	$CurrentVolumeLabel.text = (formatted % value)
