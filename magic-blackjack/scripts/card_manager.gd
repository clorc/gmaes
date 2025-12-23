extends Node

@onready var player_cards: HBoxContainer = $player_cards

const screen_width: int = 1280
const screen_height: int = 720

var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(4):
		var card = load("res://scenes/card.tscn")
		var instance = card.instantiate()
		
		instance.card_suit = rng.randi_range(0,3)
		instance.card_value = rng.randi_range(0,13)
		
		#instance.position.x = 100*i
		#instance.position.y = 560
		
		card_array.append(instance)
		
		player_cards.add_child(instance)
		
		print(instance.get_node("Label").text)
		

func _process(delta: float) -> void:
	pass
