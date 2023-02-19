class_name Pickup
extends Area2D

onready var animation_player := $AnimationPlayer as AnimationPlayer
var pickup_texture

func _ready():
	animation_player.play("idle")
	connect("body_entered", self, "_on_body_entered")
	if pickup_texture:
		$Sprite.texture = pickup_texture

func _physics_process(delta):
	pass

func _on_body_entered(body) -> void:
	if body is Player:
		_pickup(body)
		animation_player.play("destroy")
		SoundPlayer.play_sound(SoundPlayer.PICKUP)
		set_deferred("monitoring", false)
	
	#move_and_collide()

func _pickup(player: Player) -> void:
	pass
