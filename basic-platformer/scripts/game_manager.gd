extends Node

@export var score = 0
@onready var score_label: Label = $CanvasLayer/ScoreLabel
@onready var panel: Panel = $CanvasLayer/Panel

func add_point() -> void:
	score += 1
	score_label.text = 'Score: %s' % [str(score)]
	
	if score == 8:
		get_tree().paused = true
		panel.visible = true

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_exit_button_pressed() -> void:
	get_tree().quit()
