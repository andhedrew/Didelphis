extends Weapon

 
func _input(event: InputEvent) -> void:
	if attack_delay_timer < attack_delay:
		get_parent().reloading = true
	
	if attack_delay_timer > attack_delay and weapon_active:
		get_parent().reloading = false
		
	
	
	var up_down_axis := Input.get_axis("up", "down")
	
	if up_down_axis < 0:
		rotation_degrees = 270
	elif up_down_axis > 0: 
		rotation_degrees = 90
	else:
		rotation_degrees = 0


func shoot() -> void:
	get_parent().knockback(player_knockback)
	if get_parent().state != Enums.State.EXECUTE:
		var bullet: Node = bullet_scene.instance()
		bullet.set_collision_mask_bit(2, true)
		add_child(bullet)
		bullet.setup(global_transform, max_lifetime, max_bullet_speed, bullet_spread, damage, collide_with_world)
		SoundPlayer.play_sound(attack_sound)
	else:
		var bullet: Node = execute_bullet_scene.instance()
		bullet.set_collision_mask_bit(2, true)
		yield(get_tree().create_timer(0.2), "timeout")
		add_child(bullet)
		bullet.setup(global_transform, max_lifetime, max_bullet_speed, bullet_spread, damage, collide_with_world)
		SoundPlayer.play_sound(attack_sound)

func _on_player_attack():
	if attack_delay_timer > attack_delay and weapon_active:
		attack_delay_timer = 0
		shoot()


func _on_player_execute():
	if attack_delay_timer > attack_delay and weapon_active:
		attack_delay_timer = 0
		shoot()
