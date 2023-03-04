class_name Prop
extends Node2D


var health := 1
var destroyed := false
export(String) var destroy_sound := "bush"
export(Array, Texture) var variations


func _ready() -> void:
	if variations:
		$Sprite.texture = variations[randi() % variations.size()]
	z_index = SortLayer.FOREGROUND
	$Hurtbox.connect("area_entered", self, "_hitbox_area_entered")

func _hitbox_area_entered(hitbox):
	if hitbox is HitBox and !destroyed:
		$Sprite.frame = 1
		$Sprite/Particles2D.emitting = true
		$Hurtbox.call_deferred("queue_free")
		SoundPlayer.play_sound(destroy_sound)
		destroyed = true
