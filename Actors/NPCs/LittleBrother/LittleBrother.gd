extends KinematicBody2D

export(Array, StreamTexture) var death_spritesheet = []
var health := 20

func _ready():
	$Hurtbox.connect("area_entered", self, "_on_hitbox_entered")

func _process(delta):
	if health <= 0:
		die()
		
		

func _on_hitbox_entered(hitbox) -> void:
	if hitbox is HitBox:
		health -= 1
		SoundPlayer.play_sound("impact_celery")
		$EffectsPlayer.play("take_damage_animation")
		$AnimationPlayer.play("hurt")
		yield($AnimationPlayer, "animation_finished")
		$AnimationPlayer.play("sad")


func die() -> void:
	call_deferred("queue_free")
	OS.delay_msec(130)
	var explode := preload("res://Particles/death_explosion.tscn").instance()
	explode.position = global_position
	explode.big = true
	get_node("/root/").add_child(explode)
	if death_spritesheet:
		var spacing = 2
		var starting_x = (death_spritesheet.size()*(spacing*.5))
		for sprite in death_spritesheet:
			var pickup := preload("res://Pickups/FoodPickup.tscn").instance()
			pickup.pickup_texture = sprite
			pickup.position = global_position
			pickup.velocity = Vector2(starting_x, rand_range(-4, -6))
			starting_x -= spacing
			get_node("/root/World").add_child(pickup)
