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
