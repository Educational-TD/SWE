extends HBoxContainer

@onready var confirmation_popup = %ConfirmationPopup


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	confirmation_popup.visible = false # ensure popup is hidden initially


## Saves unchanged settings and changes scene back to menu
func _on_save_gui_input(event: InputEvent) -> void:
	if (
		Input.is_action_just_pressed("ui_accept")
		or event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed()
	):
		Settings.save_user_config()
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		confirmation_popup.visible = false


## Does not save unchanged settings and changes scene back to menu
func _on_dont_save_gui_input(event: InputEvent) -> void:
	if (
		Input.is_action_just_pressed("ui_accept")
		or event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed()
	):
		Settings.load_from_config() # Reset Settings attributes
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		confirmation_popup.visible = false
