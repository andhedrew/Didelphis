extends Particles2D


func _ready():
	z_index = SortLayer.FOREGROUND
	SoundPlayer.play_sound("dust")


func _process(delta):
	modulate.a -= 0.01
	if !emitting:
		queue_free()
