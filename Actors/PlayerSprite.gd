extends Sprite
enum {IDLE, WALK, JUMP, FALL, DEAD, ATTACK}
var state := IDLE
enum {RIGHT, DOWN, LEFT, UP}
var facing := RIGHT

onready var animation_player := $AnimationPlayer

func _ready():
	GameEvents.connect("player_changed_facing_direction", self, "_set_facing")
	GameEvents.connect("player_changed_state", self, "_set_state")


func _physics_process(delta):
	
	if state == IDLE:
		if facing == UP:animation_player.play("idle_looking_up")
		else:animation_player.play("idle")
	elif state == WALK:
		if facing == UP:animation_player.play("walk_looking_up")
		else:animation_player.play("walk")
	elif state == JUMP:
		if facing == UP:animation_player.play("jump_looking_up")
		else:animation_player.play("jump")
	elif state == FALL:
		if facing == UP:animation_player.play("fall_looking_up")
		else:animation_player.play("fall")
	elif state == ATTACK:
		pass
	elif state == DEAD:
		pass

func _set_state(player_state):
	state = player_state

func _set_facing(player_facing_direction):
	facing = player_facing_direction
