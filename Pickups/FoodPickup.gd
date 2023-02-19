extends Pickup


func _pickup(player: Player) -> void:
	player.food += 1
