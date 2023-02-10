extends Node2D

var state = Enums.State.IDLE

var facing = Enums.Facing.RIGHT

onready var animation_player := $AnimationPlayer
onready var effects_player := $EffectsPlayer

var landing := false
var played_death_animation := false
var died_in_the_air := false
var player: Actor

func _ready():
	GameEvents.connect("player_changed_facing_direction", self, "_set_facing")
	GameEvents.connect("player_changed_state", self, "_set_state")
	GameEvents.connect("player_took_damage", self, "_damage_effects")
	player = get_parent()


func _physics_process(delta):
	if not landing and not died_in_the_air:
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
		elif state == Enums.State.DEAD and !played_death_animation:
			played_death_animation = true
			animation_player.play("die")
	elif died_in_the_air:
		if player.is_on_floor() and state == Enums.State.DEAD and !played_death_animation:
			animation_player.play("die")
			animation_player.seek(0.3)
			played_death_animation = true

func _set_state(next_state):
	if state == Enums.State.FALL and (next_state == Enums.State.IDLE or next_state == Enums.State.WALK): 
		if facing == Enums.Facing.UP:animation_player.play("landing_looking_up")
		else:animation_player.play("landing")
		landing = true
	
	if next_state == Enums.State.DEAD and (state == Enums.State.FALL or state == Enums.State.JUMP):
		animation_player.play("die_in_air")
		died_in_the_air = true
		
	state = next_state
	

func _set_facing(player_facing_direction):
	facing = player_facing_direction


func _damage_effects(damage_amount, player_damage):
	effects_player.play("take_damage")

func _finished_landing() -> void:
	landing = false
