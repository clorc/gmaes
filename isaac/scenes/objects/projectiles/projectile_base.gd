class_name ProjectileBase
extends Area2D

@export var shot_speed: float = 600.0
@export var damage: float = 25.0

func _physics_process(delta: float) -> void:
	# Move forward along the node's local X-axis
	position += transform.x * shot_speed * delta

func _on_body_entered(body: Node2D) -> void:
	# Ignore player if projectile was shot by player
	if body.is_in_group("player"):
		return
		
	# Check if body has a health component or hurtbox
	var health_comp = body.get_node_or_null("HealthComponent") as HealthComponent
	if health_comp:
		health_comp.take_damage(damage)
		
	queue_free() # Destroy projectile on hit

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free() # Cleanup if offscreen
