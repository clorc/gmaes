extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if not body.state == 2:
		print("die")
		body.die()
