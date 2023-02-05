extends Actor

export var gravity := 3
export var move_speed := 100

var velocity := Vector2.ZERO

func _ready():
	pass

func _physics_process(delta):
	position.y += gravity
	
	move_and_slide(velocity, Vector2.UP)


