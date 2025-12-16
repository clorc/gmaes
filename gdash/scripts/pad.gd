extends Area2D

enum PadType { YELLOW, PINK, BLUE }

const YELLOW_JUMP_VELOCITY = -300.0
const PINK_JUMP_VELOCITY = -250.0

@export var type: PadType

func _on_body_entered(body: Node2D) -> void:
	match type:
		PadType.YELLOW:
			body.velocity.y = body.gravity_direction*body.gravity_multiplier*YELLOW_JUMP_VELOCITY
		
		PadType.PINK:
			body.velocity.y = body.gravity_direction*body.gravity_multiplier*PINK_JUMP_VELOCITY
			
		PadType.BLUE: 
			body.gravity_direction *= -1
