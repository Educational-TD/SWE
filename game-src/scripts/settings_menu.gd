extends Control
## This script handles all player interaction within the settings menu

# Difficulty nodes
@onready var _difficulty_hbox: HBoxContainer = $MarginContainer/VBoxContainer/DifficultyHBox
## Slider used to change the difficulty setting
@onready var difficulty_slider: HSlider = _difficulty_hbox.get_node("DifficultySlider")
## Visually represents the difficulty level
@onready var current_difficulty: Label = _difficulty_hbox.get_node("CurrentDifficultyLabel")
# Volume nodes
@onready var _volume_hbox: HBoxContainer = $MarginContainer/VBoxContainer/VolumeHBox
## Slider used to change the volume setting
@onready var volume_slider: HSlider = _volume_hbox.get_node("VolumeSlider")
## Visually represents the volume level
@onready var current_volume: Label = _volume_hbox.get_node("CurrentVolumeLabel")
# Keybind nodes
## Keybind popup menu
@onready var keybind_popup: Control = $KeybindPopup
## Item list of keybinds
@onready var keybind_list: VBoxContainer = keybind_popup.find_child("KeybindItemList")
## Keybind item template
@onready var keybind_item: PackedScene = preload("res://scenes/keybind_item.tscn")


const Difficulty := Settings.Difficulty ## Question difficulty
var user_settings: Settings = Settings.new() ## Current player settings
var _update_keybind: bool = false ## flag indicating if keybind is being remapped
var _action_to_remap: String = "" ## the action being currently remapped
var _keybind_item_to_remap: Button = null ## the visual representation of the keybing being remapped
var _changes_unsaved: Array[bool] = [false, false, false] ## flags indicating if changes are unsaved


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Setup difficulty slider and visual representation
	var diff = user_settings.difficulty # Current or default difficulty
	difficulty_slider.max_value = Difficulty.size() - 1 # 0 indexed
	current_difficulty.text = Settings.DIFF_TO_STRING[diff]
	difficulty_slider.value = diff

	# Setup volume slider and visual representation
	var volume = user_settings.volume
	current_volume.text = "%d%%" % volume
	volume_slider.value = volume

	# Setup keybinds menu
	keybind_popup.visible = false # ensure keybind popup begins hidden
	
	_changes_unsaved.fill(false)


# The player pressing escape will initiate exiting the settings menu
func _input(event: InputEvent) -> void:
	# Setting new keybind
	if (_update_keybind and event is InputEventKey): # Only allow keyboard inputs
		if !_has_keybind_conflict(event):
			_on_change_keybind(event)
			accept_event()
		else:
			pass # TODO: handle if keybind is already in use
	
	# Exiting menus
	if Input.is_action_just_pressed("escape"):
		if keybind_popup.visible == true:
			keybind_popup.visible = false
		else:
			var changes = _settings_unsaved()
			if changes.size() > 0:
				spawn_confirmation(changes)
			else:
				_back_to_title()

# ------- setting change handlers ------- #

## Handles updating the visual representation of chosen difficulty level
func _on_difficulty_slider_value_changed(value: float) -> void:
	var selected: Difficulty = int(value) as Difficulty
	user_settings.difficulty = selected
	current_difficulty.text = Settings.DIFF_TO_STRING[selected]
	_changes_unsaved[0] = true


## Handles updating the visual representation of chosen volume level
func _on_volume_slider_value_changed(value: float) -> void:
	var formatted := "%d%%"
	user_settings.volume = int(value)
	current_volume.text = (formatted % value)
	_changes_unsaved[1] = true


func _on_change_keybind(event: InputEventKey) -> void:
	user_settings.keybinds[_action_to_remap] = var_to_str(event)
	_keybind_item_to_remap.find_child("Keycode").text = _format_keybind_event(event)
	_changes_unsaved[2] = true

	_update_keybind = false
	_action_to_remap = ""
	_keybind_item_to_remap = null

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
		user_settings.save_user_config()
		_changes_unsaved.fill(false)
		_back_to_title() # TODO: decide if saving should go back to title


## Show the keybing config popup when 'edit keybinds...' is clicked
func _on_keybind_menu_gui_input(event: InputEvent) -> void:
	if is_left_click(event):
		_keybinds_popup()


## Hides the keybind config popup when the 'back' label is clicked
func _on_keybind_popup_back_gui_input(event: InputEvent) -> void:
	if is_left_click(event):
		keybind_popup.visible = false


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
		user_settings.save_user_config()
		_changes_unsaved.fill(false)
		confirmation.queue_free()
	) # save if user clicks 'Save'
	confirmation.canceled.connect(func():
		_back_to_title()
		confirmation.queue_free()
	) # else go back to title
	
	add_child(confirmation)
	confirmation.popup_centered_clamped() # show confirmation


## Gets the current keybind actions and their keycodes to populate the keybind
## config menu. After doing so the menu will be visible to the player.
func _keybinds_popup() -> void:
	InputMap.load_from_project_settings()
	
	for item in keybind_list.get_children():
		item.queue_free() # Clear list
	
	for action in user_settings.keybinds:
		var item: Button = keybind_item.instantiate()
		var action_label: Label = item.find_child("Action")
		var keycode: Label = item.find_child("Keycode")
		print(user_settings.keybinds[action]) # TODO: rmv this once setting changes are concrete
		action_label.text = action.replace("_", " ") # upgrade_dmg -> upgrade dmg
		var events = InputMap.action_get_events(action)
		keycode.text = _format_keybind_event(events[0])
		
		item.pressed.connect(_on_input_button_pressed.bind(item, action))
		keybind_list.add_child(item)
	
	keybind_popup.visible = true


## Removes the default ' - Physical' text from keyboard events
## 
## event - The user input event (i.e. 'p' key)
## returns the event string representation without the ' - Physical' suffix
func _format_keybind_event(event: InputEvent) -> String:
	return event.as_text().trim_suffix(" - Physical")


## Validate if a given key is already bound
##
## key - The new keybind
## returns true if this keybind is already in use, false otherwise
func _has_keybind_conflict(key: InputEventKey) -> bool:
	for action in InputMap.get_actions():
		for event in InputMap.action_get_events(action):
			if _format_keybind_event(event) == key.as_text():
				return true
	return false


## Sets up the next keyboard input to be used as a new keybind
##
## item - The visual representation of the action and keybind being changed
## action - The action being reassigned
func _on_input_button_pressed(item: Button, action: String) -> void:
	if not _update_keybind:
		_update_keybind = true
		_keybind_item_to_remap = item
		_action_to_remap = action
		item.find_child("Keycode").text = "Input new keybind..."
