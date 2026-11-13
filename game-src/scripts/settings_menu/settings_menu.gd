extends Control
## This script handles all player interaction within the settings menu

var _changes_unsaved: Array[bool] = [false, false, false] ## flags indicating if changes are unsaved


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	## Setup keybinds menu
	#keybind_popup.visible = false # ensure keybind popup begins hidden
	#
	#_changes_unsaved.fill(false)


# The player pressing escape will initiate exiting the settings menu
func _input(event: InputEvent) -> void:
	
	# Exiting menus
	if Input.is_action_just_pressed("escape"):
		var changes = _settings_unsaved()
		if changes.size() > 0:
			spawn_confirmation(changes)
		else:
			_back_to_title()


# ------- label click handlers ------- #

## Handler for when player clicks the 'Back' button
func _on_back_label_gui_input(event: InputEvent) -> void:
	if is_left_click(event):
		var changes = _settings_unsaved()
		if changes.size() > 0:
			spawn_confirmation(changes)
		else:
			_back_to_title()


## Handler for when the player clicks the 'Save' button
func _on_save_label_gui_input(event: InputEvent) -> void:
	if is_left_click(event):
		Settings.save_user_config()
		_changes_unsaved.fill(false)
		_back_to_title() # TODO: decide if saving should go back to title


## Validates if an event is a left mouse click
##
## event - The GUI input event
## returns true if the event is a left click, false otherwise
func is_left_click(event: InputEvent) -> bool:
	if (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed()
	):
		return true
	else:
		return false


## Change the scene back to the title menu
func _back_to_title() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


## Compares settings node values with currently saved settings.
##
## returns a list of strings with the name of each unsaved setting.
func _settings_unsaved() -> PackedStringArray:
	var changes: PackedStringArray
	if _changes_unsaved[0]:
		changes.append("Difficulty")
	if _changes_unsaved[1]:
		changes.append("Volume")
	if _changes_unsaved[2]:
		changes.append("Keybinds")
	
	return changes


## Prevents the player from unintentionally not saving any changes 
## they make to the game settings.
func spawn_confirmation(changes: PackedStringArray) -> void:
	var confirmation = ConfirmationDialog.new()
	
	confirmation.dialog_text = ("The following settings have been modified"
		+" but not saved:\n\n"
		+"\n".join(changes)
		+"\n"
	)
	confirmation.get_label().horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	confirmation.title = "Save Changes?"
	confirmation.ok_button_text = "Save"
	confirmation.cancel_button_text = "Don't Save"
	
	confirmation.confirmed.connect(func():
		Settings.save_user_config()
		_changes_unsaved.fill(false)
		confirmation.queue_free()
	) # save if user clicks 'Save'
	confirmation.canceled.connect(func():
		_back_to_title()
		confirmation.queue_free()
	) # else go back to title
	
	add_child(confirmation)
	confirmation.popup_centered_clamped() # show confirmation
