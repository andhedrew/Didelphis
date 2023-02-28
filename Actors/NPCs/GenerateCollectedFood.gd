extends Area2D

func _ready():
	connect("body_entered", self, "_generate_food")


func _generate_food(player) -> void:
	$"../CollisionPolygon2D".disabled = true
	$"../AnimationPlayer".play("eat")
	var spacing = 2
	for item in player.bag:
			var pickup := preload("res://Pickups/FoodPickup.tscn").instance()

			pickup.pickup_texture = item
			pickup.position = $FoodSpawn.global_position
			pickup.velocity = Vector2(0, rand_range(-4, -6))
			get_node("/root/World").add_child(pickup)
			var i = player.bag.find(item)
			player.bag.erase(i)
			yield(get_tree().create_timer(0.3), "timeout")
	player.bag = []
	yield(get_tree().create_timer(1.0), "timeout")
	$"../AnimationPlayer".play("idle")
