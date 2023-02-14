extends Node2D

const WEAPON_SPRITESHEETS := {
	"BoneSword": preload("res://Sprites/player_weapon_claw.png"),
	"Spear": preload("res://Sprites/player_weapon_spear.png"),
}

var _weapon: Weapon setget set_weapon

func _ready():
	pass
	#var weapon_spritesheet: Texture = WEAPON_SPRITESHEETS[_weapon.name]


func set_weapon(new_weapon: Weapon) -> void:
	if _weapon:
		remove_child(_weapon)
		_weapon.queue_free()
	_weapon = new_weapon
	add_child(_weapon)
