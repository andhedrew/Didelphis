extends Actor

export(int) var health = 3
export var gravity := 3.9
export var extra_gravity_on_fall := 3
export var move_speed := 100
export var max_move_speed := 80
export var acceleration := 7
export var acceleration_in_air := 5
export var jump_height := -150

export var max_fall_speed := 250
export var friction := 4.5

var velocity := Vector2.ZERO
enum {IDLE, WALK, JUMP, FALL, DEAD, ATTACK}
var state := IDLE
var state_last_frame := state
var state_timer := 0

enum {RIGHT, DOWN, LEFT, UP}
var facing := RIGHT
var default_facing := facing

onready var coyote_timer := $CoyoteTimer
var was_on_floor := false
onready var animation_player := $Model/AnimationPlayer

var input := Vector2.ZERO
var attack := false

func _ready():
	pass


func _physics_process(delta):
	attack = Input.is_action_just_pressed("attack")
	input.x = Input.get_axis("left", "right")
	input.y = Input.get_axis("up", "down")

	state_timer()
	apply_gravity()
	switch_state(input)
	
	if input.y == 0:
		if input.x > 0:
			facing = RIGHT
			default_facing = facing
		elif input.x < 0:
			facing = LEFT
			default_facing = facing
		else:
			facing = default_facing
	elif input.y < 0:
		facing = UP
	elif input.y > 0:
		facing = DOWN
	GameEvents.emit_signal("player_changed_facing_direction", facing)

	if input.x > 0:
		transform.x.x = 1
	elif input.x < 0:
		transform.x.x = -1


func switch_state(input) -> void :
	if state == IDLE: idle_state(input, attack)
	elif state == WALK: walk_state(input, attack)
	elif state == JUMP: jump_state(input, attack)
	elif state == ATTACK: attack_state(input)
	elif state == DEAD: dead_state()
	elif state == FALL: fall_state(input, attack)


func idle_state(input, attack):
	var jump :=  Input.is_action_just_pressed("jump")
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	apply_friction()
	
	if input.x != 0:
		state = WALK
	
	if jump or !is_on_floor():
		state = JUMP
	
	if attack:
		state = ATTACK


func walk_state(input, attack):
	var jump :=  Input.is_action_just_pressed("jump")
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	apply_acceleration(input.x)
	
	if was_on_floor and !is_on_floor():
		coyote_timer.start()
	
	was_on_floor = is_on_floor()
	
	if input.x == 0:
		state = IDLE
	
	if jump and (is_on_floor() or !coyote_timer.is_stopped()):
		state = JUMP
	
	if !is_on_floor() and coyote_timer.is_stopped():
		state = JUMP
	
	if attack:
		state = ATTACK


func jump_state(input, attack):
	var jump_release:= Input.is_action_just_released("jump")
	var jump :=  Input.is_action_just_pressed("jump")
	
	if jump_release and velocity.y < (jump_height/2):
		velocity.y = jump_height/2
	elif is_on_floor()  or !coyote_timer.is_stopped():
		coyote_timer.stop()
		velocity.y = jump_height
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor():
		if input.x == 0:
			state = IDLE
		else:
			state = WALK
	
	if velocity.y > 0:
		state = FALL
	
	if attack:
		state = ATTACK
	
	apply_acceleration(input.x)


func fall_state(input, attack):
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor():
		if input.x == 0:
			state = IDLE
		else:
			state = WALK
	apply_acceleration(input.x)
	
	if attack:
		state = ATTACK


func attack_state(input):
	var jump :=  Input.is_action_just_pressed("jump")
	if state_timer < 1:
		GameEvents.emit_signal("player_attacked")
	
	if state_timer < 1 and facing == DOWN:
		velocity.y = jump_height*0.5
		
	velocity = move_and_slide(velocity, Vector2.UP)
	
	apply_friction()
	
	if state_timer > 20:
		state = IDLE
	
	if jump:
		state = JUMP


func dead_state():
	pass


func state_timer():
	if state_last_frame != state:
		state_timer = 0
		GameEvents.emit_signal("player_changed_state", state)
	else:
		state_timer += 1
		
	state_last_frame = state


func apply_gravity():
	velocity.y += gravity
	if velocity.y > 0:
		velocity.y += extra_gravity_on_fall
	velocity.y = min(velocity.y, max_fall_speed)


func apply_friction():
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction)


func apply_acceleration(amount):
	if is_on_floor():
		velocity.x = move_toward(velocity.x, max_move_speed * amount, acceleration)
	else:
		velocity.x = move_toward(velocity.x, max_move_speed * amount, acceleration_in_air)


func _on_Hurtbox_area_entered(hitbox):
	if hitbox is HitBox:
		health -= hitbox.damage
		velocity = (self.global_position - hitbox.global_position) * hitbox.knockback_force
		velocity.y  = jump_height*0.5
		GameEvents.emit_signal("player_took_damage", hitbox.damage)
