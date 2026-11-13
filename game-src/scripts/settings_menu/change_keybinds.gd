extends HBoxContainer

# Keybind nodes
## Keybind popup menu
@onready var keybind_popup = %KeybindPopup
## Item list of keybinds
@onready var keybind_list: VBoxContainer = keybind_popup.find_child("KeybindItemList")
## Back button for keybind config popup
@onready var keybind_back: Label = keybind_popup.find_child("KeybindPopupBack")
## Keybind item template
const KeybindItemScene: PackedScene = preload("res://scenes/settings_menu/keybind_item.tscn")
const KeybindItem := preload("res://scripts/settings_menu/keybind_item.gd")

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
			accept_event()
	# Exiting popup
	if Input.is_action_just_pressed("ui_cancel"):
		if keybind_popup.visible == true:
			keybind_popup.visible = false
			$"KeybindMenu".grab_focus() # focus back to 'edit keybind' on popup exit
			accept_event()


# Ensure keybind config popup isn't shown on scene entry
func _ready() -> void:
	_start_keybinds = Settings.keybinds.duplicate()
	keybind_popup.visible = false


## Gets the current keybind actions and their keycodes to populate the keybind
## config menu. After doing so the menu will be visible to the player.
func _keybinds_popup() -> void:
	# Load a fresh popup
	_reset_keybind_change()
	for item in keybind_list.get_children():
		item.queue_free()

	var buttons: Array[Button] = []
	for action in Settings.keybinds:
		var item: Button = KeybindItemScene.instantiate()
		var action_label: Label = item.find_child("Action")
		var keycode: Label = item.find_child("Keycode")
		var events = InputMap.action_get_events(action)

		action_label.text = action.replace("_", " ").capitalize() # upgrade_dmg -> upgrade dmg
		keycode.text = _format_keybind_event(events[0])
		item.pressed.connect(_on_input_button_pressed.bind(item, action))
		keybind_list.add_child(item)
		buttons.append(item)

	keybind_popup.visible = true
	_set_focus(buttons)
	keybind_back.call_deferred("grab_focus")


## Set the focus neighbors for all nodes of the keybind config popup
##
## list - Dynamic list of keybinds that can be changed
func _set_focus(list: Array[Button]) -> void:
	var node_count := list.size()
	var back_btn_path: NodePath = keybind_back.get_path()
	
	if node_count > 0:
		for i in range(node_count):
			var top: NodePath
			var bottom: NodePath
			if i == 0:
				var btn_path: NodePath = list[i].get_path()
				top = back_btn_path
				bottom = list[i + 1].get_path()
				keybind_back.focus_neighbor_bottom = btn_path
				keybind_back.focus_neighbor_right = btn_path
			elif i == node_count - 1:
				var btn_path: NodePath = list[i].get_path()
				top = list[i - 1].get_path()
				bottom = back_btn_path
				keybind_back.focus_neighbor_top = btn_path
				keybind_back.focus_neighbor_left = btn_path
			else:
				top = list[i - 1].get_path()
				bottom = list[i + 1].get_path()

			list[i].focus_mode = Control.FOCUS_ALL
			list[i].focus_neighbor_top = top
			list[i].focus_neighbor_left = top
			list[i].focus_neighbor_bottom = bottom
			list[i].focus_neighbor_right = bottom


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


## Validate if a given key is already bound
##
## key - The new keybind
## returns true if this keybind is already in use, false otherwise
func _has_keybind_conflict(key: InputEventKey) -> bool:
	for action in InputMap.get_actions():
		if action == _action_to_remap: # allow set back to current keybind
			continue
		for event in InputMap.action_get_events(action):
			if event.is_match(key):
				return true
	return false


## If a keybind isn't already in use, save the new keybind
##
## event - The new keybind
func _on_change_keybind(event: InputEventKey) -> void:
	Settings.keybinds[_action_to_remap] = var_to_str(event) # Update settings config
	_update_input_map(_action_to_remap, event) # Update keybind immediately
	_keybind_item_to_remap.find_child("Keycode").text = _format_keybind_event(event)
	
	for key in _start_keybinds:
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
## action - The action for which to set a new keybind
## event - The new keybinding
func _update_input_map(action: String, event: InputEvent) -> void:
	InputMap.action_erase_events(action) # remove existing keybind
	InputMap.action_add_event(action, event) # add new keybind


## Hides the keybind config popup when the 'back' label is clicked
func _on_keybind_popup_back_gui_input(event: InputEvent) -> void:
	if (
		Input.is_action_just_pressed("ui_accept")
		or event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed()
	):
		keybind_popup.visible = false
		$"KeybindMenu".grab_focus() # focus back to 'edit keybind' on popup exit


## Show the keybing config popup when 'edit keybinds...' is clicked
func _on_keybind_menu_gui_input(event: InputEvent) -> void:
	if (
		Input.is_action_just_pressed("ui_accept")
		or event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed()
	):
		_keybinds_popup()


## Resets the keybinds to the default settings
func _on_defaults_label_gui_input(event: InputEvent) -> void:
	if (
		Input.is_action_just_pressed("ui_accept")
		or event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed()
	):
		Settings.keybinds = Settings.default_keybinds.duplicate()
		for action in Settings.keybinds:
			var default_event := InputEventKey.new()
			var keycode := OS.find_keycode_from_string(Settings.keybinds[action])
			default_event.physical_keycode = keycode
			_update_input_map(action, default_event)
