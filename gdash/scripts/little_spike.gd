extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if not body.state == body.CharacterState.DEAD:
		body.die()
