extends PanelContainer

@onready var index: Label = $HBoxContainer/Index 
@onready var score: Label = $HBoxContainer/Score
@onready var wave: Label = $HBoxContainer/Wave
@onready var time: Label = $HBoxContainer/Time
@onready var date: Label = $HBoxContainer/Date

const _grey: Color = Color("#1c1c1c9a")
const _blue: Color = Color("#0320269a")


func setup(index: String, score: String, wave: String, time: String, date: String) -> void:
	self.index.text = index
	self.score.text = score
	self.wave.text = wave
	self.time.text = time
	self.date.text = date
	_set_background(index)

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:

func update() -> void:
	_set_background(index.text)

func _set_background(index) -> void:
	var style := StyleBoxFlat.new()
	if (int(index) % 2 ==  0):
		style.bg_color = _grey
	else:
		style.bg_color = _blue
		
	self.add_theme_stylebox_override("panel", style)
