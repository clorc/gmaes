extends Control

@onready var card_manager: CardManager = $card_manager
@onready var player: Control = $"../player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if player.get_node("card_manager").get_total_card_value() == 21:
		player.lose()

func draw_cards() -> int:
	if card_manager.get_total_card_value() == 21:
		return 21
	else:
		card_manager.add_card()
	
	
	while card_manager.get_total_card_value() < 16:
		await get_tree().create_timer(0.5).timeout
		card_manager.add_card()
		
	return card_manager.get_total_card_value()
