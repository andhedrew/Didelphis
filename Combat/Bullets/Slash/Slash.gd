extends Bullet

onready var animation_player := $AnimationPlayer as AnimationPlayer


func _ready():
	connect("body_entered", self, "_on_body_entered")
	animation_player.play("spawn")


func _on_body_entered(body: Node) -> void:
	_destroy()


func _destroy():
	set_physics_process(false)
	set_deferred("monitoring", false)
	animation_player.play("destroy")
	yield(animation_player, "animation_finished")
	queue_free()
