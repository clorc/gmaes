class_name Door
extends StaticBody2D

signal player_entered_door(door_direction: Vector2i)

enum State { LOCKED, OPEN }

@export var direction: Vector2i = Vector2i.UP # Direction door faces (e.g. Vector2i.UP)

@onready var sprite: Sprite2D = $Sprite2D
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var trigger_area: Area2D = $DoorTrigger

var current_state: State = State.LOCKED

func set_state(new_state: State) -> void:
	current_state = new_state
	match current_state:
		State.LOCKED:
			collider.set_deferred("disabled", false)
			# Update sprite texture/animation to locked state
		State.OPEN:
			collider.set_deferred("disabled", true)
			# Update sprite texture/animation to open state

func _on_door_trigger_body_entered(body: Node2D) -> void:
	if current_state == State.OPEN and body.is_in_group("player"):
		player_entered_door.emit(direction)
