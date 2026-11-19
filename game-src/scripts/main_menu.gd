extends Control

var SCENES = {
	"run": "res://scenes/run/run.tscn",
	"settings": "res://scenes/settings_menu/settings_menu.tscn",
	"scoreboard": "res://scenes/scoreboard/scoreboard.tscn",
	"credits": "res://scenes/credits_screen/credits_screen.tscn",
}


func _ready() -> void:
	$MarginContainer/VBoxContainer/MenuOptions/NewRun.grab_focus()


func _on_new_game_gui_input(event: InputEvent) -> void:
	if (
		Input.is_action_just_pressed("ui_accept")
		or event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed()
	):
		transition_scene(SCENES["run"])
	

func _on_settings_gui_input(event: InputEvent) -> void:
	if (
		Input.is_action_just_pressed("ui_accept")
		or event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed()
	):
		Settings.scene_to_return = "res://scenes/main_menu.tscn"
		transition_scene(SCENES["settings"])


# Credits inputEvent function to bring user to credit scene when credits is pressed	
func _on_credits_gui_input(event: InputEvent) -> void:
	if (
		Input.is_action_just_pressed("ui_accept")
		or event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed()
	):
		transition_scene(SCENES["credits"])


func _on_scoreboard_gui_input(event: InputEvent) -> void:
	if (
		Input.is_action_just_pressed("ui_accept")
		or event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed()
	):
		get_tree().change_scene_to_file(SCENES["scoreboard"])


func transition_scene(path: String) -> void:
	get_tree().change_scene_to_file(path)


func _on_new_run_pressed() -> void:
	get_tree().change_scene_to_file(SCENES["run"])
