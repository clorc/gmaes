class_name RoomBase
extends Node2D

signal room_cleared
signal room_entered(room: RoomBase)

enum RoomShape { SIZE_1X1, SIZE_2X1, SIZE_1X2, SIZE_2X2, SIZE_L_SHAPE }

# Pixel dimensions of one 1x1 block
const BLOCK_SIZE: Vector2 = Vector2(384, 384) 

@export var room_shape: RoomShape = RoomShape.SIZE_1X1
@export var is_cleared: bool = false

@onready var doors_container: Node2D = $Doors
@onready var enemies_container: Node2D = $Enemies
@onready var player_detector: Area2D = $PlayerDetector

var active_enemies: int = 0
var doors: Array[Door] = []

func _ready() -> void:
	# Gather doors placed in the scene
	for child in doors_container.get_children():
		if child is Door:
			doors.append(child)
			child.player_entered_door.connect(_on_door_entered)
	
	_setup_enemy_tracking()

func _setup_enemy_tracking() -> void:
	var enemy_list = enemies_container.get_children()
	active_enemies = enemy_list.size()
	
	if active_enemies == 0:
		is_cleared = true
		_set_doors_state(Door.State.OPEN)
	else:
		for enemy in enemy_list:
			# Connect to enemy's death signal or tree_exited
			enemy.tree_exited.connect(_on_enemy_killed)

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		room_entered.emit(self)
		if not is_cleared:
			_set_doors_state(Door.State.LOCKED)

func _on_enemy_killed() -> void:
	active_enemies -= 1
	if active_enemies <= 0 and not is_cleared:
		_clear_room()

func _clear_room() -> void:
	is_cleared = true
	_set_doors_state(Door.State.OPEN)
	room_cleared.emit()

func _set_doors_state(state: Door.State) -> void:
	for door in doors:
		door.set_state(state)

func _on_door_entered(door_direction: Vector2i) -> void:
	# Handled by Floor/Dungeon Manager to transition player to adjacent room
	#EventBus.emit_signal("request_room_transition", self, door_direction)
	pass

# Helper function returning grid coordinate offsets for each shape
func get_block_offsets() -> Array[Vector2i]:
	match room_shape:
		RoomShape.SIZE_1X1:
			return [Vector2i(0, 0)]
		RoomShape.SIZE_2X1:
			return [Vector2i(0, 0), Vector2i(1, 0)]
		RoomShape.SIZE_1X2:
			return [Vector2i(0, 0), Vector2i(0, 1)]
		RoomShape.SIZE_2X2:
			return [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]
		RoomShape.SIZE_L_SHAPE:
			# 2x2 missing bottom-right corner
			return [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1)]
	return [Vector2i(0, 0)]
