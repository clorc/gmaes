extends Node

@onready var pause_menu: CanvasLayer = $pause_menu
@onready var attempt_label: Label = $attempt_label

@onready var attempt_count_label: Label = $win_screen/Panel/labels/attempt_count
@onready var time_passed_label: Label = $win_screen/Panel/labels/time_passed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:	
	update_attempt_counter()
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		pause_menu.visible = true

func update_attempt_counter() -> void:
	attempt_label.text = "Attempt %s" % [str(AttemptNumber.attempt)]

func update_winscreen_stats() -> void:
	var time_elapsed: float = TimeElapsed.get_time_elapsed()
	var minutes: float = roundf(time_elapsed/60)
	var seconds: float = fmod(time_elapsed, 60)
	
	attempt_count_label.text = "Attempts: %s" % [AttemptNumber.attempt-1] 
	time_passed_label.text = "Time: %02d:%02d" % [minutes, seconds] 

func _on_continue_pressed() -> void:
	get_tree().paused = false
	pause_menu.visible = false

func _on_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_restart_pressed() -> void:
	AttemptNumber.attempt += 1
	get_tree().paused = false
	get_tree().reload_current_scene()
