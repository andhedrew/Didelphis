class_name Pickup
extends KinematicBody2D

onready var animation_player := $AnimationPlayer as AnimationPlayer
var pickup_texture
var velocity := Vector2(0, 0)
var friction := 0.5

func _ready():
	z_index = SortLayer.FOREGROUND
	animation_player.play("idle")
	$Area2D.connect("body_entered", self, "_on_body_entered")
	if pickup_texture:
		$Sprite.texture = pickup_texture
	$Timer.start()

func _physics_process(delta):
	velocity.y += .3
	move_and_collide(velocity)
	if is_on_floor():
		apply_friction()

func _on_body_entered(body) -> void:
	if body.has_method("is_player") and $Timer.is_stopped():
		_pickup(body)
		animation_player.play("destroy")
		SoundPlayer.play_sound(SoundPlayer.PICKUP)
		set_deferred("monitoring", false)
		

func _pickup(player) -> void:
	pass


func apply_friction():
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction)
