extends Control

@onready var label: Label = $Label

enum Suit { HEART, DIAMOND, CLUB, TREBLE }
enum CardType { ACE, ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING }

@export var card_suit: Suit
@export var card_value: CardType

const card_width: int = 68
const card_height: int = 122

func _ready() -> void:
	label.text = "suit: %s \n value %s" % [card_suit, card_value]

func get_card_shape() -> Array:
	return [card_width, card_height]

func get_card_value() -> int:
	match card_value:
		CardType.ACE:
			return 11
		CardType.JACK:
			return 10
		CardType.QUEEN:
			return 10
		CardType.KING:
			return 10
	
	return card_value
