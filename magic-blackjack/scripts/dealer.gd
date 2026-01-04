extends Control
class_name Enemy

@onready var card_manager: CardManager = $card_manager

func drawing_strategy() -> bool:
	if card_manager.get_total_card_value() < 16:
		return true
	return false

func draw_cards() -> int:
	await get_tree().create_timer(1).timeout
	if drawing_strategy():
		card_manager.add_card()
		return true
			
	return false
	
func get_total_card_value():
	return card_manager.get_total_card_value()
