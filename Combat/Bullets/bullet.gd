class_name Bullet
extends Area2D

export(PackedScene) var hit_effect  
var default_speed := .2

var lifetime := 50.0

var life = 0.0

onready var speed := default_speed

func _init() -> void:
	set_as_toplevel(true)

 
func _physics_process(delta:float) -> void:
	var distance := speed * delta
	var motion := transform.x * speed * delta
	position += motion
	life += 1
	if life > lifetime: 
		_destroy()


func setup(
	new_global_transform: Transform2D,
	new_lifetime: float,
	new_speed := default_speed,
	bullet_spread: float = 0.0,
	damage: int = 0,
	collide_with_world: bool = true
) -> void:
	$Hitbox.damage = damage
	$Hitbox.collision_mask = collision_mask
	if collide_with_world: 
		$Hitbox.set_collision_mask_bit(0, true)
	transform = new_global_transform
	position.y += rand_range(-bullet_spread, bullet_spread) 
	lifetime = new_lifetime
	speed = new_speed


func _destroy() -> void:
	pass
