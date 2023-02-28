extends Pickup

var id : String = "food"

func _pickup(player) -> void:
	if player.has_method("is_player"):
		player.food += 1
		player.bag.append($Sprite.texture)
		GameEvents.emit_signal("player_picked_up_pickup", id)
