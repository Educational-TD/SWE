extends Button

enum TowerAttributes {DAMAGE, FIRE_RATE, RANGE}
@export var attribute : TowerAttributes
@export var QuestionMenu : Control

func _pressed() -> void:
	var success = await QuestionMenu.ask_question()
	grab_focus.call_deferred()
