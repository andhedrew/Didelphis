extends Node

signal player_attacked
signal player_took_damage
signal player_health_changed #Parameter 1: amount of damage taken
signal player_changed_state #Parameter 1: new state
signal player_changed_facing_direction # Parameter 1: facing direction
signal player_died
signal weapon_reloading
signal player_picked_up_pickup # Perameter: id string of pickup
signal player_executed
signal double_jump_refreshed
signal cutscene_started
signal cutscene_ended
