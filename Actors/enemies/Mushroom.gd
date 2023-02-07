extends Enemy

var direction:= Vector2.RIGHT
var velocity := Vector2.ZERO
const SPEED := 25
var health := 4
var invulnerable := false
export var gravity := 3.9
export var max_fall_speed := 250

onready var ledge_check_right := $ledge_check_right
onready var ledge_check_left := $ledge_check_left
onready var animated_sprite := $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var found_wall := is_on_wall()
	var found_ledge = not ledge_check_right.is_colliding() or not ledge_check_left.is_colliding()
	animated_sprite.play("walk")
	if found_wall or found_ledge:
		direction *= -1
		animated_sprite.flip_h = !animated_sprite.flip_h

	velocity = direction * SPEED
	apply_gravity()
	move_and_slide(velocity, Vector2.UP)
	
	if invulnerable and $InvulnerableTimer.is_stopped():
		invulnerable = false
		
	if health < 0:
		queue_free()


func when_hitbox_area_entered(hitbox):
	if hitbox is HitBox:
		health = health - 1
		$InvulnerableTimer.start()
		

func apply_gravity():
	velocity.y += gravity
	velocity.y = min(velocity.y, max_fall_speed)
		
