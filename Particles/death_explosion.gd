extends Node2D

onready var animation_player = get_node("AnimationPlayer")
var big = false
func _ready():
	animation_player.play("explode")
	if big:
		$Sprite.texture = preload("res://Sprites/vfx_explosion_x2.png")
	SoundPlayer.play_sound(SoundPlayer.EXPLODE)
	yield(animation_player, "animation_finished")
	
	queue_free()
