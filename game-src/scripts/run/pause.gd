extends TextureButton

@export var PauseMenu : Control

func _pressed() -> void:
	PauseMenu.show()
