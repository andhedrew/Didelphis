extends KinematicBody2D
class_name Enemy
 
var state = Enums.State.IDLE
var state_last_frame = state
var state_timer := 0

var facing = Enums.Facing.RIGHT
var wounded := false
var targeted := false

export(Array, StreamTexture) var death_spritesheet = []
 
export(String) var impact_sound = "impact_celery"
export(String) var attack_sound = "swoosh"
export(Array, String) var hurt_vocalizations 
export(String) var death_vocalization 
 
export(int, 0, 10, 1) var damage := 1
export var health := 3
var velocity := Vector2.ZERO

var direction:= Vector2.RIGHT

export var max_move_speed := 25
export var acceleration := 5
export var acceleration_in_air := 5

export var gravity := 3.9
export var friction := 6
export var jump_height := -80

var invulnerable := false
export var max_fall_speed := 250
export(bool) var can_be_knocked_back =  true

var executable := false

onready var hitbox:= $hitbox
onready var hurtbox:= $hurtbox

onready var ledge_check_right := $ledge_check_right
onready var ledge_check_left := $ledge_check_left

onready var animation_player := $Model/AnimationPlayer
onready var effects_player := $Model/EffectsPlayer

onready var invulnerable_timer := $InvulnerableTimer



func _ready() -> void:
	GameEvents.connect("player_executed", self, "_on_player_executed")
	z_index = SortLayer.PLAYER


func _physics_process(delta):
	timers()
	
	if health <= 1:
		wounded = true
	if wounded:
		effects_player.play("wounded")
		
	if invulnerable_timer.is_stopped():
		invulnerable = false
	else: invulnerable = true
	

func move() -> void:
	velocity = move_and_slide(velocity, Vector2.UP)



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


func when_hitbox_area_entered(hitbox):
	if hitbox is HitBox and !invulnerable:
		take_damage(hitbox.damage, hitbox)


func take_damage(amount: int, damaging_hitbox) -> void:
	state = Enums.State.HURT
	state_timer = 0
	OS.delay_msec(40)
	
	var slice_animation := preload("res://Animations/slice_animation.tscn").instance()
	
	get_node("/root/").add_child(slice_animation)
	slice_animation.global_position = global_position
	slice_animation.global_position.y -= 16
		
	var damage_number = preload("res://UI/damage_number.tscn").instance()
	damage_number.label_position = global_position
	damage_number.label_position.x += rand_range(-5,5)
	damage_number.label_position.y -= rand_range(13,16)
	damage_number.damage_label = str(0 - hitbox.damage)
	damage_number.target.y = damage_number.label_position.y - 32
	get_tree().get_root().add_child(damage_number)
	
	health -= amount
	
	if can_be_knocked_back:
		velocity = (self.global_position - damaging_hitbox.global_position) * damaging_hitbox.knockback_force
		velocity.y = jump_height*0.5
	
	effects_player.play("take_damage")
	animation_player.play("hurt")
	SoundPlayer.play_sound(impact_sound)
	if hurt_vocalizations:
		SoundPlayer.play_sound(hurt_vocalizations[randi() % hurt_vocalizations.size()])
	invulnerable_timer.start()
	
	if executable:
		_execute()


func _execute():
	if death_vocalization:
		SoundPlayer.play_sound(death_vocalization)
	yield(get_tree().create_timer(0.2), "timeout")
	die()


func die() -> void:
	state = Enums.State.DEAD
	OS.delay_msec(80)
	var explode := preload("res://Particles/death_explosion.tscn").instance()
	explode.position = global_position
	if executable:
		explode.big = true
	get_node("/root/").add_child(explode)
	
	if death_spritesheet and executable:
		var spacing = 2
		var starting_x = (death_spritesheet.size()*(spacing*.5))
		for sprite in death_spritesheet:
			var pickup := preload("res://Pickups/FoodPickup.tscn").instance()
			pickup.pickup_texture = sprite
			pickup.position = global_position
			pickup.velocity = Vector2(starting_x, rand_range(-4, -6))
			starting_x -= spacing
			get_node("/root/World").add_child(pickup)
	
	visible = false
	collision_layer = 0
	collision_mask = 0
	set_physics_process(false)
	call_deferred("queue_free")


func is_enemy() -> void:
	pass


func _on_player_executed():
	if wounded: 
		executable = true


func apply_gravity():
	velocity.y += gravity
	velocity.y = min(velocity.y, max_fall_speed)
