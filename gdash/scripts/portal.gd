extends Area2D

@onready var blue_grav_portal: Node2D = $portal_sprites/blue_grav_portal
@onready var yellow_grav_portal: Node2D = $portal_sprites/yellow_grav_portal
@onready var ufo_portal: Node2D = $portal_sprites/ufo_portal
@onready var ship_portal: Node2D = $portal_sprites/ship_portal
@onready var cube_portal: Node2D = $portal_sprites/cube_portal
@onready var ball_portal: Node2D = $portal_sprites/ball_portal

enum PortalType { CUBE, SHIP, UFO, BALL, BLUE, YELLOW }
@export var type: PortalType

func _ready() -> void:
	match type:
		PortalType.BLUE:
			blue_grav_portal.visible = true
			
		PortalType.YELLOW:
			yellow_grav_portal.visible = true
			
		PortalType.CUBE:
			cube_portal.visible = true
		
		PortalType.SHIP:
			ship_portal.visible = true
		
		PortalType.UFO:
			ufo_portal.visible = true
		
		PortalType.BALL:
			ball_portal.visible = true

func _on_body_entered(body: Node2D) -> void:
	if type >= 4:
		body.state = body.CharacterState.MIDAIR
		body.position.y -= 5
		
		match type:
			PortalType.BLUE:
				body.gravity_direction = 1
				body.up_direction = Vector2(0, -1)
				
			PortalType.YELLOW:
				body.gravity_direction = -1
				body.up_direction = Vector2(0, 1)
	else:
		body.mode = type
		body.switch_sprite(type)
