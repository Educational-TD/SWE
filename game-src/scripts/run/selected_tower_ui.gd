extends Control

func _on_selected_tower_update(has_selected_tower: bool, tower: Control) -> void:
	if has_selected_tower:
		offset_transform_rotation = tower.get_node("TowerGraphics").rotation
		show()
	else:
		hide()
