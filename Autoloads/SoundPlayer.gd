extends Node

const EXPLODE := preload("res://Sounds/explosion.wav")
const SWOOSH := preload("res://Sounds/swoosh.wav")
const IMPACT_CELERY := preload("res://Sounds/impact_celery.wav")
const OOF := preload("res://Sounds/oofHigh.wav")
const PAROOT_SQUAWK = preload("res://Sounds/ParootSquawk1.wav")
const PAROOT_SQUAWK2 = preload("res://Sounds/ParootSquawk2.wav")
const PICKUP = preload("res://Sounds/Pickup.wav")
const SLICE_SQUISH_SMALL = preload("res://Sounds/SliceSquishSmall.wav")
const SLICE_SQUISH_MEDIUM = preload("res://Sounds/SliceSquishMedium.wav")
const EH1 = preload("res://Sounds/eh.wav")
const EH2 = preload("res://Sounds/eh2.wav")
const EH3 = preload("res://Sounds/ehDisappointed.wav")

onready var audio_players := $AudioPlayers

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
			audio_stream_player.stream = load("res://Sounds/"+ sound +".ogg")
			audio_stream_player.play()
			break
