extends BaseEnemy

export(PackedScene) var bullet_scene
export(float) var attack_delay := 50
onready var bullet_spawn := $BulletSpawn
onready var player_sensor := $PlayerSensor

func _ready():
	state = Enums.State.IDLE
	facing = Enums.Facing.RIGHT


func _physics_process(delta):
	state_timer()
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
	
	if player_sensor.is_colliding():
		state = Enums.State.ATTACK

func move_state():
	pass


func  jump_state():
	pass


func  attack_state():
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

