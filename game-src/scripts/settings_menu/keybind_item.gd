extends Button

const _displacement := 5
const _duration := 0.04
var _starting_pos: Vector2

func _ready() -> void:
	_starting_pos = position

func shake() -> void:
	var tween = create_tween().set_loops(2) # Number of shakes
	tween.tween_property(self, "position:x", _starting_pos.x + _displacement, _duration)
	tween.tween_property(self, "position:x", _starting_pos.x - _displacement, _duration)
	tween.tween_property(self, "position:x", _starting_pos.x, _duration)
