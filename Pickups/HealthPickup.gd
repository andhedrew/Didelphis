extends Pickup


func _pickup(player: Player) -> void:
	if player.health < player.max_health:
		player.health += 1
