extends Node2D

var state = Enums.State.IDLE

var facing = Enums.Facing.RIGHT

onready var animation_player := $AnimationPlayer
onready var effects_player := $EffectsPlayer

var landing := false
var played_death_animation := false
var died_in_the_air := false
var player: Actor
var play_alt_slash_attack := false
var double_jump_available := false

func _ready():
	GameEvents.connect("player_changed_facing_direction", self, "_set_facing")
	GameEvents.connect("player_changed_state", self, "_set_state")
	GameEvents.connect("player_health_changed", self, "_damage_effects")
	GameEvents.connect("double_jump_refreshed", self, "_double_jump_refreshed_effects")
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
			$DoubleJumpCloud.emitting = false
			if facing == Enums.Facing.UP:animation_player.play("jump_looking_up")
			else:animation_player.play("jump")
		elif state == Enums.State.FALL:
			if facing == Enums.Facing.UP:animation_player.play("fall_looking_up")
			else:animation_player.play("fall")
		elif state == Enums.State.ATTACK:
			if facing == Enums.Facing.UP and !play_alt_slash_attack:
				animation_player.play("attack_looking_up")
			elif facing == Enums.Facing.UP and play_alt_slash_attack:
				animation_player.play("alt_attack_looking_up")
			elif play_alt_slash_attack: 
				animation_player.play("attack") 
			else: 
				animation_player.play("alt_slash_attack") 
		elif state == Enums.State.EXECUTE:
			animation_player.play("execute")
		elif state == Enums.State.CUTSCENE:
			animation_player.play("watch")


func _set_state(next_state):
	if state == Enums.State.FALL and (next_state == Enums.State.IDLE or next_state == Enums.State.WALK): 
		if facing == Enums.Facing.UP:animation_player.play("landing_looking_up")
		else:animation_player.play("landing")
		landing = true
		var landing_dust = preload("res://Particles/puff_of_dust.tscn").instance()
		landing_dust.position = global_position
		landing_dust.emitting = true
		get_tree().get_root().add_child(landing_dust)
		$DoubleJumpCloud.emitting = false
		
	
	if next_state == Enums.State.DEAD and (state == Enums.State.FALL or state == Enums.State.JUMP):
		animation_player.play("die_in_air")
		died_in_the_air = true
		
	state = next_state
	

func _set_facing(player_facing_direction):
	facing = player_facing_direction
	if get_parent().is_on_floor():
		var landing_dust = preload("res://Particles/puff_of_dust.tscn").instance()
		landing_dust.position = global_position
		if player_facing_direction == Enums.Facing.RIGHT:
			landing_dust.position.x -= 16
		elif player_facing_direction == Enums.Facing.LEFT:
			landing_dust.position.x += 16
		landing_dust.amount = 3
		landing_dust.emitting = true
		get_tree().get_root().add_child(landing_dust)


func _damage_effects(damage_amount):
	if damage_amount < 0:
		effects_player.play("take_damage")
	else:
		effects_player.play("heal")



func _double_jump_refreshed_effects() -> void:
	double_jump_available = true
	effects_player.play("refresh_jump")
	$DoubleJumpCloud.emitting = true

func _finished_landing() -> void:
	landing = false
