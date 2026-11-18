extends ProgressBar

@export var timer: Timer

func _process(delta: float) -> void:
	value = timer.time_left / timer.wait_time
