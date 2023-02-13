extends Node2D
class_name Weapon

export(PackedScene) var bullet_scene
export(float) var attack_delay_in_seconds = 50.0
export(bool) var pass_through_environment := false
export(bool) var tracking_ammo
export(int) var max_ammo
var ammo_amount : int = max_ammo
export(float) var reload_time = 1.5
var reload_timer: float = reload_time
onready var bullet_spawn := $BulletSpawn


var facing = Enums.Facing.RIGHT
var state = Enums.State.IDLE

var set_up_ammo_bar := false

func _ready():
	GameEvents.connect("player_attacked", self, "fire_weapon")
	GameEvents.connect("player_changed_facing_direction", self, "_change_facing_direction")
	get_parent().attack_delay = attack_delay_in_seconds


func _physics_process(delta):
	if !set_up_ammo_bar and tracking_ammo:
		ammo_amount = max_ammo
		GameEvents.emit_signal("weapon_reloading", ammo_amount, max_ammo)
		get_parent().reloading = false
		set_up_ammo_bar = true
	
	if ammo_amount == 0 and tracking_ammo:
		state = Enums.State.RELOADING
	
	match state:
		Enums.State.IDLE: idle_state()
		Enums.State.RELOADING: reload_state()



func fire_weapon():
	if state != Enums.State.RELOADING:
		if tracking_ammo: ammo_amount -= 1
		
		var bullet = bullet_scene.instance()
		var xspeed := 0.0
		var yspeed := 0.0
		
		bullet.position = bullet_spawn.global_position
		bullet.set_collision_mask_bit(2, true)
		bullet.set_collision_mask_bit(0, true)
		
		if facing == Enums.Facing.LEFT:
			xspeed = bullet.speed * -transform.x.x
			bullet.rotation_degrees = 180
			bullet.scale.y = -1
		elif facing == Enums.Facing.RIGHT:
			xspeed = bullet.speed * transform.x.x
			bullet.rotation_degrees = 0
		elif facing == Enums.Facing.UP:
			yspeed = -bullet.speed
			bullet.rotation_degrees = 270
		elif facing == Enums.Facing.DOWN:
			yspeed = bullet.speed
			bullet.rotation_degrees = 90
		
		bullet.velocity = Vector2(xspeed, yspeed)
		bullet.pass_through_environment = pass_through_environment
		get_parent().get_parent().add_child(bullet)



func reload_state():
	reload_timer -= 0.1
	if reload_timer <= 0:
		ammo_amount += 1
		reload_timer = reload_time
	
	GameEvents.emit_signal("weapon_reloading", ammo_amount, max_ammo)
	
	if ammo_amount >= max_ammo:
		ammo_amount = max_ammo
		get_parent().reloading = false
		state = Enums.State.IDLE
		
	


func idle_state():
	pass

func _change_facing_direction(player_facing):
	facing = player_facing


