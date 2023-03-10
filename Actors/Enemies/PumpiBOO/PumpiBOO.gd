extends ShootingEnemy

var flipped := false
var min_wait_time := 50
var max_wait_time := 150
var wait_time := rand_range(min_wait_time, max_wait_time)
func _ready():
	pass 
 
func _physics_process(delta):
	switch_state()


func apply_gravity():
	velocity.y += gravity
	velocity.y = min(velocity.y, max_fall_speed)


func move_state():
	var found_wall := is_on_wall()
	var found_ledge = not ledge_check_right.is_colliding() or not ledge_check_left.is_colliding()
	 
	if state_timer < 1:
		wait_time = rand_range(min_wait_time, max_wait_time)

	if found_wall or found_ledge:
		if not flipped:
			direction *= -1
			transform.x.x *= -1
			flipped = true
	else:
		flipped = false
	
	animation_player.play("walk")
	apply_acceleration(direction.x)
	apply_gravity()
	move()
	
	if player_sensor.is_colliding() and state_timer > attack_delay:
		state = Enums.State.ATTACK
	
	if state_timer > wait_time:
		state = Enums.State.IDLE
 

func idle_state() -> void:
	animation_player.play("idle")
	if player_sensor.is_colliding() and state_timer > attack_delay:
		state = Enums.State.ATTACK
	
	apply_gravity()
	apply_friction()
	move()
	
	if state_timer < 1:
		wait_time = rand_range(min_wait_time, max_wait_time)
	if state_timer > wait_time:
		state = Enums.State.MOVE


func  hurt_state():
	if state_timer < 1:
		if rand_range(0,2) <= 1:
			SoundPlayer.play_sound("eh")
		else:
			SoundPlayer.play_sound("eh2")
	apply_gravity()
	apply_friction()
	move()
	if state_timer > 80:
		state = Enums.State.MOVE



func _exit_tree() -> void:
	SoundPlayer.play_sound("ehDisappointed")
