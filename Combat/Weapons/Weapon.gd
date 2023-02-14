class_name Weapon
extends Node2D

export var bullet_scene: PackedScene = preload("res://Combat/Bullets/Slash/Slash.tscn")
export var weapon: PackedScene = preload("res://Combat/Bullets/Slash/Slash.tscn")

export(float, 0.0, 160.0, 1.0) var random_angle_degrees := 10

export(float, 100.0, 1000.0, 1.0) var max_range := 1000.0

export(float, 100.0, 3000.0, 1.0) var max_bullet_speed := 1500.0

onready var _random_angle := deg2rad(random_angle_degrees)


func _ready():
	assert(bullet_scene != null, 'Bullet Scene is not provided for "%s"' % [get_path()])


func shoot() -> void:
	pass
