extends Node

@onready var pause_menu: CanvasLayer = $pause_menu
@onready var attempt_label: Label = $attempt_label

@onready var attempt_count_label: Label = $win_screen/Panel/labels/attempt_count
@onready var time_passed_label: Label = $win_screen/Panel/labels/time_passed

@export var time_passed: float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	attempt_label.text = "Attempt %s" % [AttemptNumber.attempt]
	attempt_count_label.text = "Attempts: %s" % [AttemptNumber.attempt-1] 
	time_passed_label.text = "Time: %s" % [time_passed] 

	
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		pause_menu.visible = true

func _on_continue_pressed() -> void:
	get_tree().paused = false
	pause_menu.visible = false

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_settings_pressed() -> void:
	pass # Replace with function body.

func _on_restart_pressed() -> void:
	AttemptNumber.attempt = 1
	get_tree().reload_current_scene()
