extends KinematicBody2D
class_name BaseEnemy

signal died

enum {IDLE, WALK, JUMP, FALL, DEAD, ATTACK, DAMAGED}
var state := WALK
enum {RIGHT, DOWN, LEFT, UP}
var facing := RIGHT

export(StreamTexture) var spritesheet
export var damage := 1
export var health := 3
var velocity := Vector2.ZERO

var direction:= Vector2.RIGHT
export var max_move_speed := 25
export var acceleration := 5
export var acceleration_in_air := 5
export var jump_height := 40
var invulnerable := false
export var gravity := 3.9
export var max_fall_speed := 250

onready var hitbox:= $hitbox
onready var ledge_check_right := $ledge_check_right
onready var ledge_check_left := $ledge_check_left
onready var animation_player := $Model/AnimationPlayer
onready var effects_player := $Model/EffectsPlayer

func _ready() -> void:
	pass
	#assert(spritesheet, "%s needs a spritesheet" % [name])


func _physics_process(delta):
	switch_state()

func move() -> void:
	velocity = move_and_slide(velocity, Vector2.UP)
	
func take_damage(amount: int, damaging_hitbox) -> void:
	state = DAMAGED
	health -= amount
	velocity = (self.global_position - damaging_hitbox.global_position) * damaging_hitbox.knockback_force
	velocity.y = jump_height*0.5
	effects_player.play("take_damage")
	$InvulnerableTimer.start()
	if health <= 0:
		die()


func die() -> void:
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

func switch_state() -> void :
	if state == IDLE: idle_state()
	elif state == WALK: walk_state()
	elif state == JUMP: jump_state()
	elif state == ATTACK: attack_state()
	elif state == DEAD: dead_state()
	elif state == FALL: fall_state()
	elif state == DAMAGED: damaged_state()


func idle_state():
	pass

func walk_state():
	pass


func  jump_state():
	pass


func  attack_state():
	pass


func  dead_state():
	pass


func  fall_state():
	pass


func  damaged_state():
	pass
