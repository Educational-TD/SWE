extends Button

const SETTINGS_MENU = preload("res://scenes/settings_menu/settings_menu.tscn")

@onready var ui: CanvasLayer = %SettingsMenu

var _settings: Control = null

func _pressed() -> void:
	Settings.scene_to_return = "RUN"
	_settings = SETTINGS_MENU.instantiate()
	ui.add_child(_settings)
	_settings.closed.connect(_on_close)
	

func _on_close() -> void:
	_settings.queue_free()
	%SettingsBtn.grab_focus.call_deferred()
