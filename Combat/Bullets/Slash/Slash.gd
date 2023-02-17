extends Bullet

onready var animation_player := $AnimationPlayer as AnimationPlayer

onready var e_player := $EffectsPlayer as AnimationPlayer
func _ready():
	$Hitbox.connect("body_entered", self, "_on_body_entered")
	animation_player.play("spawn")

func _on_body_entered(body):
	var slice_animation := preload("res://Animations/slice_animation.tscn").instance()
	slice_animation.global_position = body.global_position
	slice_animation.global_position.y -= 16
	
	get_parent().get_parent().get_parent().add_child(slice_animation)
	

func _destroy():
	set_physics_process(false)
	set_deferred("monitoring", false)
	animation_player.play("destroy")
	yield(animation_player, "animation_finished")
	queue_free()
