extends Node

@export var start_time: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_time = Time.get_unix_time_from_system()

func get_time_elapsed() -> float:
	var end_time = Time.get_unix_time_from_system()	
	return end_time - start_time
