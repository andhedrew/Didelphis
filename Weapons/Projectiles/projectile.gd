extends KinematicBody2D

export(Texture) var bullet_sprite 
export(int) var damage
export(float) var speed
export(bool) var track_lifespan
export(float) var lifespan
onready var hitbox := get_node("Hitbox")
onready var sprite_node := $Model/BulletSprite
onready var muzzle_sprite_node := $Model/MuzzleFlashSprite

var velocity := Vector2.ZERO
var lifespan_tracker := 0.0
var set_up_hitbox_and_animation := false
onready var animation_player := $Model/AnimationPlayer

func _ready():
	#var h_frame_width: float = bullet_sprite.width/32
	lifespan_tracker = lifespan * 60
	sprite_node.texture = bullet_sprite
	sprite_node.hframes = bullet_sprite.get_width()/32
	muzzle_sprite_node.texture = bullet_sprite
	muzzle_sprite_node.hframes = bullet_sprite.get_width()/32
	

func _physics_process(delta):
	move_and_collide(velocity)
	if not set_up_hitbox_and_animation:
		animation_player.play("bullet")
		hitbox.set_collision_layer(get_collision_layer())
		hitbox.set_collision_mask(get_collision_mask())
		set_up_hitbox_and_animation = true
	
	
	if track_lifespan:
		lifespan_tracker -= 1
		if lifespan_tracker < 0:
			queue_free()


func _queue_free():
	queue_free()
