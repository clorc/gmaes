extends Control

@onready var score: Label = $"../score"
@onready var label: Label = $"../Label"
@onready var dealer_cards: HBoxContainer = $"../dealer_cards"

const screen_width: int = 1280
const screen_height: int = 720

var rng = RandomNumberGenerator.new()

var card_array: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(2):
		add_card()


func _on_hit_pressed() -> void:
	add_card()

func _on_stand_pressed() -> void:
	var dealer_score = dealer_cards.draw_cards()
	
	if dealer_score > 21 or dealer_score < get_total_card_value():
		win()
	
	else:
		lose()

func add_card() -> void:
	var card = load("res://scenes/card.tscn")
	var instance = card.instantiate()
	
	instance.card_suit = rng.randi_range(0,3)
	instance.card_value = rng.randi_range(0,13)
	
	card_array.append(instance)
	add_child(instance)

	update_score()

func update_score() -> void:
	var curr_score = get_total_card_value()
	score.text = "Score: %d" % [curr_score]
	
	if curr_score > 21:
		bust()

func get_total_card_value() -> int:
	var sum_of_cards = 0
	
	for card in card_array:
		sum_of_cards += card.get_card_value()
		
	return sum_of_cards

func lose() -> void:
	label.text = "LOST"
	label.visible = true
	get_tree().paused = true

func bust() -> void:
	label.text = "BUST"
	label.visible = true
	get_tree().paused = true
	
func win() -> void:
	label.text = "WIN"
	label.visible = true
	get_tree().paused = true
