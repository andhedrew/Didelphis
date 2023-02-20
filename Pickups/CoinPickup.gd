extends Pickup


func _pickup(player: Player) -> void:
	player.coins += 1
