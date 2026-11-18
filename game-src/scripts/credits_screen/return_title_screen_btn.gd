extends Button

# Returns the user back to title screen when title screen button is pressed
func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
