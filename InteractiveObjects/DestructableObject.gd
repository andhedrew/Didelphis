class_name DestructableObject
extends KinematicBody2D
 
export(Array, StreamTexture) var death_spritesheet = []
var executed := false
var execution_timer := 0.0
var active := true

func _ready():
	GameEvents.connect("player_executed", self, "_on_player_executed")
	$Hurtbox.connect("area_entered", self, "_hitbox_area_entered")
	z_index = SortLayer.FOREGROUND

func _process(delta):
	execution_timer -= 1*delta
	if execution_timer <= 0:
		executed = false

func _hitbox_area_entered(_hitbox):
	pass


func _on_player_executed():
	executed = true
	execution_timer = 0.5
