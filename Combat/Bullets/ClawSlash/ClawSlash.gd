extends Bullet

onready var animation_player := $AnimationPlayer as AnimationPlayer
onready var sprite := $Sprite

func _ready():
	$Hitbox.connect("body_entered", self, "_on_body_entered")
	animation_player.play("spawn")
	yield(animation_player, "animation_finished")
	animation_player.play("idle")

func _on_body_entered(body):
	if body.get_collision_layer() != 1 and !body.invulnerable:
		var slice_animation = hit_effect.instance()
		get_tree().get_root().add_child(slice_animation)
		slice_animation.global_position = body.global_position
		slice_animation.global_position.y -= 16
	_destroy()
	

func _destroy(): 
	set_physics_process(false)
	set_deferred("monitoring", false)
	animation_player.play("destroy")
	yield(animation_player, "animation_finished")
	call_deferred("queue_free")
