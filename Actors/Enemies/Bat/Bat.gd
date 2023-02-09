extends BaseEnemy

export var flight_time := 2
var flight_timer := Timer.new()


func _ready():
	add_child(flight_timer)
	flight_timer.one_shot = true
	flight_timer.wait_time = flight_time
	direction.y = 1
	state = MOVE

func _physics_process(delta):
	state_timer()
	switch_state()
	move()

func move_state():
	if not flight_timer.is_stopped():
		velocity.y = max_move_speed * direction.y
		return

	flight_timer.start()
	direction = - direction


func  hurt_state():
	move_state()
	if state_timer > 100:
		state = MOVE
