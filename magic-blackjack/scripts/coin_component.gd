extends HBoxContainer
class_name CoinComponent

@onready var coin_component: CoinComponent = $"."

@export var max_coins: int
@export var current_coins: int

#func _ready() -> void:
	#add_coins(max_coins)

func set_max_coins(new_coins: int) -> void:
	max_coins = new_coins
	
func set_curr_coins(new_coins: int) -> void:
	current_coins = new_coins
	update_coin_gui()
	
func get_coins() -> int:
	return current_coins
	
func get_max_coins() -> int:
	return max_coins
	
func add_coins(amount:int) -> int:
	current_coins += amount
	update_coin_gui()
	
	return current_coins
	
func remove_coins(amount:int) -> int:
	current_coins -= amount
	update_coin_gui()
	
	return current_coins

func update_coin_gui() -> void:
	for n in coin_component.get_children():
		n.queue_free()
	
	@warning_ignore("integer_division")
	for i in range(current_coins/2):
		var coin = load("res://scenes/coin.tscn")
		var instance = coin.instantiate()
		
		instance.value = 0
		
		coin_component.add_child(instance)
		
	if current_coins%2 == 1:
		var coin = load("res://scenes/coin.tscn")
		var instance = coin.instantiate()
		
		instance.value = 1
		
		coin_component.add_child(instance)
