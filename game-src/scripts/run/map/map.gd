extends Node2D

var selected_tower: Control
var has_selected_tower: bool = false

func _on_tower_select(tower: Control) -> void:
	if has_selected_tower:
		selected_tower._on_deselected()
		if selected_tower == tower:
			has_selected_tower = false
			return
	
	has_selected_tower = true
	selected_tower = tower
	selected_tower._on_selected()
