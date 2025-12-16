extends Area2D

enum OrbType { YELLOW, PINK, BLUE }

const YELLOW_JUMP_VELOCITY = -350.0
const PINK_JUMP_VELOCITY = -250.0

@onready var orb_circle: AnimationPlayer = $orb_circle/AnimationPlayer
@onready var orb_effect: AnimationPlayer = $"../orb_effect/AnimationPlayer"
@export var type: OrbType

func _on_body_entered(body: Node2D) -> void:	
	orb_circle.play("orb_circle_effect")
	if Input.is_action_pressed("jump"):
		orb_effect.play("orb_effect")
		match type:
			OrbType.YELLOW:
				body.velocity.y = body.gravity_direction*body.gravity_multiplier*YELLOW_JUMP_VELOCITY
			
			OrbType.PINK:
				body.velocity.y = body.gravity_direction*body.gravity_multiplier*PINK_JUMP_VELOCITY
				
			OrbType.BLUE: 
				body.gravity_direction *= -1
