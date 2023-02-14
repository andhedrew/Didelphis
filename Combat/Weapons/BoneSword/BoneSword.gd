extends Weapon


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		shoot()
	
	var up_down_axis := Input.get_axis("up", "down")
	
	if up_down_axis < 0:
		rotation_degrees = 270
	elif up_down_axis > 0:
		rotation_degrees = 90
	else:
		rotation_degrees = 0
		


func shoot() -> void:
	var bullet: Node = bullet_scene.instance()

	add_child(bullet)
	bullet.setup(global_transform, max_range, max_bullet_speed, _random_angle)
	
