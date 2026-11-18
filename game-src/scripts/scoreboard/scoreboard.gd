extends Control

@onready var scores = $MarginContainer/VBoxContainer/Scores
const HighScore: PackedScene = preload("res://scenes/scoreboard/high_score.tscn")

const _MONTHS = {
	0: "Jan",
	1: "Feb",
	2: "Mar",
	3: "Apr",
	4: "May",
	5: "Jun",
	6: "Jul",
	7: "Aug",
	8: "Sep",
	9: "Oct",
	10: "Nov",
	11: "Dec",
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_highscores()


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func get_highscores() -> void:
	var same_wave = "12" # Simulate same score sorting
	var same_time = "12:34:56" # Simulate same time sorting
	# Temp values
	for i in range(5):
		var newScore = HighScore.instantiate()
		scores.add_child(newScore)
		# TODO: Replace this with real values
		var temp_wave = _temp_wave() if i % 2 == 1 else same_wave
		var temp_time = same_time if i in [0,2] else _temp_time()
		newScore.setup(
			str(i), 
			_temp_score(temp_wave), 
			temp_wave, 
			temp_time, 
			_temp_date(),
		)
	_sort_scores()


# TEMPORARY METHOD FOR UI PROTOTYPE
func _temp_score(wave: String) -> String:
	return wave+"0"

func _temp_wave() -> String:
	return str(randi_range(1, 100))

# TEMPORARY METHOD FOR UI PROTOTYPE
func _temp_date() -> String:
	var month = randi_range(0, 11)
	var day = randi_range(1, 30)
	#var year = randi_range(2026, 2030)
	
	return "%s %02d, %d" % [_MONTHS[month], day, 2012]


# TEMPORARY METHOD FOR UI PROTOTYPE
func _temp_time() -> String:
	var hour = randi_range(0, 100)
	var minute = randi_range(0, 59)
	var second = randi_range(0, 59)
	
	return "%02d:%02d:%02d" % [hour, minute, second]


func _sort_scores() -> void:
	var all_scores = scores.get_children()
	all_scores.sort_custom(_compare_score)
	
	for i in range(all_scores.size()):
		all_scores[i].index.text = str(i + 1)
		scores.move_child(all_scores[i], i)
		all_scores[i].update()

func _compare_score(score1, score2) -> bool:
	var comp = score1.score.text.naturalnocasecmp_to(score2.score.text)
	if comp == 0: # Tie
		return _compare_playtime(score1, score2)
	else:
		return comp > 0 # Higher score goes first


func _compare_playtime(score1, score2) -> bool:
	var comp = score1.time.text.naturalnocasecmp_to(score2.time.text)
	if comp == 0:
		return _compare_date(score1, score2)
	else:
		return comp < 0 # Less playtime comes first


# TODO: Actually implement this in clean way
func _compare_date(score1, score2) -> bool:
	var date1 = score1.date.text.split(",")
	var date2 = score2.date.text.split(",")
	var year1 = date1[1].substr(date1[1].length() - 4)
	var year2 =	date2[1].substr(date2[1].length() - 4)
	var month1 = _MONTHS.find_key(date1[0].substr(0, 3))
	var month2 = _MONTHS.find_key(date2[0].substr(0, 3))
	var day1 = date1[0].substr(4)
	var day2 =	date2[0].substr(4)
	
	var comp1 = "%s%02d%s" % [year1, month1, day1]
	var comp2 = "%s%02d%s" % [year2, month2, day2]
	return comp1.naturalnocasecmp_to(comp2) < 0 # Earlier date comes first


func _on_back_gui_input(event: InputEvent) -> void:
	if (
		Input.is_action_just_pressed("ui_accept")
		or event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed()
	):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
