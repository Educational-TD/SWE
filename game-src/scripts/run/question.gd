extends CenterContainer

@export var Answer: LineEdit
@export var Submit: Button

func ask_question() -> bool:
	await Submit.pressed
	Answer.text = ""
	return true
