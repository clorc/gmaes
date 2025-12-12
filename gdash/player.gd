extends CharacterBody2D


const ANGULAR_VELOCITY = 240.0
const JUMP_VELOCITY = -700.0

var angular = 0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += 2 * get_gravity() * delta
	
	# Handle rotation
	if not is_on_floor():
		rotation_degrees += angular * delta
		print(rotation_degrees)
	else:
		rotation_degrees = round(rotation_degrees/90)*90
		angular = 0

	# Handle jump.
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		angular = ANGULAR_VELOCITY

	move_and_slide()
