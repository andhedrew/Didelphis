extends Node

onready var audio_players := $AudioPlayers

func _ready():
	pass
	#play_music("8bitmusic")

func play_sound(sound: String):
	for audio_stream_player in audio_players.get_children():
		if not audio_stream_player.playing:
			audio_stream_player.pitch_scale = rand_range(0.95, 1.05)
			audio_stream_player.stream = load("res://Sounds/"+ sound +".wav")
			audio_stream_player.play()
			break

func play_music(sound: String):
	for audio_stream_player in audio_players.get_children():
		if not audio_stream_player.playing:
			audio_stream_player.pitch_scale = rand_range(0.95, 1.05)
			audio_stream_player.stream = load("res://Sounds/Music/"+ sound +".ogg")
			audio_stream_player.play()
			break
