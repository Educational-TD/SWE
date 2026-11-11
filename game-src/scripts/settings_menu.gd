extends Control
## This script handles all interaction logic within the settings menu

## Question difficulty
const Difficulty := Settings.Difficulty


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
@onready var keybind_list: VBoxContainer = keybind_popup.get_node("PanelContainer/MarginContainer/KeybindItemList")
## Keybind item template
@onready var keybind_item: PackedScene = preload("res://scenes/keybind_item.tscn")

var user_settings: Settings

# The player pressing escape will initiate exiting the settings menu
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		if keybind_popup.visible == true:
			keybind_popup.visible = false
		else:
			var changes = settings_unsaved()
			if changes.size() > 0:
				spawn_confirmation(changes)
			else:
				_back_to_title()

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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	user_settings = Settings.new() # get settings object
	
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
	keybind_popup.visible = false # ensure this starts hidden



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


## Change the scene back to the title menu
func _back_to_title() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


## Compares settings node values with currently saved settings.
##
## returns a list of strings with the name of each unsaved setting.
func settings_unsaved() -> PackedStringArray:
	var changes: PackedStringArray
	if volume_slider.value != user_settings.volume:
		changes.append("Volume")
	if difficulty_slider.value != user_settings.difficulty:
		changes.append("Difficulty")
	
	return changes


## Prevents the player from unintentionally not saving any changes 
## they make to the game settings.
func spawn_confirmation(changes: PackedStringArray) -> void:
	var confirmation = ConfirmationDialog.new()
	
	confirmation.dialog_text = ("The following settings have been modified"  
		+ " but not saved:\n\n" 
		+ "\n".join(changes)
		+ "\n"
	)
	confirmation.get_label().horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	confirmation.title = "Save Changes?"
	confirmation.ok_button_text = "Save"
	confirmation.cancel_button_text = "Don't Save"
	
	confirmation.confirmed.connect(func():
		save_changes()
		confirmation.queue_free()
	) # save if user clicks 'Save'
	confirmation.canceled.connect(func():
		_back_to_title()
		confirmation.queue_free()
	) # else go back to title
	
	add_child(confirmation)
	confirmation.popup_centered_clamped() # show confirmation


## Handles updating the visual representation of chosen difficulty level
func _on_difficulty_slider_value_changed(value: float) -> void:
	var selected: Difficulty = int(value) as Difficulty
	current_difficulty.text = Settings.DIFF_TO_STRING[selected]


## Handles updating the visual representation of chosen volume level
func _on_volume_slider_value_changed(value: float) -> void:
	var formatted := "%d%%"
	current_volume.text = (formatted % value)


## Handler for when player clicks the 'Back' button
func _on_back_label_gui_input(event: InputEvent) -> void:
	if is_left_click(event):
		var changes = settings_unsaved()
		if changes.size() > 0:
			spawn_confirmation(changes)
		else:
			_back_to_title()


## Handler for when the player clicks the 'Save' button
func _on_save_label_gui_input(event: InputEvent) -> void:
	if is_left_click(event):
		save_changes()
		_back_to_title() # TODO: decide if saving should go back to title


## Moves values from settings menu nodes into the actual Settings object
## and saves to file.
func save_changes() -> void:
	user_settings.difficulty = int(difficulty_slider.value)
	user_settings.volume = volume_slider.value
	user_settings.keybinds = Settings.default_keybinds ## TODO: change this
	user_settings.save_user_config()


## Gets the current keybind actions and their keycodes to populate the keybind
## config menu. After doing so the menu will be visible to the player.
func _keybinds_popup() -> void:
	InputMap.load_from_project_settings()
	
	for item in keybind_list.get_children():
		item.queue_free() # Clear list
	
	for action in user_settings.keybinds:
		var item := keybind_item.instantiate()
		var action_label: Label = item.find_child("KeybindActionLabel")
		var keycode: Label = item.find_child("KeybindKeycodeLabel")
		
		action_label.text = action.replace("_", " ") # upgrade_dmg -> upgrade dmg
		var temp = InputMap.action_get_events(action)
		keycode.text = temp[0].as_text().trim_suffix(" - Physical")
		
		item.pressed.connect(_on_input_button_pressed.bind(item, action))
		keybind_list.add_child(item)
	
	keybind_popup.visible = true
	
	
func _on_input_button_pressed(item, action) -> void:
	pass


## Sets up and makes visible the keybind config menu when 'edit keybinds...'
## is cliked
func _on_keybind_menu_gui_input(event: InputEvent) -> void:
	if is_left_click(event):
		_keybinds_popup()


## Hides the keybind config popup when the 'back' label is clicked
func _on_keybind_popup_back_gui_input(event: InputEvent) -> void:
	if is_left_click(event):
		keybind_popup.visible = false
