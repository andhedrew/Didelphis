extends Area2D

var food_collected := 0

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
			player.food -= 1
			GameEvents.emit_signal("player_picked_up_pickup", "food_lost")
			food_collected += 1
			yield(get_tree().create_timer(0.3), "timeout")
	player.bag = []
	yield(get_tree().create_timer(1.0), "timeout")
	if food_collected > 0:
		$"../AnimationPlayer".play("chew")
	else:
		$"../AnimationPlayer".play("idle")

func _choose_emotion() -> void:
	if food_collected > 3:
		_play_happy()
		food_collected = 0
	else:
		_play_sad()
		food_collected = 0


func _play_happy():
	$"../AnimationPlayer".play("happy")
	yield()



func _play_sad():
	$"../AnimationPlayer".play("sad")
