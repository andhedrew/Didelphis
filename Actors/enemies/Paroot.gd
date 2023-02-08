extends BaseEnemy

func _ready():
	pass 

func _physics_process(delta):
	var found_wall := is_on_wall()
	var found_ledge = not ledge_check_right.is_colliding() or not ledge_check_left.is_colliding()
	animation_player.play("walk")
	if found_wall or found_ledge:
		direction *= -1
		animation_player.flip_h = !animation_player.flip_h

	velocity = direction * SPEED
	apply_gravity()
	move()
	
	if invulnerable and $InvulnerableTimer.is_stopped():
		invulnerable = false


func when_hitbox_area_entered(hitbox):
	if hitbox is HitBox:
		$InvulnerableTimer.start()
		

func apply_gravity():
	velocity.y += gravity
	velocity.y = min(velocity.y, max_fall_speed)
		
