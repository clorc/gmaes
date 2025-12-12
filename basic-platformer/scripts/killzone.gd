extends Area2D

@onready var death_timer: Timer = $Timer
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _on_body_entered(body: Node2D) -> void:
	if not body.state == 4: 
		body.die()
		audio_stream_player.play()
		death_timer.start(1)
	
func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
