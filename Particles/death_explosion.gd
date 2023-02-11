extends Node2D

onready var animation_player = get_node("AnimationPlayer")

func _ready():
	animation_player.play("explode")
	yield(animation_player, "animation_finished")
	#queue_free()
