class_name Player
extends CharacterBody2D

@export var speed: float = 250.0
@export var accel: float = 2000.0
@export var friction: float = 1800.0
@export var projectile_scene: PackedScene

@onready var muzzle: Marker2D = $Muzzle
@onready var shoot_timer: Timer = $ShootTimer
@onready var health_component: HealthComponent = $HealthComponent
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	add_to_group("player")
	health_component.died.connect(_on_died)
	health_component.health_changed.connect(_on_health_changed)

func _physics_process(delta: float) -> void:
	_handle_movement(delta)
	_handle_aiming()
	_handle_shooting()

func _handle_movement(delta: float) -> void:
	# Get 8-directional input vector (uses Godot default ui_ left/right/up/down or WASD)
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * speed, accel * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move_and_slide()

func _handle_aiming() -> void:
	# Rotate muzzle towards the mouse cursor
	var mouse_pos := get_global_mouse_position()
	muzzle.look_at(mouse_pos)
	
	# Flip sprite depending on mouse position relative to player
	if mouse_pos.x < global_position.x:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func _handle_shooting() -> void:
	if Input.is_action_pressed("shoot") and shoot_timer.is_stopped():
		shoot()
		shoot_timer.start()

func shoot() -> void:
	if projectile_scene == null:
		push_warning("No projectile scene assigned to Player!")
		return

	var projectile := projectile_scene.instantiate() as ProjectileBase
	# Add projectile to the main world tree so it moves independently of player position
	get_tree().current_scene.add_child(projectile)
	
	# Spawn at muzzle location and face mouse direction
	projectile.global_position = muzzle.global_position
	projectile.global_rotation = muzzle.global_rotation

func _on_health_changed(current: float, max_hp: float) -> void:
	EventBus.emit_signal("player_health_changed", current, max_hp)

func _on_died() -> void:
	# Trigger death animations or game over screen via EventBus
	EventBus.emit_signal("player_died")
	queue_free()
