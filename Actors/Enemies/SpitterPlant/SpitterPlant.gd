extends BaseEnemy

export(PackedScene) var bullet_scene
export(float, 0.0, 160.0, 1.0) var bullet_spread := 10

export(float, 50.0, 1000.0, 1.0) var max_range := 1000.0

export(float, 10.0, 3000.0, 1.0) var max_bullet_speed := 1500.0

export(float, 0.0, 100.0, 1.0) var attack_delay := 30.0

export( bool ) var collide_with_world := false

onready var bullet_spawn := $BulletSpawn
onready var player_sensor := $PlayerSensor

func _ready():
	state = Enums.State.IDLE
	facing = Enums.Facing.RIGHT


func _physics_process(delta):
	timers()
	switch_state()
	if invulnerable and $InvulnerableTimer.is_stopped():
		invulnerable = false
	
	match scale.x:
		1.0: facing = Enums.Facing.RIGHT
		-1.0: facing = Enums.Facing.LEFT


func apply_gravity():
	velocity.y += gravity
	velocity.y = min(velocity.y, max_fall_speed)

func idle_state():
	animation_player.play("idle")
	apply_gravity()
	move()
	
	if player_sensor.is_colliding() and state_timer > attack_delay:
		state = Enums.State.ATTACK

func move_state():
	pass


func  jump_state():
	pass


func  attack_state():
	animation_player.play("attack")
	if state_timer > 15 and state_timer < 17:
		fire_bullet()
	yield(animation_player, "animation_finished")
	state = Enums.State.IDLE

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

func fire_bullet():
		var bullet = bullet_scene.instance()
		bullet.set_collision_mask_bit(1, true)
		add_child(bullet)
		bullet.setup($BulletSpawn.global_transform, max_range, max_bullet_speed, bullet_spread, damage, collide_with_world)
