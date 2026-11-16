extends Control

func _on_new_game_gui_input(event: InputEvent) -> void:
	if (
		event is InputEventMouseButton 
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed()
	):
		fade_hello_world()
		print("Hello World")

func fade_hello_world() -> void:
	var tween = get_tree().create_tween()
	
	tween.tween_property($HelloWorld, "self_modulate:a", 1.0, 1.0) # fade in
	tween.tween_interval(1.0) # sleep 1 sec
	tween.tween_property($HelloWorld, "self_modulate:a", 0, 1.0) # fade out

# Credits inputEvent function to bring user to credit scene when credits is pressed	
func _on_credits_gui_input(event: InputEvent) -> void:
	if (
		event is InputEventMouseButton 
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed()
	):
		get_tree().change_scene_to_file("res://scenes/credits_screen/credits_screen.tscn")
