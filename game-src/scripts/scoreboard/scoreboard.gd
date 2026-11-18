extends Control

@onready var scores = $MarginContainer/VBoxContainer/Scores
const HighScore: PackedScene = preload("res://scenes/scoreboard/high_score.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_highscores()


func get_highscores() -> void:
	# Temp values
	for i in range(5):
		var newScore = HighScore.instantiate()
		scores.add_child(newScore)
		newScore.setup(
			str(i), 
			str(randi_range(1000, 9999)), 
			str(randi_range(1, 100)), 
			"playtime", 
			"date",
		)
	_sort_scores()


func _sort_scores() -> void:
	var all_scores = scores.get_children()
	all_scores.sort_custom(
		func(a,b): 
			return a.score.text.naturalnocasecmp_to(b.score.text) > 0
	)
	
	for i in range(all_scores.size()):
		all_scores[i].index.text = str(i + 1)
		scores.move_child(all_scores[i], i)
		all_scores[i].update()
