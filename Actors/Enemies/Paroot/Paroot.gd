extends Enemy

var flipped := false
func _ready():
	pass 

func _physics_process(delta):
	timers()
	switch_state()
	if invulnerable and $InvulnerableTimer.is_stopped():
		invulnerable = false


func apply_gravity():
	velocity.y += gravity
	velocity.y = min(velocity.y, max_fall_speed)

func idle_state():
	pass

func move_state():
	var found_wall := is_on_wall()
	var found_ledge = not ledge_check_right.is_colliding() or not ledge_check_left.is_colliding()
	animation_player.play("walk")
	if found_wall or found_ledge:
		if not flipped:
			direction *= -1
			transform.x.x *= -1
			flipped = true
	else:
		flipped = false
	apply_acceleration(direction.x)
	apply_gravity()
	move()


func  jump_state():
	pass


func  attack_state():
	pass


func  dead_state():
	pass


func  fall_state():
	pass


func  hurt_state():
	if state_timer < 1:
		if rand_range(0,2) <= 1:
			SoundPlayer.play_sound(SoundPlayer.PAROOT_SQUAWK)
		else:
			SoundPlayer.play_sound(SoundPlayer.PAROOT_SQUAWK2)
	apply_gravity()
	apply_friction()
	move()
	if state_timer > 100:
		state = Enums.State.MOVE

