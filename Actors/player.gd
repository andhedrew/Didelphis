extends Actor
class_name Player

export(int) var health = 3
var max_health = health
var food: int = 0
export var gravity := 3.9*55
export var extra_gravity_on_fall := 3*55

export var max_move_speed := 120
export var acceleration := 7
export var acceleration_in_air := 5

export var jump_height := -150
var attack_delay := 30
var reloading: bool = false

export var max_fall_speed := 250
export var friction := 6.5

var velocity := Vector2.ZERO

var state = Enums.State.IDLE
var state_last_frame = state
var state_timer := 0


var facing = Enums.Facing.RIGHT
var default_facing = facing

onready var coyote_timer := $CoyoteTimer
onready var invulnerable_timer := $InvulnerableTimer
var was_on_floor := false

var in_air_timer := 0
var player_colliding := false
var colliding_hitbox: HitBox

onready var animation_player := $Model/AnimationPlayer
onready var hurtbox := $Hurtbox

var input := Vector2.ZERO
var attack := false

var hurt_sound: AudioStreamSample = SoundPlayer.OOF


func _ready():
	z_index = SortLayer.PLAYER
	hurtbox.connect("area_entered", self, "_collided_with_hitbox")
	hurtbox.connect("area_exited", self, "_exited_hitbox")
	GameEvents.connect("weapon_reloading", self, "_reloading")


func _physics_process(delta):
	attack = Input.is_action_just_pressed("attack") and !reloading
	input.x = Input.get_axis("left", "right")
	input.y = Input.get_axis("up", "down")

	timers()
	apply_gravity(delta)
	
	match state:
		Enums.State.IDLE: idle_state(input, attack)
		Enums.State.WALK: walk_state(input, attack)
		Enums.State.JUMP: jump_state(input, attack)
		Enums.State.ATTACK: attack_state(input, delta)
		Enums.State.DEAD: dead_state()
		Enums.State.FALL: fall_state(input, attack)

	
	if state != Enums.State.DEAD:
		#if state != Enums.State.ATTACK or state_timer > 7:
		handle_facing(input)
	
	if is_on_floor():
		in_air_timer = 0
	else:
		in_air_timer  += 1

	if player_colliding and invulnerable_timer.is_stopped():
		take_damage()


func idle_state(input, attack):
	var jump :=  Input.is_action_just_pressed("jump")
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	apply_friction()
	
	if input.x != 0:
		state = Enums.State.WALK
	
	if jump or !is_on_floor():
		state = Enums.State.JUMP
	
	if attack:
		state = Enums.State.ATTACK


func walk_state(input, attack):
	var jump :=  Input.is_action_just_pressed("jump")
	apply_acceleration(input.x)
	velocity = move_and_slide(velocity, Vector2.UP)
	
	
	
	if was_on_floor and !is_on_floor():
		coyote_timer.start()
	
	was_on_floor = is_on_floor()
	
	if input.x == 0:
		state = Enums.State.IDLE
	
	if jump and (is_on_floor() or !coyote_timer.is_stopped()):
		state = Enums.State.JUMP
	
	if !is_on_floor() and coyote_timer.is_stopped():
		state = Enums.State.JUMP
	
	if attack:
		state = Enums.State.ATTACK


func jump_state(input, attack):
	var jump_release:= Input.is_action_just_released("jump")
	var jump :=  Input.is_action_pressed("jump")
	
	if jump_release and velocity.y < (jump_height/2):
		velocity.y = jump_height/2
	elif jump and (is_on_floor()  or !coyote_timer.is_stopped()):
		coyote_timer.stop()
		velocity.y = jump_height
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor():
		
		if input.x == 0:
			state = Enums.State.IDLE
		else:
			state = Enums.State.WALK
	
	if velocity.y > 0:
		state = Enums.State.FALL
	
	if attack:
		state = Enums.State.ATTACK
	
	apply_acceleration(input.x)


func fall_state(input, attack):
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor():
		if input.x == 0:
			state = Enums.State.IDLE
		else:
			state = Enums.State.WALK
	apply_acceleration(input.x)
	
	if attack:
		state = Enums.State.ATTACK


func attack_state(input, delta):
	var jump :=  Input.is_action_just_pressed("jump")
	if state_timer < 1:
		GameEvents.emit_signal("player_attacked")
		
	if state_timer < 1 and facing == Enums.Facing.DOWN:
		velocity.y = min((jump_height)+in_air_timer, velocity.y)
		
	velocity = move_and_slide(velocity, Vector2.UP)
	apply_acceleration(input.x)
	apply_friction()
	
	if Input.is_action_just_pressed("attack"):
		state_timer = 0
		GameEvents.emit_signal("player_attacked")
		$Model.play_alt_slash_attack = !$Model.play_alt_slash_attack
	
	if state_timer > attack_delay:
		state = Enums.State.IDLE
	
	if jump:
		state = Enums.State.JUMP


func dead_state():
	set_collision_mask_bit(4, false)
	apply_friction()
	if !is_on_floor():
		velocity = move_and_slide(velocity, Vector2.UP)


func timers():
	if state_last_frame != state:
		state_timer = 0
		GameEvents.emit_signal("player_changed_state", state)
	else:
		state_timer += 1
		
	state_last_frame = state
	
	if is_on_floor():
		in_air_timer = 0
	else:
		in_air_timer  += 1


func apply_gravity(delta):
	velocity.y += gravity*delta
	if velocity.y > 0:
		velocity.y += extra_gravity_on_fall*delta
	velocity.y = min(velocity.y, max_fall_speed)


func apply_friction():
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction)


func apply_acceleration(amount):
	if is_on_floor():
		velocity.x = move_toward(velocity.x, max_move_speed * amount, acceleration)
	else:
		velocity.x = move_toward(velocity.x, max_move_speed * amount, acceleration_in_air)


func take_damage():
	SoundPlayer.play_sound(hurt_sound)
	velocity = (self.global_position - colliding_hitbox.global_position) * colliding_hitbox.knockback_force
	velocity.y  = max(jump_height+in_air_timer, velocity.y)
	invulnerable_timer.start()
	GameEvents.emit_signal("player_health_changed", colliding_hitbox.damage, health)
	if health == 0:
		GameEvents.emit_signal("player_died")
		state = Enums.State.DEAD
		hurtbox.queue_free()


func handle_facing(input) -> void:
	if input.y == 0:
		if input.x > 0:
			facing = Enums.Facing.RIGHT
			default_facing = facing
		elif input.x < 0:
			facing = Enums.Facing.LEFT
			default_facing = facing
		else:
			facing = default_facing
	elif input.y < 0:
		facing = Enums.Facing.UP
	elif input.y > 0:
		facing = Enums.Facing.DOWN
	GameEvents.emit_signal("player_changed_facing_direction", facing)

	if input.x > 0:
		transform.x.x = 1
	elif input.x < 0:
		transform.x.x = -1


func _collided_with_hitbox(hitbox) -> void:
	if hitbox is HitBox:
		player_colliding = true
		colliding_hitbox = hitbox


func _exited_hitbox(exiting_hitbox) -> void:
	if exiting_hitbox == colliding_hitbox:
		player_colliding = false
		colliding_hitbox = null

func _reloading(ammo_amount, max_ammo) -> void:
	reloading = true


func knockback(amount) -> void:
	match facing:
		Enums.Facing.RIGHT: velocity.x -= amount
		Enums.Facing.LEFT:  velocity.x += amount
