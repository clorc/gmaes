extends TileMapLayer

@onready var player: CharacterBody2D = %player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not player.state == player.CharacterState.DEAD:
		position.x += 0.6 * player.SPEED * delta
		
