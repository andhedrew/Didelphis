extends KinematicBody2D

export(int) var damage
export(float) var speed
export(bool) var track_lifespan
export(float) var lifespan


var velocity := Vector2.ZERO
var lifespan_tracker := 0.0

func _ready():
	lifespan_tracker = lifespan * 60
	$AnimatedSprite.frame = 0
	$AnimatedSprite.play("default")

func _physics_process(delta):
	move_and_collide(velocity)
	
	
	if track_lifespan:
		lifespan_tracker -= 1
		if lifespan_tracker < 0:
			queue_free()
	else:
		yield($AnimatedSprite, "animation_finished")
		queue_free()
