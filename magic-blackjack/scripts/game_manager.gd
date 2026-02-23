extends Control

@onready var hit: Button = $Buttons/hit
@onready var stand: Button = $Buttons/stand
@onready var dealer: Enemy = $dealer
@onready var player: Control = $player
@onready var wager_button: Button = $Buttons/wager/wager_button
@onready var line_edit: LineEdit = $Buttons/wager/LineEdit
@onready var up: Button = $Buttons/wager/up
@onready var down: Button = $Buttons/wager/down

var player_turn: bool = true
var player_stands: bool = false
var enemy_stands: bool = false

var wagered: bool = false
var finish: bool = false

@export var wager: int = 0

func _ready() -> void:
	PlayerMoney.max_coins = 20
	player.update_coins()
	
func _process(_delta: float) -> void:
	if wagered:
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
				enemy_stands = not await dealer.draw_cards()
				set_process(true)
				
				if dealer.get_total_card_value() > 21 and not finish:
					finish=true
					PlayerMoney.current_coins += wager
					player.update_coins()
					await player.win()
					
				if not player_stands:
					player_turn = true

func finish_game() -> void:
	var player_score: int = player.get_total_card_value()
	var enemy_score: int = dealer.get_total_card_value()

	if player_score == enemy_score:
		await player.tie()
		
	elif player_score > enemy_score:
		PlayerMoney.current_coins += wager
		player.update_coins()
		await player.win()
		
	else:
		PlayerMoney.current_coins -= wager
		player.update_coins()
		await player.lose()

func _on_hit_pressed() -> void:
	var player_score: int = player.draw_card()
	if not enemy_stands:
		player_turn = false
	
	if player_score > 21:
		PlayerMoney.current_coins -= wager
		player.update_coins()
		await player.bust()

func _on_stand_pressed() -> void:
	player_stands = true
	player_turn = false

func _on_wager_button_pressed() -> void:
	wagered = true
	
	hit.disabled = false
	stand.disabled = false
	
	up.disabled = true
	down.disabled = true
	wager_button.disabled = true
	
	line_edit.editable = false

func _on_up_pressed() -> void:
	wager += 1
	wager = min(wager, PlayerMoney.current_coins)
	line_edit.text = str(wager)

func _on_down_pressed() -> void:
	wager -= 1
	wager = max(wager, 0)
	line_edit.text = str(wager)
