extends HBoxContainer

signal volume_change(flag: bool) ## Change setting indicator

var _start_volume: float ## Initial volume

# Setup GUI on scene load
func _ready() -> void:
	# Setup volume slider and visual representation
	_start_volume = Settings.volume
	$CurrentVolumeLabel.text = "%d%%" % (_start_volume * 100)
	$VolumeSlider.value = _start_volume

## Handles updating the visual representation of chosen volume level
func _on_volume_slider_value_changed(value: float) -> void:
	Settings.volume = value
	$CurrentVolumeLabel.text = ("%d%%" % (value * 100))
	volume_change.emit(_start_volume != value) # emit true if change, false if not
