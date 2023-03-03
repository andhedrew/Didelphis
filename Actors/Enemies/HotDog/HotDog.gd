extends Enemy

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

func idle_state():
	if state_timer < 1:
		wait_time = rand_range(min_wait_time, max_wait_time)
	animation_player.play("idle")
	apply_gravity()
	if state_timer > wait_time:
		state = Enums.State.MOVE

func move_state():
	if state_timer < 1:
		wait_time = rand_range(min_wait_time, max_wait_time)
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
	
	if state_timer > wait_time:
		state = Enums.State.IDLE


func  jump_state():
	pass


func  attack_state():
	pass


func  dead_state():
	if state_timer < 1:
		SoundPlayer.play_sound("sad_dog_die")


func  fall_state():
	pass


func  hurt_state():
	if state_timer < 1:
		if rand_range(0,2) <= 1:
			SoundPlayer.play_sound("sad_dog_1")
		else:
			SoundPlayer.play_sound("sad_dog_2")
	apply_gravity()
	apply_friction()
	move()
	if state_timer > 80:
		state = Enums.State.MOVE

