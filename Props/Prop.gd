class_name Prop
extends Node2D


var health := 1

func _ready() -> void:
	$Hurtbox.connect("area_entered", self, "_hitbox_area_entered")

func _hitbox_area_entered(hitbox):
	if hitbox is HitBox:
		$Sprite.frame = 1
		$Sprite/Particles2D.emitting = true
		$Hurtbox.queue_free()
