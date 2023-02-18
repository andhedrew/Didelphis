extends Weapon


func _input(event: InputEvent) -> void:
	if attack_delay_timer < attack_delay:
		get_parent().reloading = true
	if event.is_action_pressed("attack") and attack_delay_timer > attack_delay and weapon_active:
		get_parent().reloading = false
		attack_delay_timer = 0
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
	bullet.set_collision_mask_bit(2, true)
	add_child(bullet)
	bullet.setup(global_transform, max_range, max_bullet_speed, bullet_spread, damage, collide_with_world)
