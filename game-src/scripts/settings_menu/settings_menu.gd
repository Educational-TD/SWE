extends Control
## This script handles all player interaction within the settings menu

var _difficulty_change := false
var _volume_change := false
var _keybind_change := false

@onready var difficulty = $MarginContainer/VBoxContainer/DifficultyHBox
@onready var volume = $MarginContainer/VBoxContainer/VolumeHBox
@onready var keybind = $MarginContainer/VBoxContainer/KeybindHBox
@onready var confirmation_popup = %ConfirmationPopup

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Setup listeners for setting change signals
	difficulty.difficulty_change.connect(func(flag): _difficulty_change = flag)
	volume.volume_change.connect(func(flag): _volume_change = flag)
	keybind.keybind_change.connect(func(flag): _keybind_change = flag)


# The player pressing escape will initiate exiting the settings menu
func _input(_event: InputEvent) -> void:
	# Exiting menus
	if Input.is_action_just_pressed("ui_cancel"):
		var changes = _settings_unsaved()
		if confirmation_popup.is_visible_in_tree():
			confirmation_popup.visible = false # hide if currently open
			$MarginContainer/VBoxContainer/DifficultyHBox/DifficultySlider.grab_focus()
		elif changes.size() > 0:
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
	var info: Label = confirmation_popup.find_child("InfoBox")
	info.text = ("The following settings have been modified"
		+" but not saved\n\n"
		+"\n".join(changes)
		+"\n"
	)
	
	confirmation_popup.visible = true # show confirmation_popup
	var save: Label = confirmation_popup.find_child("Save")
	save.call_deferred("grab_focus")


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
