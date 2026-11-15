extends Path2D

@export var path_width : int = 40
@export var path_color : Color = Color(0.97, 0.65, 0.39, 0.4)

func _draw() -> void:
	draw_polyline(curve.get_baked_points(), path_color, path_width)
