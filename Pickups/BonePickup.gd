extends Pickup

var id : String = "bone"

func _pickup(player) -> void:
	if player.has_method("is_player"):
		player.bones += 1
		GameEvents.emit_signal("player_picked_up_pickup", id)
