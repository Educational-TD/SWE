extends Control
## This script handles all player interaction within the settings menu

var _confirmation: ConfirmationDialog
var _difficulty_change := false
var _volume_change := false
var _keybind_change := false

@onready var difficulty = $MarginContainer/VBoxContainer/DifficultyHBox
@onready var volume = $MarginContainer/VBoxContainer/VolumeHBox
@onready var keybind = $MarginContainer/VBoxContainer/KeybindHBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	difficulty.difficulty_change.connect(func(flag): _difficulty_change = flag)
	volume.volume_change.connect(func(flag): _volume_change = flag)
	keybind.keybind_change.connect(func(flag): _keybind_change = flag)


# The player pressing escape will initiate exiting the settings menu
func _input(_event: InputEvent) -> void:
	# Exiting menus
	if Input.is_action_just_pressed("ui_cancel"):
		var changes = _settings_unsaved()
		if changes.size() > 0:
			spawn_confirmation(changes)
		else:
			_back_to_title()


## Compares settings node values with currently saved settings.
##
## returns a list of strings with the name of each unsaved setting.
func _settings_unsaved() -> PackedStringArray:
	var changes: PackedStringArray
	if _difficulty_change:
		changes.append("Difficulty")
	if _volume_change:
		changes.append("Volume")
	if _keybind_change:
		changes.append("Keybinds")

	return changes


## Prevents the player from unintentionally not saving any changes 
## they make to the game settings.
func spawn_confirmation(changes: PackedStringArray) -> void:
	_confirmation = ConfirmationDialog.new()
	
	_confirmation.dialog_text = ("The following settings have been modified"
		+" but not saved:\n\n"
		+"\n".join(changes)
		+"\n"
	)
	_confirmation.get_label().horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_confirmation.title = "Save Changes?"
	_confirmation.ok_button_text = "Save"
	_confirmation.cancel_button_text = "Don't Save"
	
	_confirmation.confirmed.connect(
		func():
			Settings.save_user_config()
			_back_to_title()
			_confirmation.queue_free()
	) # save if user clicks 'Save'
	var cancel_btn := _confirmation.get_cancel_button()
	cancel_btn.pressed.connect(
		func():
			Settings.load_from_config() # Reset Settings attributes
			_back_to_title()
			_confirmation.queue_free()
	) # exit without saving if they click 'Don't Save"
	
	add_child(_confirmation)
	_confirmation.popup_centered_clamped() # show _confirmation


## Change the scene back to the title menu
func _back_to_title() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


## Handler for when the player clicks the 'Save' button
func _on_save_label_gui_input(event: InputEvent) -> void:
	if (
		Input.is_action_just_pressed("ui_accept")
		or event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed()
	):
		Settings.save_user_config()
		_back_to_title()


## Handler for when player clicks the 'Back' button
func _on_back_label_gui_input(event: InputEvent) -> void:
	if (
		Input.is_action_just_pressed("ui_accept")
		or event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed()
	):
		var changes = _settings_unsaved()
		if changes.size() > 0:
			spawn_confirmation(changes)
		else:
			_back_to_title()
