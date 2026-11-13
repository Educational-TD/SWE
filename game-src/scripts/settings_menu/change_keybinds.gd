extends HBoxContainer

# Keybind nodes
## Keybind popup menu
@onready var keybind_popup = %KeybindPopup
## Item list of keybinds
@onready var keybind_list: VBoxContainer = keybind_popup.find_child("KeybindItemList")
## Keybind item template
@onready var keybind_item: PackedScene = preload("res://scenes/settings_menu/keybind_item.tscn")

var _update_keybind: bool = false ## flag indicating if keybind is being remapped
var _action_to_remap: String = "" ## the action being currently remapped
var _keybind_item_to_remap: Button = null ## the visual representation of the keybing being remapped

signal keybind_change(flag: bool) ## Change setting indicator

var _start_keybinds: Dictionary[String, String] ## Initial keybinds

# Handle new keybind inputs
func _input(event) -> void:
	# Setting new keybind
	if (_update_keybind and event is InputEventKey): # Only allow keyboard inputs
		if !_has_keybind_conflict(event):
			_on_change_keybind(event)
			accept_event()
		else:
			_keybind_item_to_remap.shake() # Indicate invalid keybind
	# Exiting popup
	if Input.is_action_just_pressed("escape"):
		if keybind_popup.visible == true:
			keybind_popup.visible = false
			accept_event()


# Ensure keybind config popup isn't shown on scene entry
func _ready() -> void:
	_start_keybinds = Settings.keybinds.duplicate()
	keybind_popup.visible = false


## Gets the current keybind actions and their keycodes to populate the keybind
## config menu. After doing so the menu will be visible to the player.
func _keybinds_popup() -> void:
	#InputMap.load_from_project_settings()

	# Load a fresh popup
	_reset_keybind_change()
	for item in keybind_list.get_children():
		item.queue_free()

	for action in Settings.keybinds:
		var item: Button = keybind_item.instantiate()
		var action_label: Label = item.find_child("Action")
		var keycode: Label = item.find_child("Keycode")
		var events = InputMap.action_get_events(action)

		action_label.text = action.replace("_", " ").capitalize() # upgrade_dmg -> upgrade dmg
		keycode.text = _format_keybind_event(events[0])
		item.pressed.connect(_on_input_button_pressed.bind(item, action))
		keybind_list.add_child(item)
	
	keybind_popup.visible = true


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


## Removes the default ' - Physical' text from keyboard events
## 
## event - The user input event (i.e. 'p' key)
## returns the event string representation without the ' - Physical' suffix
func _format_keybind_event(event: InputEvent) -> String:
	return event.as_text().trim_suffix(" - Physical")


func is_left_click(event: InputEvent) -> bool:
	if (
		event is InputEventMouseButton 
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed()
	):
		return true
	else:
		return false


## Hides the keybind config popup when the 'back' label is clicked
func _on_keybind_popup_back_gui_input(event: InputEvent) -> void:
	if is_left_click(event):
		keybind_popup.visible = false


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


## If a keybind isn't already in use, save the new keybind
##
## event - The new keybind
func _on_change_keybind(event: InputEventKey) -> void:
	Settings.keybinds[_action_to_remap] = var_to_str(event) # Update settings config
	_update_input_map(event) # Update keybind immediately
	_keybind_item_to_remap.find_child("Keycode").text = _format_keybind_event(event)
	
	for key in _start_keybinds:
		print(_start_keybinds[key])
		print("\n\n")
		print(Settings.keybinds[key])
		if _start_keybinds[key] != Settings.keybinds[key]:
			keybind_change.emit(true) # emit true if any keybind changed
			break
		keybind_change.emit(false) # emit false if no keybinds are changed
	
	_reset_keybind_change()

## Resets the keybind change variables
func _reset_keybind_change() -> void:
	_update_keybind = false
	_action_to_remap = ""
	_keybind_item_to_remap = null


## Immediately update the InputMap
##
## event - The new keybinding
func _update_input_map(event: InputEvent) -> void:
	InputMap.action_erase_events(_action_to_remap) # remove existing keybind
	InputMap.action_add_event(_action_to_remap, event) # add new keybind
	#InputMap.action_sav


## Show the keybing config popup when 'edit keybinds...' is clicked
func _on_keybind_menu_gui_input(event: InputEvent) -> void:
	if is_left_click(event):
		_keybinds_popup()
