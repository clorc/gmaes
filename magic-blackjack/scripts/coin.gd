extends Panel

enum CoinType { FULL, HALF }
@export var value: CoinType

@onready var sprite: Sprite2D = $sprite

func _ready() -> void:
	if value == CoinType.HALF:
		sprite.region_rect.position.x = 64
