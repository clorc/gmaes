extends Node2D

@onready var color_rect: ColorRect = $"../ColorRect"
@onready var timer: Timer = $"../ColorRect/Timer"
@onready var animation_player: AnimationPlayer = $"../ColorRect/AnimationPlayer"

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/level.tscn")

func _on_play_pressed() -> void:
	timer.start(0.2)
	color_rect.visible = true
	animation_player.play("fade_out")

func _on_exit_pressed() -> void:
	get_tree().quit()
