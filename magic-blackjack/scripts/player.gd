extends Control

@onready var card_manager: CardManager = $card_manager
@onready var coin_component: HBoxContainer = $CoinComponent

func update_coins() -> void:
	print(PlayerMoney.current_coins)
	coin_component.add_coins(PlayerMoney.current_coins)

func draw_card() -> int:
	card_manager.add_card()
	return get_total_card_value()
	
func get_total_card_value() -> int:
	return card_manager.get_total_card_value()

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
