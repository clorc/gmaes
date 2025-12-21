extends Node2D

@onready var label: Label = $Label

enum Suit { HEART, DIAMOND, CLUB, TREBLE }
enum CardType { ACE, ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING }

@export var card_suit: Suit
@export var card_value: CardType

func _ready() -> void:
	label.text = "suit: %s \n value %s" % [card_suit, card_value]
