extends HBoxContainer

@onready var confirmation_popup = %ConfirmationPopup

signal closed

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
		confirmation_popup.visible = false
		_back_to_title()


## Change the scene back to the title menu
func _back_to_title() -> void:
	if Settings.scene_to_return != "RUN":
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	else:
		closed.emit()

## Does not save unchanged settings and changes scene back to menu
func _on_dont_save_gui_input(event: InputEvent) -> void:
	if (
		Input.is_action_just_pressed("ui_accept")
		or event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed()
	):
		confirmation_popup.visible = false
		_back_to_title()
