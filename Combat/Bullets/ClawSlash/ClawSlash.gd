extends Bullet

onready var animation_player := $AnimationPlayer as AnimationPlayer
onready var sprite := $Sprite

func _ready():
	$Hitbox.connect("body_entered", self, "_on_body_entered")
	animation_player.play("spawn")
	yield(animation_player, "animation_finished")
	animation_player.play("idle")

func _on_body_entered(body):
	var slice_animation = hit_effect.instance()
	slice_animation.global_position = body.global_position
	slice_animation.global_position.y -= 16
	get_tree().get_root().add_child(slice_animation)
	_destroy()
	

func _destroy(): 
	set_physics_process(false)
	set_deferred("monitoring", false)
	animation_player.play("destroy")
	yield(animation_player, "animation_finished")
	queue_free()
