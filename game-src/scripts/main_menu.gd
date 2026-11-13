extends Control

var SCENES = {
	"title": "res://scenes/main_menu.tscn",
	"settings": "res://scenes/settings_menu/settings_menu.tscn"
}


func is_left_click(event: InputEvent) -> bool:
	if (
		event is InputEventMouseButton 
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed()
	):
		return true
	else:
		return false


func _on_new_game_gui_input(event: InputEvent) -> void:
	if (is_left_click(event)):
		fade_hello_world()
		print("Hello World")


func fade_hello_world() -> void:
	var tween := get_tree().create_tween()
	
	tween.tween_property($HelloWorld, "self_modulate:a", 1.0, 1.0) # fade in
	tween.tween_interval(1.0) # sleep 1 sec
	tween.tween_property($HelloWorld, "self_modulate:a", 0, 1.0) # fade out
	


func _on_settings_gui_input(event: InputEvent) -> void:
	if (is_left_click(event)):
		transition_scene(SCENES["settings"])


func transition_scene(path: String) -> void:
	get_tree().change_scene_to_file(path)
