extends KinematicBody2D

export(int) var damage
export(float) var speed
export(float) var lifespan

var velocity := Vector2.ZERO

func _ready():
	pass

func _physics_process(delta):
	move_and_collide(velocity)
