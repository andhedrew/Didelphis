extends Sprite

onready var animation_player = $AnimationPlayer as AnimationPlayer

func _ready():
	animation_player.play("slice")

func _physics_process(delta):
	yield(animation_player, "animation_finished")
	queue_free()
