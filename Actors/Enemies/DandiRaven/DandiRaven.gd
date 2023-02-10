extends BaseEnemy

export var flight_time := 2
onready var path_follow: PathFollow2D
var move_speed: float
var lerped_move_speed: float
var current_move_speed: float
onready var offset_amount: float

func _ready():
	path_follow = get_parent()
	offset_amount = path_follow.get_offset()
	state = Enums.State.MOVE
	move_speed = max_move_speed*0.05
	lerped_move_speed = move_speed
	current_move_speed = move_speed
	global_rotation_degrees = 0
	transform.x.x = 0
	transform.y.y = 0

func _physics_process(delta):
	
	state_timer()
	switch_state()
	
	if path_follow.unit_offset < 0.05:
		current_move_speed = move_speed
	elif path_follow.unit_offset > 0.95:
		current_move_speed = -move_speed
	

	lerped_move_speed = lerp(lerped_move_speed, current_move_speed, 0.1)
	path_follow.set_offset(path_follow.get_offset() + lerped_move_speed)



func move_state():
	animation_player.play("walk")



func  hurt_state():
	animation_player.play("hurt")
	if state_timer > 30:
		state = Enums.State.MOVE


