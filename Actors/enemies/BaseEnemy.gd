extends KinematicBody2D
class_name BaseEnemy

signal died

var state = Enums.State.MOVE
var state_last_frame = state
var state_timer := 0
var facing = Enums.Facing.RIGHT

export(StreamTexture) var spritesheet
export var damage := 1
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

onready var hitbox:= $hitbox
onready var hurtbox:= $hurtbox
onready var ledge_check_right := $ledge_check_right
onready var ledge_check_left := $ledge_check_left
onready var animation_player := $Model/AnimationPlayer
onready var effects_player := $Model/EffectsPlayer

func _ready() -> void:
	hurtbox.connect("area_entered", self, "_when_hitbox_area_entered")
	#assert(spritesheet, "%s needs a spritesheet" % [name])


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
	if health <= 0:
		die()


func die() -> void:
	var explode := preload("res://Particles/death_explosion.tscn").instance()
	explode.position = global_position
	get_node("/root/World").add_child(explode)
	
	emit_signal("died")
	visible = false
	hitbox.queue_free()
	collision_layer = 0
	collision_mask = 0
	set_physics_process(false)
	
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
	if state == Enums.State.IDLE: idle_state()
	elif state == Enums.State.MOVE: move_state()
	elif state == Enums.State.JUMP: jump_state()
	elif state == Enums.State.ATTACK: attack_state()
	elif state == Enums.State.DEAD: dead_state()
	elif state == Enums.State.FALL: fall_state()
	elif state == Enums.State.HURT: hurt_state()


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

func state_timer():
	if state_last_frame != state:
		state_timer = 0
	else:
		state_timer += 1
	state_last_frame = state

func _when_hitbox_area_entered(hitbox):
	if hitbox is HitBox:
		take_damage(hitbox.damage, hitbox)
