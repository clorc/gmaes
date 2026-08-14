extends Node

# ==============================================================================
# EVENT BUS (AUTOLOAD SINGLETON)
# Centralized signal manager for decoupled node communication.
# ==============================================================================

# --- PLAYER SIGNALS ---
signal player_health_changed(current_health: float, max_health: float)
signal player_died

# --- ROOM & FLOOR SIGNALS ---
signal room_entered(room: RoomBase)
signal room_cleared(room: RoomBase)
signal request_room_transition(from_room: RoomBase, direction: Vector2i)

# --- ITEM & INTERACTION SIGNALS ---
signal item_picked_up(item_data: Resource)
signal chest_opened(chest: Node2D)
signal coin_count_changed(new_amount: int)

# --- GAME STATE SIGNALS ---
signal game_over
signal floor_cleared
