extends Pickup

var amount := 2

func _pickup(player: Player) -> void:
	if player.health < player.max_health:
		player.health += amount
		GameEvents.emit_signal("player_health_changed", amount)
		
