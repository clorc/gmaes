extends HBoxContainer

@onready var dealer_score: Label = $"../dealer_score"
@onready var player_cards: HBoxContainer = $"../player_cards"

const screen_width: int = 1280
const screen_height: int = 720

var rng = RandomNumberGenerator.new()

var card_array: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(2):
		add_card()
	
	if get_total_card_value() == 21:
		player_cards.lose()

func draw_cards() -> int:
	add_card()
	
	while get_total_card_value() < 16:
		add_card()
		
	return get_total_card_value()
	
func get_total_card_value() -> int:
	var sum_of_cards = 0
	
	for card in card_array:
		sum_of_cards += card.get_card_value()
		
	return sum_of_cards
	
func update_score() -> void:
	var curr_score = get_total_card_value()
	dealer_score.text = "Table: %d" % [curr_score]
	
func add_card() -> void:
	var card = load("res://scenes/card.tscn")
	var instance = card.instantiate()
	
	instance.card_suit = rng.randi_range(0,3)
	instance.card_value = rng.randi_range(0,13)
	
	card_array.append(instance)
	add_child(instance)
	
	update_score()
