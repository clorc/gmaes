extends Node

@onready var pause_menu: CanvasLayer = $pause_menu

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		pause_menu.visible = true

func _on_continue_pressed() -> void:
	get_tree().paused = false
	pause_menu.visible = false

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_settings_pressed() -> void:
	pass # Replace with function body.
