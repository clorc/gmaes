extends Area2D

enum OrbType { YELLOW, PINK, BLUE }

const YELLOW_JUMP_VELOCITY = -350.0
const PINK_JUMP_VELOCITY = -250.0

@onready var player: CharacterBody2D = $"../../../../player"

@onready var orb_circle: AnimationPlayer = $orb_circle/AnimationPlayer
@onready var orb_effect: AnimationPlayer = $"../orb_effect/AnimationPlayer"
@export var type: OrbType

func _process(_delta: float) -> void:
	if overlaps_body(player):
		if Input.is_action_pressed("jump") and not player.buffer_triggered:
			orb_effect.play("orb_effect")
			player.buffer_triggered = true
			
			match type:
				OrbType.YELLOW:
					player.velocity.y = player.gravity_direction*player.gravity_multiplier*YELLOW_JUMP_VELOCITY
				
				OrbType.PINK:
					player.velocity.y = player.gravity_direction*player.gravity_multiplier*PINK_JUMP_VELOCITY
					
				OrbType.BLUE: 
					player.gravity_direction *= -1
					player.velocity.y = 0
					
		if Input.is_action_just_released("jump"):
			player.buffer_triggered = false

func _on_body_entered(_body: Node2D) -> void:	
	orb_circle.play("orb_circle_effect")
	
