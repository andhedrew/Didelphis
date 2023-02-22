extends Pickup

var id : String = "bone"

func _pickup(player: Player) -> void:
	player.bones += 1
	GameEvents.emit_signal("player_picked_up_pickup", id)
