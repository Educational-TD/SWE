extends Control

var SCENES = {
	"title": "res://scenes/main_menu.tscn",
	"game": "res://scenes/run/run.tscn",
	"settings": "res://scenes/settings_menu/settings_menu.tscn"
}


func _ready() -> void:
	$MarginContainer/VBoxContainer/MenuOptions/NewGame.grab_focus()

func _on_new_game_gui_input(event: InputEvent) -> void:
	if (
		Input.is_action_just_pressed("ui_accept")
		or event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed()
	):
		transition_scene(SCENES["game"])

func _on_settings_gui_input(event: InputEvent) -> void:
	if (
		Input.is_action_just_pressed("ui_accept")
		or event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed()
	):
		transition_scene(SCENES["settings"])


func transition_scene(path: String) -> void:
	get_tree().change_scene_to_file(path)
