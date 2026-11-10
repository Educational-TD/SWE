extends Control


const Difficulty := Settings.Difficulty


# Difficulty nodes
@onready var difficulty_hbox: HBoxContainer = $MarginContainer/VBoxContainer/DifficultyHBox
@onready var difficulty_slider: HSlider = difficulty_hbox.get_node("DifficultySlider")
@onready var current_difficulty: Label = difficulty_hbox.get_node("CurrentDifficultyLabel")
# Volume nodes
@onready var volume_hbox: HBoxContainer = $MarginContainer/VBoxContainer/VolumeHBox
@onready var volume_slider: HSlider = volume_hbox.get_node("VolumeSlider")
@onready var current_volume: Label = volume_hbox.get_node("CurrentVolumeLabel")

var user_settings: Settings

# TODO: check if this is captured even in the confirmation popup
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		if not settings_unsaved():
			back_to_title()

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
	
	difficulty_slider.max_value = Difficulty.size() - 1 # 0 indexed
	
	var current_diff = user_settings.difficulty
	difficulty_slider.value = current_diff
	current_difficulty.text = Settings.DIFF_TO_STRING[current_diff]
	volume_slider.value = user_settings.volume


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func back_to_title() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func settings_unsaved() -> bool:
	var changes: PackedStringArray
	if volume_slider.value != user_settings.volume:
		changes.append("Volume")
	if difficulty_slider.value != user_settings.difficulty:
		changes.append("Difficulty")
	
	if changes.size() > 0:
		spawn_confirmation(changes)
		return true
	else:
		return false


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
	
	confirmation.confirmed.connect( func():
		save_changes()
		confirmation.queue_free()
	) # save if user clicks 'Save'
	confirmation.canceled.connect( func():
		back_to_title()
		confirmation.queue_free()
	) # else go back to title
	
	add_child(confirmation)
	confirmation.popup_centered_clamped() # show confirmation


func _on_difficulty_slider_value_changed(value: float) -> void:
	var selected: Difficulty = int(value) as Difficulty
	current_difficulty.text = Settings.DIFF_TO_STRING[selected]


func _on_volume_slider_value_changed(value: float) -> void:
	var formatted := "%d%%"
	current_volume.text = (formatted % value)


func _on_back_label_gui_input(event: InputEvent) -> void:
	if is_left_click(event):
		if not settings_unsaved():
			back_to_title()


func _on_save_label_gui_input(event: InputEvent) -> void:
	if is_left_click(event):
		save_changes()
		back_to_title() # TODO: decide if saving goes back to title

func save_changes() -> void:
	user_settings.difficulty = int(difficulty_slider.value)
	user_settings.volume = volume_slider.value
	user_settings.keybinds = {"test1": "test2"}
	user_settings.save_user_config()
