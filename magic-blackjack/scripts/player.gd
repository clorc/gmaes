extends Control

@onready var card_manager: CardManager = $card_manager
@onready var dealer: Control = $"../dealer"

func _on_hit_pressed() -> void:
	card_manager.add_card()
	
	if card_manager.get_total_card_value() > 21:
		bust()

func _on_stand_pressed() -> void:
	if dealer:
		var dealer_score = await dealer.draw_cards()
			
		if dealer_score > 21 or dealer_score < card_manager.get_total_card_value():
			win()
		
		elif dealer_score == card_manager.get_total_card_value():
			tie()
		
		else:
			lose()

func lose() -> void:
	print("lose")
	await get_tree().create_timer(1).timeout
	get_tree().reload_current_scene()
	
func bust() -> void:
	print("bust")
	await get_tree().create_timer(1).timeout
	get_tree().reload_current_scene()
	
func win() -> void:
	print("win")
	await get_tree().create_timer(1).timeout
	get_tree().reload_current_scene()

func tie() -> void:
	print("tie")
	await get_tree().create_timer(1).timeout
	get_tree().reload_current_scene()
