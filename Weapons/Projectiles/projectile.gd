extends KinematicBody2D

export(Texture) var bullet_sprite 

export(int) var damage
export(float) var speed
export(bool) var track_lifespan
export(float) var lifespan
export(float) var knockback_force
onready var hitbox := get_node("Hitbox")
onready var sprite_node := $Model/BulletSprite

var velocity := Vector2.ZERO
var lifespan_tracker := 0.0
var set_up_hitbox_and_animation := false
onready var animation_player := $Model/AnimationPlayer
var pass_through_environment: bool = true

func _ready():
	lifespan_tracker = lifespan * 60
	sprite_node.texture = bullet_sprite
	sprite_node.hframes = bullet_sprite.get_width()/32
	


func _physics_process(delta):
	move_and_collide(velocity)
	if not set_up_hitbox_and_animation:
		animation_player.play("bullet")
		hitbox.set_collision_layer(get_collision_layer())
		hitbox.set_collision_mask(get_collision_mask())
		hitbox.damage = damage
		hitbox.knockback_force = knockback_force
		set_up_hitbox_and_animation = true
	
	
	if track_lifespan:
		lifespan_tracker -= 1
		if lifespan_tracker < 0:
			_queue_free()


func _queue_free():
	queue_free()


func _on_Hitbox_body_entered(body):
	if not pass_through_environment:
		_queue_free()
