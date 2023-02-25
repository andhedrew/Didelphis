class_name Weapon

extends Node2D

export var bullet_scene: PackedScene = preload("res://Combat/Bullets/Slash/Slash.tscn")
export var sprite_sheet: Texture = preload("res://Sprites/player_weapon_bone_sword.png")

export(float, 0.0, 160.0, 1.0) var bullet_spread := 10
export(float, 0.0, 1000.0, 1.0) var max_lifetime := 1000.0
export(float, 0.0, 3000.0, 1.0) var max_bullet_speed := 1500.0

export(float, 0.0, 100.0, 1.0) var attack_delay := 30.0
export(int, 0, 10, 1) var damage := 1
export(bool) var collide_with_world := true

export(float, 30.0, 500.0, 1.0) var player_knockback := 100 

export( AudioStreamSample ) var attack_sound := SoundPlayer.SWOOSH
var attack_delay_timer := attack_delay+1
var weapon_active := true


func _physics_process(delta):
	attack_delay_timer += 1

func _ready():
	assert(bullet_scene != null, 'Bullet Scene is not provided for "%s"' % [get_path()])
	var weapon_model = get_node("/root/World/Player/Model/WeaponModel")
	GameEvents.connect("player_died", self, "_on_player_death")
	GameEvents.connect("player_attacked", self, "_on_player_attack")
	weapon_model.texture = sprite_sheet


func shoot() -> void:
	pass

func _on_player_death():
	weapon_active = false


func _on_player_attack():
	pass
