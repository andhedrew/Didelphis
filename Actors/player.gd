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
onready var animation_player := $Model/AnimationPlayer

var input := Vector2.ZERO

func _ready():
	pass

func _input(event):
	var attack = Input.is_action_just_pressed("attack")
	if attack:
		GameEvents.emit_signal("player_attacked")


func _physics_process(delta):
	
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
	
	if facing == RIGHT:
		transform.x.x = 1
	elif  facing == LEFT:
		transform.x.x = -1


func switch_state(input) -> void :
	
	if state == IDLE: idle_state(input)
	elif state == WALK: walk_state(input)
	elif state == JUMP: jump_state(input)
	elif state == DEAD: dead_state()
	elif state == FALL: fall_state(input)


func idle_state(input):
	var jump :=  Input.is_action_just_pressed("jump")
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	apply_friction()
	
	if input.x != 0:
		state = WALK
	
	if jump:
		state = JUMP


func walk_state(input):
	var jump :=  Input.is_action_just_pressed("jump")
	
	
	velocity = move_and_slide(velocity, Vector2.UP)
	apply_acceleration(input.x)
	var was_on_floor = is_on_floor()
	
	if was_on_floor and !is_on_floor():
		coyote_timer.start()
	
	if input.x == 0:
		state = IDLE
	
	if jump and (is_on_floor() or !coyote_timer.is_stopped()):
		state = JUMP
	
	if !is_on_floor() and coyote_timer.is_stopped():
		state = JUMP


func jump_state(input):
	var jump_release:= Input.is_action_just_released("jump")
	var jump :=  Input.is_action_just_pressed("jump")
	

	if jump_release and velocity.y < (jump_height/2):
		velocity.y = jump_height/2
	elif is_on_floor()  or !coyote_timer.is_stopped():
		velocity.y = jump_height
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor():
		if input.x == 0:
			state = IDLE
		else:
			state = WALK
	
	if velocity.y > 0:
		state = FALL
	apply_acceleration(input.x)


func fall_state(input):
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor():
		if input.x == 0:
			state = IDLE
		else:
			state = WALK
	apply_acceleration(input.x)


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
	
