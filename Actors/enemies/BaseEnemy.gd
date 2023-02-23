extends KinematicBody2D
class_name Enemy

signal died

var state = Enums.State.MOVE
var state_last_frame = state
var state_timer := 0
var facing = Enums.Facing.RIGHT
var wounded := false

export(Array, StreamTexture) var death_spritesheet = []
export(AudioStreamSample) var hurt_sound := SoundPlayer.IMPACT_CELERY
export(AudioStreamSample) var attack_sound := SoundPlayer.SWOOSH
export(int, 0, 10, 1) var damage := 1
export var health := 3
var velocity := Vector2.ZERO

var direction:= Vector2.RIGHT
export var max_move_speed := 25
export var acceleration := 5
export var acceleration_in_air := 5
export var friction := 6
export var jump_height := -80
var invulnerable := false
export var gravity := 3.9
export var max_fall_speed := 250
export(bool) var can_be_knocked_back =  true
var executed := false

onready var hitbox:= $hitbox
onready var hurtbox:= $hurtbox
onready var ledge_check_right := $ledge_check_right
onready var ledge_check_left := $ledge_check_left
onready var animation_player := $Model/AnimationPlayer
onready var effects_player := $Model/EffectsPlayer

var targeted := false


func _ready() -> void:
	hurtbox.connect("area_entered", self, "_hitbox_area_entered")
	GameEvents.connect("player_executed", self, "_execute")


func _physics_process(delta):
	pass

func move() -> void:
	velocity = move_and_slide(velocity, Vector2.UP)
	
func take_damage(amount: int, damaging_hitbox) -> void:
	state = Enums.State.HURT
	health -= amount
	if can_be_knocked_back:
		velocity = (self.global_position - damaging_hitbox.global_position) * damaging_hitbox.knockback_force
		velocity.y = jump_height*0.5
	effects_player.play("take_damage")
	animation_player.play("hurt")
	$InvulnerableTimer.start()
	if health <= 3:
		wounded = true
	if wounded:
		effects_player.play("wounded")
	if health <= 0:
		die()

func die() -> void:
	OS.delay_msec(80)
	var explode := preload("res://Particles/death_explosion.tscn").instance()
	explode.position = global_position
	if executed:
		explode.big = true
	get_node("/root/").add_child(explode)
	emit_signal("died")
	
	if death_spritesheet and executed:
		var spacing = 2
		var starting_x = -(death_spritesheet.size()*(spacing*.5))
		for sprite in death_spritesheet:
			var pickup := preload("res://Pickups/FoodPickup.tscn").instance()
			pickup.pickup_texture = sprite
			pickup.position = global_position
			pickup.velocity = Vector2(starting_x, rand_range(-4, -6))
			starting_x += spacing
			get_node("/root/World").add_child(pickup)
	
	visible = false
	collision_layer = 0
	collision_mask = 0
	set_physics_process(false)
	
	hitbox.queue_free()
	#die_sound.pitch_scale = rand_range(0.95, 1.05)
	#die_sound.play()
	#yield(die_sound, "finished")
	queue_free()
	


func apply_acceleration(amount):
	if is_on_floor():
		velocity.x = move_toward(velocity.x, max_move_speed * amount, acceleration)
	else:
		velocity.x = move_toward(velocity.x, max_move_speed * amount, acceleration_in_air)


func apply_friction():
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction)

func switch_state() -> void :
	match state:
		Enums.State.IDLE: idle_state()
		Enums.State.JUMP: jump_state()
		Enums.State.ATTACK: attack_state()
		Enums.State.DEAD: dead_state()
		Enums.State.FALL: fall_state()
		Enums.State.MOVE: move_state()
		Enums.State.HURT: hurt_state()

func idle_state():
	pass

func move_state():
	pass


func  jump_state():
	pass


func  attack_state():
	pass


func  dead_state():
	pass


func  fall_state():
	pass


func  hurt_state():
	pass

func timers():
	if state_last_frame != state:
		state_timer = 0
	else:
		state_timer += 1
	state_last_frame = state

func _hitbox_area_entered(hitbox):
	if hitbox is HitBox:
		OS.delay_msec(40)
		take_damage(hitbox.damage, hitbox)
		SoundPlayer.play_sound(hurt_sound)


func is_enemy() -> void:
	pass


func _execute(execution_target):
	if execution_target == self:
		executed = true
		var t = Timer.new()
		t.set_wait_time(.5)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		die()
