extends RigidBody2D

var y_velocity = 0
var mid_air = false
var velocity_vector = Vector2.ZERO
var initial_position = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_position = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position.x = initial_position.x
	if initial_position.y - position.y < 1e-5:
		if Input.is_action_pressed("ui_up"):
			y_velocity = 550
			velocity_vector = Vector2.UP * y_velocity
			
			apply_torque_impulse(4000.0)
			apply_impulse(velocity_vector)
			mid_air = true
			
	print(rotation_degrees)

	if initial_position.y - position.y < 0.0:
		position.y = initial_position.y
		mid_air=false
	
