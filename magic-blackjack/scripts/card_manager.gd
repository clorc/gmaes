extends Control
class_name CardManager

@onready var score: Label = $score
@onready var cards: HBoxContainer = $cards

@export var initial_card_num: int
@export var score_name: String

const screen_width: int = 1280
const screen_height: int = 720

var rng = RandomNumberGenerator.new()

var card_array: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(initial_card_num):
		add_card()
	
func get_total_card_value() -> int:
	var sum_of_cards = 0
	var ace_counter = 0
	
	for card in card_array:
		sum_of_cards += card.get_card_value()
		
		if card.card_value == 0:
			ace_counter += 1
		
	for i in range(ace_counter):
		if sum_of_cards > 21:
			sum_of_cards -= 10
		
	return sum_of_cards
	
func update_score() -> void:
	var curr_score = get_total_card_value()
	score.text = "%s: %d" % [score_name, curr_score]
	
func add_card() -> void:
	var card = load("res://scenes/card.tscn")
	var instance = card.instantiate()
	
	instance.card_suit = rng.randi_range(0,3)
	instance.card_value = rng.randi_range(0,13)
	
	card_array.append(instance)
	cards.add_child(instance)
	
	update_score()
