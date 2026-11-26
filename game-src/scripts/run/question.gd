extends CenterContainer

@export var MenuDarken: Control
@export var Answer: LineEdit

## Answer submissions can be triggered by *either* the LineEdit
## or the Submit button. This merges these options to work in one await.
signal submit_answer(answer: String)
func _on_answer_submitted() -> void:
	submit_answer.emit(Answer.text)

func ask_question() -> bool:
	MenuDarken.show()
	show()
	Answer.grab_focus.call_deferred()
	
	var response = await submit_answer
	
	MenuDarken.hide()
	hide()
	Answer.text = ""
	return true
