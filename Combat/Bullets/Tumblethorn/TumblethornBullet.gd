extends Bullet

onready var animation_player := $AnimationPlayer as AnimationPlayer

func _ready():
	$Hitbox.connect("body_entered", self, "_on_body_entered")
	animation_player.play("spawn")
	yield(animation_player, "animation_finished")
	animation_player.play("idle")

func _on_body_entered(body):
	var slice_animation := preload("res://Animations/slice_animation.tscn").instance()
	get_parent().get_parent().get_parent().add_child(slice_animation)
	slice_animation.global_position = body.global_position
	slice_animation.global_position.y -= 16

func _physics_process(delta):
	speed += 5

func _destroy():
	set_physics_process(false)
	set_deferred("monitoring", false)
	animation_player.play("destroy")
	yield(animation_player, "animation_finished")
	call_deferred("queue_free")
