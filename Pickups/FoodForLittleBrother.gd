extends KinematicBody2D

var pickup_texture
var velocity := Vector2(0, 0)
var friction := 0.5
var max_fall_speed := 5


func _ready():
	z_index = SortLayer.FOREGROUND
	if pickup_texture:
		$Sprite.texture = pickup_texture

func _physics_process(delta):
	velocity.y += .3
	velocity.y = min(velocity.y, max_fall_speed)
	move_and_collide(velocity)
