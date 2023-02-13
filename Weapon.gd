extends Node2D
class_name Weapon

export(PackedScene) var bullet_scene
export(float) var attack_delay_in_seconds := 50
export(bool) var pass_through_environment := false
onready var bullet_spawn := $BulletSpawn



var facing = Enums.Facing.RIGHT

func _ready():
	GameEvents.connect("player_attacked", self, "fire_weapon")
	GameEvents.connect("player_changed_facing_direction", self, "_change_facing_direction")
	get_parent().attack_delay = attack_delay_in_seconds

func _physics_process(delta):
	pass



func fire_weapon():
	print_debug("fired once")
	var bullet = bullet_scene.instance()
	var xspeed := 0.0
	var yspeed := 0.0
	
	bullet.position = bullet_spawn.global_position
	bullet.set_collision_mask_bit(2, true)
	bullet.set_collision_mask_bit(0, true)
	
	if facing == Enums.Facing.LEFT:
		xspeed = bullet.speed * -transform.x.x
		bullet.rotation_degrees = 180
		bullet.scale.y = -1
	elif facing == Enums.Facing.RIGHT:
		xspeed = bullet.speed * transform.x.x
		bullet.rotation_degrees = 0
	elif facing == Enums.Facing.UP:
		yspeed = -bullet.speed
		bullet.rotation_degrees = 270
	elif facing == Enums.Facing.DOWN:
		yspeed = bullet.speed
		bullet.rotation_degrees = 90
	
	bullet.velocity = Vector2(xspeed, yspeed)
	bullet.pass_through_environment = pass_through_environment
	get_parent().get_parent().add_child(bullet)


func reload():
	pass

func _change_facing_direction(player_facing):
	facing = player_facing


