extends CharacterBody2D

enum CharacterState { MIDAIR, ONFLOOR, DEAD }
enum GameMode { CUBE, SHIP, UFO, BALL}

@onready var cube_sprite: Node2D = $player_sprites/cube
@onready var ship_sprite: Node2D = $player_sprites/ship
@onready var ufo_sprite: Node2D = $player_sprites/ufo
@onready var ball_sprite: Node2D = $player_sprites/ball

@onready var death_explosion: AnimatedSprite2D = $death_explosion
@onready var timer: Timer = $Timer

const SPEED = 300.0
const JUMP_VELOCITY = -300.0
const ANGULAR_VELOCITY = 327

@export var gravity_direction = 1
@export var mode = GameMode.CUBE
@export var state = CharacterState.ONFLOOR


func die() -> void:
	if not state == CharacterState.DEAD:
		state = CharacterState.DEAD
		get_node("death_explosion").visible = true
		get_node("player_sprites").visible = false
		timer.start(1)
	
func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()

func cube_movement(delta: float) -> void:
	if state == CharacterState.MIDAIR:
		cube_sprite.rotation_degrees += gravity_direction * delta * ANGULAR_VELOCITY
	
	else:
		var target_rotation = round(cube_sprite.rotation_degrees/90.0)*90.0
		cube_sprite.rotation_degrees = move_toward(cube_sprite.rotation_degrees, target_rotation, delta*ANGULAR_VELOCITY*3)
		
	cube_sprite.rotation_degrees = fmod(cube_sprite.rotation_degrees, 360.0)
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y += JUMP_VELOCITY
	
func ship_movement() -> void:
	pass
	
func ufo_movement() -> void:
	pass
	
func ball_movement() -> void:
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not state == CharacterState.DEAD:
		velocity.x = SPEED
		
		# Handle jump.
		if not is_on_floor():
			velocity += gravity_direction * 1.2 * get_gravity() * delta
			state = CharacterState.MIDAIR
		else:
			state = CharacterState.ONFLOOR
			
		match mode:
			GameMode.CUBE:
				cube_movement(delta)
			
			GameMode.SHIP:
				ship_movement()
			
			GameMode.UFO:
				ufo_movement()
				
			GameMode.BALL:
				ball_movement()
	else:
		velocity = Vector2(0,0)
		death_explosion.play("death_explosion")

	move_and_slide()
	 
	if velocity.x == 0.0:
		die()
