extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Uses a default input map to return back to title screen upon release of esc key
	if(Input.is_action_just_released("ui_close_dialog")):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
