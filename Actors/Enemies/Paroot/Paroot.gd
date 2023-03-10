extends Enemy

var flipped := false
func _ready():
	state = Enums.State.MOVE
	

func _physics_process(_delta):
	switch_state()


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
	apply_gravity()
	apply_friction()
	move()
	if state_timer > 100:
		state = Enums.State.MOVE

