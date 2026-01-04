extends HBoxContainer

@export var max_health: int
var current_hp: int

func _ready() -> void:
	current_hp = max_health
	
func set_max_health(new_health: int) -> void:
	max_health = new_health
	
func set_curr_health(new_health: int) -> void:
	current_hp = new_health
	
func get_health() -> int:
	return current_hp
	
func get_max_health() -> int:
	return max_health
	
func remove_health(damage:int) -> int:
	current_hp -= damage
	return current_hp
