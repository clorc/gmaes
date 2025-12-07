extends RigidBody2D

var y_velocity = 0
var velocity_vector = Vector2.ZERO
var on_floor: bool = false # now global!

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

#func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	#on_floor = false # reset on_floor for this physics frame
#
	#var i := 0
	#while i < state.get_contact_count():
		#var normal := state.get_contact_local_normal(i)
		#var this_contact_on_floor = normal.dot(Vector2.UP) > 0.99
#
		## boolean math, will stay true if any one contact is on floor
		#on_floor = on_floor or this_contact_on_floor
		#i += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		if abs(linear_velocity.dot(Vector2.UP)) <1e-6:
			y_velocity = 550
			velocity_vector = Vector2.UP * y_velocity
			
			apply_torque_impulse(4000.0)
			apply_impulse(velocity_vector)
	
