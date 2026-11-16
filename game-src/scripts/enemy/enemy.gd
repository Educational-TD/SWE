extends PathFollow2D

@export var velocity: float = 100

func _process(delta: float) -> void:
	progress += velocity * delta
	# if progress_ratio >= 1: # Turn off "Loop" as well
		# queue_free()
