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
	
	## If you want tiles to be destructable:
#	var ray = RayCast2D.new()
#	ray.enabled = true
#	ray.cast_to = motion
#	add_child(ray)
#	ray.force_raycast_update()
#	if ray.is_colliding():
#		var tilemap = ray.get_collider()
#		var collision_point = ray.get_collision_point()
#		var cell_vec = tilemap.world_to_map(collision_point)
#		if tilemap.name == "RedTiles":
#			tilemap.set_cellv(cell_vec, -1)
#			queue_free()
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
