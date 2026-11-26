extends Node2D

signal selected_tower_update(has_selected_tower: bool, tower: Control)

var selected_tower: Control
var has_selected_tower: bool = false

func _on_tower_select(tower: Control) -> void:
	if has_selected_tower:
		selected_tower._on_deselected()
		if selected_tower == tower:
			has_selected_tower = false
			selected_tower_update.emit(false, tower)
			return
	
	has_selected_tower = true
	selected_tower = tower
	selected_tower_update.emit(true, tower)
	selected_tower._on_selected()


func _on_tower_fire(tower: Control) -> void:
	if has_selected_tower and (selected_tower == tower):
		selected_tower_update.emit(true, tower)
