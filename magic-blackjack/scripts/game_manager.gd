extends Control

@onready var hit: Button = $Buttons/hit
@onready var stand: Button = $Buttons/stand
@onready var dealer: Enemy = $dealer
@onready var player: Control = $player

var player_turn: bool = true
var player_stands: bool = false
var enemy_stands: bool = false

var finish: bool = false

func _ready() -> void:
	PlayerMoney.max_coins = 20
	player.update_coins()
	
func _process(_delta: float) -> void:
	if player_stands and enemy_stands:
		set_process(false)
		await finish_game()
		set_process(true)
	
	else:
		if player_turn:
			hit.disabled = false
			stand.disabled = false
			
		else:
			hit.disabled = true
			stand.disabled = true
			
			set_process(false)
			enemy_stands =  not await dealer.draw_cards()
			set_process(true)
			
			if dealer.get_total_card_value() > 21 and not finish:
				finish=true
				await player.win()
				
			if not player_stands:
				player_turn = true

func finish_game() -> void:
	var player_score: int = player.get_total_card_value()
	var enemy_score: int = dealer.get_total_card_value()

	if player_score == enemy_score:
		await player.tie()
		
	elif player_score > enemy_score:
		await player.win()
		
	else:
		await player.lose()

func _on_hit_pressed() -> void:
	var player_score: int = player.draw_card()
	if not enemy_stands:
		player_turn = false
	
	if player_score > 21:
		await player.bust()


func _on_stand_pressed() -> void:
	player_stands = true
	player_turn = false
