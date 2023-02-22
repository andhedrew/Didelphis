extends Pickup

var id : String = "food"

func _pickup(player: Player) -> void:
	player.food += 1
	GameEvents.emit_signal("player_picked_up_pickup", id)
