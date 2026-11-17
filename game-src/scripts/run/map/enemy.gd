extends PathFollow2D

@export var velocity: float = 100
@export var sides: int = 3
@export var color: Color = Color.DARK_ORANGE
@export var radius: int = 30
@export var width: int = 5

func get_regular_polygon(sides: int) -> PackedVector2Array:
	var vertices = PackedVector2Array()
	for v in sides + 1:
		vertices.append(Vector2(radius,0).rotated(v * 2 * PI / sides))
	return vertices
func _draw() -> void:
	draw_polyline(get_regular_polygon(sides), color, width)

func _process(delta: float) -> void:
	progress += velocity * delta
	if progress_ratio >= 1:
		queue_free()
