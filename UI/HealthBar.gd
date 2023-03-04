class_name HealthBar
extends Control


const TEXTURE_EMPTY := preload("res://Sprites/UI Sprites/health/health3.png")
const TEXTURE_HALF := preload("res://Sprites/UI Sprites/health/health2.png")
const TEXTURE_FULL := preload("res://Sprites/UI Sprites/health/health1.png")

var max_health := 3
var health := max_health setget set_health

onready var _row := $HBoxContainer as HBoxContainer

func _ready() -> void:
	set_health(10)
	GameEvents.connect("player_health_changed", self, "_on_player_health_changed")

func set_health(new_health: int) -> void:
	health = new_health
	var health_index = health
	
	
	for index in _row.get_child_count():
		var heart: TextureRect = _row.get_child(index)
		if health_index >= 2:
			heart.texture = TEXTURE_FULL
			health_index -= 2
		elif health_index == 1:
			heart.texture = TEXTURE_HALF
			health_index -= 1
		else:
			heart.texture = TEXTURE_EMPTY


func _on_player_health_changed(amount):
	set_health(health+amount)
