extends Node2D

signal successful_fire(tower: Control)

@export var Enemies: Node2D

var projectile = preload("res://scenes/run/projectile.tscn")
const PROJECTILE_SPEED = 1200

func _on_tower_fire(tower: Control) -> void:
	if Enemies.get_child_count() == 0:
		return
	
	var least_distance = 1000000
	var closest_enemy: Node2D = null
	for Enemy in Enemies.get_children():
		var distance = tower.position.distance_to(Enemy.position)
		if distance < least_distance:
			least_distance = distance
			closest_enemy = Enemy
	if least_distance > tower.range:
		return
	
	var delta = closest_enemy.position - tower.position # TODO: Make towers lead their shots
	var proj = projectile.instantiate()
	proj.position = tower.position
	proj.velocity = PROJECTILE_SPEED * delta.normalized()
	add_child(proj) # TODO: Delete projectiles when they get too far away
	
	tower.get_node("TowerGraphics").rotation = atan2(delta.y, delta.x)
	successful_fire.emit(tower)
