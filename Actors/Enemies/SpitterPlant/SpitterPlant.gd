extends ShootingEnemy

func _physics_process(delta):
	timers()
	apply_gravity()
	switch_state()
	if invulnerable and $InvulnerableTimer.is_stopped():
		invulnerable = false
	match scale.x:
		1.0: facing = Enums.Facing.RIGHT
		-1.0: facing = Enums.Facing.LEFT


func apply_gravity():
	velocity.y += gravity
	velocity.y = min(velocity.y, max_fall_speed)


func move_state():
	pass


func  jump_state():
	pass


func  dead_state():
	pass


func  fall_state():
	pass


func  hurt_state():
	animation_player.play("hurt")
	apply_gravity()
	apply_friction()
	move()
	if state_timer > 100:
		state = Enums.State.IDLE

