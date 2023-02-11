extends Node

const EXPLODE := preload("res://Sounds/explosion.wav")
onready var audio_players := $AudioPlayers

func play_sound(sound):
	for audio_stream_player in audio_players.get_children():
		if not audio_stream_player.playing:
			audio_stream_player.pitch_scale = rand_range(0.95, 1.05)
			audio_stream_player.stream = sound
			audio_stream_player.play()
			break
