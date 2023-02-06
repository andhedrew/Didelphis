extends Node2D
class_name Weapon

export(PackedScene) var bullet_scene
onready var animated_sprite := $AnimatedSprite
onready var bullet_spawn := $BulletSpawn

enum {RIGHT, DOWN, LEFT, UP}
var facing := RIGHT

func _ready():
	GameEvents.connect("player_attacked", self, "fire_weapon")
	GameEvents.connect("player_changed_facing_direction", self, "_change_facing_direction")

func _physics_process(delta):
	match_player_facing_direction()



func fire_weapon():
	var bullet = bullet_scene.instance()
	var xspeed := 0.0
	var yspeed := 0.0
	
	animated_sprite.play("default")
	bullet.position = bullet_spawn.global_position
	
	
	if facing == LEFT or facing == RIGHT:
		xspeed = bullet.speed * scale.x
	elif facing == UP:
		yspeed = -bullet.speed
	elif facing == DOWN:
		yspeed = bullet.speed
	
	bullet.velocity = Vector2(xspeed, yspeed)
	get_parent().get_parent().add_child(bullet)


func reload():
	pass

func _change_facing_direction(player_facing):
	facing = player_facing

func match_player_facing_direction():
	if facing == RIGHT:
		rotation_degrees = 0
		scale.x = 1
	elif facing == LEFT:
		rotation_degrees = 0
		scale.x = -1
	elif facing == UP:
		if scale.x > 0:
			rotation_degrees = 270
		elif scale.x < 0:
			rotation_degrees = 90
	elif facing == DOWN:
		if scale.x > 0:
			rotation_degrees = 90
		elif scale.x < 0:
			rotation_degrees = 270
