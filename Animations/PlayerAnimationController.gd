extends Node2D

var state = Enums.State.IDLE

var facing = Enums.Facing.RIGHT

onready var animation_player := $AnimationPlayer
onready var effects_player := $EffectsPlayer

var landing := false

func _ready():
	GameEvents.connect("player_changed_facing_direction", self, "_set_facing")
	GameEvents.connect("player_changed_state", self, "_set_state")
	GameEvents.connect("player_took_damage", self, "_damage_effects")


func _physics_process(delta):
	if !landing:
		if state == Enums.State.IDLE:
			if facing == Enums.Facing.UP:animation_player.play("idle_looking_up")
			else:animation_player.play("idle")
		elif state == Enums.State.WALK:
			if facing == Enums.Facing.UP:animation_player.play("walk_looking_up")
			else:animation_player.play("walk")
		elif state == Enums.State.JUMP:
			if facing == Enums.Facing.UP:animation_player.play("jump_looking_up")
			else:animation_player.play("jump")
		elif state == Enums.State.FALL:
			if facing == Enums.Facing.UP:animation_player.play("fall_looking_up")
			else:animation_player.play("fall")
		elif state == Enums.State.ATTACK:
			if facing == Enums.Facing.UP:animation_player.play("attack_looking_up")
			else:animation_player.play("attack")
		elif state == Enums.State.DEAD:
			pass


func _set_state(player_state):
	if state == Enums.State.FALL and (player_state == Enums.State.IDLE or player_state == Enums.State.WALK): 
		if facing == Enums.Facing.UP:animation_player.play("landing_looking_up")
		else:animation_player.play("landing")
		landing = true
	
	state = player_state
	

func _set_facing(player_facing_direction):
	facing = player_facing_direction


func _damage_effects(damage_amount):
	effects_player.play("take_damage")

func _finished_landing() -> void:
	landing = false
