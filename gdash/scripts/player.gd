extends CharacterBody2D

enum CharacterState { MIDAIR, ONFLOOR, DEAD }
enum GameMode { CUBE, SHIP, UFO, BALL }

@onready var game_manager: Node = %game_manager
@onready var win_screen: CanvasLayer = $"../game_manager/win_screen"

@onready var player_trail: CPUParticles2D = $trails/player_trail
@onready var ship_trail: CPUParticles2D = $player_sprites/ship/ship_trail

@onready var cube_sprite: Node2D = $player_sprites/cube
@onready var ship_sprite: Node2D = $player_sprites/ship
@onready var ufo_sprite: Node2D = $player_sprites/ufo
@onready var ball_sprite: Node2D = $player_sprites/ball

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var death_explosion: AnimatedSprite2D = $death_explosion
@onready var timer: Timer = $Timer

@export_category("Player Properties")
@export var SPEED = 270.0
const JUMP_VELOCITY = -340.0
const UFO_VELOCITY = -340.0
const FLY_ACCELERATION = -2000
const ANGULAR_VELOCITY = 310

var ufo_target_angle = 0.0

@export var gravity_multiplier = 1.3
@export var gravity_direction = 1
@export var mode: GameMode
@export var state: CharacterState

func win() -> void:
	win_screen.visible = true
	get_tree().paused = true

func die() -> void:
	if not state == CharacterState.DEAD:
		state = CharacterState.DEAD
		AttemptNumber.attempt += 1
		get_node("death_explosion").visible = true
		get_node("player_sprites").visible = false
		timer.start(1)
		
func clear_sprites() -> void:
	cube_sprite.visible = false
	player_trail.emitting = false
	ship_sprite.visible = false
	ship_trail.emitting = false
	ufo_sprite.visible = false
	ball_sprite.visible = false
	
func switch_sprite(new_mode: GameMode) -> void:
	clear_sprites()
	
	match new_mode:
		GameMode.CUBE:
			cube_sprite.visible = true
			
		GameMode.SHIP:
			ship_sprite.visible = true
			
		GameMode.UFO:
			ufo_sprite.visible = true
			
		GameMode.BALL:
			ball_sprite.visible = true
	
func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()

func cube_movement(delta: float) -> void:
	var floor_normal = get_floor_normal()

	if state == CharacterState.MIDAIR:
		cube_sprite.rotation_degrees += gravity_direction * delta * ANGULAR_VELOCITY
		player_trail.emitting = false
	
	else:
		var slope_deg = rad_to_deg(acos(floor_normal.dot(Vector2(0,-1))))
		var target_rotation = round(cube_sprite.rotation_degrees/90.0)*90.0 - slope_deg
		cube_sprite.rotation_degrees = move_toward(cube_sprite.rotation_degrees, target_rotation, delta*ANGULAR_VELOCITY*3)
		player_trail.emitting = true
	
	cube_sprite.rotation_degrees = fmod(cube_sprite.rotation_degrees, 360.0)
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y += gravity_direction*JUMP_VELOCITY
	
func ship_movement(delta: float) -> void:
	var normalized_velocity_vec = velocity.normalized()
	var angle = gravity_direction*sign(normalized_velocity_vec.y)*rad_to_deg(acos(normalized_velocity_vec.dot(Vector2(1,0))))
	
	ship_sprite.rotation_degrees = move_toward(ship_sprite.rotation_degrees, angle, delta*ANGULAR_VELOCITY*3)
	
	if gravity_direction > 0.0:
		scale.y = 1.0
	else:
		scale.y = -1.0
	
	if Input.is_action_pressed("jump"):
		ship_trail.emitting = true
		velocity.y += gravity_direction*gravity_multiplier*FLY_ACCELERATION*delta
	else:
		ship_trail.emitting = false
		
	
func ufo_movement(delta: float) -> void:
	ufo_target_angle = move_toward(ufo_target_angle, 0.0, delta*150)
	ufo_sprite.rotation_degrees = move_toward(ufo_sprite.rotation_degrees, ufo_target_angle, delta*150)
	
	if gravity_direction > 0.0:
		scale.y = 1.0
	else:
		scale.y = -1.0
	
	if Input.is_action_just_pressed("jump"):
		ufo_target_angle = 30.0
		velocity.y = gravity_direction*gravity_multiplier*UFO_VELOCITY
	
func ball_movement(delta: float) -> void:
	ball_sprite.rotation_degrees += gravity_direction * delta * ANGULAR_VELOCITY
	
	if Input.is_action_just_pressed("jump") and state == CharacterState.ONFLOOR:
		gravity_direction *= -1

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not state == CharacterState.DEAD:
		velocity.x = SPEED
		up_direction = Vector2(0, -gravity_direction)

		# Handle jump.
		if not is_on_floor():
			velocity += gravity_direction * gravity_multiplier * get_gravity() * delta
			state = CharacterState.MIDAIR
			
		else:
			state = CharacterState.ONFLOOR
			
		match mode:
			GameMode.CUBE:
				gravity_multiplier = 1.3
				cube_movement(delta)
			
			GameMode.SHIP:
				gravity_multiplier = 0.6
				ship_movement(delta)
			
			GameMode.UFO:
				gravity_multiplier = .8
				ufo_movement(delta)
				
			GameMode.BALL:
				gravity_multiplier = 1.5
				ball_movement(delta)
	else:
		velocity = Vector2(0,0)
		death_explosion.play("death_explosion")
		player_trail.emitting = false
		ship_trail.emitting = false
		audio_stream_player_2d.playing = false

	move_and_slide()
	
	if velocity.x < SPEED:
		die()
