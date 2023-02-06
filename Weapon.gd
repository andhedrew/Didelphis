extends Node2D
class_name Weapon

export(PackedScene) var bullet_scene
onready var animated_sprite = $AnimatedSprite


func _ready():
	GameEvents.connect("player_attacked", self, "_fire")


func _fire():
	animated_sprite.play("default")
	var bullet = bullet_scene.instance()
	bullet.position = Vector2(0, 0)
	bullet.velocity = Vector2(5, 0)
	add_child(bullet)
