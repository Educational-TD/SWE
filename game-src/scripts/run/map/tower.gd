extends Control

signal select(tower: Control) ## Passes `self` to Map when selected
signal fire(tower: Control) ## Passes `self` to Map when attack cooldown expires

var is_selected: bool = false
const SELECTION_COLOR = Color(0.95, 0.95, 0.95, 0.67)
const SELECTION_WIDTH = 2
const SELECTION_SHADOW_COLOR = Color(0.95, 0.95, 0.95, 0.4)
const SELECTION_SHADOW_RADIUS = 55

@export var ExtraInfo: Control

var range: float = 269

func _draw() -> void:
	if is_selected:
		draw_circle(Vector2(0, 0), SELECTION_SHADOW_RADIUS, SELECTION_SHADOW_COLOR)
		draw_circle(Vector2(0, 0), range, SELECTION_COLOR, false, SELECTION_WIDTH, true)

func _on_hitbox_pressed() -> void:
	select.emit(self)


func toggle_selected() -> void:
	is_selected = not is_selected
	queue_redraw()
	ExtraInfo.visible = not ExtraInfo.visible

func _on_selected() -> void:
	if not is_selected:
		toggle_selected()

func _on_deselected() -> void:
	if is_selected:
		toggle_selected()


func _on_projectile_timer_timeout() -> void:
	fire.emit(self)
