extends Node

var score = 0

@onready var score_label: Label = $CanvasLayer/ScoreLabel

func add_point():
	score += 1
	score_label.text = 'Score: %s' % [str(score)]
	
