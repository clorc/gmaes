extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var roll_timer: Timer = $Timer

enum CharacterState { IDLE, WALKING, RUNNING, ROLLING, DEAD, MID_AIR }

@export var state = CharacterState.MID_AIR

const SPEED = 130.0
const JUMP_VELOCITY = -200.0
var speed_multiplier = 1.0

func jump(direction: float) -> void:
	if state == CharacterState.IDLE or state == CharacterState.WALKING:
		velocity.y = JUMP_VELOCITY
		state = CharacterState.MID_AIR
		
	elif state == CharacterState.RUNNING:
		roll_timer.start(0.2)
		state = CharacterState.ROLLING
		speed_multiplier = 3.0
		velocity.x = direction * speed_multiplier * SPEED
		animated_sprite.flip_h = bool(int(direction/2-0.5) % 2)
	
func move(direction: float) -> void:
	if direction and not state == CharacterState.DEAD and not state == CharacterState.ROLLING:
		if Input.is_action_pressed("run"):
			state = CharacterState.RUNNING
			speed_multiplier = 1.5
			
		else:
			state = CharacterState.WALKING
			speed_multiplier = 1.0
		
		velocity.x = direction * speed_multiplier * SPEED
		animated_sprite.flip_h = bool(int(direction/2-0.5) % 2)
		
	else:
		state = CharacterState.IDLE
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
func die() -> void:
	state = CharacterState.DEAD

func _on_timer_timeout() -> void:
	state = CharacterState.WALKING
	velocity.x = move_toward(velocity.x, 0, SPEED)
	print("TIMER DONE")

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	
	if not state == CharacterState.DEAD:
		if not state == CharacterState.ROLLING:
			move(direction)
			if not is_on_floor():
				state = CharacterState.MID_AIR
				velocity += get_gravity() * delta
				animated_sprite.play("jump")
			else:
				if direction == 0:
					animated_sprite.play("idle")
				else:
					animated_sprite.play("run")
			# Handle jump.
			if Input.is_action_pressed("jump") and not state == CharacterState.MID_AIR:
				jump(direction)
			
			
		else:
			if not is_on_floor():
				velocity += get_gravity() * delta
			
			animated_sprite.play("roll")
		
	else:
		animated_sprite.play("death")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
