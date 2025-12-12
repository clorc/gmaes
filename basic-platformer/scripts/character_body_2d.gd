extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 130.0
const JUMP_VELOCITY = -200.0
var speed_multiplier = 1.0

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	
	if Input.is_action_pressed("run"):
		speed_multiplier = 1.5
	else:
		speed_multiplier = 1.0

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		animated_sprite.play("jump")
	else:
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")

	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction:
		velocity.x = direction * speed_multiplier * SPEED
		
		animated_sprite.flip_h = bool(int(direction/2-0.5) % 2)
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
