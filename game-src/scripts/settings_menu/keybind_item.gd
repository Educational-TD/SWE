extends Button

const _displacement := 5 ## Amount of pixels to move left/right
const _duration := 0.04 ## Time for each movement
var _starting_pos: Vector2 ## Initial position

# Save starting pos on init
func _ready() -> void:
	_starting_pos = position

## Briefly shakes a button left and right
func shake() -> void:
	var tween = create_tween().set_loops(2) # Number of shakes
	tween.tween_property(self, "position:x", _starting_pos.x + _displacement, _duration)
	tween.tween_property(self, "position:x", _starting_pos.x - _displacement, _duration)
	tween.tween_property(self, "position:x", _starting_pos.x, _duration)
