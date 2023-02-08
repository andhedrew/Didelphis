extends BaseEnemy

var flipped := false
func _ready():
	pass 

func _physics_process(delta):
	pass
	if invulnerable and $InvulnerableTimer.is_stopped():
		invulnerable = false


func when_hitbox_area_entered(hitbox):
	if hitbox is HitBox:
		take_damage(hitbox.damage, hitbox)

func apply_gravity():
	velocity.y += gravity
	velocity.y = min(velocity.y, max_fall_speed)

func idle_state():
	pass

func walk_state():
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


func  damaged_state():
	pass

