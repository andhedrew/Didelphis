class_name Bullet
extends Area2D

var default_speed := .2

var max_range := 1000.0

var _tavelled_distance = 0.0

onready var speed := default_speed

func _init() -> void:
	set_as_toplevel(true)


func _physics_process(delta:float) -> void:
	var distance := speed * delta
	var motion := transform.x * speed * delta
	
	position += motion
	
	_tavelled_distance += distance
	if _tavelled_distance > max_range: 
		_destroy()


func setup(
	new_global_transform: Transform2D,
	new_range: float,
	new_speed := default_speed,
	bullet_spread: float = 0.0,
	damage: int = 0
) -> void:
	$Hitbox.damage = damage
	transform = new_global_transform
	position.y += rand_range(-bullet_spread, bullet_spread) 
	max_range = new_range
	speed = new_speed


func _destroy() -> void:
	pass

func randomize_rotation(max_angle: float) -> void:
	rotation += randf() * max_angle - max_angle / 2.0

