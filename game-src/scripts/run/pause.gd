extends Control

@export var MenuDarken: Control
@export var OnPauseFocus: Control
@export var OnUnpauseFocus: Control

func _on_pause() -> void:
	MenuDarken.show()
	show()
	get_tree().paused = true
	OnPauseFocus.grab_focus.call_deferred()

func _on_unpause() -> void:
	MenuDarken.hide()
	hide()
	get_tree().paused = false
	OnUnpauseFocus.grab_focus.call_deferred()


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			_on_unpause()
		else:
			_on_pause()
