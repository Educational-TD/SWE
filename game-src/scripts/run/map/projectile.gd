extends Sprite2D

var velocity = Vector2(0, 0)

func _process(delta: float) -> void:
	position += velocity * delta
