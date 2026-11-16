extends Button

enum TowerAttributes {DAMAGE, FIRE_RATE, RANGE}
@export var attribute : TowerAttributes
@export var QuestionMenu : Control

func _pressed() -> void:
	QuestionMenu.show()
	var success = await QuestionMenu.ask_question()
	QuestionMenu.hide()
