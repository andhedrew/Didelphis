extends Sprite

onready var animation_player = $AnimationPlayer as AnimationPlayer

func _ready():
	animation_player.play("slice")
