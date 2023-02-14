extends "res://Weapons/Projectiles/projectile.gd"


func _ready():
	pass


func _physics_process(delta):
	velocity.x = speed
#	if is_on_floor():
#		velocity.y = -30
	
	apply_gravity(delta)
	

func apply_gravity(delta):
	var gravity = 3.9*55
	velocity.y += gravity*delta
